//
//  LHHookManager.h
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/12.
//

#import <Foundation/Foundation.h>
#import "Aspects.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol LHHookManagerDelegate <NSObject>
//
//-(void)actionHookCallBackWithMethodName:(NSString*)methodName AspectInfo:(id<AspectInfo>)aspectInfo;
//
//@end

@interface LHHookManager : NSObject

+ (instancetype)shareInstance;

//@property (nonatomic,weak)id<LHHookManagerDelegate>delegate;

/// Hook要监听的事件
-(void)hookActionWithFuntionArray:(NSArray*)funtionAry;


@end

NS_ASSUME_NONNULL_END
