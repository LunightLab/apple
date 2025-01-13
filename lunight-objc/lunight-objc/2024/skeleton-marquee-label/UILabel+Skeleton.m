#import "UILabel+Skeleton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (SkeletonAnimation)

- (void)startSkeletonAnimation {
    [self startSkeletonAnimationWithLines:0]; // 0을 전달하여 줄 수를 자동으로 계산
}

- (void)startSkeletonAnimationWithLines:(NSUInteger)lines {
    // 기존의 스켈레톤 레이어들을 제거
    [self removeSkeletonLayers];
    
    // 각 줄의 스켈레톤 애니메이션 설정
    CGFloat lineHeight = self.font.lineHeight; // UILabel의 기본 텍스트 높이를 사용
    CGFloat padding = 5.0; // 위아래 여백 설정
    NSUInteger numberOfLines = lines ? lines : floor(self.bounds.size.height / (lineHeight + padding)); // 표시될 줄 수 계산
    
    for (NSUInteger i = 0; i < numberOfLines; i++) {
        CGFloat yPosition = i * (lineHeight + padding); // 각 줄의 Y 위치 계산
        CAShapeLayer *skeletonLayer = [self createSkeletonLayerWithYPosition:yPosition isFirstLine:(i == 0)];
        [self.layer addSublayer:skeletonLayer];
    }
}

- (CAShapeLayer *)createSkeletonLayerWithYPosition:(CGFloat)yPosition isFirstLine:(BOOL)isFirstLine {
    CGFloat skeletonWidth = isFirstLine ? self.bounds.size.width - 20 : self.bounds.size.width; // 첫 줄의 길이는 20만큼 줄임
    CGFloat lineHeight = self.font.lineHeight; // UILabel의 기본 텍스트 높이를 사용

    CAShapeLayer *skeletonLayer = [CAShapeLayer layer];
    skeletonLayer.frame = CGRectMake(0, yPosition, skeletonWidth, lineHeight); // 각 줄의 크기 및 위치 설정
    
    UIColor *lightColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    UIColor *darkColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = skeletonLayer.bounds;
    gradientLayer.colors = @[(id)lightColor.CGColor, (id)darkColor.CGColor, (id)lightColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
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
