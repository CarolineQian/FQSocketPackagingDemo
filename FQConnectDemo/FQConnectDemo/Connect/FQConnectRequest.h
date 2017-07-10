//
//  FQConnectRequest.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQConnectSocketTcpMessage.h"

@interface FQConnectRequest : NSBlockOperation

@property(nonatomic) int option;
@property(nonatomic) FQConnectSocketTcpMessage *message;
@property(nonatomic, copy) void (^callbackBlock)(SInt32 state, NSData *data);  /** 回调 */



@end
