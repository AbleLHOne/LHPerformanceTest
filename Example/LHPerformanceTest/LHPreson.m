//
//  LHPreson.m
//  LHTimeConsumingDetection_Example
//
//  Created by mac on 2021/9/12.
//  Copyright © 2021 albert.li. All rights reserved.
//

#import "LHPreson.h"

@implementation LHPreson

-(void)sleep{
    
    NSLog(@"sleep---------");
    
    [NSThread sleepForTimeInterval:0.3];
    
    NSLog(@"sleep---------end");
    
}


-(void)eat{
    
    NSLog(@"eat---------");
    
    [NSThread sleepForTimeInterval:0.4];
    
    NSLog(@"eat---------end");
}

@end
