//
//  FQConnectSocketTcpMessage.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQNetDefines.h"

@interface FQConnectSocketTcpMessage : NSObject

/** Message类型，业务=100 */
@property(nonatomic) FQMessageType type;
/** 区分不同请求用的标签 */
@property(nonatomic) SInt32 tag;
/** 交易ID */
@property(nonatomic) SInt32 operation;
@property(nonatomic) NSData *bodyData;



@end
