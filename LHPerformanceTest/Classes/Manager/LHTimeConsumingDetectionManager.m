//
//  LHTimeConsumingDetectionManager.m
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/10.
//

#import "LHTimeConsumingDetectionManager.h"
#import "LHTimeManager.h"
#import "LHHookManager.h"


@interface LHTimeConsumingDetectionManager ()

@property(nonatomic,assign)BOOL isOnce;

@end

@implementation LHTimeConsumingDetectionManager

static LHTimeConsumingDetectionManager* _instance = nil;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

//用alloc返回也是唯一实例
+(id) allocWithZone:(struct _NSZone *)zone {
   
   return [LHTimeConsumingDetectionManager shareInstance] ;
}

//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
   
   return [LHTimeConsumingDetectionManager shareInstance] ;//return _instance;
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

/// 设置测试次数
-(void)setTestCount:(NSInteger)testCount{
    
    [[LHTimeManager shareInstance]setTestCount:testCount];
}

/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName{
    
    [[LHTimeManager shareInstance]setLastMethonName:methonName];
}

/// 开始统计
-(void)startStatistical{
    
    [[LHTimeManager shareInstance]startTime];
}

/// hook 统计方法
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"XXXX"
///} ]
-(void)hookStatisticalFuntionWithFuntionData:(NSArray*)funtionData{
    
    [[LHHookManager shareInstance]hookActionWithFuntionArray:funtionData];
}

/// 计算整体耗时
-(NSString*)getCalculateTimeConsumingStr{
    
    return [[LHTimeManager shareInstance]getCalculateTimeConsumingStr];
}

// 获取阶段耗时字符串
-(NSString*)getPhaseTimeConsumingStr{
    
    return [[LHTimeManager shareInstance]getPhaseTimeConsumingStr];
}

/// 获取当前数据绘制的视图
-(UIView*)getCurrenStatisticalView{
    
    return [UIView new];
}


@end
