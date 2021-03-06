//
//  LHTimeConsumingDetectionManager.h
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHTimeConsumingDetectionManager : NSObject

+ (instancetype)shareInstance;

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

/// 获取计算整体耗时
-(NSString*)getCalculateTimeConsumingStr;

/// 获取计算整体耗时
-(NSString*)getCalculateTimeConsumingFormatStr;

// 获取阶段耗时字符串
-(NSString*)getPhaseTimeConsumingStr;

/// 获取测试次数
-(NSInteger)getAlreadyCount;

@end

NS_ASSUME_NONNULL_END
