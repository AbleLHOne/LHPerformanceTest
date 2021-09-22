//
//  LHActionSuccessRateManager.h
//  LHPerformanceTest
//
//  Created by mac on 2021/9/13.
//

#import <Foundation/Foundation.h>
#import "LHObjectContrastProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface LHActionSuccessRateManager : NSObject

+ (instancetype)shareInstance;

///对象对比(测试成功率需要)
///@param protocol 用于外部设置数据
-(void)setObjectContrastProtocol:(id<LHObjectContrastProtocol>)protocol;

///设置第一个调用的方法 （开启定时器和相关配置 必填）
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

///标记当前数据
///@param name 方法名称
///@param objectData 参数列表数据
-(void)markDataWithName:(NSString*)name ObjectData:(id)objectData;

/// 获取成功率
-(NSString*)getSuccessRateStr;

/// 获取格式成功率字符串
-(NSString*)getSuccessRateFormatStr;

/// 获取阶段成功率
-(NSString*)getPhaseSuccessRateStr;


@end

NS_ASSUME_NONNULL_END
