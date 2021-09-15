//
//  LHAppResourcesManager.h
//  LHPerformanceTest
//
//  Created by mac on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHAppResourcesManager : NSObject


+ (instancetype)shareInstance;

/// 开启检测
-(void)start;

/// 关闭检测
-(void)stop;

/// 获取Cpu 波动
-(NSString*)getCpuVolatility;

/// 获取内存 波动 
-(NSString*)getMemoryVolatility;

/// 获取电量 波动
-(NSString*)getElectricityVolatility;

@end

NS_ASSUME_NONNULL_END
