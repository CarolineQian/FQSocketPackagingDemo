//
//  FQSocketDataBuffer.h
//  FQConnectDemo
//
//  Created by 冯倩 on 2017/6/23.
//  Copyright © 2017年 冯倩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FQSocketDataBuffer;

@protocol FQSocketDataBufferDelegate<NSObject>
@required
/** 组装完整数据时，将其返回。如果 packageData 是空，则表示收到了空数据。 */
- (void)socketDataBuffer:(FQSocketDataBuffer *)buffer
         didCompleteData:(NSData *)data
          encodeMarkData:(NSData *)encodeMarkData;
@end



@interface FQSocketDataBuffer : NSObject

@property(nonatomic, weak) id<FQSocketDataBufferDelegate> delegate;


/** 接收到一次数据，如果可以组成一个完成报文或者报文数据错乱，会回调相应的委托方法 */
- (void)receiveSocketData:(NSData *)data;



@end
