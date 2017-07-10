//
//  FQNetDefines.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/20.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#ifndef FQNetDefines_h
#define FQNetDefines_h

/** 每次请求都有自己的tag，tag自增，而这些是特例 */
typedef NS_ENUM(NSUInteger, FQRequestTags)
{
    FQRequestTagOfAESKey    = 0,
    FQRequestTagOfHeartbeat = 10
};



typedef NS_ENUM(NSInteger, FQConnectErrorType)
{
    /** 无错 */
    FQConnectErrorTypeOfNoError = 0,
    /** 网络连接失败 */
    FQConnectErrorTypeOfConnectFail = -1,
    /** 服务器繁忙 */
    FQConnectErrorTypeOfServerFail = -2,
    /** 已经切换了用户 */
    FQConnectErrorTypeOfChangeUser = -3,
    /** 取消 */
    FQConnectErrorTypeOfCancel = -5,
};


typedef NS_ENUM(SInt32, FQMessageType)
{
    /** 客户端发送AESkey（RSA加密，可以没有header，data是KEY） */
    FQMessageTypeOfAESKeyRequest = 1,
    /** 客户端发送业务数据 */
    FQMessageTypeOfBusinessRequest = 101,

    //----------------------心跳（可以没有header和data）
    /** 客户端发送心跳（可以没有header和data） */
    FQMessageTypeOfHeartBeatRequest = 1001,
    /** 服务器对心跳的回应（可以没有header和data） */
    FQMessageTypeOfHeartBeatResponse = 1002
};



//(除了DidConnected状态外，发送业务请求时也会尝试建立连接并在之后发送)
typedef NS_ENUM(NSUInteger, FQConnectState)
{
    /** 标准状态，没有连接 */
    FQConnectStateNotConnected,
    /** 正在建立Socket连接 */
    FQConnectStateIsConnecting,
    /** 已经正常连接 */
    FQConnectStateDidConnected,
    /** 错误了，正在断开，稍后会变成 FQConnectStateNotConnected */
    FQConnectStateConnectErr,
};




#endif /* FQNetDefines_h */
