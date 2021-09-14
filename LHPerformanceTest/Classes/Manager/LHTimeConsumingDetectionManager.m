//
//  LHTimeConsumingDetectionManager.m
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/10.
//

#import "LHTimeConsumingDetectionManager.h"
#import "LHTimeManager.h"
#import "LHHookManager.h"

@interface LHTimeConsumingDetectionManager ()<LHHookManagerDelegate>

@property(nonatomic,assign)BOOL             isOnce;
@property(nonatomic,strong)LHTimeManager   *timeManager;
@property(nonatomic,strong)LHHookManager   *hookManager;

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
   
   return [LHTimeConsumingDetectionManager shareInstance] ;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

/// 设置测试次数
-(void)setTestCount:(NSInteger)testCount{
    
    [self.timeManager setTestCount:testCount];
}

/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName{
    
    [self.timeManager setLastMethonName:methonName];
}

/// 开始统计
-(void)startStatistical{
    
    [self.timeManager startTime];
}

/// hook 统计方法
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"XXXX"
///} ]
-(void)hookStatisticalFuntionWithFuntionData:(NSArray*)funtionData{
    
    [self.hookManager hookActionWithFuntionArray:funtionData];
}

/// 计算整体耗时
-(NSString*)getCalculateTimeConsumingStr{
    
    return [self.timeManager getCalculateTimeConsumingStr];
}

/// 获取计算整体耗时
-(NSString*)getCalculateTimeConsumingFormatStr{
    
    
    return [self.timeManager getCalculateTimeConsumingFormatStr];;
}



// 获取阶段耗时字符串
-(NSString*)getPhaseTimeConsumingStr{
    
    return [self.timeManager getPhaseTimeConsumingStr];
}

/// 获取当前数据绘制的视图
-(UIView*)getCurrenStatisticalView{
    
    return [UIView new];
}

#pragma mark - LHHookManagerDelegate

-(void)actionHookCallBackWithMethodName:(NSString*)methodName AspectInfo:(id<AspectInfo>)aspectInfo{
    
    [self.timeManager markTimeWithName:methodName];
}

#pragma mark - getter - setter

-(LHTimeManager *)timeManager{
    
    if (!_timeManager) {
        
       _timeManager =[[LHTimeManager alloc]init];
    }
    return _timeManager;
}

-(LHHookManager *)hookManager{
    
    if (!_hookManager) {
        _hookManager =[[LHHookManager alloc]init];
        _hookManager.delegate = self;
    }
    
    return _hookManager;
}


@end
