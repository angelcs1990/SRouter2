//
//  ViewController.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, copy) void(^block1)();
@property (nonatomic, strong) void(^block2)();

@end

