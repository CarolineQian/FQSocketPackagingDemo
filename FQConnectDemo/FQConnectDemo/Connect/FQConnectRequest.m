//
//  FQConnectRequest.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQConnectRequest.h"

@interface FQConnectRequest() <NSCoding> 

@end

@implementation FQConnectRequest


//将对象编码(即:序列化)

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.option forKey:@"option"];
    [aCoder encodeObject:self.message forKey:@"message"];
    

}

//将对象解码(反序列化)

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.option = [aDecoder decodeIntForKey:@"option"];
        self.message = [aDecoder decodeObjectForKey:@"message"];
    }
    return (self);
}


@end
