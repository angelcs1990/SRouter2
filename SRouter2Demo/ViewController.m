//
//  ViewController.m
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ViewController.h"
#import "SRouter2.h"

#import "ModuleInterfaceHeader.h"


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, TestProtocol, SR2ModuleProtocol>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayDataSource;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupInit];
    [self setupView];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SR2ModuleProtocol
- (id)SR2Module_Command:(SR2Params *)params
{
    switch (params.cmd) {
        case SR2ModuleNotify:
        {
            //接收通知，如果block没有设置
            NSDictionary *subParams = [SR2Manager SR2ModuleNotifyParams:params];
            NSLog(@"ViewController Subscrib SR2Module_Command Print:%@", subParams[@"pass"]);
            
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [SR2Manager router_Push:@"OneViewController" params:@{@"name":@"cs"} handler:^(NSDictionary *dictParams) {
                NSLog(@"%@", dictParams[@"pass"]);
            }];
            [SR2Manager router_TellModuleMessage:@"OneViewController" withCmd:SR2ModuleOther + 1 withParams:nil];
        }
            break;
        case 1:
        {
            [SR2Manager router_Push:@"OneViewController" params:@{@"name":@"cs"} protocol:self];
        }
            break;
        case 2:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SR2Manager router_Notify:5 withSrcName:@"ViewController" withParams:@{@"cs":@"pass value"}];
            });
            
            UIViewController *vc = [SR2Manager router_InstanceClass:@"OneViewController"];
            vc.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40);
            vc.modalPresentationStyle =  UIModalPresentationFormSheet;
            //            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
            [self presentViewController:vc animated:YES completion:nil];
            //            [SR2Manager router_Present:@"OneViewController" params:@{@"name":@"cs"} handler:nil];
        }
            break;
        case 3:
        {
            [SR2Manager ModulaA_showToast:self.view withMsg:@"我是cs啦"];
        }
            break;
        case 4:
        {
            [SR2Manager ModuleB_PushViewController];
        }
            break;
        case 5:
        {
            [SR2Manager router_Push:@"GroupViewController" params:nil handler:nil];
        }
            break;
        case 6:
        {
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"routercell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"routercell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.arrayDataSource[indexPath.row];
    
    return cell;
}


#pragma mark - TestProtocol
- (void)testPassValue:(NSString *)value
{
    NSLog(@"测试船只:%@", value);
}

#pragma mark - 私有函数（初始化）
- (void)setupData
{
    [SR2Manager router_SubscribMsg:0 withName:NSStringFromClass([self class]) handler:^(NSDictionary *dictParams) {
        NSLog(@"ViewController Subscrib Block Print:%@", dictParams[@"pass"]);
    } recvCount:2];
    
    
    [SR2Manager router_SubscribMsg:1 withName:NSStringFromClass([self class]) handler:nil];
    
    [SR2Manager router_SubscribMsg:2 srcName:NSStringFromClass([self class]) desName:@"OneViewController" handler:^(NSDictionary *dictParams) {
        NSLog(@"ViewController Subscrib Block Print:%@", dictParams[@"pass"]);
    }];
    
    [SR2Manager router_UnregisteServer:@"ViewController"];
    [SR2Manager router_RegisteServerEx:self];
    
}

- (void)setupInit
{
    
}

- (void)setupView
{
    [self.view addSubview:self.tableView];
}


#pragma mark - setter and getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource= self;
    }
    
    return _tableView;
}

- (NSArray *)arrayDataSource
{
    if (_arrayDataSource == nil) {
        _arrayDataSource = @[@"push界面带参数回调", @"push界面带参数回调2", @"pesent界面带参数无回调", @"调用模块A的Toast显示", @"调用模块B", @"groupTableView", @"待添加", @"待添加"];
    }
    
    return _arrayDataSource;
}

@end
