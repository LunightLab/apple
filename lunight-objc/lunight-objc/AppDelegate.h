//
//  AppDelegate.h
//  lunight-objc
//
//  Created by lunight on 1/13/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CommonUtil.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

