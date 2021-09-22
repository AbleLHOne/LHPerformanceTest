//
//  NSObject+LHPropertyListing.h
//  LHPerformanceTest
//
//  Created by mac on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LHPropertyListing)

/// 2、/* 获取对象的所有属性 以及属性值 */

- (NSDictionary *)properties_aps;

@end

NS_ASSUME_NONNULL_END
