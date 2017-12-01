//
//  ViewController.h
//  EmitterIcon
//
//  Created by Kael on 2017/11/30.
//  Copyright © 2017年 SkyWorth_hightong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ModeSwitchType) {
    ModeSwitchType_pause_resume,//暂停继续模式
    ModeSwitchType_userreactor,//用户交互模式
};

@interface ViewController : UIViewController

@property (nonatomic, assign) ModeSwitchType switchType;;
@property (strong, nonatomic) IBOutlet UIButton *actionBtn;

- (IBAction)changeAnimationStatusAction:(UIButton *)sender;

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)touchCancel:(UIButton *)sender;

/**
 <#Description#>

 @param sender <#sender description#>
 */
- (IBAction)touchDown:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UISwitch *modeSwitch;
- (IBAction)modeCahnged:(UISwitch *)sender;

@property (strong, nonatomic) IBOutlet UILabel *switchtitle;




@end

