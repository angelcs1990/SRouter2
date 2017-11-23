//
//  ModuleBViewController.m
//  SRouter2Demo
//
//  Created by cs on 16/12/28.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ModuleBViewController.h"

@interface ModuleBViewController ()

@end

@implementation ModuleBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ModuleBViewController";
    
    UILabel *labelTmp = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 300)];
    labelTmp.layer.borderWidth = 1.0f;
    labelTmp.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:labelTmp];
    
    labelTmp.numberOfLines = 0;
    labelTmp.textAlignment = NSTextAlignmentCenter;
    labelTmp.text = @"老师都放假了深\n刻的肌肤来\n说肯定减肥了圣诞\n节弗兰克是江东父老看世界代理反\n馈就是地方了看就是代理反馈就\n是来的反馈就是独立空间";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
