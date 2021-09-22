//
//  LHPerformanceTestHUD.h
//  LHPerformanceTest
//
//  Created by mac on 2021/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LHPerformanceTestHUDDelegate <NSObject>

-(void)statusBtnClick:(NSInteger)type;

-(void)infoBtnClick;

@end

@interface LHPerformanceTestHUD : UIView

@property (nonatomic,weak)id<LHPerformanceTestHUDDelegate>delegate;

///设置状态按钮是否可以点击
-(void)setStatusIsEnable:(BOOL)isEnable;

@end

NS_ASSUME_NONNULL_END
