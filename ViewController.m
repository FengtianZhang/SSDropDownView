//
//  ViewController.m
//  SSDropDownViewDemo
//
//  Created by shao_Mac on 16/8/26.
//  Copyright © 2016年 RX_zft. All rights reserved.
//

#import "ViewController.h"
#import "SSDropDownView.h"

@interface ViewController () <SSDropDownDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) SSDropDownView *dropView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, assign) NSInteger clickTag;

@property (nonatomic, assign) NSInteger oldClickTag;

@property (nonatomic, assign) BOOL isOpenSelect;

@property (nonatomic, strong) NSArray *selectArray;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isOpenSelect = NO;
    _oldClickTag = 0;
    
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:22 + i];
        [button setTitle:self.titleArray[i] forState:(UIControlStateNormal)];
    }
    
}


- (IBAction)buttonAction:(UIButton *)sender {
    
    //    sender.tag 从坐到右 22, 23, 24
    _clickTag = sender.tag;
    NSInteger tableHeight = self.selectArray.count * SELECT_CELL_HEIGHT;
    
    if (_oldClickTag != 0 && _oldClickTag != _clickTag && _dropView) {
       
        UIButton *previouButton = (UIButton *)[self.view viewWithTag:_oldClickTag];
        NSString *previouButtonString = [previouButton titleForState:(UIControlStateNormal)];
        if ([previouButtonString isEqualToString:_titleArray[_oldClickTag - 22]]) {
            [_dropView transFormButtonImageAndTitleColor:previouButton];
        }else{
            [_dropView transFormButtonImage:previouButton];
        }
        
        NSString *buttonString = [sender titleForState:(UIControlStateNormal)];
        if ([buttonString isEqualToString:_titleArray[_clickTag - 22]]) {
            [_dropView transFormSenderImageAndTitleColor:sender];
        }else{
            [_dropView transFormSenderImage:sender];
        }
        
        [_dropView changeTableViewHeightWithHeight:tableHeight];
        _oldClickTag = _clickTag;
        return;
    }
    
    if (_isOpenSelect == NO) {
        
        [self.dropView upAnimationWithButton:sender WithHeight:tableHeight];
        [_dropView addGestureRecognizer:self.tap];
        
    }else{
        
        BOOL ischange = NO;
        if ([[sender titleForState:(UIControlStateNormal)] isEqualToString:_titleArray[_clickTag - 22]]) {
            ischange = YES;
        }
        [self.dropView downAnimationWithButton:sender WithHeight:tableHeight isChange:ischange];
        [_dropView removeGestureRecognizer:self.tap];
        _dropView = nil;
    }
    _oldClickTag = _clickTag;
    _isOpenSelect = !_isOpenSelect;
}

#define mark ----  SSDropViewDelegate
// 返回多少个
- (NSInteger)dropDownCount
{
    return self.selectArray.count;
}

// 返回是选择内容
- (NSArray *)dropDownArray
{
    return self.selectArray;
}

// 当前选中的index
- (NSInteger)SelectIndex
{
    UIButton *button = (UIButton *)[self.view viewWithTag:_clickTag];
    NSString *buttonString = [button titleForState:(UIControlStateNormal)];
    return [self.selectArray indexOfObject:buttonString];
    
}

// 点击选择之后回调
- (void)selectCellString:(NSString *)string
{
    _isOpenSelect = !_isOpenSelect;
    UIButton *button = (UIButton *)[self.view viewWithTag:_clickTag];
    NSInteger tableHeight = self.selectArray.count * SELECT_CELL_HEIGHT;
    
    
    BOOL ischange = NO;
    if ([string isEqualToString:_titleArray[_clickTag - 22]]) {
        ischange = YES;
    }
    
    [self.dropView downAnimationWithButton:button WithHeight:tableHeight isChange:ischange];
    
    [_dropView removeGestureRecognizer:self.tap];
    _dropView = nil;
    
    [button setTitle:string forState:(UIControlStateNormal)];
}

- (SSDropDownView *)dropView
{
    if (!_dropView) {
        _dropView = [[SSDropDownView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 41)];
        _dropView.delegate = self;
        [self.view addSubview:_dropView];
    }
    return _dropView;
}

- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tap.delegate = self;
    }
    return _tap;
}

// 处理tableViewcell点击和tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[SSDropDownView class]]) {
        return YES;
    }
    return NO;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSInteger tableHeight = self.selectArray.count * SELECT_CELL_HEIGHT;
    
    UIButton *button = (UIButton *)[self.view viewWithTag:_clickTag];
    
    BOOL ischange = NO;
    if ([[button titleForState:(UIControlStateNormal)] isEqualToString:self.titleArray[_clickTag - 22]]) {
        ischange = YES;
    }
    [self.dropView downAnimationWithButton:button WithHeight:tableHeight isChange:ischange];
    [self.dropView removeGestureRecognizer:tap];
    _dropView = nil;
    _isOpenSelect = !_isOpenSelect;
}

- (NSArray *)selectArray
{
    _selectArray = nil;
    if (_clickTag == 22) {
        return @[self.titleArray[0],@"qqqq",@"wwww",@"eeee"];
    }else if (_clickTag == 23){
        return @[self.titleArray[1],@"aaaa",@"ssss",@"dddd",@"ffff"];
    }else if (_clickTag == 24){
        return @[self.titleArray[2],@"zzzz",@"xxxx",@"cccc",@"vvvv",@"bbbb"];
    }
    return nil;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"选项1",@"选项2",@"选项3"];
    }
    return _titleArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
