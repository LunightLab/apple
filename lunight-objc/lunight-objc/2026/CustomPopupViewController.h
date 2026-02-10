#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomPopupViewController : UIViewController

// xib 파일명을 받아서 로드
- (instancetype)initWithContentXib:(NSString *)xibName;

- (void)presentFromViewController:(UIViewController *)viewController;

@property (nonatomic, assign) CGFloat animationDuration;   // Default: 0.7
@property (nonatomic, strong, readonly) UIView *contentContainerView; // xib를 추가할 뷰

@end

NS_ASSUME_NONNULL_END
