//
//  LHPerformanceTestManager.h
//  LHPerformanceTest
//
//  Created by mac on 2021/9/20.
//

#import <Foundation/Foundation.h>
#import "LHObjectContrastProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHPerformanceTestManager : NSObject

/// 单例
+ (instancetype)shareInstance;

///对象对比(测试成功率需要)
///@param protocol 用于获取外部设置数据
-(void)setObjectContrastProtocol:(id<LHObjectContrastProtocol>)protocol;

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

///Hook 统计方法
///@param funtionData 统计方法字典数据
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"XXXX"
///} ]
-(void)hookStatisticalFuntionWithFuntionData:(NSArray*)funtionData;

/// 获取方法整体耗时
-(NSString*)getConsumingCalculateTimeConsumingStr;

// 获取方法阶段耗时字符串
-(NSString*)getConsumingPhaseTimeConsumingStr;

/// 获取格式化计算整体耗时
-(NSString*)getCalculateTimeConsumingFormatStr;

/// 获取方法成功率
-(NSString*)getSuccessRateStr;

/// 获取格式成功率字符串
-(NSString*)getSuccessRateFormatStr;

/// 获取方法阶段成功率
-(NSString*)getPhaseSuccessRateStr;

/// 获取Cpu 波动
-(NSString*)getCpuVolatility;

/// 获取内存 波动
-(NSString*)getMemoryVolatility;

/// 获取电量 波动
-(NSString*)getElectricityVolatility;

/// 获取已经测试次数
-(NSInteger)getAlreadyCount;



@end

NS_ASSUME_NONNULL_END
