//
//  ViewController.m
//  EmitterIcon
//
//  Created by Kael on 2017/11/30.
//  Copyright © 2017年 SkyWorth_hightong. All rights reserved.
//

#import "ViewController.h"

//#import "EmitterIconView.swift"

#import "EmitterIconView.h"

@interface ViewController ()

/**
 <#Description#>
 */
@property (nonatomic,assign) KAnimationType status;

/**
 <#Description#>
 */
@property (nonatomic, strong) EmitterIconView *emitter;

/**
 <#Description#>
 */
@property (nonatomic,assign) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _switchType = ModeSwitchType_pause_resume;
    
    _emitter = [[EmitterIconView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) andImage:@"happysales" andCircleColor:[UIColor colorWithRed:0.91 green:0.20 blue:0.11 alpha:1.00]];
    [self.view addSubview:_emitter];
    _emitter.center = self.view.center;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_emitter setCircleColor:[UIColor greenColor]];
//    });
}


#pragma mark - **************** 用户交互模式的响应事件
/**
 中心按钮抬起
 */
-(void)centerActionTouchUpInside{
    [_emitter changeAnimationStatus:KAnimationType_stop];
}

/**
 中心按钮抬起
 */
-(void)centerActionTouchDown{
    [_emitter setPeopertyWithAnimationDuration:4.0 andLayerNum:@8];

}
#pragma mark - **************** 暂停按钮响应事件
- (IBAction)changeAnimationStatusAction:(UIButton *)sender {
//    _count++;
//    if (_count == 5) {
//        
//        [_emitter setPeopertyWithAnimationDuration:4.0 andLayerNum:@8];
//        _count = 0;
//        return;
//    }
    if (_status != KAnimationType_pause) {
        _status = KAnimationType_pause;
        [_emitter changeAnimationStatus:KAnimationType_pause];
        [sender setTitle:@"resume" forState:UIControlStateNormal];
    }else{
        _status = KAnimationType_resume;
        [_emitter changeAnimationStatus:KAnimationType_resume];
        [sender setTitle:@"pause" forState:UIControlStateNormal];
    }
    
}
#pragma mark - **************** 模式切换事件
- (IBAction)modeCahnged:(UISwitch *)sender {
    
    if (_switchType == ModeSwitchType_pause_resume) {
        _switchType = ModeSwitchType_userreactor;
        
        [_emitter changeAnimationStatus:KAnimationType_stop];
        
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [centerButton setImage:[UIImage imageNamed:@"happysales"] forState:UIControlStateNormal];
        [centerButton addTarget:self action:@selector(centerActionTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [centerButton addTarget:self action:@selector(centerActionTouchDown) forControlEvents:UIControlEventTouchDown];
        [_emitter addCenterView:centerButton];
        
        _switchtitle.text = @"用户交互模式";
        _actionBtn.hidden = YES;

    }else{
        _switchType = ModeSwitchType_pause_resume;
        [_emitter removeCenterView];
        [_emitter setPeopertyWithAnimationDuration:3 andLayerNum:@6];
        _switchtitle.text = @"暂停/继续模式";
        _actionBtn.hidden = NO;
    }
}


#pragma mark - **************** 弃用的方法
//弃用
- (IBAction)touchCancel:(UIButton *)sender {
    
    //    [_emitter changeAnimationStatus:KAnimationType_stop];
    
}
//弃用
- (IBAction)touchDown:(UIButton *)sender {
    return;
    NSLog(@"按下");
    [_emitter setPeopertyWithAnimationDuration:4.0 andLayerNum:@8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   // 内存警告
}
@end
