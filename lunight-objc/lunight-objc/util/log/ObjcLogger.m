#import "ObjCLogger.h"
#import <os/log.h>

@implementation ObjCLogger

// 날짜 포맷터
+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    });
    return formatter;
}

// 서브시스템 얻기
+ (NSString *)subsystem {
    return [[NSBundle mainBundle] bundleIdentifier] ?: @"com.default";
}

// 로그 객체 얻기
+ (os_log_t)logForCategory:(NSString *)category {
    if ([category isEqualToString:@"network"]) {
        static os_log_t networkLog = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            networkLog = os_log_create([[self subsystem] UTF8String], "network");
        });
        return networkLog;
    }
    else if ([category isEqualToString:@"ui"]) {
        static os_log_t uiLog = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            uiLog = os_log_create([[self subsystem] UTF8String], "ui");
        });
        return uiLog;
    }
    else {
        static os_log_t generalLog = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            generalLog = os_log_create([[self subsystem] UTF8String], "general");
        });
        return generalLog;
    }
}

#pragma mark - 기본 로깅 메서드

+ (void)logInfo:(NSString *)message {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] %@", timestamp, message];
    
    os_log_info([self logForCategory:@"general"], "%{public}s", [formattedMessage UTF8String]);
}

+ (void)logError:(NSString *)message {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] %@", timestamp, message];
    
    os_log_error([self logForCategory:@"general"], "%{public}s", [formattedMessage UTF8String]);
}

+ (void)logPrivate:(NSString *)message {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *contextInfo = [NSString stringWithFormat:@"[%@]", timestamp];
    
    os_log_info([self logForCategory:@"general"], "%{public}s %{private}s", [contextInfo UTF8String], [message UTF8String]);
}

#pragma mark - 카테고리 지정 로깅 메서드

+ (void)logInfo:(NSString *)message category:(NSString *)category {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] %@", timestamp, message];
    
    os_log_info([self logForCategory:category], "%{public}s", [formattedMessage UTF8String]);
}

+ (void)logError:(NSString *)message category:(NSString *)category {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] %@", timestamp, message];
    
    os_log_error([self logForCategory:category], "%{public}s", [formattedMessage UTF8String]);
}

+ (void)logPrivate:(NSString *)message category:(NSString *)category {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *contextInfo = [NSString stringWithFormat:@"[%@]", timestamp];
    
    os_log_info([self logForCategory:category], "%{public}s %{private}s", [contextInfo UTF8String], [message UTF8String]);
}

#pragma mark - 위치 정보 포함 메서드

+ (void)logInfoWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *fileName = [[[NSString stringWithUTF8String:file] lastPathComponent] stringByDeletingPathExtension];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] [%@:%d %s] %@",
                                  timestamp, fileName, line, function, message];
    
    os_log_info([self logForCategory:@"general"], "%{public}s", [formattedMessage UTF8String]);
}

+ (void)logErrorWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *fileName = [[[NSString stringWithUTF8String:file] lastPathComponent] stringByDeletingPathExtension];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] [%@:%d %s] %@",
                                  timestamp, fileName, line, function, message];
    
    os_log_error([self logForCategory:@"general"], "%{public}s", [formattedMessage UTF8String]);
}

+ (void)logPrivateWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *fileName = [[[NSString stringWithUTF8String:file] lastPathComponent] stringByDeletingPathExtension];
    NSString *contextInfo = [NSString stringWithFormat:@"[%@] [%@:%d %s]",
                             timestamp, fileName, line, function];
    
    os_log_info([self logForCategory:@"general"], "%{public}s %{private}s",
                [contextInfo UTF8String], [message UTF8String]);
}

#pragma mark - DEBUG 모드 전용 로깅

#if DEBUG
+ (void)logDebug:(NSString *)message {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] %@", timestamp, message];
    
    os_log_debug([self logForCategory:@"general"], "%{public}s", [formattedMessage UTF8String]);
}

+ (void)logDebug:(NSString *)message category:(NSString *)category {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] %@", timestamp, message];
    
    os_log_debug([self logForCategory:category], "%{public}s", [formattedMessage UTF8String]);
}

+ (void)logDebugWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function {
    NSString *timestamp = [[self dateFormatter] stringFromDate:[NSDate date]];
    NSString *fileName = [[[NSString stringWithUTF8String:file] lastPathComponent] stringByDeletingPathExtension];
    NSString *formattedMessage = [NSString stringWithFormat:@"[%@] [%@:%d %s] %@",
                                  timestamp, fileName, line, function, message];
    
    os_log_debug([self logForCategory:@"general"], "%{public}s", [formattedMessage UTF8String]);
}
#else
+ (void)logDebug:(NSString *)message {}
+ (void)logDebug:(NSString *)message category:(NSString *)category {}
+ (void)logDebugWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function {}
#endif

@end
