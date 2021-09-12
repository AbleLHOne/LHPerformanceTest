//
//  LHViewController.m
//  LHTimeConsumingDetection
//
//  Created by albert.li on 09/10/2021.
//  Copyright (c) 2021 albert.li. All rights reserved.
//

#import "LHViewController.h"
#import "LHPreson.h"
#import "LHTimeConsumingDetectionManager.h"
@interface LHViewController ()

@property (nonatomic,strong)LHPreson *preson;

@end

@implementation LHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.preson = [[LHPreson alloc]init];
    
    NSMutableArray *array =[NSMutableArray array];
     
    [array addObject:@{
            @"className":@"LHPreson",
            @"funtionName":@"sleep"
    }];
    
    [array addObject:@{
            @"className":@"LHPreson",
            @"funtionName":@"eat"
    }];
    
    
    [[LHTimeConsumingDetectionManager shareInstance]setTestCount:50];
    [[LHTimeConsumingDetectionManager shareInstance]setLastMethonName:@"eat"];
    [[LHTimeConsumingDetectionManager shareInstance]hookStatisticalFuntionWithFuntionData:array];
  
}


-(void)presonLife{
    
    [[LHTimeConsumingDetectionManager shareInstance]startStatistical];
    
    
    for (int i =0; i<50; i++) {
        
        [self.preson sleep];
        [self.preson eat];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self presonLife];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
