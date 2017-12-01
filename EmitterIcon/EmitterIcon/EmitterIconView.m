//
//  EmitterIconView.m
//  EmitterIcon
//
//  Created by Kael on 2017/11/30.
//  Copyright © 2017年 SkyWorth_hightong. All rights reserved.
//



#import "EmitterIconView.h"

@interface EmitterIconView(){
    CGRect _frame;//self的frame
    CGPoint _origin;//self 的origin
    CGSize _size;//self 的 尺寸
    CGFloat _originRate;//初始圆圈大小比率  或者 icon 占 self的比例
    UIColor *_circleColor;//圆圈颜色
    CGFloat _duration;//动画持续时间
    CGFloat _originAlppha;//动画初始透明度
    CGFloat _finalAlpha;//动画最终透明度
    NSNumber *_layerNum;//动画视图层数
    NSMutableArray *_layerViewArr;//盛放动画视图的数组
    NSMutableArray *_animationGroupArr;//盛放动画组合的数组
    NSString *_iconImgURL;//icon 图片链接
    CGPoint _center;//当前视图的中心点
    NSInteger _authritionCount;//状态更换ID  每生成一组动画 都会有新的ID产生。
    UIView *_circleContentView;
}

/**
 动画时长  决定了动画的速度
 */
@property (nonatomic, assign) CGFloat duration;

/**
 动画 辐射层数
 */
@property (nonatomic, strong) NSNumber *layerNum;

@end

@implementation EmitterIconView

-(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)img andCircleColor:(UIColor *)circleColor{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initBaseData];
        _iconImgURL = img;
        _circleColor = circleColor;

        [self initBaseView];
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(YES, @"请使用初始化方法 -(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)img");
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSAssert(YES, @"请使用初始化方法 -(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)img");
    }
    return self;
}

#pragma mark - **************** 初始化操作
- (void)initBaseData {
    _frame = self.frame;
    _origin = _frame.origin;
    _size = _frame.size;//视图初始尺寸
    _originRate = 0.33;//圆圈占整体大小的 初始比例
    _circleColor = [UIColor colorWithRed:0.91 green:0.20 blue:0.11 alpha:1.00];//主题色
    _duration = 3.0f;//动画时长
    _originAlppha = 0.7;
    _finalAlpha = 0.01;
    _layerNum = @4;//层数
    _center = self.center;
    
    _layerViewArr = [NSMutableArray array];
    _animationGroupArr = [NSMutableArray array];
    
}

- (void)initBaseView {
    _circleContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
    _circleContentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_circleContentView];
    
    [self initLayerViewWithNum:_layerNum];
    [self initIconImg];
    
}
-(void)initIconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_iconImgURL]];
        _iconImg.frame = CGRectMake(0, 0, _size.width*_originRate, _size.height*_originRate);
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
        _iconImg.backgroundColor = _circleColor;
        _iconImg.clipsToBounds = YES;
        _iconImg.layer.cornerRadius = _size.width*_originRate*0.5;
        [self addSubview:_iconImg];
        _iconImg.center = self.center;
        [self bringSubviewToFront:_iconImg];
    }
}
-(void)initLayerViewWithNum:(NSNumber *)num{
    //给层数赋值
    _layerNum = num;
    //创建放射层 并放入指定数组
    for (int i = 0; i<[num intValue]; i++) {
        UIView *layerView = [self creatCircleView];
        layerView.tag = 100 + i;//标记View
        [_circleContentView addSubview:layerView];
        //添加到数组
        [_layerViewArr addObject:layerView];
    }
    _authritionCount += 1;
    NSInteger authritionCount = _authritionCount;
    //给放射层设置动画
    for (int i = 0; i<_layerViewArr.count; i++) {
        UIView *layerView = [_layerViewArr objectAtIndex:i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((float)i*_duration/[_layerNum floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"\nauthritionCount:%ld ------ _authritionCount:%ld",(long)authritionCount,(long)_authritionCount);
            
            if (authritionCount != _authritionCount) {
                return ;
            }
            
            //创建动画组合
            CAAnimationGroup *animationGroup = [self scaleAndOpacityAnimation];
            //往layer上添加动画
            [layerView.layer addAnimation:animationGroup forKey:[NSString stringWithFormat:@"scaleAndOpacity-%d",i]];
            //添加到动画数组
            [_animationGroupArr addObject:animationGroup];

        });
    }
}

-(UIView *)creatCircleView{
    
    UIView *circleView = [UIView new];
    circleView.backgroundColor = _circleColor;
    circleView.frame = CGRectMake(0, 0, _size.width*_originRate , _size.height*_originRate );
    circleView.center = _center;
    circleView.layer.cornerRadius = _size.width*_originRate*0.5 ;

    return circleView;
}

#pragma mark - **************** 动画
-(CAAnimationGroup *)scaleAndOpacityAnimation{
    //透明度动画
    CABasicAnimation *opacityAnimation00 = [self opacityForever_Animation:_duration];
    //放缩动画
    CABasicAnimation *scaleAnimation00 = [self scale:[NSNumber numberWithFloat:1.0/_originRate] orgin:@1 durTimes:_duration Rep:NSIntegerMax];
    //把动画放入数组
    NSMutableArray *animationsArr = [NSMutableArray array];
    [animationsArr addObject:opacityAnimation00];
    [animationsArr addObject:scaleAnimation00];
    //创建CAAnimationGroup
    CAAnimationGroup *animationGroup00 = [self groupAnimation:animationsArr durTimes:_duration Rep:NSIntegerMax];
    return animationGroup00;
}

-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:_originAlppha];
    animation.toValue=[NSNumber numberWithFloat:_finalAlpha];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

-(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repeatTimes
{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue=orginMultiple;
    
    animation.toValue=Multiple;
    
    animation.duration=time;
    
    animation.autoreverses=YES;
    
    animation.repeatCount=repeatTimes;
    
    animation.removedOnCompletion=NO;
    
    animation.fillMode=kCAFillModeForwards;
    
    return animation;
    
}
//组合动画
-(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes
{
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations=animationAry;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

#pragma mark - **************** 暂停 和 继续动画
//暂停动画
-(void)pauseAnimationOnLayer:(CALayer *)layer{
    //1.取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    layer.timeOffset = pauseTime;
    //3.将动画的运行速度设置为0， 默认的运行速度是1.0
    layer.speed = 0.0;
}

//恢复动画
- (void)resumeAnimationOnLayer:(CALayer *)layer {
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = layer.timeOffset;
    //2.计算出开始时间
    CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
    [layer setTimeOffset:0];
    [layer setBeginTime:begin];
    layer.speed = 1;
}

#pragma mark - **************** 添加自定义的centerView
-(void)addCenterView:(UIView *)centerView{
    //开启交互
    _iconImg.userInteractionEnabled = YES;
    //移除之前的子视图
    [self removeCenterView];
    
    centerView.frame = CGRectMake(0, 0, _size.width*_originRate, _size.height*_originRate);
    centerView.backgroundColor = _circleColor;
    centerView.clipsToBounds = YES;
    centerView.layer.cornerRadius = _size.width*_originRate*0.5;
    [_iconImg addSubview:centerView];
}
-(void)removeCenterView{
    //移除之前的子视图
    for (UIView *subView in [_iconImg subviews]) {
        [subView removeFromSuperview];
    }
}
#pragma mark - **************** 动画状态改变
-(void)changeAnimationStatus:(KAnimationType)status{
    
    if (_layerViewArr.count > 0) {
        for (int i=0; i<_layerViewArr.count; i++) {
            UIView *layerView = [_layerViewArr objectAtIndex:i];
            //1.判断myView.layer上是否添加了动画
            CAAnimation *animation = [layerView.layer animationForKey:[NSString stringWithFormat:@"scaleAndOpacity-%d",i]];
            if (animation) {
                [self pauseAnimationOnLayer:layerView.layer];
            }
            
            switch (status) {
                case KAnimationType_start:{
                    
                }
                    break;
                case KAnimationType_pause:{
                    [self pauseAnimationOnLayer:layerView.layer];
                }
                    break;
                case KAnimationType_resume:{
                    [self resumeAnimationOnLayer:layerView.layer];
                }
                    break;
                case KAnimationType_stop:{
                    [self removeAllLayerAnitmation];
                }
                    break;
                default:
                    break;
            }

        }
    }
}

-(void)setPeopertyWithAnimationDuration:(CGFloat)duration andLayerNum:(NSNumber *)layerNum{
    _duration = duration;
    _layerNum = layerNum;
    //移除之前的动画和视图
    [self removeAllLayerAnitmation];
    [self removeAllLayerView];
    //添加新的放射视图
    [self initLayerViewWithNum:layerNum];
    [self bringSubviewToFront:_iconImg];
}

-(void)setCircleColor:(UIColor *)circleColor{
    _circleColor = circleColor;
    _iconImg.backgroundColor = _circleColor;
    for (UIView *layerView in _layerViewArr) {
        layerView.backgroundColor =_circleColor;
    }
}

#pragma mark - **************** 状态 视图 清楚方法
-(void)removeAllLayerAnitmation{
    _authritionCount++;
    if (_layerViewArr.count > 0) {
        for (int i=0; i<_layerViewArr.count; i++) {
            UIView *layerView = [_layerViewArr objectAtIndex:i];
            [layerView.layer removeAllAnimations];
//            [layerView.layer removeAnimationForKey:[NSString stringWithFormat:@"scaleAndOpacity-%d",i]];
        }
    }
    
    [_layerViewArr removeAllObjects];
    [_animationGroupArr removeAllObjects];
}

-(void)removeAllLayerView{
    for (int i=0; i<_layerViewArr.count; i++) {
        UIView *layerView = [_layerViewArr objectAtIndex:i];
        [layerView removeFromSuperview];
    }
}

-(void)dealloc{
    [self removeAllLayerAnitmation];
    [self removeAllLayerView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
