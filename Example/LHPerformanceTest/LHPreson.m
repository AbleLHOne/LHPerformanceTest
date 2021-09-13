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
    
//    NSLog(@"sleep---------");
    
    [NSThread sleepForTimeInterval:0.3];
    
//    NSLog(@"sleep---------end");
    
    
    [self sleepDown:[self getRandomNumber:0 to:1]];
    
}

-(void)sleepDown:(BOOL)down{
    
    NSLog(@"sleepDown ===%d",down);

}

-(void)eat{
    
//    NSLog(@"eat---------");
    
    [NSThread sleepForTimeInterval:0.4];
//
//    NSLog(@"eat---------end");

    
    [self eatDown:[self getRandomNumber:0 to:1]];
    
}

-(void)eatDown:(BOOL)down{
    
    NSLog(@"eatDown === %d",down);

}

-(int)getRandomNumber:(int)from to:(int)to

{

    return (int)(from + (arc4random() % (to-from+1)));

}

@end
