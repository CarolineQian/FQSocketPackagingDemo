//
//  FQBaseConnect.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/20.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQBaseConnect.h"
#import "FQConnectRequest.h"
#import "FQConnect.h"

@implementation FQBaseConnect
{
    FQConnectRequest *_request;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _messageType = FQMessageTypeOfBusinessRequest;
    }
    return self;
}

#pragma mark - GetSet
- (SInt32)code
{
    return _code;
}

- (NSString *)message
{
    return _message;
}

#pragma mark - 外部方法

+ (instancetype)connect
{
    return [[self alloc] init];
}

/** 子类发送时，使用此方法 */
- (void)sendOperation:(SInt32)operation
                 data:(NSData *)data
            completed:(FQConnectCompletionBlock)completedBlock
       updateProperty:(FQConnectUpdatePropertyBlock)updatePropertyBlock
{
    
    _request   = [[FQConnect sharedInstance] sendOperation:operation
                                                             data:data
                                                             type:_messageType
                                                         finished:^(SInt32 state, NSData *data)
                         {
                             _code    = state;
                             _message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                             //block传来
                             if ([NSThread isMainThread])
                             {
                                 if (updatePropertyBlock)
                                 {
                                     updatePropertyBlock(state, data);
                                 }
                                 if (completedBlock)
                                 {
                                     completedBlock(self);
                                 }
                             }
                             else
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^
                                                {
                                                    if (updatePropertyBlock)
                                                    {
                                                        updatePropertyBlock(state, data);
                                                    }
                                                    if (completedBlock)
                                                    {
                                                        completedBlock(self);
                                                    }
                                                });
                             }
                         }];
    
    
    
    
}


@end
