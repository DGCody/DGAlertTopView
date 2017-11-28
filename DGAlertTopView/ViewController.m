//
//  ViewController.m
//  DGAlertTopView
//
//  Created by Cody on 2017/11/27.
//  Copyright © 2017年 Cody. All rights reserved.
//

#import "ViewController.h"
#import "DGAlertTopView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic)UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews{
    self.tableView.frame = self.view.bounds;
}

#pragma mark - get
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"提示框";
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            DGAlertTopView * alertView = [[DGAlertTopView alloc] initWithTitle:@"北京天气预报中心"
                                                                       content:@"今天不知道哪来的风。很大。"
                                                                     doneTitle:nil
                                                                   cancelTitle:nil];
            alertView.viewType = indexPath.row;
            [alertView showAnimation:YES];

        }
            break;
        case 1:
        {
            [DGAlertTopView showTitleOnly:@"消息" content:@"只显示一下消息" duration:6];
        }
            break;
        case 2:
        {
            DGAlertTopView * alertView = [[DGAlertTopView alloc] initWithTitle:@"北京天气预报中心"
                                                                       content:@"今天不知道哪来的风。很大，请民众尽量在家不要出门"
                                                                     doneTitle:@"去看看"
                                                                   cancelTitle:nil];
            alertView.viewType = indexPath.row;
            [alertView showAnimation:YES];
        }
            break;
        case 3:
        {
            DGAlertTopView * alertView = [[DGAlertTopView alloc] initWithTitle:@"北京天气预报中心"
                                                                       content:@"今天不知道哪来的风。很大，请民众尽量在家不要出门。否则可能会吹的头不舒服。"
                                                                     doneTitle:@"去看看"
                                                                   cancelTitle:@"知道了"];
            alertView.viewType = indexPath.row;
            alertView.hidenTimeIcon = YES;
            [alertView showAnimation:YES duration:5];

        }
            break;

        default:
        {
            DGAlertTopView * alertView = [[DGAlertTopView alloc] initWithTitle:nil
                                                                       content:@"今天不知道哪来的风"
                                                                     doneTitle:@"去看看"
                                                                   cancelTitle:@"知道了"];
            alertView.viewType = indexPath.row;
            alertView.hidenCountdownDuration = 7;
            [alertView showAnimation:YES];
            
        }
            break;
    }
    
    
    
}


- (void)a{
    //创建redView
    UIView *redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    //创建redView第一个约束，相对self.view的左边缘间距20
    NSLayoutConstraint * redLeftLc = [NSLayoutConstraint constraintWithItem:redView
                                                                  attribute:NSLayoutAttributeLeftMargin
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0f
                                                                   constant:20.0];
    //只有在没有参照控件的情况下，约束才加到自身，不然加到父控件上
    [self.view addConstraint:redLeftLc];
    
    
    //创建redView第二个约束，相对self。view的底边缘间距20
    NSLayoutConstraint *redBottomLc = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.0f constant:-20];//由于是redview相对self.view往上减20，所以是-20
    //添加约束
    [self.view addConstraint:redBottomLc];
    //创建redView第三个约束，设置自身宽，宽可以参照其他控件设置，比如是self.view宽的一半,则应该这样写
    /*
     [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0.0];
     */
    //这里直接设置自身宽为50
    NSLayoutConstraint * redWLc = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:50.0f];
    //由于没有参照物，所以约束添加于自身身上
    [redView addConstraint:redWLc];
    //创建最后一个约束，自身的高
    NSLayoutConstraint * redHLc = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:50];
    //由于没有参照物，所以约束添加于自身身上
    [redView addConstraint:redHLc];
    
}


-(void)c{
    
    //0.创建队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //1.创建GCD中的定时器
    /*
     第一个参数:创建source的类型 DISPATCH_SOURCE_TYPE_TIMER:定时器
     第二个参数:0
     第三个参数:0
     第四个参数:队列
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //2.设置时间等
    /*
     第一个参数:定时器对象
     第二个参数:DISPATCH_TIME_NOW 表示从现在开始计时
     第三个参数:间隔时间 GCD里面的时间 纳秒
     第四个参数:精准度(表示允许的误差,0表示绝对精准)
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    //3.要调用的任务
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD-----%@",[NSThread currentThread]);
        
    });
    
    //4.开始执行
    dispatch_resume(timer);
}

@end
