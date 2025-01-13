//
//  DatePickerViewController.m
//  lunight-objc
//
//  Created by lunight on 1/13/25.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 세그먼티드 컨트롤 생성
    NSArray *items = @[@"Date", @"Time", @"Date & Time"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.selectedSegmentIndex = 0; // 기본 선택: Date
    self.segmentedControl.frame = CGRectMake(20, 150, self.view.frame.size.width - 40, 30);
    [self.segmentedControl addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    // DatePicker 생성
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    self.datePicker.datePickerMode = UIDatePickerModeDate; // 기본 모드
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    // 한국어 로케일 설정
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"ko_KR"];
    self.datePicker.tintColor = [UIColor blueColor];
    
    // 강제로 라이트모드 UI로 보이도록 설정
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    
//    if (@available(iOS 13.0, *)) {
//        UIUserInterfaceStyle style = self.traitCollection.userInterfaceStyle;
//        if (style == UIUserInterfaceStyleDark) {
//            NSLog(@"다크 모드 사용 중");
//        } else if (style == UIUserInterfaceStyleLight) {
//            NSLog(@"라이트 모드 사용 중");
//        } else {
//            NSLog(@"알 수 없는 모드");
//        }
//    }
    
    [self.view addSubview:self.datePicker];
}

#pragma mark - Actions

// 세그먼티드 컨트롤의 선택이 변경될 때 호출
- (void)modeChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0: // Date
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        case 1: // Time
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            break;
        case 2: // Date & Time
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        default:
            break;
    }
}

// DatePicker 값이 변경될 때 호출
- (void)datePickerValueChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 모드에 따라 포맷 변경
    if (self.datePicker.datePickerMode == UIDatePickerModeDate) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    } else if (self.datePicker.datePickerMode == UIDatePickerModeTime) {
        [formatter setDateFormat:@"HH:mm"];
    } else if (self.datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    NSString *formattedDate = [formatter stringFromDate:sender.date];
    NSLog(@"Selected Date: %@", formattedDate);
}

@end
