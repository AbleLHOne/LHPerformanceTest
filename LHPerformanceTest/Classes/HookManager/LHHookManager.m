//
//  LHHookManager.m
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/12.
//

#import "LHHookManager.h"
#import "Aspects.h"
#import "LHTimeManager.h"

@interface LHHookManager ()

@end

@implementation LHHookManager

static LHHookManager* _instance = nil;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

//用alloc返回也是唯一实例
+(id) allocWithZone:(struct _NSZone *)zone {
   
   return [LHHookManager shareInstance] ;
}

//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
   
   return [LHHookManager shareInstance] ;//return _instance;
}

//对对象使用mutablecopy也是返回唯一实例
-(id)mutableCopyWithZone:(NSZone *)zone {
   
   return [LHTimeManager shareInstance] ;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}


/// Hook要监听的事件
-(void)hookActionWithFuntionArray:(NSArray*)funtionAry{
    
    for (NSDictionary*dict in funtionAry) {
       
        NSString*className = dict[@"className"];
        NSString*funtionName =dict[@"funtionName"];
        SEL method =NSSelectorFromString(funtionName);
        Class cls =  NSClassFromString(className);
        [cls aspect_hookSelector:method withOptions:AspectPositionAfter usingBlock:^(){
            
            [self actionHookCallBackWithMethodName:funtionName];
            
        } error:nil];
    }

}

/// Hook方法回调
-(void)actionHookCallBackWithMethodName:(NSString*)methodName{
    
    [[LHTimeManager shareInstance]markTimeWithName:methodName];
    
}

@end
