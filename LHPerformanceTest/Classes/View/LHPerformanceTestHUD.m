//
//  LHPerformanceTestHUD.m
//  LHPerformanceTest
//
//  Created by mac on 2021/9/20.
//

#import "LHPerformanceTestHUD.h"


@interface LHPerformanceTestHUD ()

@property (nonatomic,strong) UILabel    *titleLable;
@property (nonatomic,strong) UIButton   *statusBtn;
@property (nonatomic,strong) UIButton   *closeBtn;
@property (nonatomic,strong) UIButton   *infoBtn;
@end

@implementation LHPerformanceTestHUD

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self =[super initWithFrame:frame]) {
        
        [self configUI];
        
    }
    
    return self;
}

#pragma mark =- configUI

-(void)configUI{

    [self addSubview:self.titleLable];
    [self addSubview:self.statusBtn];
    [self addSubview:self.infoBtn];
    [self addSubview:self.closeBtn];

}


///设置状态按钮是否可以点击
-(void)setStatusIsEnable:(BOOL)isEnable{
    
    self.statusBtn.enabled = isEnable;
    self.infoBtn.enabled = !isEnable;
    self.hidden = NO;
    if (isEnable) {
        _statusBtn.backgroundColor =[UIColor orangeColor];
        self.infoBtn.backgroundColor =[UIColor grayColor];
    }else{
        
        _statusBtn.backgroundColor =[UIColor grayColor];
        self.infoBtn.backgroundColor =[UIColor orangeColor];
    }
    
}


#pragma mark - Event

-(void)statusBtnClick:(UIButton*)sender{
    
    if ([self.delegate respondsToSelector:@selector(statusBtnClick:)]) {
        
        [self.delegate statusBtnClick:0];
    }
}

-(void)infoBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(infoBtnClick)]) {
        
        [self.delegate infoBtnClick];
    }
}

-(void)closeBtnClick{
    
    self.hidden = YES;
}

#pragma mark - getter -setter

-(UILabel *)titleLable{
    
    if (!_titleLable) {
        
        _titleLable =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 20)];
        _titleLable.font =[UIFont systemFontOfSize:16];
        _titleLable.text  = @"性能测试";
        
    }
    
    return _titleLable;
}

-(UIButton *)statusBtn{
    
    if (!_statusBtn) {
        
        _statusBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 38, 80, 30)];
        [_statusBtn setTitle:@"停止" forState:(UIControlStateNormal)];
        _statusBtn.backgroundColor =[UIColor grayColor];
        _statusBtn.layer.cornerRadius = 6;
        _statusBtn.enabled = NO;
        _statusBtn.titleLabel.font =[UIFont systemFontOfSize:16];
        [_statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _statusBtn;
}

-(UIButton *)infoBtn{
    
    if (!_infoBtn) {
        
        _infoBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 38, 80, 30)];
        [_infoBtn setTitle:@"测试信息" forState:(UIControlStateNormal)];
        _infoBtn.backgroundColor =[UIColor grayColor];
        _infoBtn.layer.cornerRadius = 6;
        _infoBtn.enabled = NO;
        _infoBtn.titleLabel.font =[UIFont systemFontOfSize:16];
        [_infoBtn addTarget:self action:@selector(infoBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _infoBtn;
}


-(UIButton *)closeBtn{
    
    if (!_closeBtn) {
        
        _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 8, 40, 20)];
        [_closeBtn setTitle:@"关闭" forState:(UIControlStateNormal)];
        _closeBtn.backgroundColor =[UIColor orangeColor];
        _closeBtn.layer.cornerRadius = 6;
        _closeBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        [_closeBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _closeBtn;
}




@end
