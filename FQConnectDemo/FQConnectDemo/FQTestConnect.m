//
//  FQTestConnect.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/7/6.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQTestConnect.h"

@implementation FQTestConnect

- (void)sendWithUser1:(NSString *)user
       withPassworld1:(NSString *)pwd
            withType1:(SInt32)type
     withCountryCode1:(NSString *)countryCode
       withCompleted1:(FQConnectCompletionBlock)completedBlock
{
    //在这里转model,再将model转为PB文件后发送出去
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:user forKey:@"user"];
    [dic setObject:pwd forKey:@"pwd"];
    [dic setObject:[NSString stringWithFormat:@"%d",(int)type] forKey:@"type"];
    [dic setObject:countryCode forKey:@"countryCode"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [super sendOperation:200001 data:data completed:nil updateProperty:^(SInt32 code, NSData *pbData)
     {
         if (completedBlock)
         {
             completedBlock(self);
         }
     }];
    
}


@end
