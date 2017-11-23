//
//  headerView.m
//  SRouter2Demo
//
//  Created by cs on 17/1/21.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "GroupHeaderView.h"

#define W 1
@implementation GroupHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    GroupHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if (headerView == nil) {
        headerView = [[GroupHeaderView alloc] initWithReuseIdentifier:reuseIdentifier withTableView:tableView];

        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.textColor = [UIColor redColor];
        labelTitle.tag = 9527;
        //        labelTitle.font = GGFont(5);
        
        labelTitle.backgroundColor = [UIColor clearColor];
        [headerView addSubview:labelTitle];
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withTableView:(UITableView *)tableView
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.tableView = tableView;
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
//    CALayer * temp = [CALayer layer];
//    temp.frame = CGRectMake(1, 1, 303 - 2, 25 - 2);
//    [temp setBackgroundColor:[UIColor redColor].CGColor];
//    
//    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:temp.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(3.5, 3.5)];
//    
//    CAShapeLayer * mask  = [[CAShapeLayer alloc] initWithLayer:temp];
//    mask.path = path.CGPath;
//    temp.mask = mask;
//    [testButton.layer addSublayer:temp];
//    
//    UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:testButton.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
//    CAShapeLayer * mask2  = [[CAShapeLayer alloc] initWithLayer:temp];
//    mask2.path = path2.CGPath;
//    testButton.layer.mask = mask2;
    CGFloat cornerRadius = 3.f;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect tmp = CGRectMake(0, 2, self.tableView.bounds.size.width - self.tableView.frame.origin.x, 25);
    CGRect bounds = CGRectInset(tmp, W, 0);
    
    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
    layer.path = pathRef;
    CFRelease(pathRef);
    layer.lineWidth = 1;
    layer.miterLimit = layer.lineWidth;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    CALayer *lineLayer = [[CALayer alloc] init];
    CGFloat lineHeight = 1;//(1.f / [UIScreen mainScreen].scale);
    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
    lineLayer.backgroundColor = [UIColor redColor].CGColor;
    [layer addSublayer:lineLayer];
    
    UIView *testView = [[UIView alloc] initWithFrame:bounds];
    [testView.layer insertSublayer:layer atIndex:0];
    testView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = testView;
}

@end


@implementation GroupFooterView

+ (instancetype)footerViewWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    GroupFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if (headerView == nil) {
        headerView = [[GroupFooterView alloc] initWithReuseIdentifier:reuseIdentifier withTableView:tableView];

    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withTableView:(UITableView *)tableView
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.tableView = tableView;
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    CGFloat cornerRadius = 3.f;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect tmp = CGRectMake(0, 0, self.tableView.bounds.size.width - self.tableView.frame.origin.x, 20);
    CGRect bounds = CGRectInset(tmp, W, 0);
    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    layer.path = pathRef;
    CFRelease(pathRef);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
//    CALayer *lineLayer = [[CALayer alloc] init];
//    CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
//    lineLayer.backgroundColor = [UIColor redColor].CGColor;
//    [layer addSublayer:lineLayer];
    
    UIView *testView = [[UIView alloc] initWithFrame:bounds];
    [testView.layer insertSublayer:layer atIndex:0];
    testView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = testView;
}

@end
