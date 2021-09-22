//
//  LHObjectContrastProtocol.h
//  LHPerformanceTest
//
//  Created by mac on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LHObjectContrastProtocol <NSObject>

/// 对象对比(测试成功率需要 ，找不到对应数据会默认当前成功率 为 0)
/// funtionName :方法名称
/// object:对比对象
/// index:和方法参数列表第几个对象对比
/// Return [ { funtionName:"object",index:XXX}]
-(NSArray*)objectContrastData;

@end

NS_ASSUME_NONNULL_END
