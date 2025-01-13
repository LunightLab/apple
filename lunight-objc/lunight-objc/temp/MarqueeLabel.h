#import <UIKit/UIKit.h>

@interface MarqueeLabel : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat speed;

- (void)startMarquee;

@end
