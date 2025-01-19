#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SkeletonAnimation)

- (void)startSkeletonAnimationWithLines:(NSUInteger)lines;
- (void)startSkeletonAnimation; // 줄 수를 자동으로 계산
- (void)stopSkeletonAnimation;

@end

NS_ASSUME_NONNULL_END
