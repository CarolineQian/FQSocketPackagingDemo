//
//  FQTestConnect.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/7/6.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQBaseConnect.h"

@interface FQTestConnect : FQBaseConnect

- (void)sendWithUser1:(NSString *)user
       withPassworld1:(NSString *)pwd
            withType1:(SInt32)type
     withCountryCode1:(NSString *)countryCode
       withCompleted1:(FQConnectCompletionBlock)completedBlock;


@end
