//
//  FQConnectSocketTcpMessage.m
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/21.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import "FQConnectSocketTcpMessage.h"

@interface FQConnectSocketTcpMessage ()<NSCoding> 

/** 请求版本 客户端设置，服务器不需要*/
@property(nonatomic) SInt32 version;
/** 设备类型 */
@property(nonatomic) SInt32 deviceType;
/** 设备token（ifda） */
@property(nonatomic, copy) NSString *deviceToken;


@end

@implementation FQConnectSocketTcpMessage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.version     = 1.1;
        self.deviceType  = 0;
        self.deviceToken = @"ABGHUIJHBNMJGGVHKNKBHJBBBKNLNLLNLN";
    }
    return self;
}



//将对象编码(即:序列化)

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //外部
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeInteger:self.tag forKey:@"tag"];
    [aCoder encodeInteger:self.operation forKey:@"operation"];
    [aCoder encodeObject:self.bodyData forKey:@"bodyData"];
    //内部
    [aCoder encodeInteger:self.version forKey:@"version"];
    [aCoder encodeInteger:self.deviceType forKey:@"deviceType"];
    [aCoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    
}

//将对象解码(反序列化)

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.type = [aDecoder decodeIntForKey:@"type"];
        self.tag = [aDecoder decodeIntForKey:@"tag"];
        self.operation = [aDecoder decodeIntForKey:@"operation"];
        self.version = [aDecoder decodeIntForKey:@"version"];
        self.deviceType = [aDecoder decodeIntForKey:@"deviceType"];
        
        self.bodyData = [aDecoder decodeObjectForKey:@"bodyData"];
        self.deviceToken = [aDecoder decodeObjectForKey:@"deviceToken"];
    }
    return (self);
}





@end
