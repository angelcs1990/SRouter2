//
//  headerView.h
//  SRouter2Demo
//
//  Created by cs on 17/1/21.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupHeaderView : UITableViewHeaderFooterView
@property (nonatomic, weak) UITableView *tableView;
+ (instancetype)headerViewWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;
@end


@interface GroupFooterView : UITableViewHeaderFooterView
@property (nonatomic, weak) UITableView *tableView;
+ (instancetype)footerViewWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;
@end
