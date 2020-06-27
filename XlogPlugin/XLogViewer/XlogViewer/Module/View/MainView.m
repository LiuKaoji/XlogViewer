//
//  MainView.m
//  Example
//
//  Created by Damon on 2020/6/20.
//  Copyright © 2020 Damon. All rights reserved.
//

#import "MainView.h"
#import "Masonry.h"
#import "MBProgressHUD+JDragon.h"
#import "GradientView.h"
#import <XlogPlugin/XLogPlugin-prefix.pch>

@interface MainView ()
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UISegmentedControl *logTypeSegment;
@property(nonatomic,strong)UIButton *githubBtn;
@property(nonatomic,strong)UILabel *versionLabel;
@end

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView{
    
    GradientView *backgroudAnimationView =  [[GradientView alloc] initWithFrame:self.frame];
    [self addSubview:backgroudAnimationView];
    [self setTitleArr:@[@"创建日志",@"日志列表",@"沙盒查看"]];
    
    _githubBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 45, STATUS_BAR_HEIGHT + 10, 30, 30)];
    [_githubBtn setImage:[UIImage imageNamed:@"github"] forState:UIControlStateNormal];
    [_githubBtn addTarget:self action:@selector(onClickGithub) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_githubBtn];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - (isBangsDevice ?42:38), SCREENWIDTH, 30)];
    _versionLabel.text = [NSString localizedStringWithFormat:@"XlogViewer V%@",version];
    _versionLabel.font = [UIFont systemFontOfSize:12];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_versionLabel];
}

- (void)setTitleArr:(NSArray *)titleArr

{
    UIView *stackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width *0.4, UIScreen.mainScreen.bounds.size.height *0.5)];
    stackView.center = self.center;
    [self addSubview:stackView];
    
    NSMutableArray *arrayMut = [NSMutableArray array];
    
    for (int i = 0; i<titleArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = OptionTag + i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor colorWithRed:113/255  green:113/255 blue:113/255 alpha:0.4]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldM" size:15];
        [stackView addSubview:btn];
        [arrayMut addObject:btn];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            btn.layer.cornerRadius = 10;
        });
    }
    
    if (arrayMut.count <= 0) {
        return;
    }
    
    [arrayMut mas_distributeViewsAlongAxis:MASAxisTypeVertical
                          withFixedSpacing:20   //item间距
                               leadSpacing:0   //起始间距
                               tailSpacing:0]; //结尾间距
    [arrayMut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stackView.mas_centerX);
        make.width.equalTo(stackView.mas_width);
    }];
}

-(void)onClickBtn:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onClickOption:)]){
        [self.delegate onClickOption:sender.tag - OptionTag];
    }
}

-(void)onClickGithub{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LiuKaoji/XlogViewer"] options:@{} completionHandler:nil];
}

@end
