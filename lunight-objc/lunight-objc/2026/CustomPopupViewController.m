#import "CustomPopupViewController.h"

@interface CustomPopupViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *auroraContainer;
@property (nonatomic, strong) UIView *contentContainerView;

@property (nonatomic, strong) CAGradientLayer *auroraLayer1;
@property (nonatomic, strong) CAGradientLayer *auroraLayer2;
@property (nonatomic, strong) CAGradientLayer *auroraLayer3;
@property (nonatomic, strong) UIVisualEffectView *blurView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat initialTranslationY;

@property (nonatomic, strong) NSString *contentXibName;

@end

@implementation CustomPopupViewController

#pragma mark - Initialization

- (instancetype)initWithContentXib:(NSString *)xibName {
    self = [super init];
    if (self) {
        _contentXibName = xibName;
        _animationDuration = 0.7;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (instancetype)init {
    return [self initWithContentXib:nil];
}

#pragma mark - Lifecycle
//
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"📱 viewDidLoad");
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupContainerView];
    [self setupAuroraEffect];
    [self setupContentContainer];
    [self setupSwipeGesture];
    
    if (self.contentXibName) {
        [self loadContentFromXib];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSLog(@"📊 Container subviews:");
            for (int i = 0; i < self.containerView.subviews.count; i++) {
                UIView *subview = self.containerView.subviews[i];
                NSLog(@"   [%d] %@ (alpha: %.2f)", i, subview.class, subview.alpha);
            }
        });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"📱 viewDidAppear");
    NSLog(@"   Container hierarchy:");
    NSLog(@"   - containerView: %@", self.containerView);
    NSLog(@"   - auroraContainer: %@", self.auroraContainer);
    NSLog(@"   - contentContainerView: %@", self.contentContainerView);
    NSLog(@"   - contentContainerView.subviews: %@", self.contentContainerView.subviews);
    
    [self animatePresentation];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"📐 viewDidLayoutSubviews");
    NSLog(@"   containerView.bounds: %@", NSStringFromCGRect(self.containerView.bounds));
    NSLog(@"   auroraContainer.frame before: %@", NSStringFromCGRect(self.auroraContainer.frame));
    
    [self layoutAuroraEffect];
    
    NSLog(@"   auroraContainer.frame after: %@", NSStringFromCGRect(self.auroraContainer.frame));
    NSLog(@"   auroraLayer1.frame: %@", NSStringFromCGRect(self.auroraLayer1.frame));
    NSLog(@"   auroraLayer2.frame: %@", NSStringFromCGRect(self.auroraLayer2.frame));
    NSLog(@"   auroraLayer3.frame: %@", NSStringFromCGRect(self.auroraLayer3.frame));
}
#pragma mark - Setup
- (void)setupContainerView {
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   screenWidth,
                                                                   screenHeight)];
    
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
    
    self.containerView.transform = CGAffineTransformMakeTranslation(0, screenHeight);
    // ⭐ alpha를 1로 시작 (Aurora가 올라오면서 보이도록)
    self.containerView.alpha = 1.0;  // 0에서 1로 변경!
    
    NSLog(@"🏗️ Container created with transform.y=%f", screenHeight);
    
    [self.view addSubview:self.containerView];
}


- (void)setupAuroraEffect {
    self.auroraContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.auroraContainer.clipsToBounds = YES;
    self.auroraContainer.alpha = 0;
    self.auroraContainer.userInteractionEnabled = NO;
    [self.containerView insertSubview:self.auroraContainer atIndex:0];
    
    // Layer 1
    self.auroraLayer1 = [CAGradientLayer layer];
    self.auroraLayer1.colors = @[
        (id)[UIColor colorWithRed:0.6 green:0.7 blue:0.95 alpha:0.7].CGColor,
        (id)[UIColor colorWithRed:0.7 green:0.8 blue:0.98 alpha:0.5].CGColor,
        (id)[UIColor colorWithRed:0.8 green:0.85 blue:0.98 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor
    ];
    self.auroraLayer1.startPoint = CGPointMake(0, 0);
    self.auroraLayer1.endPoint = CGPointMake(1, 1);
    self.auroraLayer1.locations = @[@0.0, @0.3, @0.6, @1.0];
    [self.auroraContainer.layer addSublayer:self.auroraLayer1];
    
    // Layer 2
    self.auroraLayer2 = [CAGradientLayer layer];
    self.auroraLayer2.colors = @[
        (id)[UIColor colorWithRed:0.8 green:0.6 blue:0.9 alpha:0.6].CGColor,
        (id)[UIColor colorWithRed:0.85 green:0.7 blue:0.95 alpha:0.45].CGColor,
        (id)[UIColor colorWithRed:0.9 green:0.8 blue:0.98 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor
    ];
    self.auroraLayer2.startPoint = CGPointMake(1, 0);
    self.auroraLayer2.endPoint = CGPointMake(0, 1);
    self.auroraLayer2.locations = @[@0.0, @0.35, @0.65, @1.0];
    [self.auroraContainer.layer addSublayer:self.auroraLayer2];
    
    // Layer 3
    self.auroraLayer3 = [CAGradientLayer layer];
    self.auroraLayer3.colors = @[
        (id)[UIColor colorWithRed:0.5 green:0.85 blue:0.8 alpha:0.55].CGColor,
        (id)[UIColor colorWithRed:0.6 green:0.9 blue:0.85 alpha:0.4].CGColor,
        (id)[UIColor colorWithRed:0.7 green:0.92 blue:0.88 alpha:0.25].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor
    ];
    self.auroraLayer3.startPoint = CGPointMake(0.5, 0);
    self.auroraLayer3.endPoint = CGPointMake(0.5, 1);
    self.auroraLayer3.locations = @[@0.0, @0.4, @0.7, @1.0];
    [self.auroraContainer.layer addSublayer:self.auroraLayer3];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.auroraContainer addSubview:self.blurView];
    
}
- (void)setupContentContainer {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    // Handle bar
    UIView *handle = [[UIView alloc] initWithFrame:CGRectMake((width - 36) / 2, 10, 36, 4)];
    handle.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    handle.layer.cornerRadius = 2;
    [self.containerView addSubview:handle];
    
    self.contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          24,
                                                                          width,
                                                                          height - 24)];
    // ⭐ 투명 배경 (Aurora가 보이도록)
    self.contentContainerView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.contentContainerView];
    
    // ⭐ 정중앙에 "AI가 분석하고 있어요" 라벨만!
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                      (height - 24 - 80) / 2,
                                                                      width - 40,
                                                                      80)];
    centerLabel.text = @"AI가 분석하고 있어요";
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightMedium];
    centerLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    centerLabel.numberOfLines = 0;
    centerLabel.alpha = 0.0;  // 처음엔 숨김
    [self.contentContainerView addSubview:centerLabel];
    
    NSLog(@"📦 ContentContainer created with center label");
}
- (void)loadContentFromXib {
    NSLog(@"🔍 Loading XIB: '%@'", self.contentXibName);
    
    @try {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:self.contentXibName
                                                        owner:self
                                                      options:nil];
        
        NSLog(@"   📦 Loaded views count: %lu", (unsigned long)views.count);
        
        if (views.count > 0) {
            UIView *contentView = views.firstObject;
            
            NSLog(@"   ✅ XIB loaded successfully");
            NSLog(@"   📏 View frame: %@", NSStringFromCGRect(contentView.frame));
            NSLog(@"   🎨 View background: %@", contentView.backgroundColor);
            
            contentView.frame = self.contentContainerView.bounds;
            contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            // ⭐⭐ 핵심: 처음엔 숨김 (showXibContent에서 fade in)
            contentView.alpha = 0.0;  // 다시 0으로!
            
            [self.contentContainerView addSubview:contentView];
            
            NSLog(@"   ✅ XIB added to container (hidden, will fade in later)");
        } else {
            NSLog(@"   ❌ No views in XIB");
        }
    } @catch (NSException *exception) {
        NSLog(@"   ❌ Exception loading XIB: %@", exception);
    }
}


- (void)setupSwipeGesture {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePanGesture:)];
    [self.containerView addGestureRecognizer:self.panGesture];
}
- (void)layoutAuroraEffect {
    CGFloat width = CGRectGetWidth(self.containerView.bounds);
    CGFloat height = CGRectGetHeight(self.containerView.bounds);
    
    // ⭐ 전체 영역으로 확장
    self.auroraContainer.frame = self.containerView.bounds;  // 전체!
    
    // Layer도 전체 영역에 맞춰서 더 크게
    CGFloat layerWidth = width * 1.5;
    CGFloat layerHeight = height * 1.3;
    
    self.auroraLayer1.frame = CGRectMake(-width * 0.25, -height * 0.15, layerWidth, layerHeight);
    self.auroraLayer2.frame = CGRectMake(-width * 0.25, -height * 0.15, layerWidth, layerHeight);
    self.auroraLayer3.frame = CGRectMake(-width * 0.25, -height * 0.15, layerWidth, layerHeight);
    
    self.blurView.frame = self.auroraContainer.bounds;
}

#pragma mark - Pan Gesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];
    
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            // 현재 transform의 translation 값 저장
            self.initialTranslationY = self.containerView.transform.ty;
            break;
            
        case UIGestureRecognizerStateChanged: {
            // 아래로만 드래그 가능
            CGFloat newY = self.initialTranslationY + translation.y;
            if (newY < 0) {
                newY = 0;
            }
            
            // ⭐ Transform 사용
            self.containerView.transform = CGAffineTransformMakeTranslation(0, newY);
            
            CGFloat progress = newY / screenHeight;
            self.containerView.alpha = 1.0 - (progress * 0.5);
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            BOOL shouldDismiss = velocity.y > 1000 ||
                                 (self.containerView.transform.ty > screenHeight * 0.3);
            
            if (shouldDismiss) {
                [self dismissAnimated];
            } else {
                // 원래 위치로 복귀
                [UIView animateWithDuration:0.3
                                      delay:0
                     usingSpringWithDamping:0.8
                      initialSpringVelocity:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                    self.containerView.transform = CGAffineTransformIdentity;
                    self.containerView.alpha = 1.0;
                } completion:nil];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Animations



- (void)animatePresentation {
    NSLog(@"🎬 === ANIMATION TIMELINE START ===");
    
    // ⭐ Aurora를 초기에 보이게 설정
    self.auroraContainer.alpha = 1.0;
    
    // 1. Container slide up + fade in (더 천천히!)
    [UIView animateWithDuration:1.2  // ⭐ 0.7초에서 1.2초로 증가
                          delay:0
         usingSpringWithDamping:0.85
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.containerView.alpha = 1.0;
        
        NSLog(@"   🎬 Container sliding up slowly...");
    } completion:^(BOOL finished) {
        NSLog(@"   ✅ Container animation complete");
        
        // ⭐ 슬라이드 완료 후 0.6초 뒤 라벨 표시 (더 빨리!)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showXibContent];
        });
    }];
    
    // 2. Flowing animation 시작
    NSLog(@"   💫 Starting flowing animation immediately...");
    [self startFlowingAnimation];
}

- (void)showXibContent {
    NSLog(@"   🎨 showXibContent called");
    
    for (UIView *subview in self.contentContainerView.subviews) {
        if (subview.alpha < 1.0) {
            NSLog(@"   🎨 Fading in label...");
            
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                subview.alpha = 1.0;
            } completion:^(BOOL finished) {
                NSLog(@"   ✅ Label visible on Aurora background");
            }];
        }
    }
}


- (void)startFlowingAnimation {
    NSLog(@"   💫 startFlowingAnimation called");
    NSLog(@"      Layer1: %@", self.auroraLayer1);
    NSLog(@"      Layer2: %@", self.auroraLayer2);
    NSLog(@"      Layer3: %@", self.auroraLayer3);
    
    CGFloat width = CGRectGetWidth(self.containerView.bounds);
    
    // ⭐ Layer1 animation
    CABasicAnimation *move1 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    move1.fromValue = @(-width * 0.2);
    move1.toValue = @(width * 0.2);
    move1.duration = 4.0;
    move1.repeatCount = 2;
    move1.autoreverses = YES;
    move1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.auroraLayer1 addAnimation:move1 forKey:@"flow1"];
    NSLog(@"      ✅ Layer1 animation added");
    
    // ⭐ Layer2 animation
    CABasicAnimation *move2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    move2.fromValue = @(width * 0.15);
    move2.toValue = @(-width * 0.15);
    move2.duration = 5.0;
    move2.repeatCount = 1.5;
    move2.autoreverses = YES;
    move2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.auroraLayer2 addAnimation:move2 forKey:@"flow2"];
    NSLog(@"      ✅ Layer2 animation added");
    
    // ⭐ Layer3 animation
    CABasicAnimation *move3X = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    move3X.fromValue = @(-width * 0.12);
    move3X.toValue = @(width * 0.12);
    move3X.duration = 4.5;
    move3X.repeatCount = 2;
    move3X.autoreverses = YES;
    move3X.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *move3Y = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    move3Y.fromValue = @(-15);
    move3Y.toValue = @(15);
    move3Y.duration = 3.5;
    move3Y.repeatCount = 2;
    move3Y.autoreverses = YES;
    move3Y.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.auroraLayer3 addAnimation:move3X forKey:@"flow3X"];
    [self.auroraLayer3 addAnimation:move3Y forKey:@"flow3Y"];
    NSLog(@"      ✅ Layer3 animations added");
    
    // Color shift
    [self animateColorShift];
}


- (void)animateColorShift {
    NSLog(@"   🎨 animateColorShift called");
    
    // ⭐ Layer1 color animation
    CABasicAnimation *colorAnim1 = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorAnim1.fromValue = @[
        (id)[UIColor colorWithRed:0.6 green:0.7 blue:0.95 alpha:0.7].CGColor,
        (id)[UIColor colorWithRed:0.7 green:0.8 blue:0.98 alpha:0.5].CGColor,
        (id)[UIColor colorWithRed:0.8 green:0.85 blue:0.98 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor
    ];
    colorAnim1.toValue = @[
        (id)[UIColor colorWithRed:0.75 green:0.65 blue:0.9 alpha:0.7].CGColor,
        (id)[UIColor colorWithRed:0.8 green:0.75 blue:0.95 alpha:0.5].CGColor,
        (id)[UIColor colorWithRed:0.85 green:0.8 blue:0.98 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor
    ];
    colorAnim1.duration = 3.5;
    colorAnim1.repeatCount = 2;
    colorAnim1.autoreverses = YES;
    colorAnim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.auroraLayer1 addAnimation:colorAnim1 forKey:@"colorShift1"];
    NSLog(@"      ✅ Layer1 color animation added");
    
    // ⭐ Layer2 color animation
    CABasicAnimation *colorAnim2 = [CABasicAnimation animationWithKeyPath:@"colors"];
    colorAnim2.fromValue = @[
        (id)[UIColor colorWithRed:0.8 green:0.6 blue:0.9 alpha:0.6].CGColor,
        (id)[UIColor colorWithRed:0.85 green:0.7 blue:0.95 alpha:0.45].CGColor,
        (id)[UIColor colorWithRed:0.9 green:0.8 blue:0.98 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor
    ];
    colorAnim2.toValue = @[
        (id)[UIColor colorWithRed:0.6 green:0.8 blue:0.85 alpha:0.6].CGColor,
        (id)[UIColor colorWithRed:0.7 green:0.85 blue:0.9 alpha:0.45].CGColor,
        (id)[UIColor colorWithRed:0.8 green:0.88 blue:0.93 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor
    ];
    colorAnim2.duration = 4.0;
    colorAnim2.repeatCount = 2;
    colorAnim2.autoreverses = YES;
    colorAnim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.auroraLayer2 addAnimation:colorAnim2 forKey:@"colorShift2"];
    NSLog(@"      ✅ Layer2 color animation added");
}



- (void)fadeOutAurora {
    NSLog(@"   🌅 fadeOutAurora called (current alpha: %f)", self.auroraContainer.alpha);
    
    [UIView animateWithDuration:2.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        NSLog(@"      🌅 Aurora fading out...");
        self.auroraContainer.alpha = 0;
    } completion:^(BOOL finished) {
        NSLog(@"   ✅ Aurora fade out complete (finished: %d)", finished);
        [self.auroraLayer1 removeAllAnimations];
        [self.auroraLayer2 removeAllAnimations];
        [self.auroraLayer3 removeAllAnimations];
        [self.auroraContainer removeFromSuperview];
        NSLog(@"   🗑️ Aurora container removed");
        
        // ⭐⭐⭐ 핵심: Aurora가 사라진 후 XIB 표시!
        NSLog(@"   🎨 Now showing XIB content...");
        [self showXibContent];
    }];
}

- (void)dismissAnimated {
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    [self.auroraLayer1 removeAllAnimations];
    [self.auroraLayer2 removeAllAnimations];
    [self.auroraLayer3 removeAllAnimations];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        // ⭐ Transform 사용
        self.containerView.transform = CGAffineTransformMakeTranslation(0, screenHeight);
        self.containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Public

- (void)presentFromViewController:(UIViewController *)viewController {
    NSLog(@"🚀 presentFromViewController called");
    
    [viewController presentViewController:self animated:NO completion:nil];
}

@end
