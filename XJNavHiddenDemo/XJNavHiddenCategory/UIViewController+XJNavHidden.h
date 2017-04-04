//
//  UIViewController+XJNavHidden.h
//  XJNavHiddenDemo
//
//  Created by 邢进 on 2017/3/29.
//  Copyright © 2017年 邢进. All rights reserved.
//

#import <UIKit/UIKit.h>

//用category而不是继承
//第一:滑动隐藏navbar在项目中只是个别页面的需求,写在BaseController的话会造成BaseController很沉重;
//第二:实际工作中,尽量不破坏项目中别人已有的类的封装,与已有类完全分开,保持了模块化的独立性

typedef NS_OPTIONS(NSUInteger, HiddenSetting) {
    HiddenLeftItem = 1 << 0,     //隐藏leftBarButtonItem
    HiddenTitleView = 1 << 1,    //隐藏textView
    HiddenRightItem = 1 << 2,    //隐藏rightBarButtonItem
};
@interface UIViewController (XJNavHidden)

#pragma mark - 必须实现的方法
//初始化
- (void)setScrollView:(UIScrollView *)myScrollView scrollOffsetY:(CGFloat)scrollY hiddenSetting:(HiddenSetting)hiddenSetting;
//生命周期设置
- (void)xj_viewWillAppear:(BOOL)animated;
- (void)xj_viewWillDisappear:(BOOL)animated;
- (void)xj_viewDidDisappear:(BOOL)animated;
#pragma mark - public
//设置navbarBGImage
- (void)setNavBGImage:(UIImage *)navBGImage;

@end







