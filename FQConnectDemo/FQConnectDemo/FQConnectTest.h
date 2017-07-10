//
//  FQConnectTest.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQBaseConnect.h"

@interface FQConnectTest : FQBaseConnect

- (void)sendWithUser:(NSString *)user
       withPassworld:(NSString *)pwd
            withType:(SInt32)type
     withCountryCode:(NSString *)countryCode
       withCompleted:(FQConnectCompletionBlock)completedBlock;


@end
