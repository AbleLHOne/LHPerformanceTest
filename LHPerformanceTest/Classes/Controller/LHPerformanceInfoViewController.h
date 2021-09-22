//
//  LHPerformanceInfoViewController.h
//  AFNetworking
//
//  Created by mac on 2021/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHPerformanceInfoViewController : UIViewController


///设置测试次数
///@param testCount 测试次数
-(void)setTestCount:(NSInteger)testCount;

/// 设置耗时数据
///@param consumingStr 全部测试数据耗时
///@param allPhaseConsumingStr 阶段测试数据耗时
-(void)setTimeConsumingStr:(NSString*)consumingStr AllPhaseConsumingStr:(NSString*)allPhaseConsumingStr;

/// 设置成功率数据
///@param successRateStr 全部测试数据成功率
///@param allPhaseSuccessRateStr 阶段测试数据成功率
-(void)setSuccessRateStr:(NSString*)successRateStr AllPhaseSuccessRateStr:(NSString*)allPhaseSuccessRateStr;

/// 设置App资源使用率数据、
///@param cpuUsageStr cpu测试数据
///@param memoryUsagStr 内存测试数据成功率
///@param electricityUsagStr 电量测试数据
-(void)setCpuUsageStr:(NSString*)cpuUsageStr MemoryUsagStr:(NSString*)memoryUsagStr ElectricityUsagStr:(NSString*)electricityUsagStr;


@end

NS_ASSUME_NONNULL_END
