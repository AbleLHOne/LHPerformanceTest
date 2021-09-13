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
#import "LHActionSuccessRateManager.h"

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
    
    
    NSMutableArray *array1 =[NSMutableArray array];
     
    [array1 addObject:@{
            @"className":@"LHPreson",
            @"funtionName":@"sleepDown:"
    }];
    
    [array1 addObject:@{
            @"className":@"LHPreson",
            @"funtionName":@"eatDown:"
    }];
    
    
    NSMutableArray *array2 =[NSMutableArray array];
    
    NSNumber *number = [[NSNumber alloc]initWithInt:1];
    
    [array2 addObject:@{
            @"className":@"NSNumber",
            @"funtionName":@"sleepDown:",
            @"keyWord":number
    }];
    
    [array2 addObject:@{
            @"className":@"NSNumber",
            @"funtionName":@"eatDown:",
            @"keyWord":number
    }];
    
    
    
    
   
    
    
    
    
    [[LHActionSuccessRateManager shareInstance]setTestCount:10];
    [[LHActionSuccessRateManager shareInstance]setLastMethonName:@"eatDown:"];
    [[LHActionSuccessRateManager shareInstance]hookStatisticalFuntionWithFuntionData:array1];
    
    [[LHActionSuccessRateManager shareInstance]setCheckClassData:array2];
    
    
    
    
//    [[LHTimeConsumingDetectionManager shareInstance]setTestCount:10];
//    [[LHTimeConsumingDetectionManager shareInstance]setLastMethonName:@"eat"];
//    [[LHTimeConsumingDetectionManager shareInstance]hookStatisticalFuntionWithFuntionData:array];
  
}


-(void)presonLife{
    
//    [[LHTimeConsumingDetectionManager shareInstance]startStatistical];
    
    [[LHActionSuccessRateManager shareInstance]start];
    
    
    for (int i =0; i<10; i++) {
        
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
