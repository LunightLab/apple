//================================================================
//
//  📱 AppLogger - Better logging for iOS
//  Created by Hardy - 2025
//
//  📌 체크사항
//  Swift 인터페이스 헤더 관련 설정
//  - "Build Settings" > "Swift Compiler - General" > "Objective-C Generated Interface Header Name"
//  모듈 정의 확인
//  - "Build Settings" > "Packaging" > "Defines Module" (YES로 설정되어 있어야 함)
//  Swift 컴파일러 인터페이스
//  - "Build Settings" > "Swift Compiler - Interface Builder" > "Objective-C Compatible"
//
//================================================================

#import <Foundation/Foundation.h>

// TODO: From Project_Prefix.pch에 추가
// NSLog 재정의
#ifdef _DEBUG
// NSLog 원본 저장 (이름 충돌 방지)
#define OriginalNSLog NSLog
#undef NSLog
// NSLog를 ObjCLogger로 재정의 - os_log 사용
#define NSLog(fmt, ...) [ObjCLogger logInfoWithLocation:[NSString stringWithFormat:fmt, ##__VA_ARGS__] file:__FILE__ line:__LINE__ function:__PRETTY_FUNCTION__]
#else
#define NSLog(...)
#endif

// 디버그 로그용 TRACE - @를 자동으로 추가 - os_log 사용
#if _DEBUG
#define TRACE(fmt, ...) [ObjCLogger logDebugWithLocation:[NSString stringWithFormat:fmt, ##__VA_ARGS__] file:__FILE__ line:__LINE__ function:__PRETTY_FUNCTION__]
#else
#define TRACE(fmt, ...)
#endif


NS_ASSUME_NONNULL_BEGIN

@interface ObjCLogger : NSObject

// 기본 로깅 메서드
+ (void)logInfo:(NSString *)message;
+ (void)logError:(NSString *)message;
+ (void)logPrivate:(NSString *)message;

// 카테고리 지정 로깅 메서드
+ (void)logInfo:(NSString *)message category:(NSString *)category;
+ (void)logError:(NSString *)message category:(NSString *)category;
+ (void)logPrivate:(NSString *)message category:(NSString *)category;

// 위치 정보 포함 메서드 (매크로에서 사용)
+ (void)logInfoWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function;
+ (void)logErrorWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function;
+ (void)logPrivateWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function;

// DEBUG 모드 전용 로깅
#if DEBUG
+ (void)logDebug:(NSString *)message;
+ (void)logDebug:(NSString *)message category:(NSString *)category;
+ (void)logDebugWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function;
#else
+ (void)logDebug:(NSString *)message;
+ (void)logDebug:(NSString *)message category:(NSString *)category;
+ (void)logDebugWithLocation:(NSString *)message file:(const char *)file line:(int)line function:(const char *)function;
#endif

@end

// 위치 정보를 자동으로 포함하는 로깅 매크로
#define LOG_INFO(msg) [ObjCLogger logInfoWithLocation:msg file:__FILE__ line:__LINE__ function:__FUNCTION__]
#define LOG_ERROR(msg) [ObjCLogger logErrorWithLocation:msg file:__FILE__ line:__LINE__ function:__FUNCTION__]
#define LOG_PRIVATE(msg) [ObjCLogger logPrivateWithLocation:msg file:__FILE__ line:__LINE__ function:__FUNCTION__]
#define LOG_DEBUG(msg) [ObjCLogger logDebugWithLocation:msg file:__FILE__ line:__LINE__ function:__FUNCTION__]

NS_ASSUME_NONNULL_END
