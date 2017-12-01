//
//  EmitterIconView.h
//  EmitterIcon
//
//  Created by Kael on 2017/11/30.
//  Copyright © 2017年 SkyWorth_hightong. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 APP 登陆 icon动画 状态类型

 - KAnimationType_start: 动画开始
 - KAnimationType_pause: 动画暂停
 - KAnimationType_resume: 动画重新继续
 - KAnimationType_stop: 动画停止（清除动画）
 */
typedef NS_ENUM(NSUInteger, KAnimationType) {
    KAnimationType_start,
    KAnimationType_pause,
    KAnimationType_resume,
    KAnimationType_stop,
};

@interface EmitterIconView : UIView

-(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)img andCircleColor:(UIColor *)circleColor;

/**
 图标
 */
@property (nonatomic, strong) UIImageView *iconImg;

/**
 圆圈颜色
 */
@property (nonatomic, strong) UIColor *circleColor;

/**
 添加唯一的中心视图方法

 @param centerView 自定义的唯一中心视图可是按钮等可交互的视图
 */
-(void)addCenterView:(UIView *)centerView;

-(void)removeCenterView;

/**
 设置基本属性（如果不设置 会选用默认的效果）

 @param duration 动画时长
 @param layerNum 辐射层数
 */
-(void)setPeopertyWithAnimationDuration:(CGFloat)duration andLayerNum:(NSNumber *)layerNum;

/**
 动画状态更改

 @param status 动画可选的更改状态
 */
-(void)changeAnimationStatus:(KAnimationType)status;

@end
