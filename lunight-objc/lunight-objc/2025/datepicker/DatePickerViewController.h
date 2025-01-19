//
//  DatePickerViewController.h
//  lunight-objc
//
//  Created by lunight on 1/13/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatePickerViewController : UIViewController
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

NS_ASSUME_NONNULL_END
