//
//  LHPerformanceInfoViewController.m
//  AFNetworking
//
//  Created by mac on 2021/9/21.
//

#import "LHPerformanceInfoViewController.h"
#import <Masonry/Masonry.h>

@interface LHPerformanceInfoViewController ()
@property (nonatomic,strong)UITextView    *textView;
@property (nonatomic,strong)UILabel       *titleLabel;
@property (nonatomic,strong)UIView        *infoView;
@property (nonatomic,strong)NSString      *timeConsumingStr;
@property (nonatomic,strong)NSString      *rateStr;

@end

@implementation LHPerformanceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}


#pragma mark - configUI

-(void)configUI{
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.infoView = [self configTestViewWithTitle:@"性能测试" testCount:1 ];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.textView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(15);
        
    }];
  
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(220);
    
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(self.infoView.mas_bottom).offset(35);
        make.height.mas_equalTo(self.view.frame.size.height*0.55);
    
    }];

    
    
}


-(UIView *)configTestViewWithTitle:(NSString*)title testCount:(int)testCount{
    
    UIView *testView = [[UIView alloc]init];
        
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.textColor =[UIColor blackColor];
    titleLabel.font =[UIFont systemFontOfSize:16];
    [testView addSubview:titleLabel];
    
    UILabel *timeConsumingLabel = [[UILabel alloc]init];
    timeConsumingLabel.text = @"耗时: X 秒";
    timeConsumingLabel.textColor =[UIColor blackColor];
    timeConsumingLabel.font =[UIFont systemFontOfSize:16];
    timeConsumingLabel.tag = 101;
    [testView addSubview:timeConsumingLabel];
    
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.text = [NSString stringWithFormat:@"次数: %d次",testCount];
    countLabel.textColor =[UIColor blackColor];
    countLabel.font =[UIFont systemFontOfSize:16];
    countLabel.tag = 110;
    [testView addSubview:countLabel];
    
    UILabel *successLabel = [[UILabel alloc]init];
    successLabel.text = [NSString stringWithFormat:@"成功率: X %%"];
    successLabel.textColor =[UIColor blackColor];
    successLabel.font =[UIFont systemFontOfSize:16];
    successLabel.tag = 102;
    [testView addSubview:successLabel];
    
    
    UILabel *cpuLabel = [[UILabel alloc]init];
    cpuLabel.text = [NSString stringWithFormat:@"CPU: X %% -- X %%"];
    cpuLabel.textColor =[UIColor blackColor];
    cpuLabel.font =[UIFont systemFontOfSize:16];
    cpuLabel.tag = 103;
    [testView addSubview:cpuLabel];
    
    UILabel *memoryLabel = [[UILabel alloc]init];
    memoryLabel.text = [NSString stringWithFormat:@"Memory: X M -- X M"];
    memoryLabel.textColor =[UIColor blackColor];
    memoryLabel.font =[UIFont systemFontOfSize:16];
    memoryLabel.tag = 104;
    [testView addSubview:memoryLabel];
    
    UILabel *electricityLabel = [[UILabel alloc]init];
    electricityLabel.text = [NSString stringWithFormat:@"Electricity: X %% -- X %%"];
    electricityLabel.textColor =[UIColor blackColor];
    electricityLabel.font =[UIFont systemFontOfSize:16];
    electricityLabel.tag = 105;
    [testView addSubview:electricityLabel];
    
    UIView*lineView =[[UIView alloc]init];
    lineView.backgroundColor =[UIColor blackColor];
    [testView addSubview:lineView];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(testView.mas_left).offset(15);
        make.top.mas_equalTo(testView.mas_top).offset(10);
    }];
    
    [timeConsumingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(testView.mas_left).offset(15);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
        
    }];
    
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
        make.left.mas_equalTo(titleLabel.mas_right).offset(15);
        
    }];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(timeConsumingLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(testView.mas_left).offset(15);
    }];
    

    [cpuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(successLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(testView.mas_left).offset(15);
    }];
    
    [memoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(cpuLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(testView.mas_left).offset(15);
    }];
    
    [electricityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(memoryLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(testView.mas_left).offset(15);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(testView.mas_left).offset(15);
        make.right.mas_equalTo(testView.mas_right).offset(-15);
        make.bottom.mas_equalTo(testView.mas_bottom);
        make.height.mas_equalTo(2);
    }];
    
    
    return testView;
}


#pragma mark -ConfigData
///设置测试次数
///@param testCount 测试次数
-(void)setTestCount:(NSInteger)testCount{
    
    UIView*tagretView = self.infoView;

    UILabel *label= [tagretView viewWithTag:110];
    
    label.text = [NSString stringWithFormat:@"次数: %ld次",(long)testCount];
    
}
/// 设置信息
-(void)setLogMessage:(NSString*)logMessageStr{
    
    self.textView.text =logMessageStr;
    self.textView.editable = NO;
}

/// 设置耗时数据
-(void)setTimeConsumingStr:(NSString*)consumingStr AllPhaseConsumingStr:(NSString*)allPhaseConsumingStr {
    
    UIView*tagretView = self.infoView;

    UILabel *label= [tagretView viewWithTag:101];
    
    label.text = [NSString stringWithFormat:@"耗时:%@",consumingStr];
    self.timeConsumingStr = [NSString stringWithFormat:@"⏱⏱⏱⏱⏱⏱⏱⏱⏱⏱\n\n%@\n\n⏱⏱⏱⏱⏱⏱⏱⏱⏱⏱\n\n%@\n\n",consumingStr,allPhaseConsumingStr];

}


/// 设置成功率数据
-(void)setSuccessRateStr:(NSString*)successRateStr AllPhaseSuccessRateStr:(NSString*)allPhaseSuccessRateStr {
    
    UIView*tagretView = self.infoView;
    
    UILabel *label = [tagretView viewWithTag:102];
     
    label.text = [NSString stringWithFormat:@"成功率:%@",successRateStr];
    
    self.rateStr = [NSString stringWithFormat:@"🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉\n\n%@\n\n🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉\n\n%@\n\n",successRateStr,allPhaseSuccessRateStr];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString*logStr = [NSString stringWithFormat:@"%@\n%@",self.timeConsumingStr,self.rateStr];
        [self setLogMessage:logStr];
    });
    
}

/// 设置App资源使用率数据
-(void)setCpuUsageStr:(NSString*)cpuUsageStr MemoryUsagStr:(NSString*)memoryUsagStr ElectricityUsagStr:(NSString*)electricityUsagStr{
    
    UIView*tagretView = self.infoView;
    
    UILabel *cpuLabel = [tagretView viewWithTag:103];
    cpuLabel.text = [NSString stringWithFormat:@"CPU:%@",cpuUsageStr];
    
    UILabel *memoryLabel = [tagretView viewWithTag:104];
    memoryLabel.text = [NSString stringWithFormat:@"Memory:%@",memoryUsagStr];
    
    UILabel *electricityLabel = [tagretView viewWithTag:105];
    electricityLabel.text = [NSString stringWithFormat:@"Electricity:%@",electricityUsagStr];
    
}





#pragma mark -setter & getter

-(UITextView *)textView{
    
    if (!_textView) {
        
        _textView = [[UITextView alloc]init];
        _textView.text = @"121";
//        _textView.editable = NO;
        _textView.layer.borderColor =[UIColor orangeColor].CGColor;
        _textView.layer.borderWidth = 2;
        _textView.layer.cornerRadius = 6;
        _textView.font =[UIFont systemFontOfSize:16];
    }
    
    return _textView;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"测试信息";
        _titleLabel.textColor =[UIColor blackColor];
        _titleLabel.font =[UIFont systemFontOfSize:20];
    }
    return _titleLabel;
}



@end
