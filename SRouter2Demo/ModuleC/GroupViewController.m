//
//  GroupViewController.m
//  SRouter2Demo
//
//  Created by cs on 17/1/21.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupHeaderView.h"
#import "GroupCell.h"

@interface GroupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dictDataSource;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
//    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
//    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footerView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerSectionID = @"scheduleHeaderSectionID";
    GroupHeaderView *headerView = [GroupHeaderView headerViewWithTableView:tableView reuseIdentifier:headerSectionID];
    
    ((UILabel *)[headerView viewWithTag:9527]).text = @"cs";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GroupFooterView *headerView = [GroupFooterView footerViewWithTableView:tableView reuseIdentifier:@"footerView"];

    return headerView;
//    UITableViewHeaderFooterView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
//    if (sectionView == nil) {
//        sectionView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footerView"];
//        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
//        labelTitle.textAlignment = NSTextAlignmentCenter;
//        labelTitle.textColor = [UIColor redColor];
//        labelTitle.tag = 9527;
//        //        labelTitle.font = GGFont(5);
//        
//        sectionView.contentView.backgroundColor = [UIColor yellowColor];
////        [sectionView addSubview:labelTitle];
//        
//    }
//    
//    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCell *cell = [GroupCell cellWithTableView:tableView reuseIdentifier:@"cell"];

    return cell;
}
#pragma mark - setter and getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        CGRect tmpRt = self.view.bounds;
        tmpRt.size.width -= 9;
        tmpRt.origin.x = 9;
        _tableView.frame = tmpRt;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.layer.borderWidth = 0.1f;
//        _tableView.layer.borderColor = [UIColor redColor].CGColor;
        _tableView.backgroundColor = [UIColor yellowColor];
        
        
    }
    
    return _tableView;
}

- (NSMutableDictionary *)dictDataSource
{
    if (_dictDataSource == nil) {
        _dictDataSource = [NSMutableDictionary dictionary];
    }
    
    return _dictDataSource;
}

@end
