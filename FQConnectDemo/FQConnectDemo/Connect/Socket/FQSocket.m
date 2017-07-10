//
//  FQSocket.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQSocket.h"
#import "GCDAsyncSocket.h"
#import "FQSocketDataBuffer.h"

@interface FQSocket ()<GCDAsyncSocketDelegate,FQSocketDataBufferDelegate>
{
    GCDAsyncSocket *_socket;
    FQSocketDataBuffer *_buffer;
}

@end

@implementation FQSocket

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        _buffer          = [[FQSocketDataBuffer alloc] init];
        _buffer.delegate = self;
    }
    return self;
}

#pragma mark - 对外接口_连接

- (void)connectToHost:(NSString *)hostName port:(UInt16)port
{
    NSError *error = nil;
    if (_socket.isConnected)
    {
        if ([_socket.connectedHost isEqualToString:hostName] && _socket.connectedPort == port)
        {
            NSLog(@"重复连接 host : %@ \t port : %ld", hostName, (long)port);
        }
        else
        {
            NSLog(@"断开重连 host : %@ \t port : %ld", hostName, (long)port);
            [self disConnect];
            [_socket connectToHost:hostName onPort:port withTimeout:20 error:&error];
        }
    }
    else
    {
        [_socket connectToHost:hostName onPort:port withTimeout:20 error:&error];
    }
    
    if (error)
    {
        NSLog(@"服务连接 error : %@", [error localizedDescription]);
        [self disConnect];
        [self.delegate socket:self didMakeError:FQConnectErrorTypeOfConnectFail];
    }
    else
    {
        //开了线程等待接收数据 过了readDataWithTimeout这个时间就自动停止，-1表示一直接收
        [_socket readDataWithTimeout:-1 tag:0];
    }
}

#pragma mark - 对外接口_断开连接
/** 断开连接 */
- (void)disConnect
{
    _socket.delegate = nil;
    [_socket disconnect];
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}
/** 发送完成后再断开 */
- (void)disConnectAfterWriting
{
    _socket.delegate = nil;
    [_socket disconnectAfterWriting];
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - 对外接口_发送数据
- (void)sendData:(NSData *)data
{
    [_socket writeData:data withTimeout:-1 tag:0];
}


#pragma mark - GCDAsynSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (sock != _socket)
    {
        return;
    }
    NSLog(@"连接成功,服务器IP是 ：%@", host);
    [_socket readDataWithTimeout:-1 tag:0];//冯倩加的
    [self.delegate socketDidConnect:self];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (sock != _socket)
    {
        return;
    }
     [_buffer receiveSocketData:data];
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    if (sock != _socket)
    {
        return;
    }
    
    if (!err)
    {
        [self.delegate socketDidDisConnect:self];
    }
    else
    {
        FQConnectErrorType errorType = FQConnectErrorTypeOfNoError;
        if (FQConnectErrorTypeOfNoError == errorType)
        {
            NSLog(@"断开 主动断开 \n\n ");
        }
        
        [self.delegate socket:self didMakeError:errorType];
    }
}

#pragma mark - FQSocketDataBufferDelegate 组装完整数据后

- (void)socketDataBuffer:(FQSocketDataBuffer *)buffer
         didCompleteData:(NSData *)data
        encodeMarkData:(NSData *)encodeMarkData
{
    [self.delegate socket:self didReceiveData:data];
}

@end
