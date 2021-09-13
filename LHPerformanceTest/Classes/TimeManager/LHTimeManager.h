//
//  LHTimeManager.h
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHTimeManager : NSObject


/// 开启
-(void)startTime;

/// 关闭
-(void)stopTime;

/// 设置测试次数
-(void)setTestCount:(NSInteger)testCount;

/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName;

///标记当前时间
-(void)markTimeWithName:(NSString*)name;

/// 计算整体耗时
-(NSString*)getCalculateTimeConsumingStr;

// 获取阶段耗时字符串
-(NSString*)getPhaseTimeConsumingStr;

@end

NS_ASSUME_NONNULL_END
