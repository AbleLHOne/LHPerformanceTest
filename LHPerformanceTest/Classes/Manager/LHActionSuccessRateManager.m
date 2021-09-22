//
//  LHActionSuccessRateManager.m
//  LHPerformanceTest
//
//  Created by mac on 2021/9/13.
//

#import "LHActionSuccessRateManager.h"
#import "LHHookManager.h"
#import "NSObject+LHPropertyListing.h"

@interface LHActionSuccessRateManager()

@property (nonatomic,assign) NSInteger          testCount;
@property (nonatomic,strong) NSString          *lastMethonName;
@property (nonatomic,strong) NSString          *firstMethonName;
@property (nonatomic,assign) NSInteger          alreadyCount; // 已经测试的次数
@property (nonatomic,assign) NSInteger          successCount; // 成功的次数
@property (nonatomic,strong) NSMutableArray     *markDataAry;
@property (nonatomic,strong) NSMutableArray     *alreadyArray;
@property (nonatomic,strong) NSString           *successRateStr;
@property (nonatomic,strong) NSString           *successPhaseRateStr;
@property (nonatomic,strong) NSString           *successRateFormatStr;
@property (nonatomic,strong) NSDictionary       *nameDict;

@property (nonatomic,weak)   id<LHObjectContrastProtocol>protocol;

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
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hookAction:) name:@"HookAction" object:nil];
        
    }
    return self;
}



-(void)start{
    
    self.successCount = 0;
    
    [self.alreadyArray removeAllObjects];
    [self.markDataAry removeAllObjects];

    self.successRateStr = nil;
    self.successPhaseRateStr = nil;
    
}

-(void)reset{
    
    self.alreadyCount = 0;
}



///对象对比(测试成功率需要)
///@param protocol 用于外部设置数据
-(void)setObjectContrastProtocol:(id<LHObjectContrastProtocol>)protocol{
    
    if (protocol) {
        self.protocol = protocol;
    }
}


/// hook 统计方法
///funtionData = [  {
///    className:"XXXX"
///    funtionName:"XXXX"
///} ]
-(void)hookStatisticalFuntionWithFuntionData:(NSArray*)funtionData{
    
    [[LHHookManager shareInstance]hookActionWithFuntionArray:funtionData];
}

/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName{
    
    _lastMethonName = methonName;
    
}

/// 设置第一个调用的方法
-(void)setFirstMethonName:(NSString*)methonName{
    
    _firstMethonName = methonName;
}


/// 设置测试次数
-(void)setTestCount:(NSInteger)testCount{
    
    _testCount = testCount;
}

///设置方法名称映射 （可选）
///@param nameMap 方法名称映射字典
-(void)setMethodNameMapping:(NSDictionary*)nameMap{
    
    self.nameDict = nameMap;
    
}

///标记当前数据
-(void)markDataWithName:(NSString*)name ObjectData:(NSArray*)objectData{
    
    @synchronized (self) {
        
        if ([self.firstMethonName isEqualToString:name]) {
            
            if (self.alreadyCount == 0) {
                
                [self start];
            }
            
        }else{
            
            NSString * isSuccess = [self checkObjectCorrectWithObjectData:objectData Name:name];
         
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSString*newName = name;
            if (self.nameDict[name]) {
                newName = self.nameDict[name];
            }
            
            [dict setValue:isSuccess forKey:successKey];
            [dict setValue:newName forKey:funtionNameKey];
            [self.markDataAry addObject:dict];
            [self checkisLastMethonName:name MarkDataAry:self.markDataAry.copy];
        }
        
    }
    
}

-(NSString*)checkObjectCorrectWithObjectData:(NSArray*)objectData Name:(NSString*)name{
    
   __block NSString * isSuccess = @"0";
    
    NSDictionary*dict = [self findClassDataWithMethodName:name];
    
    if (dict) {
        
        int index  = [dict[@"index"] intValue];
        
        if (index >=objectData.count) {
            
            return isSuccess;
        }
        
        
       id object =objectData[index];
        
        id value = dict[name];
        
        
        /// 优先对比是否 BOOL 和 NSString 类型
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
        
        NSDictionary*contrastDict = [object properties_aps];
        
        NSDictionary*parameterDict = [value properties_aps];
        
        /// 以提供数据为准 精确对比
        [contrastDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            if (parameterDict[key] ==  obj) {
                
                isSuccess = @"1";
            }else{
                
                isSuccess = @"0";
            }
        }];
    
    }
    
    return isSuccess;
}


/// 检测是否最后一个方法
-(void)checkisLastMethonName:(NSString*)methonName MarkDataAry:(NSArray*)markDataAry{
    
    if ([self.lastMethonName isEqualToString:methonName]) {
        
        self.alreadyCount++;
        
        [self.alreadyArray addObject:markDataAry];
        [self.markDataAry removeAllObjects];
        
        
        if (self.alreadyCount == self.testCount) {
            
            [self printTimeConsumingStr];
        }
    }
}

/// 查找对应的关键字
-(NSDictionary*)findClassDataWithMethodName:(NSString*)methodName{
    
    if ([self.protocol respondsToSelector:@selector(objectContrastData)]) {
        
        NSArray * dictAry = [self.protocol objectContrastData];
        
        for (NSDictionary*dict in dictAry) {
            
            if (dict[methodName]) {
                
                return dict;
            }
        }
        
    }
    
    return nil;
}

/// 打印
-(void)printTimeConsumingStr{
    
    self.successRateStr = [self setSuccessRateStrWithMarkDataAry:self.alreadyArray];
    self.successPhaseRateStr = [self setPhaseSuccessRateStrWithAlreadyArray:self.alreadyArray];
//    NSLog(@"%@",self.successRateStr);
//    NSLog(@"%@", self.successPhaseRateStr);
    [self reset];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SuccessRateFinish" object:nil];
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

/// 获取格式化成功率字符串
-(NSString*)getSuccessRateFormatStr{
    
    return self.successRateFormatStr;
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
    
    self.successRateFormatStr = rateStr;
    
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
        
        rate = rate>100?100:rate;
        
        rateStr = [NSString stringWithFormat:@"%@%@ ---》》》成功率: %.1f %%\n",rateStr,key,rate];
        
    }];
    
    
    return rateStr;
}


#pragma mark - NSNotification

-(void)hookAction:(NSNotification*)noti{
    
    NSDictionary*dict = noti.object;
    
    NSArray * arguments = dict[@"AspectInfo"];
    
    [self markDataWithName:dict[@"methodName"] ObjectData:arguments];
    
}


#pragma mark - getter - setter



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


-(NSDictionary *)nameDict{
    
    if (!_nameDict) {
        
        _nameDict = [NSDictionary dictionary];
        
    }
    
    return _nameDict;
}



@end
