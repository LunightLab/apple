
#import "UILabel+SkeletonAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (SkeletonAnimation)

- (void)startSkeletonAnimationWithBaseAlpha:(CGFloat)baseAlpha
                             highlightAlpha:(CGFloat)highlightAlpha
                                  baseColor:(UIColor *)baseColor
                             highlightColor:(UIColor *)highlightColor
                                  direction:(SkeletonAnimationDirection)direction
                                     shape:(SkeletonAnimationShape)shape
                                       tilt:(CGFloat)tilt {
    // 기존의 스켈레톤 레이어들을 제거
    [self removeSkeletonLayers];
    
    // UILabel 전체에 스켈레톤 애니메이션 설정
    CAShapeLayer *skeletonLayer = [self createSkeletonLayerWithFrame:self.bounds
                                                          baseAlpha:baseAlpha
                                                     highlightAlpha:highlightAlpha
                                                          baseColor:baseColor
                                                     highlightColor:highlightColor
                                                          direction:direction
                                                             shape:shape
                                                              tilt:tilt];
    
    // 스켈레톤 애니메이션의 zPosition을 높게 설정
    skeletonLayer.zPosition = 10; // 예시에서는 임의의 높은 값으로 설정했습니다.

    
    [self.layer addSublayer:skeletonLayer];
}

- (CAShapeLayer *)createSkeletonLayerWithFrame:(CGRect)frame
                                     baseAlpha:(CGFloat)baseAlpha
                                highlightAlpha:(CGFloat)highlightAlpha
                                     baseColor:(UIColor *)baseColor
                                highlightColor:(UIColor *)highlightColor
                                     direction:(SkeletonAnimationDirection)direction
                                        shape:(SkeletonAnimationShape)shape
                                          tilt:(CGFloat)tilt {
    CAShapeLayer *skeletonLayer = [CAShapeLayer layer];
    skeletonLayer.frame = frame; // UILabel의 전체 크기 및 위치 설정
    
    UIColor *lightColor = [highlightColor colorWithAlphaComponent:highlightAlpha];
    UIColor *darkColor = [baseColor colorWithAlphaComponent:baseAlpha];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = skeletonLayer.bounds;
    gradientLayer.colors = @[(id)darkColor.CGColor, (id)lightColor.CGColor, (id)darkColor.CGColor];
    
    if (shape == SkeletonAnimationShapeLinear) {
        gradientLayer.type = kCAGradientLayerAxial;
    } else if (shape == SkeletonAnimationShapeRadial) {
        gradientLayer.type = kCAGradientLayerRadial;
    }
    
    // Adjust startPoint and endPoint based on direction and tilt
    switch (direction) {
        case SkeletonAnimationDirectionLeftToRight:
            gradientLayer.startPoint = CGPointMake(0.0, 0.5 - tilt / 100.0);
            gradientLayer.endPoint = CGPointMake(1.0, 0.5 + tilt / 100.0);
            break;
        case SkeletonAnimationDirectionTopToBottom:
            gradientLayer.startPoint = CGPointMake(0.5 - tilt / 100.0, 0.0);
            gradientLayer.endPoint = CGPointMake(0.5 + tilt / 100.0, 1.0);
            break;
        case SkeletonAnimationDirectionRightToLeft:
            gradientLayer.startPoint = CGPointMake(1.0, 0.5 + tilt / 100.0);
            gradientLayer.endPoint = CGPointMake(0.0, 0.5 - tilt / 100.0);
            break;
        case SkeletonAnimationDirectionBottomToTop:
            gradientLayer.startPoint = CGPointMake(0.5 + tilt / 100.0, 1.0);
            gradientLayer.endPoint = CGPointMake(0.5 - tilt / 100.0, 0.0);
            break;
    }

    gradientLayer.locations = @[@0.0, @0.5, @1.0];
    
    // 애니메이션 설정
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = @[@0.0, @0.1, @0.2];
    animation.toValue = @[@1.0, @1.1, @1.2];
    animation.duration = 1.5;
    animation.repeatCount = HUGE_VALF;
    
    [gradientLayer addAnimation:animation forKey:@"skeletonAnimation"];
    
    [skeletonLayer addSublayer:gradientLayer];
    
    return skeletonLayer;
}

- (void)stopSkeletonAnimation {
    // 모든 스켈레톤 애니메이션 제거
    [self removeSkeletonLayers];
}

- (void)removeSkeletonLayers {
    NSMutableArray *layersToRemove = [NSMutableArray array];
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layersToRemove addObject:layer];
        }
    }
    
    for (CALayer *layer in layersToRemove) {
        [layer removeFromSuperlayer];
    }
}

@end




//#import "UILabel+SkeletonAnimation.h"
//#import <QuartzCore/QuartzCore.h>
//
//@implementation UILabel (SkeletonAnimation)
//
//- (void)startSkeletonAnimationWithBaseAlpha:(CGFloat)baseAlpha
//                             highlightAlpha:(CGFloat)highlightAlpha
//                                  baseColor:(UIColor *)baseColor
//                             highlightColor:(UIColor *)highlightColor {
//    // 기존의 스켈레톤 레이어들을 제거
//    [self removeSkeletonLayers];
//    
//    // UILabel 전체에 스켈레톤 애니메이션 설정
//    CAShapeLayer *skeletonLayer = [self createSkeletonLayerWithFrame:self.bounds
//                                                          baseAlpha:baseAlpha
//                                                     highlightAlpha:highlightAlpha
//                                                          baseColor:baseColor
//                                                     highlightColor:highlightColor];
//    [self.layer addSublayer:skeletonLayer];
//}
//
//- (CAShapeLayer *)createSkeletonLayerWithFrame:(CGRect)frame
//                                     baseAlpha:(CGFloat)baseAlpha
//                                highlightAlpha:(CGFloat)highlightAlpha
//                                     baseColor:(UIColor *)baseColor
//                                highlightColor:(UIColor *)highlightColor {
//    CAShapeLayer *skeletonLayer = [CAShapeLayer layer];
//    skeletonLayer.frame = frame; // UILabel의 전체 크기 및 위치 설정
//    
//    UIColor *lightColor = [highlightColor colorWithAlphaComponent:highlightAlpha];
//    UIColor *darkColor = [baseColor colorWithAlphaComponent:baseAlpha];
//    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = skeletonLayer.bounds;
//    gradientLayer.colors = @[(id)darkColor.CGColor, (id)lightColor.CGColor, (id)darkColor.CGColor];
//    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
//    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
//    gradientLayer.locations = @[@0.0, @0.5, @1.0];
//    
//    // 애니메이션 설정
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
//    animation.fromValue = @[@0.0, @0.1, @0.2];
//    animation.toValue = @[@1.0, @1.1, @1.2];
//    animation.duration = 1.5;
//    animation.repeatCount = HUGE_VALF;
//    
//    [gradientLayer addAnimation:animation forKey:@"skeletonAnimation"];
//    
//    [skeletonLayer addSublayer:gradientLayer];
//    
//    return skeletonLayer;
//}
//
//- (void)stopSkeletonAnimation {
//    // 모든 스켈레톤 애니메이션 제거
//    [self removeSkeletonLayers];
//}
//
//- (void)removeSkeletonLayers {
//    NSMutableArray *layersToRemove = [NSMutableArray array];
//    for (CALayer *layer in self.layer.sublayers) {
//        if ([layer isKindOfClass:[CAShapeLayer class]]) {
//            [layersToRemove addObject:layer];
//        }
//    }
//    
//    for (CALayer *layer in layersToRemove) {
//        [layer removeFromSuperlayer];
//    }
//}
//
//@end
