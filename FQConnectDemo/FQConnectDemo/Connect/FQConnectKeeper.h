//
//  FQConnectKeeper.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/23.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQNetDefines.h"

@interface FQConnectKeeper : NSObject

@property(nonatomic, readonly) NSData *authKey;

#pragma mark - 外部方法

- (void)startAuth;

- (void)startHeartBeat;

- (BOOL)shouldConnectCurrently;

- (void)cancelHeartBeat;



@end
