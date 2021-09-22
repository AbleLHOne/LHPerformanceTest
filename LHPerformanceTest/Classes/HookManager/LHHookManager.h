//
//  LHHookManager.h
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/12.
//

#import <Foundation/Foundation.h>
#import "Aspects.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHHookManager : NSObject

+ (instancetype)shareInstance;

/// Hook要监听的事件
-(void)hookActionWithFuntionArray:(NSArray*)funtionAry;

/// 删除Hook方法
-(void)removeHookFuntion;

@end

NS_ASSUME_NONNULL_END
