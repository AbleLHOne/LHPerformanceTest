//
//  LHTimeManager.m
//  LHTimeConsumingDetection
//
//  Created by mac on 2021/9/10.
//

#import "LHTimeManager.h"

@interface LHTimeManager ()

@property (nonatomic,assign) int                timeInterval;
@property (nonatomic,strong) NSString          *startTimeStamp;
@property (nonatomic,strong) NSString          *stopTimeStamp;
@property (nonatomic,strong) NSMutableArray    *markTimeArray;
@property (nonatomic,assign) NSInteger          testCount;
@property (nonatomic,strong) NSString          *lastMethonName;
@property (nonatomic,strong) NSString          *firstMethonName;
@property (nonatomic,assign) NSInteger          alreadyCount; // 已经测试的次数
@property (nonatomic,assign) NSInteger          oldAlreadyCount;
@property (nonatomic,strong) NSMutableArray    *alreadyTimeArray;
@property (nonatomic,strong) NSString          *timeConsumingStr;
@property (nonatomic,strong) NSString          *phaseConsumingStr;
@property (nonatomic,strong) NSString          *timeConsumingFormatStr;
@property (nonatomic,strong) NSString          *phaseConsumingFormatStr;

@property (nonatomic,strong) NSDictionary      *nameDict;


@end

@implementation LHTimeManager

static NSString * timeStampKey = @"timeStamp";
static NSString * funtionNameKey = @"funtionName";
static NSString * timeConsumingKey = @"timeConsuming";

/// 开启定时器
-(void)startTime{
    
    self.startTimeStamp = [self getCurrenTimeStamp];
    self.timeConsumingStr = nil;
    self.phaseConsumingStr = nil;
    [self.alreadyTimeArray removeAllObjects];
    [self.markTimeArray removeAllObjects];
    [self reset];
}

/// 重置数据
-(void)reset{
    
    self.alreadyCount = 0;
}

/// 关闭定时器
-(void)stopTime{
    
    self.stopTimeStamp = [self getCurrenTimeStamp];
}

/// 设置测试次数
-(void)setTestCount:(NSInteger)testCount{
    
    _testCount = testCount;
}

/// 设置最后一个调用的方法
-(void)setLastMethonName:(NSString*)methonName{
    
    _lastMethonName =methonName;
}

/// 设置第一个调用的方法
-(void)setFirstMethonName:(NSString*)methonName{
    
    _firstMethonName = methonName;
}

///设置方法名称映射 （可选）
///@param nameMap 方法名称映射字典
-(void)setMethodNameMapping:(NSDictionary*)nameMap{
    
    self.nameDict = nameMap;
}


///标记当前时间
-(void)markTimeWithName:(NSString*)name{
    
    @synchronized (self) {
        
        if ([self.firstMethonName isEqualToString:name]) {
            
            if (self.alreadyCount == 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"LHTestStart" object:nil];
                [self startTime];
            }
            
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString*newName =name;
        if (self.nameDict[name]) {
            newName =self.nameDict[name];
        }
        
        [dict setValue:[self getCurrenTimeStamp] forKey:timeStampKey];
        [dict setValue:newName forKey:funtionNameKey];
        
        [self.markTimeArray addObject:dict];
        [self checkisLastMethonName:name MarkTimeArray:self.markTimeArray.copy];
        
    }
}

/// 检测是否最后一个方法
-(void)checkisLastMethonName:(NSString*)methonName MarkTimeArray:(NSArray*)markTimeArray{
    
    
    if ([self.lastMethonName isEqualToString:methonName]) {
        
        self.alreadyCount++;
        
        self.oldAlreadyCount = self.alreadyCount;
        
        if (self.testCount > 1) {
            
            [self.alreadyTimeArray addObject:markTimeArray];
            [self.markTimeArray removeAllObjects];
        }
        
        if (self.alreadyCount == self.testCount ) {
            [self stopTime];
            [self printTimeConsumingStr];
            
        }
        
       
    }
    
}

/// 打印
-(void)printTimeConsumingStr{
    
    self.timeConsumingStr = [self getCalculateTimeConsumingStr];
    self.phaseConsumingStr = [self getPhaseTimeConsumingStr];
    NSLog(@"%@",self.timeConsumingStr);
    NSLog(@"%@", self.phaseConsumingStr);
    
    [self reset];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TimeConsuminFinish" object:nil];
    
}

-(void)afterCall{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self checkisLastMethonName:self.lastMethonName MarkTimeArray:self.markTimeArray];
    });
}



/// 计算整体耗时
-(NSString*)getCalculateTimeConsumingStr{
    
    if (self.timeConsumingStr) {
        return self.timeConsumingStr;
    }
   
    return [self getCalculateTimeConsumingStrWithStartTimeStamp:self.startTimeStamp];
}

/// 获取阶段耗时字符串
-(NSString*)getPhaseTimeConsumingStr{
    
    if (self.phaseConsumingStr) {
        return self.phaseConsumingStr;
    }
    
    if (self.testCount > 1) {
        
        return [self getMultiplePhaseTimeConsumingStr];
    }

    return [self getOncePhaseTimeConsumingStrWithStartTimeStamp:self.startTimeStamp MarkTimeArray:self.markTimeArray];
}

/// 单次
-(NSString*)getCalculateTimeConsumingStrWithStartTimeStamp:(NSString*)startTimeStamp{
    
    NSString*time = [NSString stringWithFormat:@"%ld次流程整体耗时:%.3f秒",(long)self.testCount,[self getDurationStartTime:startTimeStamp endTime:self.stopTimeStamp]];
    
    self.timeConsumingFormatStr = time;
    
    time = [NSString stringWithFormat:@"\n\n⏱⏱⏱⏱⏱⏱⏱⏱⏱⏱\n\n%@\n\n⏱⏱⏱⏱⏱⏱⏱⏱⏱⏱\n",time];

    return time;
    
}

/// 获取一次阶段耗时字符串
-(NSString*)getOncePhaseTimeConsumingStrWithStartTimeStamp:(NSString*)startTimeStamp MarkTimeArray:(NSArray*)markTimeArray{
    
    NSArray *consumingAry = [self calculatePhaseTimeConsumingWithStartTimeStamp:startTimeStamp MarkTimeArray:markTimeArray];

    return [self formattingPhaseTimeConsumingStr:consumingAry];
    
}

/// 获取多次次阶段耗时字符串
-(NSString*)getMultiplePhaseTimeConsumingStr{
    
    NSString *phaseStr = @"";
    NSString*upTime = self.startTimeStamp;
    int index = 0;
    for (NSArray*markTimeArray in self.alreadyTimeArray) {
        index++;
        NSArray *consumingAry = [self calculatePhaseTimeConsumingWithStartTimeStamp:upTime MarkTimeArray:markTimeArray];
        
        NSString*time = [self formattingPhaseTimeConsumingStr:consumingAry];
        
        phaseStr = [NSString stringWithFormat:@"%@第%d次耗时测试\n%@",phaseStr,index,time];
        
        /// 最后一个方法的时间戳
        NSDictionary*dict = markTimeArray.lastObject;
        
        upTime =dict[timeStampKey];
        
    }
    
    
    return phaseStr;
}

/// 格式化字符串
-(NSString*)formattingPhaseTimeConsumingStr:(NSArray*)consumingAry{
    
    
    NSString *phaseStr = @"";
    NSString *oldFuntionName = @"耗时测试开始";
    for (NSDictionary*dict in consumingAry) {
        NSString *currenfuntionName =dict[funtionNameKey];
        NSString *timeConsumingStr =dict[timeConsumingKey];
        phaseStr = [NSString stringWithFormat:@"%@%@ ---》》》 %@ 耗时: %@秒\n",phaseStr,oldFuntionName,currenfuntionName,timeConsumingStr];
        
        oldFuntionName = currenfuntionName;
    }
    
    return phaseStr;
}




/// 计算阶段耗时
-(NSArray*)calculatePhaseTimeConsumingWithStartTimeStamp:(NSString*)startTimeStamp MarkTimeArray:(NSArray*)markTimeArray{

    NSMutableArray *consumingAry =[NSMutableArray array];
    NSString*upTime = startTimeStamp;
    
    for (NSDictionary *dict in markTimeArray) {
        
        @autoreleasepool {
            
            NSMutableDictionary*consumingDict = [NSMutableDictionary dictionary];
            NSString *currenTimeStamp =dict[timeStampKey];
            NSString *currenfuntionName =dict[funtionNameKey];
            NSString *consumingStr = [NSString stringWithFormat:@"%.3f",[self getDurationStartTime:upTime endTime:currenTimeStamp]];
            
            [consumingDict setValue:consumingStr forKey:timeConsumingKey];
            [consumingDict setValue:currenfuntionName forKey:funtionNameKey];
            [consumingAry addObject:consumingDict];
            upTime = currenTimeStamp;
        }
        
    }
    
    return consumingAry.copy;
}


/// 获取计算整体耗时
-(NSString*)getCalculateTimeConsumingFormatStr{
    
    return self.timeConsumingFormatStr;
}

/// 获取测试次数
-(NSInteger)getAlreadyCount{
    
    return self.oldAlreadyCount;
}


#pragma mark - P

/// 获取当前时间戳
-(NSString*)getCurrenTimeStamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    
    //时间转时间戳的方法:
    NSString *ts = [NSString stringWithFormat:@"%ld",(long)([datenow timeIntervalSince1970]*1000)];//时间戳的值
    return ts;
    
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SS"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}


/**持续时间*/
- (double)getDurationStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    if (startTime && endTime) {
        double aTime = [endTime doubleValue] - [startTime doubleValue];
        return aTime/1000;
    } else {
        return -1;
    }
}



#pragma mark -setter -getter


-(NSMutableArray *)markTimeArray{
    
    if (!_markTimeArray) {
        _markTimeArray =[NSMutableArray array];
    }
    
    return _markTimeArray;
}

-(NSMutableArray *)alreadyTimeArray{
    
    if (!_alreadyTimeArray) {
        _alreadyTimeArray =[NSMutableArray array];
    }
    
    return _alreadyTimeArray;
}

-(NSDictionary *)nameDict{
    
    if (!_nameDict) {
        
        _nameDict = [NSDictionary dictionary];
    }
    
    return _nameDict;
}



@end
