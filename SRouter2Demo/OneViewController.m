//
//  OneViewController.m
//  SRouter2Demo
//
//  Created by cs on 16/12/26.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "OneViewController.h"
#import "SRouter2.h"
#import "ModuleInterfaceHeader.h"

@interface OneViewController ()<SR2ModuleProtocol>

@property (nonatomic, copy) SR2BlockHandler handler;
@property (nonatomic, weak) id<TestProtocol> delegate;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor purpleColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"pass" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 100, 120, 50);
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 0.5f;
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    [SR2Manager router_SubscribMsg:5 withName:@"OneViewController" handler:^(NSDictionary *dictParams) {
        NSLog(@"recv %@", dictParams[@"cs"]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [SR2Manager router_CancelSubscribMsg:5 withName:@"OneViewController"];
    [SR2Manager router_printSubscribe];
    SR2Log(@"释放了");
}


- (void)buttonDidClicked
{
    if (self.handler) {
        self.handler(@{@"pass":@"pass cs"});
    }
    
    if (self.delegate) {
        [self.delegate testPassValue:@"我是cs"];
    }
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SR2Manager router_Notify:0 withParams:@{@"pass":@"哈哈，0"}];
        [SR2Manager router_Notify:1 withParams:@{@"pass":@"哈哈，1"}];
        [SR2Manager router_Notify:2 withSrcName:NSStringFromClass([self class]) withParams:@{@"pass":@"cs,2"}];
        
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

- (id)SR2Module_Command:(SR2Params *)params
{
    switch (params.cmd) {
        case SR2ModulePassParams:
        {
            self.title = [params.params objectForKey:@"name"];
            self.handler = SR2QueryBlock(params);
            self.delegate = (id<TestProtocol>)SR2QueryDelegate(params);
        }
            break;
        case SR2ModuleOther + 1:
            NSLog(@"ss");
            break;
        default:
            break;
    }
    
    return nil;
}

@end
