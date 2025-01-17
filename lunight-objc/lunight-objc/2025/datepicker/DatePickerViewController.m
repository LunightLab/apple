//
//  DatePickerViewController.m
//  lunight-objc
//
//  Created by lunight on 1/13/25.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *yearPicker;
@property (strong, nonatomic) NSArray<NSNumber *> *years;

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 세그먼티드 컨트롤 생성
    NSArray *items = @[@"Date", @"Time", @"Date & Time", @"Year"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.selectedSegmentIndex = 0; // 기본 선택: Date
    self.segmentedControl.frame = CGRectMake(20, 150, self.view.frame.size.width - 40, 30);
    [self.segmentedControl addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    // DatePicker 생성
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    self.datePicker.datePickerMode = UIDatePickerModeDate; // 기본 모드
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"ko_KR"];
    self.datePicker.tintColor = [UIColor blueColor];
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    if (@available(iOS 13.4, *)) {
        if (@available(iOS 14.0, *)) {
            self.datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
        } else {
            
            self.datePicker.preferredDatePickerStyle = UIDatePickerStyleAutomatic; 
        }
    }
    [self.view addSubview:self.datePicker];
    
    // 연도 데이터 생성
    NSMutableArray *yearsArray = [NSMutableArray array];
    NSInteger currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selectedRow = 0; // 기본 선택 행
    for (NSInteger year = 1900; year <= 2100; year++) {
        [yearsArray addObject:@(year)];
        if (year == currentYear) {
            selectedRow = [yearsArray indexOfObject:@(year)]; // 현재 연도의 인덱스를 저장
        }
    }
    self.years = [yearsArray copy];
    
    // 연도 선택을 위한 UIPickerView 생성
    self.yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
    
    // 현재 연도로 기본 선택 설정
    [self.yearPicker selectRow:selectedRow inComponent:0 animated:NO];

    self.yearPicker.hidden = YES; // 기본적으로 숨김
    
    [self.view addSubview:self.yearPicker];
}

#pragma mark - Actions

// 세그먼티드 컨트롤의 선택이 변경될 때 호출
- (void)modeChanged:(UISegmentedControl *)sender {
    // Date & Time 모드일 경우 하단에 잘리는 현상 수정
    if (@available(iOS 14.0, *)) {
        if (self.datePicker.preferredDatePickerStyle == UIDatePickerStyleInline) {
            CGFloat adjustedHeight = [self.datePicker systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            CGRect frame = self.datePicker.frame;
            frame.size.height = adjustedHeight;
            self.datePicker.frame = frame;
        }
    }
    switch (sender.selectedSegmentIndex) {
        case 0: // Date
            self.datePicker.hidden = NO;
            self.yearPicker.hidden = YES;
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        case 1: // Time
            self.datePicker.hidden = NO;
            self.yearPicker.hidden = YES;
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
            break;
        case 2: // Date & Time
            self.datePicker.hidden = NO;
            self.yearPicker.hidden = YES;
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        case 3: // Year
            self.datePicker.hidden = YES;
            self.yearPicker.hidden = NO;
            break;
        default:
            break;
    }
}

// DatePicker 값이 변경될 때 호출
- (void)datePickerValueChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
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

#pragma mark - UIPickerView DataSource and Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1; // 연도만 표시
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.years.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", self.years[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSNumber *selectedYear = self.years[row];
    NSLog(@"선택된 연도: %@", selectedYear);
}

@end
