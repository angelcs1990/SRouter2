//
//  GroupCell.h
//  SRouter2Demo
//
//  Created by cs on 17/1/21.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCell : UITableViewCell

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UILabel *labelText;

+ (instancetype)cellWithTableView:(UITableView *)talbeView reuseIdentifier:(NSString *)iden;

@end
