//
//  FQBaseConnect.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/20.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQNetDefines.h"

@interface FQBaseConnect : NSObject
{
    FQMessageType   _messageType;          // 网络请求类型
    SInt32          _code;                 //网络请求返回的状态码
    NSString        *_message;             //调用LGNetError的方法,根据_code得到提示消息
}

@property(nonatomic, readonly) SInt32 code;
@property(nonatomic, readonly) NSString *message;
typedef void (^FQConnectUpdatePropertyBlock)(SInt32 code, NSData *pbData);
typedef void (^FQConnectCompletionBlock)(FQBaseConnect *con);


#pragma mark - 方法
/** 初始化 ,默认的LGMessageType是LGMessageTypeOfBusinessRequest */
+ (instancetype)connect;

/** 发送网络请求*/
- (void)sendOperation:(SInt32)operation
                 data:(NSData *)data
            completed:(FQConnectCompletionBlock)completedBlock
       updateProperty:(FQConnectUpdatePropertyBlock)updatePropertyBlock;


@end
