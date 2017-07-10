//
//  FQConnect.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQConnect.h"
#import "FQSocket.h"
#import "FQConnectSocketTcpMessage.h"
#import "FQConnectKeeper.h"
#import <UIKit/UIKit.h>


@interface FQConnect ()<FQSocketDelegate,NSCoding>
@end

@implementation FQConnect
{
    FQConnectState       _connectState;
    FQSocket             *_socket;
    FQConnectKeeper      *_keeper;
    NSOperationQueue     *_queue;
    NSMutableArray<FQConnectRequest *>      *_unqueuedRequestList;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _connectState  = FQConnectStateNotConnected;
        _queue                             = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        _unqueuedRequestList               = [NSMutableArray array];
        
        _socket          = [[FQSocket alloc] init];
        _socket.delegate = self;
        _keeper = [[FQConnectKeeper alloc] init];
    }
    return self;
}


#pragma mark - 内部方法


- (FQConnectRequest *)requestOfMessage:(FQConnectSocketTcpMessage *)message
                                option:(SInt32)option
                       completionBlock:(void (^)(SInt32, NSData *))completion
{
    __weak typeof(self) weakSelf = self;
    FQConnectRequest *req                = [[FQConnectRequest alloc] init];
    __weak FQConnectRequest *weakRequest = req;
    
    req.message = message;
    req.option = option;
    //回调
    req.callbackBlock = ^(SInt32 state, NSData *data)
    {
        completion ? completion(state, data) : nil;
    };
    
    //添加多线程异步操作
    [req addExecutionBlock:^
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         __strong FQConnectRequest *strongReq = weakRequest;
         
         //         //在这里向服务器发送信息 1
         //         NSData *sendData = (NSData *)strongReq.message.bodyData;
         NSData  *sendData = [NSKeyedArchiver archivedDataWithRootObject:strongReq];
         [strongSelf->_socket sendData:sendData];
     }];
    
    
    //执行完毕调用    2,
    req.completionBlock = ^(void)
    {
        NSLog(@"req执行完毕,若有后续操作添加在此");
    };
    return req;
}




#pragma mark - 外部方法
+ (instancetype)sharedInstance
{
    static FQConnect *     sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    return sharedInstance;
}


- (FQConnectState)connectState
{
    return _connectState;
}

/** 发起连接，成功后会交互KEY等 */
- (BOOL)connect
{
    if ([_keeper shouldConnectCurrently])
    {
        if (FQConnectStateNotConnected == _connectState)
        {
            _connectState = FQConnectStateIsConnecting;
            [_socket connectToHost:@"127.0.0.1" port:8080];
        }
        else
        {
            if (FQConnectStateConnectErr == _connectState)
            {
                [self disConnectByErrorType:FQConnectErrorTypeOfServerFail];
            }
            else
            {
                NSLog(@"已连接");
            }
        }
        return YES;
    }
    return NO;
    
}

- (void)disConnectByErrorType:(FQConnectErrorType)errorType
{
    NSLog(@"断网重连");
    if (FQConnectErrorTypeOfChangeUser == errorType)
    {
        //取消所有已在队列的请求的 callback,发送等待请求，之后再断开链接
        [_queue waitUntilAllOperationsAreFinished];
        
        [_socket disConnectAfterWriting];
    }
    else
    {
        [_socket disConnect];
    }
    
    _connectState = FQConnectStateNotConnected;
    [_keeper cancelHeartBeat];
    
    [self performSelector:@selector(connect) withObject:nil afterDelay:1];
}



#pragma mark - 外部方法_发送数据
//发送业务数据
- (FQConnectRequest *)sendOperation:(SInt32)operation
                               data:(NSData *)data
                               type:(FQMessageType)type
                           finished:(void (^)(SInt32 state, NSData *data))finished
{
    
    if (![_keeper shouldConnectCurrently])
    {
        finished ? finished(FQConnectErrorTypeOfConnectFail, nil) : nil;
        return nil;
    }
    
    if (FQConnectStateNotConnected == _connectState || FQConnectStateConnectErr == _connectState)
    {
        [self connect];
    }
    
    FQConnectSocketTcpMessage *message = [[FQConnectSocketTcpMessage alloc] init];
    message.operation   = operation;
    message.bodyData    = data;
    message.type        = type;
    message.tag         = 100;

    
    FQConnectRequest *req = [self requestOfMessage:message option:operation completionBlock:finished];
    
    if(FQConnectStateDidConnected == _connectState)
    {
        [_unqueuedRequestList addObject:req];
        [_queue addOperation:req];
    }
    else
    {
        req.callbackBlock(FQConnectErrorTypeOfConnectFail, data);
    };

    
    return req;
  
}

//发送key和心跳均是000000
- (void)sendMessage:(FQConnectSocketTcpMessage *)message
{
    
    FQConnectRequest *req = [self requestOfMessage:message option:000000 completionBlock:nil];
    
    if (message.type == FQMessageTypeOfAESKeyRequest)
    {
        req.queuePriority = NSOperationQueuePriorityVeryHigh;
    }
    else if (message.tag == FQRequestTagOfHeartbeat)
    {
        req.queuePriority = NSOperationQueuePriorityVeryHigh - 1;
    }
    if (FQConnectStateNotConnected == _connectState || FQConnectStateConnectErr == _connectState)
    {
        [self connect];
    }
    if (FQMessageTypeOfAESKeyRequest == message.type || FQMessageTypeOfHeartBeatRequest == message.type ||
        FQConnectStateDidConnected == _connectState)
    {
        [_unqueuedRequestList addObject:req];
        [_queue addOperation:req];
    }
    
}


#pragma mark - FQSocketDelegate

- (void)socketDidConnect:(FQSocket *)socket
{
    NSLog(@"连接已经建立，开始交互密钥");
    _connectState = FQConnectStateDidConnected;
    [_keeper startAuth];
}

- (void)socketDidDisConnect:(FQSocket *)socket
{
    [self disConnectByErrorType:FQConnectErrorTypeOfNoError];
}

- (void)socket:(FQSocket *)socket didReceiveData:(NSData *)data
{
    FQConnectRequest *req = [NSKeyedUnarchiver unarchiveObjectWithData:data];//反序列化
    
    //客户端发送key成功后则开启心跳
    if(req.message.type == FQMessageTypeOfAESKeyRequest)
    {
        NSLog(@"服务器返回key");
        [_keeper startHeartBeat];
        
    }
    //客户端发送心跳成功
    else if(req.message.type == FQMessageTypeOfHeartBeatRequest)
    {
        NSLog(@"服务器返回心跳");
    }
    //正常业务请求
    else
    {
        //根据请求的唯一operation找到数组中的req,返回数据
        for (int i = 0; i< _unqueuedRequestList.count; i++)
        {
            if (req.option == _unqueuedRequestList[i].option)
            {
                _unqueuedRequestList[i].callbackBlock(_unqueuedRequestList[i].message.operation, _unqueuedRequestList[i].message.bodyData);
                [_unqueuedRequestList removeObjectAtIndex:i];
            }
        }
    }
    
    

}
- (void)socket:(FQSocket *)socket didMakeError:(FQConnectErrorType)errorType
{
    _connectState = FQConnectStateConnectErr;
    [self disConnectByErrorType:errorType];
}






@end
