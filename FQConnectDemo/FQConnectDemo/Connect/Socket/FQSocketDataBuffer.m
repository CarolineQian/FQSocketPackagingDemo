
//
//  FQSocketDataBuffer.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/23.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQSocketDataBuffer.h"
#import "FQNetDefines.h"



@implementation FQSocketDataBuffer


- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


/** 接收到一次数据 */
- (void)receiveSocketData:(NSData *)data
{
    if ([NSThread isMainThread])
    {
        [self receiveDataOnMainThread:data];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(receiveDataOnMainThread:) withObject:data waitUntilDone:YES];
    }
}

- (void)receiveDataOnMainThread:(NSData *)data
{
    [self.delegate socketDataBuffer:self didCompleteData:data encodeMarkData:nil];
}




@end


