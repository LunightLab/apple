#import "MarqueeLabel.h"

@interface MarqueeLabel()

@property (nonatomic, strong) UILabel *duplicateLabel;

@end

@implementation MarqueeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] init];
        [self addSubview:_label];
        _speed = 50.0; // 기본 속도 설정
        self.clipsToBounds = YES; // 뷰의 경계를 넘는 부분을 잘리도록 설정
    }
    return self;
}

- (void)startMarquee {
    
    [self resetLabelFrame];

    CGFloat labelWidth = self.label.frame.size.width;
    CGFloat viewWidth = self.bounds.size.width;

    // Create a duplicate label if needed
    if (!self.duplicateLabel) {
        self.duplicateLabel = [[UILabel alloc] initWithFrame:self.label.frame];
        self.duplicateLabel.text = [NSString stringWithFormat:@"2%@", self.label.text ];
        self.duplicateLabel.font = self.label.font;
        self.duplicateLabel.textColor = self.label.textColor;
        self.duplicateLabel.backgroundColor = self.label.backgroundColor;
        [self addSubview:self.duplicateLabel];
    }

    // Position the duplicate label right after the original label
    CGRect duplicateInitialFrame = self.duplicateLabel.frame;
    duplicateInitialFrame.origin.x = labelWidth;
    self.duplicateLabel.frame = duplicateInitialFrame;

    // Calculate duration based on the combined width
    CGFloat duration = (labelWidth + viewWidth) / self.speed;

    // Start the animation
    [self animateLabelsWithDuration:duration];
}

- (void)resetLabelFrame {
    CGSize textSize = [self.label.text sizeWithAttributes:@{NSFontAttributeName: self.label.font}];
    CGRect labelFrame = self.label.frame;
    labelFrame.size.width = textSize.width;
    labelFrame.size.height = self.bounds.size.height;
    labelFrame.origin.x = 0;
    self.label.frame = labelFrame;
}

- (void)animateLabelsWithDuration:(CGFloat)duration {
    CGFloat labelWidth = self.label.frame.size.width;
    CGFloat viewWidth = self.bounds.size.width;

    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                     animations:^{
                         CGRect labelFrame = self.label.frame;
                         CGRect duplicateLabelFrame = self.duplicateLabel.frame;

                         labelFrame.origin.x = -labelWidth;
                         duplicateLabelFrame.origin.x = labelFrame.origin.x + labelWidth;

                         self.label.frame = labelFrame;
                         self.duplicateLabel.frame = duplicateLabelFrame;
                     }
                     completion:^(BOOL finished) {
                         // 애니메이션이 끝나면 위치를 재설정하고 반복
                         if (finished) {
                             [self resetLabelFrame];
                             [self startMarquee];
                         }
                     }];
}

@end
