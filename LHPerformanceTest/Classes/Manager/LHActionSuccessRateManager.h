//
//  LHActionSuccessRateManager.h
//  LHPerformanceTest
//
//  Created by mac on 2021/9/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHActionSuccessRateManager : NSObject


+ (instancetype)shareInstance;


-(void)start;

/// hook 统计方法
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"XXXX"
///} ]
-(void)hookStatisticalFuntionWithFuntionData:(NSArray*)funtionData;

/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName;

/// 设置测试次数
-(void)setTestCount:(NSInteger)testCount;

///标记当前数据
-(void)markDataWithName:(NSString*)name ObjectData:(id)objectData;

/// 获取成功率
-(NSString*)getSuccessRateStr;

/// 获取格式成功率字符串
-(NSString*)getSuccessRateFormatStr;

/// 获取阶段成功率
-(NSString*)getPhaseSuccessRateStr;

/// 设置对象对比是否成功
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"keyWord"
///} ]
-(void)setCheckClassData:(NSArray*)ClassData;;

@end

NS_ASSUME_NONNULL_END
