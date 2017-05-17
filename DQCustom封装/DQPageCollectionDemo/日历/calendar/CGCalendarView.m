//
//  CGCalendarView.m
//  SecondMenuDemo
//
//  Created by duxiaoqiang on 2017/5/16.
//  Copyright © 2017年 professional. All rights reserved.
//

#import "CGCalendarView.h"
#import "CGCalendarCollectionViewCell.h"
#import "NSDate+Calculate.h"
#import "UIImage+Calendar.h"
#define weekDayHeight  31
#define contentMargin  10
#define topViewHeight  50
#define bottomDescHeight  60
static NSString * const calculateIndenty = @"calculateIndenty";
#import "CalendarButton.h"
@interface CGCalendarView()<UICollectionViewDataSource,UICollectionViewDelegate>
// 记录周
@property (nonatomic,strong) NSArray *weekDayArray;
// 记录Label
@property (nonatomic,strong) NSMutableArray *labels;
@property (nonatomic,strong) UIView  *contentView ;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UILabel *yearAndMonthLabel;
// 获取某月里面的天数集合
@property (nonatomic,strong) NSMutableArray *daysArray;
@property (nonatomic,strong) UIView  *topView;
// 记录当前显示的日期
@property (nonatomic,strong) NSDate  *currentShowDate;
// 异常图片
@property (nonatomic,strong) UIImage  *exceptionImage;
// 选中图片
@property (nonatomic,strong) UIImage  *selectedImage;
@end
@implementation CGCalendarView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    // 添加一个全局的点击事件
    UIButton * clickBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    clickBtn.backgroundColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    clickBtn.layer.opacity = 0.3;
    [clickBtn addTarget:self action:@selector(clickBlankArea) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickBtn];
    CGFloat contentViewY = 120;
    CGFloat contentViewH = 416;
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        contentViewY = 60;
        contentViewH = 380;
    }
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(15, contentViewY,  [UIScreen mainScreen].bounds.size.width - 30, 416)];
    [self addSubview:self.contentView];
    NSDate * currentDate =  self.backShowDate != nil ? [NSDate converFromStringToDate:self.backShowDate] : [NSDate date];
    _daysArray = [[NSDate feachOfMonthArray:currentDate] mutableCopy];
    [self setupWeekView];
    // 具体日历内容
    [self setupContent];
    // 添加底部BottomView内容
    [self setupBottomView];
}

- (void)setBackShowDate:(NSString *)backShowDate
{
    _backShowDate = backShowDate;
    [self changDate:[NSDate converFromStringToDate:backShowDate]];
}
- (void)showView
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)setupWeekView
{
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, topViewHeight + weekDayHeight)];

    UIView * yearAndMonthView = [self setupYearAndMonthView];
    yearAndMonthView.backgroundColor = [UIColor colorWithRed:250/(255.0) green:161/(255.0) blue:97/(255.0) alpha:1.0];
    [topView addSubview:yearAndMonthView];
    UIView * titltView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight, self.contentView.frame.size.width, weekDayHeight)];
    for (NSString * day in self.weekDayArray) {
        UILabel * weekLabel = [[UILabel alloc] init];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = [UIColor whiteColor];
        weekLabel.font = [UIFont systemFontOfSize:18];
        weekLabel.text = day;
        [self.labels addObject:weekLabel];
        [titltView addSubview:weekLabel];
    }
    titltView.backgroundColor =  [UIColor colorWithRed:253/(255.0) green:139/(255.0) blue:96/(255.0) alpha:1.0];
    [topView addSubview:titltView];
    [self.contentView addSubview:topView];
    self.topView = topView;
}


- (UIView *)setupYearAndMonthView
{
    // 创建中间年月显示Label
    CGFloat labelMargin = 0;
    CGFloat leftAndRightMagin = 20;
    CGFloat buttonW = 80;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        labelMargin = 15;
        leftAndRightMagin = 10;
    }

    UIView  * yearAndMonthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,topViewHeight)];
   
    // 创建左边按钮
    CalendarButton * leftButton  = [[CalendarButton alloc] initWithFrame:CGRectMake(leftAndRightMagin, 10, buttonW, leftAndRightMagin)];
    [leftButton setTitle:@"上月" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(preMonthClick) forControlEvents:UIControlEventTouchUpInside];
    [yearAndMonthView addSubview:leftButton];

       CGFloat labelW =  self.contentView.frame.size.width - 2*(leftAndRightMagin + buttonW);
    UILabel * centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftButton.frame) + labelMargin, 0, labelW, topViewHeight)];
    NSDate * currentDate = self.backShowDate != nil ? [NSDate converFromStringToDate:self.backShowDate] : [NSDate date];
    centerLabel.text = [NSDate feachByDate:currentDate];
    self.currentShowDate = currentDate;
    centerLabel.font = [UIFont systemFontOfSize:24];
    centerLabel.textColor = [UIColor whiteColor];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    [yearAndMonthView addSubview:centerLabel];
    self.yearAndMonthLabel = centerLabel;
    // 创建右边按钮
    CalendarButton * rigthButton  = [[CalendarButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(centerLabel.frame) + labelMargin, 10, buttonW, leftAndRightMagin)];
    [rigthButton setTitle:@"下月" forState:UIControlStateNormal];
    rigthButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rigthButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    CGFloat imgWidth = rigthButton.imageView.bounds.size.width;
    CGFloat labWidth = rigthButton.titleLabel.bounds.size.width;
    [rigthButton setImageEdgeInsets:UIEdgeInsetsMake(0, labWidth, 0, -labWidth)];
    [rigthButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth -55, 0, imgWidth)];
    [rigthButton addTarget:self action:@selector(nextMonthClick) forControlEvents:UIControlEventTouchUpInside];
    [yearAndMonthView addSubview:rigthButton];
    return yearAndMonthView;
}

- (void)setupContent
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = self.contentView.bounds.size.width / 7;
    CGFloat itemH = (self.contentView.bounds.size.height -  CGRectGetMaxY(self.topView.frame) - bottomDescHeight) / 6;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    CGFloat collectViewH = self.contentView.frame.size.height - CGRectGetMaxY(self.topView.frame);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.contentView.bounds.size.width, collectViewH) collectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGCalendarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:calculateIndenty];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:254/(255.0) green:248/(255.0) blue:231/(255.0) alpha:1.0];
    // 添加左右滑动手势
    UISwipeGestureRecognizer *swipeGest ;
    NSArray * array = @[@(UISwipeGestureRecognizerDirectionLeft),@(UISwipeGestureRecognizerDirectionRight)];
    for (NSNumber * number in array) {
        swipeGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        swipeGest.direction  = [number integerValue];
        [self.collectionView addGestureRecognizer:swipeGest];
    }
    [self.contentView addSubview:self.collectionView];
}
// 设置底部BottomView
- (void)setupBottomView
{
    CGFloat bottomY = self.contentView.bounds.size.height - bottomDescHeight;
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, self.contentView.bounds.size.width, bottomDescHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    // 添加内容VIew
    CGFloat leftAndRightmargin = 50;
    CGFloat topAndBottommargin = 15;
    CGFloat buttomW = (self.contentView.bounds.size.width - 2 * leftAndRightmargin) * 0.5;
    CGFloat buttomH = bottomDescHeight - 2 * topAndBottommargin;
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(leftAndRightmargin, topAndBottommargin, buttomW, buttomH)];

    [leftButton setTitle:@"异常:" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage* exceptionImage =  [UIImage drawTriangle:[UIColor redColor] withFrameSize:CGSizeMake(8, 8) withRectSize:CGSizeMake(40, 40) isShowBorderColor:NO];
    [leftButton setImage:exceptionImage forState:UIControlStateNormal];
    [self changButtonPosition:leftButton];
    // 设置图片TODO
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftButton.frame), topAndBottommargin, buttomW, buttomH)];
    [rightButton setTitle:@"选中:" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomView addSubview:leftButton];
    [bottomView addSubview:rightButton];
    UIImage* selectedImage =  [UIImage imageWithRectColor:[UIColor redColor] withFrameSize:CGSizeMake(20, 20)];
    [rightButton setImage:selectedImage forState:UIControlStateNormal];

    [self changButtonPosition:rightButton];
    [self.contentView addSubview:bottomView];
}

- (void)changButtonPosition:(UIButton *)button
{
    CGFloat margin = 15;
    CGFloat imgWidth = button.imageView.bounds.size.width;
    CGFloat labWidth = button.titleLabel.bounds.size.width;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, labWidth + margin, 0, -labWidth)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, 0, imgWidth)];
}

// 上一月点击事件
- (void)preMonthClick
{
    NSDate *preDate = [NSDate feachPreDate:self.currentShowDate];
    [self changDate:preDate];
}
// 下一月点击事件
- (void)nextMonthClick
{
    NSDate *nextDate = [NSDate feachNextDate:self.currentShowDate];
    [self changDate:nextDate];
}
- (void)clickBlankArea
{
    [self removeFromSuperview];
}

- (void) swipeAction:(UISwipeGestureRecognizer *)swipe {
    
    switch (swipe.direction) {
            
        case UISwipeGestureRecognizerDirectionLeft:
            [self nextMonthClick];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [self preMonthClick];
            break;
        default:
            break;
    }
    
}

- (void)changDate:(NSDate *)currentDate
{
    self.currentShowDate = currentDate;
    // 更改Lable
    self.yearAndMonthLabel.text = [NSDate feachByDate:currentDate];
    // 更改数组
    [self.daysArray removeAllObjects];
    self.daysArray =  [[NSDate feachOfMonthArray:currentDate] mutableCopy];
    [self.collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 计算每个Label的排版
    CGFloat labelW = self.contentView.bounds.size.width / self.labels.count;
    CGFloat labelY = 0;
    for (NSInteger i = 0; i< self.labels.count; i++) {
        UILabel * label = self.labels[i];
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, weekDayHeight);
    }
}

#pragma mark - UICollection代理和数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.daysArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:calculateIndenty forIndexPath:indexPath];
    NSString * num = self.daysArray[indexPath.row];
    // 当天日期
    if ([NSDate compareDate:[NSDate date] target:self.currentShowDate] && [num integerValue] == [NSDate day:[NSDate date]]) {
        cell.showNumLabel.textColor = [UIColor redColor];
    }else{
        cell.showNumLabel.textColor = [UIColor blackColor];
    }
    if ([num integerValue] == 18) {   // 异常图片
        cell.showBackImage.image = self.exceptionImage;
    }
    else if ([num integerValue] == [NSDate day:self.currentShowDate]) // 选中日期图片
    {
        cell.showBackImage.image = self.selectedImage;
    }else if([num integerValue] == 9){ // 异常且选中图片
        cell.showBackImage.image = [UIImage drawTriangle:[UIColor redColor] withFrameSize:CGSizeMake(8, 8) withRectSize:CGSizeMake(35, 35) isShowBorderColor:YES];
    }else
    {
        cell.showBackImage.image = nil;
    }
    cell.showNumLabel.text = num;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    // 取出点击的数据
    NSString * day = self.daysArray[indexPath.row];
    if (day.length == 0) {
        return;
    }
    // 获取当前日期
    NSDate * currentDate = self.currentShowDate;
    NSCalendar * calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    components.day = [day integerValue];
    NSDate * newDate = [calendar dateFromComponents:components];
    if(self.selectedItemClick)
    {
        self.selectedItemClick([NSDate convertByDate:newDate]);
    }
    [self removeFromSuperview];
}


#pragma mark - 懒加载
-(NSArray* )weekDayArray
{
    if(!_weekDayArray)
    {
        _weekDayArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    }
    return _weekDayArray;
}

-(NSMutableArray* )labels
{
    if(!_labels)
    {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
-(UIImage * )exceptionImage
{
    if(!_exceptionImage)
    {
        _exceptionImage =  [UIImage drawTriangle:[UIColor redColor] withFrameSize:CGSizeMake(8, 8) withRectSize:CGSizeMake(35, 35) isShowBorderColor:NO];
    }
    return _exceptionImage;
}
-(UIImage * )selectedImage
{
    if(!_selectedImage)
    {
        _selectedImage =  [UIImage imageWithRectColor:[UIColor redColor] withFrameSize:CGSizeMake(35, 35)];
    }
    return _selectedImage;
}
@end
