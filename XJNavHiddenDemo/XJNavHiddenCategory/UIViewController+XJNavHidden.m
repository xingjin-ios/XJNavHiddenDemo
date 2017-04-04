//
//  UIViewController+XJNavHidden.m
//  XJNavHiddenDemo
//
//  Created by 邢进 on 2017/3/29.
//  Copyright © 2017年 邢进. All rights reserved.
//

#import "UIViewController+XJNavHidden.h"
#import <objc/runtime.h>

@interface UIViewController()
//需要监听的scrollView(table,collection,scroll,web)
@property (nonatomic, weak)UIScrollView *myScrollView;
//设置导航条上的item是否需要跟随滚动变化透明度,默认一直显示
@property (nonatomic, assign)HiddenSetting myHiddenSetting;
//定义scrollView的y偏移量到达这个值后navbar完全显示,一般设置为显示图片的headerView的高度
@property (nonatomic, assign)CGFloat scrollOfsetY;
@property (nonatomic, assign)CGFloat alpha;//记录alpha
@property (nonatomic, strong)UIImage *navBGImage;//navbar BGImage

@end
//category要用runtime添加属性哦😯😯😯😯
static const char *keyScrollView = "myScrollView";
static const char *keymyHiddenSetting = "myHiddenSetting";
static const char *keyscrollOfsetY = "scrollOfsetY";
static const char *keyalpha = "alpha";
static const char *keynavBGImage = "navBGImage";

@implementation UIViewController (XJNavHidden)

- (UIScrollView *)myScrollView {
    return objc_getAssociatedObject(self, keyScrollView);
}
- (void)setMyScrollView:(UIScrollView *)myScrollView {
    objc_setAssociatedObject(self, keyScrollView, myScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)myHiddenSetting {
    return [objc_getAssociatedObject(self, keymyHiddenSetting) integerValue];
}
- (void)setMyHiddenSetting:(NSInteger)myHiddenSetting {
    objc_setAssociatedObject(self, keymyHiddenSetting, @(myHiddenSetting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)scrollOfsetY {
    return [objc_getAssociatedObject(self, keyscrollOfsetY) floatValue];
}
- (void)setScrollOfsetY:(CGFloat)scrollOfsetY {
    objc_setAssociatedObject(self, keyscrollOfsetY, @(scrollOfsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)alpha {
    return [objc_getAssociatedObject(self, keyalpha) floatValue];
}
- (void)setAlpha:(CGFloat)alpha {
    objc_setAssociatedObject(self, keyalpha, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)navBGImage {
    return objc_getAssociatedObject(self, keynavBGImage);
}
- (void)setNavBGImage:(UIImage *)navBGImage {
    objc_setAssociatedObject(self, keynavBGImage, navBGImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//终于set/get完了....

//初始化
- (void)setScrollView:(UIScrollView *)myScrollView scrollOffsetY:(CGFloat)scrollY hiddenSetting:(HiddenSetting)hiddenSetting {
    self.myScrollView = myScrollView;
    self.myHiddenSetting = hiddenSetting;
    self.scrollOfsetY = scrollY;
    //监听scrollerView偏移量
    [self.myScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
//监听事件处理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //设置alpha 0~1 变化
    self.alpha = self.myScrollView.contentOffset.y/self.scrollOfsetY;
    if (self.alpha >= 1) {
        self.alpha = 1;
    }else if (self.alpha <= 0) {
        self.alpha = 0;
    }
    [self changeAlpha];
}

- (void)changeAlpha {
    //包含即设置alpha
    self.navigationItem.leftBarButtonItem.customView.alpha = self.myHiddenSetting & 1 ? self.alpha : 1;
    self.navigationItem.titleView.alpha = self.myHiddenSetting >> 1 & 1 ? self.alpha : 1;
    self.navigationItem.rightBarButtonItem.customView.alpha = self.myHiddenSetting >> 2 & 1 ? self.alpha : 1;

    //虽然navigationBar是继承于UIView的，但是直接设置其alpha是无效的，应该是因为navigationBar复合的视图层级
    //根据视图层级关系，我们用这个十分简单的方法来设置navigationBar的透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:self.alpha];
}
//生命周期设置
- (void)xj_viewWillAppear:(BOOL)animated {
    //设置背景图片
    [self.navigationController.navigationBar setBackgroundImage:self.navBGImage forBarMetrics:UIBarMetricsDefault];
    //清除边框，设置一张空的图片
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self changeAlpha];
}
- (void)xj_viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)xj_viewDidDisappear:(BOOL)animated {
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
}


@end
