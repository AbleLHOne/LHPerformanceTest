//
//  LHHookManager.m
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/12.
//

#import "LHHookManager.h"

#import "LHTimeManager.h"

@interface LHHookManager ()

@end

@implementation LHHookManager

/// Hook要监听的事件
-(void)hookActionWithFuntionArray:(NSArray*)funtionAry{
    
    for (NSDictionary*dict in funtionAry) {
       
        NSString*className = dict[@"className"];
        NSString*funtionName =dict[@"funtionName"];
        SEL method =NSSelectorFromString(funtionName);
        Class cls =  NSClassFromString(className);
        [cls aspect_hookSelector:method withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> info){
            
            NSLog(@"%@",info.arguments);
            
            [self actionHookCallBackWithMethodName:funtionName AspectInfo:info];
            
        } error:nil];
    }

}

/// Hook方法回调
-(void)actionHookCallBackWithMethodName:(NSString*)methodName AspectInfo:(id<AspectInfo>)aspectInfo{
    
    if ([self.delegate respondsToSelector:@selector(actionHookCallBackWithMethodName:AspectInfo:)]) {
        
        [self.delegate actionHookCallBackWithMethodName:methodName AspectInfo:aspectInfo];
    }

}



@end
