#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SkeletonAnimation)

typedef NS_ENUM(NSInteger, SkeletonAnimationDirection) {
    SkeletonAnimationDirectionLeftToRight = 0,
    SkeletonAnimationDirectionTopToBottom = 1,
    SkeletonAnimationDirectionRightToLeft = 2,
    SkeletonAnimationDirectionBottomToTop = 3
};

typedef NS_ENUM(NSInteger, SkeletonAnimationShape) {
    SkeletonAnimationShapeLinear = 0,
    SkeletonAnimationShapeRadial = 1
};

- (void)startSkeletonAnimationWithBaseAlpha:(CGFloat)baseAlpha
                             highlightAlpha:(CGFloat)highlightAlpha
                                  baseColor:(UIColor *)baseColor
                             highlightColor:(UIColor *)highlightColor
                                  direction:(SkeletonAnimationDirection)direction
                                     shape:(SkeletonAnimationShape)shape
                                       tilt:(CGFloat)tilt;
- (void)stopSkeletonAnimation;

@end

NS_ASSUME_NONNULL_END


//#import <UIKit/UIKit.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface UILabel (SkeletonAnimation)
//
//- (void)startSkeletonAnimationWithBaseAlpha:(CGFloat)baseAlpha
//                             highlightAlpha:(CGFloat)highlightAlpha
//                                  baseColor:(UIColor *)baseColor
//                             highlightColor:(UIColor *)highlightColor;
//- (void)stopSkeletonAnimation;
//
//@end
//
//NS_ASSUME_NONNULL_END
