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

/// 开始统计
-(void)startStatistical;

/// 设置测试次数
-(void)setTestCount:(NSInteger)testCount;

/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName;


/// hook 统计方法
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

/// 获取当前数据绘制的视图
-(UIView*)getCurrenStatisticalView;

@end

NS_ASSUME_NONNULL_END
