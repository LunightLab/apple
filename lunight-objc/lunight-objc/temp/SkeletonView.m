#import "SkeletonView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SkeletonView {
    NSMutableArray<CAGradientLayer *> *gradientLayers;
    BOOL isAnimating;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        gradientLayers = [NSMutableArray array];
        [self setupSkeletons];
    }
    return self;
}

- (void)setupSkeletons {
    [gradientLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [gradientLayers removeAllObjects];
    
    CGFloat layerHeight = 20.0; // 각 스켈레톤 레이어의 높이
    NSUInteger numberOfLayers = ceil(self.bounds.size.height / layerHeight);
    
    for (NSUInteger i = 0; i < numberOfLayers; i++) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, i * layerHeight, self.bounds.size.width, layerHeight);
        
        UIColor *lightColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        UIColor *darkColor = [UIColor colorWithWhite:0.75 alpha:1.0];
        
        gradientLayer.colors = @[(id)lightColor.CGColor, (id)darkColor.CGColor, (id)lightColor.CGColor];
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        gradientLayer.locations = @[@0.0, @0.5, @1.0];
        
        [self.layer addSublayer:gradientLayer];
        [gradientLayers addObject:gradientLayer];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupSkeletons];
}

- (void)startAnimating {
    if (isAnimating) return;
    
    for (CAGradientLayer *gradientLayer in gradientLayers) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
        animation.fromValue = @[@0.0, @0.1, @0.2];
        animation.toValue = @[@1.0, @1.1, @1.2];
        animation.duration = 1.5;
        animation.repeatCount = HUGE_VALF;
        animation.removedOnCompletion = NO; // 애니메이션이 종료된 후에도 상태를 유지
        animation.fillMode = kCAFillModeForwards;
        [gradientLayer addAnimation:animation forKey:@"skeletonAnimation"];
    }
    isAnimating = YES;
}

- (void)stopAnimating {
    if (!isAnimating) return;
    
    for (CAGradientLayer *gradientLayer in gradientLayers) {
        [gradientLayer removeAnimationForKey:@"skeletonAnimation"];
    }
    isAnimating = NO;
}

@end
