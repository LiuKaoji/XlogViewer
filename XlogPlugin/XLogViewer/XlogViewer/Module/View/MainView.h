//
//  MainView.h
//  Example
//
//  Created by Damon on 2020/6/20.
//  Copyright © 2020 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define OptionTag 18000 //按钮的tag

@protocol MainViewDelegate <NSObject>

-(void)onClickOption:(NSInteger)tag;//点击了按钮

@end

@interface MainView : UIView

@property(nonatomic,assign)id<MainViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
