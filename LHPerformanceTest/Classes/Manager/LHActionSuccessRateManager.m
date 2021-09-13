//
//  LHActionSuccessRateManager.m
//  LHPerformanceTest
//
//  Created by mac on 2021/9/13.
//

#import "LHActionSuccessRateManager.h"
#import "LHHookManager.h"

@interface LHActionSuccessRateManager()<LHHookManagerDelegate>

@property (nonatomic,assign) NSInteger          testCount;
@property (nonatomic,strong) NSString          *lastMethonName;
@property (nonatomic,assign) NSInteger          alreadyCount; // 已经测试的次数
@property (nonatomic,assign) NSInteger          successCount; // 成功的次数
@property (nonatomic,strong) LHHookManager      *hookManager;
@property (nonatomic,strong) NSMutableArray     *markDataAry;
@property (nonatomic,strong) NSMutableArray     *alreadyArray;
@property (nonatomic,strong) NSString           *successRateStr;
@property (nonatomic,strong) NSString           *successPhaseRateStr;
@property (nonatomic,strong) NSMutableArray     *classDataAry;

 
@end

@implementation LHActionSuccessRateManager

static NSString * funtionNameKey = @"funtionName";
static NSString * successKey = @"success";


static LHActionSuccessRateManager* _instance = nil;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

//用alloc返回也是唯一实例
+(id) allocWithZone:(struct _NSZone *)zone {
   
   return [LHActionSuccessRateManager shareInstance] ;
}

//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
   
   return [LHActionSuccessRateManager shareInstance] ;//return _instance;
}

//对对象使用mutablecopy也是返回唯一实例
-(id)mutableCopyWithZone:(NSZone *)zone {
   
   return [LHActionSuccessRateManager shareInstance] ;
}

- (instancetype)init {
    if (self = [super init]) {
        
      
        self.lastMethonName = @"";
        [self hookManager];
        
    }
    return self;
}

-(void)start{
    
    self.alreadyCount = 0;
    self.successCount = 0;
    
    [self.alreadyArray removeAllObjects];
    [self.markDataAry removeAllObjects];

    self.successRateStr = nil;
    self.successPhaseRateStr = nil;
    
}

/// hook 统计方法
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"XXXX"
///} ]
-(void)hookStatisticalFuntionWithFuntionData:(NSArray*)funtionData{
    
    [self.hookManager hookActionWithFuntionArray:funtionData];
    
}

/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName{
    
    _lastMethonName = methonName;
    
}

/// 设置测试次数
-(void)setTestCount:(NSInteger)testCount{
    
    _testCount = testCount;
}

///标记当前数据
-(void)markDataWithName:(NSString*)name ObjectData:(NSArray*)objectData{
    
    @synchronized (self) {
        
        NSString * isSuccess = [self checkObjectCorrectWithObjectData:objectData Name:name];
     
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setValue:isSuccess forKey:successKey];
        [dict setValue:name forKey:funtionNameKey];
        [self.markDataAry addObject:dict];
        [self checkisLastMethonName:name MarkDataAry:self.markDataAry.copy];
    }
    
}

-(NSString*)checkObjectCorrectWithObjectData:(NSArray*)objectData Name:(NSString*)name{
    
    NSString * isSuccess = @"0";
    
    NSDictionary*dict = [self findClassDataWithMethodName:name];
    
    if (dict) {
        
        for (id object in objectData) {
            
            NSString*className = dict[@"className"];
            
            id value = dict[@"keyWord"];
            
            Class cls = NSClassFromString(className);
            
            if ([object isKindOfClass:[NSNumber class]]) {
                
                if ([object intValue] == [value intValue]) {
                    
                    isSuccess = @"1";
                }
            }
            
            
            if ([object isKindOfClass:[NSString class]]) {
                
                if ([object isEqualToString:value]) {
                    
                    isSuccess = @"1";
                }
            }
            
            if ([object isKindOfClass:[cls class]]) {
                
//                if (object) {
//                    
//                    isSuccess = @"1";
//                }
            }
            
        }
    }
 
    return isSuccess;
}


/// 检测是否最后一个方法
-(void)checkisLastMethonName:(NSString*)methonName MarkDataAry:(NSArray*)markDataAry{
    
    if ([self.lastMethonName isEqualToString:methonName]) {
        
        if (self.alreadyCount == self.testCount || self.testCount < 1) {
            
            [self printTimeConsumingStr];
            
            
        }else{
            
            [self.alreadyArray addObject:markDataAry];
            [self.markDataAry removeAllObjects];
            self.alreadyCount++;
            
            if (self.alreadyCount == self.testCount) {
                [self afterCall];
            }
            
        }
    }
}

/// 打印
-(void)printTimeConsumingStr{
    
    self.successRateStr = [self setSuccessRateStrWithMarkDataAry:self.alreadyArray];
    self.successPhaseRateStr = [self setPhaseSuccessRateStrWithAlreadyArray:self.alreadyArray];
    NSLog(@"%@",self.successRateStr);
    NSLog(@"%@", self.successPhaseRateStr);
}

-(void)afterCall{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self checkisLastMethonName:self.lastMethonName MarkDataAry:self.markDataAry];
    });
}


/// 获取成功率
-(NSString*)getSuccessRateStr{
    
    return self.successRateStr;
}

/// 获取阶段成功率
-(NSString*)getPhaseSuccessRateStr{
    
    return self.successPhaseRateStr;
}


/// 设置
-(NSString*)setSuccessRateStrWithMarkDataAry:(NSArray*)markDataAry{
    
    CGFloat successCount = 0;
    CGFloat methonCount = 0;
    for (NSArray*dictAry in markDataAry) {
        
        methonCount = dictAry.count;
        for (NSDictionary*dict in dictAry) {
            
            if ([dict[successKey] isEqualToString:@"1"]) {
                
                successCount++;
            }
        }
    }
    
    CGFloat rate = (successCount/(self.testCount*methonCount))*100;
    
    NSString*rateStr = [NSString stringWithFormat:@"%ld次流程整体成功率:%.1f %%",(long)self.testCount,rate];
    
    rateStr = [NSString stringWithFormat:@"\n\n🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉\n\n%@\n\n🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉\n",rateStr];

    return rateStr;
    
}

/// 设置
-(NSString*)setPhaseSuccessRateStrWithAlreadyArray:(NSArray*)alreadyArray{
    
    
    NSString *phaseStr = @"";

    int index = 1;
    for (NSArray*markDataArray in alreadyArray) {
        
        NSString *onceSuccessRateStr = [self getOncePhaseSuccessRateStrWithmarkDataAry:markDataArray];
        
        
        phaseStr = [NSString stringWithFormat:@"%@第%d次测试\n%@",phaseStr,index,onceSuccessRateStr];
        
     
        index++;
    }
    
    return phaseStr;
}


-(NSString*)getOncePhaseSuccessRateStrWithmarkDataAry:(NSArray*)markDataAry{
        
    NSMutableDictionary *successDict = [NSMutableDictionary dictionary];
    
    for (NSDictionary*dict in markDataAry) {
        
        NSString*funtionName = dict[funtionNameKey];
        
        if ([dict[successKey] isEqualToString:@"1"]) {
            
            if (successDict[funtionName]) {
                
                int count = [successDict[funtionName] intValue];
                
                [successDict setValue:[NSString stringWithFormat:@"%d",count+1] forKey:funtionName];
                
            }else{
                
                [successDict setValue:@"1" forKey:funtionName];
            }
        }else{
            
            [successDict setValue:@"0" forKey:funtionName];
            
        }
    }
    
    __block NSString*rateStr = @"";
    
    [successDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        CGFloat rate = ([obj intValue]/1)*100;
        
        rateStr = [NSString stringWithFormat:@"%@%@-成功率:%.1f %%\n",rateStr,key,rate];
        
    }];
    
    
    return rateStr;
}

/// 设置对象对比是否成功
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"xxxx"
///    keyWord:xxxx
///} ]
-(void)setCheckClassData:(NSArray*)classData{
    
    self.classDataAry = classData.mutableCopy;

}

/// 查找对应的关键字
-(NSDictionary*)findClassDataWithMethodName:(NSString*)methodName{
    
    
    for (NSDictionary*dict in self.classDataAry) {
        
        if ([dict[funtionNameKey] isEqualToString:methodName]) {
            
            return dict;
        }
    }
    
    
    return nil;
}



#pragma mark - LHHookManagerDelegate

-(void)actionHookCallBackWithMethodName:(NSString*)methodName AspectInfo:(id<AspectInfo>)aspectInfo{
    
    [self markDataWithName:methodName ObjectData:aspectInfo.arguments];
    
}


#pragma mark - getter - setter

-(LHHookManager *)hookManager{
    
    if (!_hookManager) {
        _hookManager =[[LHHookManager alloc]init];
        _hookManager.delegate = self;
    }
    
    return _hookManager;
}


-(NSMutableArray *)markDataAry{
    
    if (!_markDataAry) {
        
        _markDataAry = [NSMutableArray array];
    }
    return _markDataAry;
}

-(NSMutableArray *)alreadyArray{
    
    if (!_alreadyArray) {
        
        _alreadyArray = [NSMutableArray array];
    }
    return _alreadyArray;
}



@end
