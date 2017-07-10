//
//  FQConnectKeeper.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/23.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQConnectKeeper.h"
#import "FQSocket.h"
#import "FQConnect.h"

#import <UIKit/UIKit.h>   //下面的UIApplicationDidEnterBackgroundNotification和UIApplication报错均是因为需要导入这个

@implementation FQConnectKeeper
{
    NSTimer         *_heartBeatTimer;               //心跳计时器
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(applicationDidEnterBackground:)
                           name:UIApplicationDidEnterBackgroundNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(applicationDidBecomeActive:)
                           name:UIApplicationDidBecomeActiveNotification
                         object:nil];
//        [notiCenter addObserver:self
//                       selector:@selector(netTypeChanged)
//                           name:@"FQNotificationNameOfNettypeChanged"
//                         object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 外部方法
- (void)startAuth
{
    _authKey = [self randAESKey];
    [self sendAESAuthMessage];
}

- (BOOL)shouldConnectCurrently
{
    if (UIApplicationStateActive != [UIApplication sharedApplication].applicationState)
    {
        NSLog(@"连接禁止,applicationState不是active");
        return NO;
    }
    return YES;
}

- (void)startHeartBeat
{
    NSLog(@"设置心跳计时器");
    [_heartBeatTimer invalidate];
    _heartBeatTimer               = [NSTimer scheduledTimerWithTimeInterval:10
                                                                     target:self
                                                                   selector:@selector(heartBeatTimerUp)
                                                                   userInfo:nil
                                                                    repeats:YES];
    //连接成功的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FQNotificationNameOfTcpNetworkChanged"
                                                        object:nil];
}

- (void)cancelHeartBeat
{
    NSLog(@"取消心跳计时器");
    [_heartBeatTimer invalidate];
    _heartBeatTimer = nil;
}


#pragma mark - 内部方法

#pragma mark - 发送key

//生成key
- (NSData *)randAESKey
{
    UInt8 bytes[16];
    for (int i = 0; i < 16; i++)
    {
        bytes[i] = rand() % 256;
    }
    return [NSData dataWithBytes:bytes length:16];
}
//发送key
- (void)sendAESAuthMessage
{
    FQConnectSocketTcpMessage *message = [[FQConnectSocketTcpMessage alloc] init];
    message.type                       = FQMessageTypeOfAESKeyRequest;
    message.tag                        = FQRequestTagOfAESKey;
    message.bodyData                   = _authKey;
    message.operation                  = 000000;
    [[FQConnect sharedInstance] sendMessage:message];
}

#pragma mark - 每10S发送一次心跳包

- (void)heartBeatTimerUp
{
    [self sendHeartBeatMessage];
}

- (void)sendHeartBeatMessage
{
    NSLog(@"发送心跳");
    FQConnectSocketTcpMessage *message = [[FQConnectSocketTcpMessage alloc] init];
    message.type                       = FQMessageTypeOfHeartBeatRequest;
    message.tag                        = FQRequestTagOfHeartbeat;
    message.bodyData                   = nil;
    message.operation                  = 000000;
    [[FQConnect sharedInstance] sendMessage:message];
}



#pragma mark - 网络状况变化的处理
//#pragma mark - 应用切换前后台的处理

- (void)applicationDidEnterBackground:(NSNotification *)not
{
    //5秒后断开网络
    [self performSelector:@selector(appBackgroundTimerUp) withObject:nil afterDelay:5];
}

- (void)appBackgroundTimerUp
{
    [[FQConnect sharedInstance] disConnectByErrorType:FQConnectErrorTypeOfCancel];
}

- (void)applicationDidBecomeActive:(NSNotification *)not
{
    [FQConnect cancelPreviousPerformRequestsWithTarget:self
                                              selector:@selector(appBackgroundTimerUp)
                                                object:nil];
    [[FQConnect sharedInstance] connect];
}




@end
