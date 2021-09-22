//
//  LHPerformanceTestManager.m
//  LHPerformanceTest
//
//  Created by mac on 2021/9/20.
//

#import "LHPerformanceTestManager.h"
#import "LHTimeConsumingDetectionManager.h"
#import "LHAppResourcesManager.h"
#import "LHActionSuccessRateManager.h"
#import "LHHookManager.h"
#import "LHPerformanceTestHUD.h"
#import "LHPerformanceInfoViewController.h"

@interface LHPerformanceTestManager ()<LHPerformanceTestHUDDelegate>

@property (nonatomic,strong) LHPerformanceTestHUD *hudView;

@end


@implementation LHPerformanceTestManager


static LHPerformanceTestManager* _instance = nil;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

//用alloc返回也是唯一实例
+(id) allocWithZone:(struct _NSZone *)zone {
   
   return [LHPerformanceTestManager shareInstance] ;
}

//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
   
   return [LHPerformanceTestManager shareInstance] ;//return _instance;
}

//对对象使用mutablecopy也是返回唯一实例
-(id)mutableCopyWithZone:(NSZone *)zone {
   
   return [LHPerformanceTestManager shareInstance] ;
}

- (instancetype)init {
    if (self = [super init]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.hudView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeConsuminFinish) name:@"SuccessRateFinish" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(testStart) name:@"LHTestStart" object:nil];
        
        
    }
    return self;
}




///对象对比(测试成功率需要)
///@param protocol 用于外部设置数据
-(void)setObjectContrastProtocol:(id<LHObjectContrastProtocol>)protocol{
    
    NSAssert((protocol != nil ), @"非法数据,请输入正确数据");
    
    [[LHActionSuccessRateManager shareInstance]setObjectContrastProtocol:protocol];
}


/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName{
    
    NSAssert((methonName != nil ||methonName.length > 0 ), @"非法字符串,请输入正确字符");
    
    [[LHTimeConsumingDetectionManager shareInstance]setLastMethonName:methonName];
    [[LHActionSuccessRateManager shareInstance]setLastMethonName:methonName];
    
}

/// 设置第一个调用的方法
-(void)setFirstMethonName:(NSString*)methonName{
    
    NSAssert((methonName != nil ||methonName.length > 0 ), @"非法字符串,请输入正确字符");
    
    [[LHTimeConsumingDetectionManager shareInstance]setFirstMethonName:methonName];
    [[LHActionSuccessRateManager shareInstance]setFirstMethonName:methonName];
    
}

/// 设置测试次数 （可选）
-(void)setTestCount:(NSInteger)testCount{
    
    [[LHTimeConsumingDetectionManager shareInstance]setTestCount:testCount];
    [[LHActionSuccessRateManager shareInstance]setTestCount:testCount];
    
}

///设置方法名称映射 （可选）
///@param nameMap 方法名称映射字典
-(void)setMethodNameMapping:(NSDictionary*)nameMap{
    
    [[LHTimeConsumingDetectionManager shareInstance]setMethodNameMapping:nameMap];
    [[LHActionSuccessRateManager shareInstance]setMethodNameMapping:nameMap];
}

/// hook 统计方法
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"XXXX"
///} ]
-(void)hookStatisticalFuntionWithFuntionData:(NSArray*)funtionData{
    
    NSAssert((funtionData != nil ||funtionData.count > 0 ), @"非法数据,请输入正确数据");
    
    [[LHHookManager shareInstance]hookActionWithFuntionArray:funtionData];
    
}

/// 获取方法整体耗时
-(NSString*)getConsumingCalculateTimeConsumingStr{
    
    return [[LHTimeConsumingDetectionManager shareInstance]getCalculateTimeConsumingStr];
}

// 获取方法阶段耗时字符串
-(NSString*)getConsumingPhaseTimeConsumingStr{
    
    return [[LHTimeConsumingDetectionManager shareInstance]getPhaseTimeConsumingStr];
}

/// 获取格式化计算整体耗时
-(NSString*)getCalculateTimeConsumingFormatStr{
    
    return [[LHTimeConsumingDetectionManager shareInstance]getCalculateTimeConsumingFormatStr];
}

/// 获取方法成功率
-(NSString*)getSuccessRateStr{
    
    return  [[LHActionSuccessRateManager shareInstance]getSuccessRateStr];
}

/// 获取格式成功率字符串
-(NSString*)getSuccessRateFormatStr{
    
    return  [[LHActionSuccessRateManager shareInstance]getSuccessRateFormatStr];
}

/// 获取方法阶段成功率
-(NSString*)getPhaseSuccessRateStr{
    
    return  [[LHActionSuccessRateManager shareInstance]getPhaseSuccessRateStr];
}

/// 获取Cpu 波动
-(NSString*)getCpuVolatility{
    
    return [[LHAppResourcesManager shareInstance]getCpuVolatility];
}

/// 获取内存 波动
-(NSString*)getMemoryVolatility{
    
    return [[LHAppResourcesManager shareInstance]getMemoryVolatility];
}

/// 获取电量 波动
-(NSString*)getElectricityVolatility{
    
    return [[LHAppResourcesManager shareInstance]getElectricityVolatility];
}

/// 获取已经测试次数
-(NSInteger)getAlreadyCount{
    
    return [[LHTimeConsumingDetectionManager shareInstance]getAlreadyCount];
}

#pragma mark - LHPerformanceTestHUDDelegate

-(void)statusBtnClick:(NSInteger)type{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"会在下个流程结束停止" preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction *ala1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self setTestCount: [self getAlreadyCount]+1];
    }];


    UIAlertAction *ala3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {


    }];

    [ac addAction:ala1];

    [ac addAction:ala3];

    //显示弹框
    UIViewController *currenVc = [self lh_findVisibleViewController];

    [currenVc presentViewController:ac animated:true completion:nil];
   
}

-(void)infoBtnClick{
    
    LHPerformanceInfoViewController *vc =[[LHPerformanceInfoViewController alloc]init];
    
    UIViewController *currenVc = [self lh_findVisibleViewController];
    [currenVc presentViewController:vc animated:YES completion:^{
        
        NSString* timeConsumingStr = [self getCalculateTimeConsumingFormatStr];
        NSString* allPhaseConsumingStr = [self getConsumingPhaseTimeConsumingStr];
        NSString* successRateStr =[[LHActionSuccessRateManager shareInstance]getSuccessRateFormatStr];
        NSString* allPhaseSuccessRateStr = [[LHActionSuccessRateManager shareInstance]getPhaseSuccessRateStr];;
        [vc setTestCount:[self getAlreadyCount]];
        [vc setTimeConsumingStr:timeConsumingStr AllPhaseConsumingStr:allPhaseConsumingStr];
        [vc setCpuUsageStr:[self getCpuVolatility] MemoryUsagStr:[self getMemoryVolatility]  ElectricityUsagStr:[self getElectricityVolatility]];
        [vc setSuccessRateStr:successRateStr AllPhaseSuccessRateStr:allPhaseSuccessRateStr];
        
    }];
    
}

- (UIViewController *)lh_getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}


- (UIViewController *)lh_findVisibleViewController {
    
    UIViewController* currentViewController = [self lh_getRootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

#pragma mark - Notification

/// 测试开始通知
-(void)testStart{

    [[LHAppResourcesManager shareInstance]start];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.hudView setStatusIsEnable:YES];
    });
    
}

/// 测试结束通知
-(void)timeConsuminFinish{
    
    [[LHAppResourcesManager shareInstance]stop];
    [[LHHookManager shareInstance]removeHookFuntion];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.hudView setStatusIsEnable:NO];
    });
   
    
}


#pragma mark - getter -setetr

-(LHPerformanceTestHUD *)hudView{
    
    if (!_hudView) {
        _hudView =[[LHPerformanceTestHUD alloc]initWithFrame:CGRectMake(0, 100, 200, 80)];
        _hudView.backgroundColor =[UIColor redColor];
        _hudView.delegate  = self;
        _hudView.layer.cornerRadius = 8;
    }
    
    return _hudView;
}



@end
