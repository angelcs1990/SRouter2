//
//  GroupCell.m
//  SRouter2Demo
//
//  Created by cs on 17/1/21.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)talbeView reuseIdentifier:(NSString *)iden
{
    GroupCell *cell =[talbeView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden withTableView:talbeView];
        UIView *selected = [[UIView alloc] initWithFrame:cell.bounds];
        UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(1, 0, talbeView.frame.size.width-12, cell.frame.size.height - 1)];
        [selected addSubview:tmp];
        tmp.backgroundColor = [UIColor grayColor];
         cell.selectedBackgroundView = selected;
        
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTableView:(UITableView *)tableView
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tableView = tableView;
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    [self addSubview:self.labelText];
    self.labelText.frame = CGRectMake(10, 0, self.tableView.bounds.size.width - self.tableView.frame.origin.x, self.bounds.size.height);
    self.labelText.text = @"init";
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect tmp = CGRectMake(0, 0, self.tableView.bounds.size.width - self.tableView.frame.origin.x, self.bounds.size.height);
    CGRect bounds = CGRectInset(tmp, 1, 0);

//    int value = arc4random() % 2;
//    if (value == 0) {
//        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), 0);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), self.bounds.size.height);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), self.bounds.size.height - 1);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), self.bounds.size.height - 1);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), self.bounds.size.height);
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), 0);
//    } else {

        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), 0);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), self.bounds.size.height);
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds), 0);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), self.bounds.size.height);
    
    layer.path = pathRef;
    CFRelease(pathRef);
    layer.lineWidth = 1.f;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
//    CALayer *lineLayer = [[CALayer alloc] init];
//    CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
//    lineLayer.backgroundColor = [UIColor redColor].CGColor;
//    [layer addSublayer:lineLayer];
    
    UIView *testView = [[UIView alloc] initWithFrame:bounds];
    [testView.layer insertSublayer:layer atIndex:0];
    testView.backgroundColor = [UIColor clearColor];
    self.backgroundView = testView;
}

#pragma mark - 
- (UILabel *)labelText
{
    if (_labelText == nil) {
        _labelText = [UILabel new];
    }
    
    return _labelText;
}

@end
