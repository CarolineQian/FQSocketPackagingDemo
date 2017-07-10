//
//  main.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/20.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
//    @autoreleasepool
//    {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
    
    @try
    {
        @autoreleasepool
        {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    @catch (NSException* exception)
    {
        NSLog(@"!!!!!!!错误Exception=%@\nStack Trace:%@", exception, [exception callStackSymbols]);
    }
}
