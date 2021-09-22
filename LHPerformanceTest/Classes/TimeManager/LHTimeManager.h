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

///设置第一个调用的方法 （开启定时器和相关配置, 必填）
///@param methonName :第一个调用方法名称
-(void)setFirstMethonName:(NSString*)methonName;

///设置最后一个调用的方法 （关闭相关配置 必填）
///@param methonName :最后一个调用方法名称
-(void)setLastMethonName:(NSString*)methonName;

///设置测试次数 （可选）
///@param testCount 测试次数
-(void)setTestCount:(NSInteger)testCount;

///设置方法名称映射 （可选）
///@param nameMap 方法名称映射字典
-(void)setMethodNameMapping:(NSDictionary*)nameMap;

///标记当前时间
-(void)markTimeWithName:(NSString*)name;

/// 计算整体耗时
-(NSString*)getCalculateTimeConsumingStr;

// 获取阶段耗时字符串
-(NSString*)getPhaseTimeConsumingStr;

/// 获取计算整体耗时
-(NSString*)getCalculateTimeConsumingFormatStr;

/// 获取测试次数
-(NSInteger)getAlreadyCount;


@end

NS_ASSUME_NONNULL_END
