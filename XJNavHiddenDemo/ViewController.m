//
//  ViewController.m
//  XJNavHiddenDemo
//
//  Created by 邢进 on 2017/3/29.
//  Copyright © 2017年 邢进. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+XJNavHidden.h"

#define HHHHH 190

@interface ViewController ()<UITableViewDataSource, UIScrollViewDelegate> {
    CGFloat topContentInset;//iamgeView的高
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.table.delegate = self;
    
    [self.table reloadData];
    //使用说明:
    //第一,设置当有导航栏自动添加64的高度的属性为NO,使视图能够滚上去
    self.automaticallyAdjustsScrollViewInsets = NO;
    //第二,初始化,这里设置  left和titleview随之渐隐😄
    [self setScrollView:_table scrollOffsetY:HHHHH hiddenSetting:HiddenTitleView | HiddenLeftItem];
}

//第三,必须复写此方法 否则导航栏显示不正常
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self xj_viewWillAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self xj_viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self xj_viewWillDisappear:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    //下拉判断
    if (offsetY < 0) {
        //根据下拉y偏移量计算出图片应该放大的倍数,然后重置frame
        _imageView.transform = CGAffineTransformMakeScale(1 + offsetY/(-topContentInset), 1 + offsetY/(-topContentInset));
        CGRect frame = _imageView.frame;
        frame.origin.y = offsetY;
        _imageView.frame = frame;
    }
    
}
//视图加载后获取storyboard上iamgeView的高度
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    topContentInset = _imageView.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
