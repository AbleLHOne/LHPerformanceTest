//
//  LHAppResourcesManager.m
//  LHPerformanceTest
//
//  Created by mac on 2021/9/15.
//

#import "LHAppResourcesManager.h"
#import <mach/mach.h>
#import <objc/runtime.h>


@interface LHAppResourcesManager ()

@property (nonatomic,assign) CGFloat    startCpuUsage;
@property (nonatomic,assign) CGFloat    stopCpuUsage;
@property (nonatomic,assign) NSInteger  startMemoryUsage;
@property (nonatomic,assign) NSInteger  stopMemoryUsage;
@property (nonatomic,assign) int        startBatteryUsage;
@property (nonatomic,assign) int        stopBatteryUsage;


@end

@implementation LHAppResourcesManager


static LHAppResourcesManager* _instance = nil;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

//用alloc返回也是唯一实例
+(id) allocWithZone:(struct _NSZone *)zone {
   
   return [LHAppResourcesManager shareInstance] ;
}

//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
   
   return [LHAppResourcesManager shareInstance] ;//return _instance;
}

//对对象使用mutablecopy也是返回唯一实例
-(id)mutableCopyWithZone:(NSZone *)zone {
   
   return [LHAppResourcesManager shareInstance] ;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


/// 开启检测
-(void)start{
    
    self.startCpuUsage = [self cpuUsageForApp];
    self.startMemoryUsage = [self useMemoryForApp];
    self.startBatteryUsage = [self getCurrentBatteryLevel];
    
}
/// 关闭检测
-(void)stop{
    
    self.stopCpuUsage = [self cpuUsageForApp];
    self.stopMemoryUsage = [self useMemoryForApp];
    self.stopBatteryUsage = [self getCurrentBatteryLevel];

}

/// 获取Cpu 波动
-(NSString*)getCpuVolatility{
    
    return [NSString stringWithFormat:@" %.1f%% -- %.1f%%",self.startCpuUsage*100,self.stopCpuUsage*100];
}

/// 获取内存 波动
-(NSString*)getMemoryVolatility{
    
    return [NSString stringWithFormat:@" %ldM -- %ldM",(long)self.startMemoryUsage,(long)self.stopMemoryUsage];
}

/// 获取电量 波动
-(NSString*)getElectricityVolatility{
    
    
    return [NSString stringWithFormat:@" %d -- %d",self.startBatteryUsage,self.stopBatteryUsage];
}



// 获取 CPU 使用率
- (CGFloat)cpuUsageForApp {
    kern_return_t           kr;
    thread_array_t          thread_list;
    mach_msg_type_number_t  thread_count;
    thread_info_data_t      thinfo;
    mach_msg_type_number_t  thread_info_count;
    thread_basic_info_t     basic_info_th;

    // 根据当前 task 获取所有线程
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS)
        return -1;

    float total_cpu_usage = 0;
    // 遍历所有线程
    for (int i = 0; i < thread_count; i++) {
        thread_info_count = THREAD_INFO_MAX;
        // 获取每一个线程信息
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS)
            return -1;

        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            // cpu_usage : Scaled cpu usage percentage. The scale factor is TH_USAGE_SCALE.
            // 宏定义 TH_USAGE_SCALE 返回 CPU 处理总频率：
            total_cpu_usage += basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }

    // 注意方法最后要调用 vm_deallocate，防止出现内存泄漏
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    return total_cpu_usage;
}


// 当前 app 内存使用量
- (CGFloat)useMemoryForApp {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (kernelReturn == KERN_SUCCESS) {
        int64_t memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        return memoryUsageInByte / 1024 / 1024;
    } else {
        return -1;
    }
}


/// 获取电量
- (int)getCurrentBatteryLevel
{
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0)
                {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar)
                    {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        //这种方式也可以
                        /*ptrdiff_t offset = ivar_getOffset(ivar);
                         unsigned char *stuffBytes = (unsigned char *)(__bridge void *)bview;
                         batteryLevel = * ((int *)(stuffBytes + offset));*/
                        NSLog(@"电池电量:%d",batteryLevel);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                            
                        } else {
                            return 0;
                        }
                    }
                    
                }
                
            }
        }
    }
    
    return 0;
}




@end
