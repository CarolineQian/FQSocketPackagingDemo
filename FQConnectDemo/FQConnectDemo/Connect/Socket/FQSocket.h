//
//  FQSocket.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQNetDefines.h"

@class FQSocket;
@protocol FQSocketDelegate<NSObject>

- (void)socketDidConnect:(FQSocket *)socket;
- (void)socketDidDisConnect:(FQSocket *)socket;
- (void)socket:(FQSocket *)socket didReceiveData:(NSData *)data;
- (void)socket:(FQSocket *)socket didMakeError:(FQConnectErrorType)errorType;

@end

@interface FQSocket : NSObject
@property(nonatomic, weak) id<FQSocketDelegate> delegate;

/** 连接到IP或域名,端口 */
- (void)connectToHost:(NSString *)hostName port:(UInt16)port;
/** 断开连接 */
- (void)disConnect;
/** 发送完毕之后再断开 */
- (void)disConnectAfterWriting;
/** 发送数据，PdMessage结构 */
- (void)sendData:(NSData *)data;
@end
