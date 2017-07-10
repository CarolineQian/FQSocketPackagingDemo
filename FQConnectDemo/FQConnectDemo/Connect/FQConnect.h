//
//  FQConnect.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQNetDefines.h"
#import "FQConnectRequest.h"

@class FQConnect;

@interface FQConnect : NSObject

/** 全局默认的connect，（FQConnect只能在UI线程使用） */
+ (instancetype)sharedInstance;
/** 当前连接状态，发送数据时会自动连接，无需再手动操作 */
- (FQConnectState)connectState;
/** 发起连接，成功后会交互KEY等 */
- (BOOL)connect;
/** 断开连接 */
- (void)disConnectByErrorType:(FQConnectErrorType)errorType;


/** 发送业务数据 */
- (FQConnectRequest *)sendOperation:(SInt32)operation
                               data:(NSData *)data
                               type:(FQMessageType)type
                           finished:(void (^)(SInt32 state, NSData *data))finished;
/** 发送key和心跳数据 */
- (void)sendMessage:(FQConnectSocketTcpMessage *)message;

@end
