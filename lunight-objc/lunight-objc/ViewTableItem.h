//
//  ViewTableItem.h
//  lunight-objc
//
//  Created by lunight on 1/13/25.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TaskStatus) {
    TaskStatusPending,
    TaskStatusInProgress,
    TaskStatusCompleted,
    TaskStatusDelete,
};

@interface ViewTableItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *viewControllerName;
@property (nonatomic, assign) TaskStatus taskStatus; // 변경된 속성 이름
@end

NS_ASSUME_NONNULL_END
