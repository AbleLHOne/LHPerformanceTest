//
//  LHHookManager.m
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/12.
//

#import "LHHookManager.h"

#import "LHTimeManager.h"

@interface LHHookManager ()

@property (nonatomic,strong) NSMutableArray *aspectTokenArray;

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
   
   return [LHHookManager shareInstance] ;
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
        id<AspectToken> token = [cls aspect_hookSelector:method withOptions:AspectPositionBefore usingBlock:^(id <AspectInfo> info){
            
            NSLog(@"method ==== %@",funtionName);
            
            [self actionHookCallBackWithMethodName:funtionName AspectInfo:info];
            
        } error:nil];
        
        [self.aspectTokenArray addObject:token];
    }

}

/// Hook方法回调
-(void)actionHookCallBackWithMethodName:(NSString*)methodName AspectInfo:(id<AspectInfo>)aspectInfo{
    
    NSDictionary*dict = @{
        
        @"methodName":methodName,
        @"AspectInfo":aspectInfo.arguments
    };
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HookAction" object:dict];
    
}

/// 删除Hook方法
-(void)removeHookFuntion{
    
    for (id<AspectToken> token in self.aspectTokenArray) {
        [token remove];
    }
    
    [self.aspectTokenArray removeAllObjects];
}



-(NSMutableArray *)aspectTokenArray{
    
    if (!_aspectTokenArray) {
        _aspectTokenArray =[NSMutableArray array];

    }
    
    return _aspectTokenArray;
}



@end
