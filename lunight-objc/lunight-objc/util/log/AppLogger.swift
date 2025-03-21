// ================================================================
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
// ================================================================

import Foundation
import os.log

public class AppLogger: NSObject {
    // 서브시스템 정의
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.default"
    
    // 카테고리별 로거/로그 저장
    @available(iOS 14.0, *)
    private static let generalLogger = Logger(subsystem: subsystem, category: "general")
    
    @available(iOS 14.0, *)
    private static let networkLogger = Logger(subsystem: subsystem, category: "network")
    
    @available(iOS 14.0, *)
    private static let uiLogger = Logger(subsystem: subsystem, category: "ui")
    
    // iOS 12-13용 os_log 객체
    private static let generalLog = OSLog(subsystem: subsystem, category: "general")
    private static let networkLog = OSLog(subsystem: subsystem, category: "network")
    private static let uiLog = OSLog(subsystem: subsystem, category: "ui")
    
    // 날짜 포맷터
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    // 파일 경로에서 파일명만 추출하는 헬퍼 함수
    private static func fileNameFromPath(_ path: String) -> String {
        return URL(fileURLWithPath: path).lastPathComponent
    }
    
    // MARK: - Swift 로깅 메서드
    
    // 일반 로깅 - iOS 버전에 따라 분기
    public class func info(_ message: String, category: String = "general", file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = fileNameFromPath(file)
        let formattedMessage = "[\(timestamp)] [\(fileName):\(line) \(function)] \(message)"
        
        if #available(iOS 14.0, *) {
            let logger = getLoggerForCategory(category)
            logger.info("\(formattedMessage)")
        } else {
            let log = getOSLogForCategory(category)
            os_log(.info, log: log, "%{public}s", formattedMessage)
        }
    }
    
    public class func error(_ message: String, category: String = "general", file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = fileNameFromPath(file)
        let formattedMessage = "[\(timestamp)] [\(fileName):\(line) \(function)] \(message)"
        
        if #available(iOS 14.0, *) {
            let logger = getLoggerForCategory(category)
            logger.error("\(formattedMessage)")
        } else {
            let log = getOSLogForCategory(category)
            os_log(.error, log: log, "%{public}s", formattedMessage)
        }
    }
    
    public class func notice(_ message: String, category: String = "general", file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = fileNameFromPath(file)
        let formattedMessage = "[\(timestamp)] [\(fileName):\(line) \(function)] \(message)"
        
        if #available(iOS 14.0, *) {
            let logger = getLoggerForCategory(category)
            logger.notice("\(formattedMessage)")
        } else {
            let log = getOSLogForCategory(category)
            os_log(.default, log: log, "%{public}s", formattedMessage)
        }
    }
    
    // 개인정보 보호 로깅
    public class func privateInfo(_ message: String, category: String = "general", file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = fileNameFromPath(file)
        let contextInfo = "[\(timestamp)] [\(fileName):\(line) \(function)]"
        
        if #available(iOS 14.0, *) {
            let logger = getLoggerForCategory(category)
            logger.info("\(contextInfo) \(message, privacy: .private)")
        } else {
            let log = getOSLogForCategory(category)
            os_log(.info, log: log, "%{public}s %{private}s", contextInfo, message)
        }
    }
    
    public class func sensitiveInfo(_ message: String, category: String = "general", file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = fileNameFromPath(file)
        let contextInfo = "[\(timestamp)] [\(fileName):\(line) \(function)]"
        
        if #available(iOS 14.0, *) {
            let logger = getLoggerForCategory(category)
            logger.info("\(contextInfo) \(message, privacy: .sensitive)")
        } else {
            let log = getOSLogForCategory(category)
            os_log(.info, log: log, "%{public}s %{sensitive}s", contextInfo, message)
        }
    }
    
    // MARK: - DEBUG 전용 로깅
    
    #if DEBUG
    public class func debug(_ message: String, category: String = "general", file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = dateFormatter.string(from: Date())
        let fileName = fileNameFromPath(file)
        let formattedMessage = "[\(timestamp)] [\(fileName):\(line) \(function)] \(message)"
        
        if #available(iOS 14.0, *) {
            let logger = getLoggerForCategory(category)
            logger.debug("\(formattedMessage)")
        } else {
            let log = getOSLogForCategory(category)
            os_log(.debug, log: log, "%{public}s", formattedMessage)
        }
    }
    #else
    public class func debug(_ message: String, category: String = "general", file: String = #file, function: String = #function, line: Int = #line) {}
    #endif
    
    // MARK: - 헬퍼 메서드
    
    @available(iOS 14.0, *)
    private class func getLoggerForCategory(_ category: String) -> Logger {
        switch category {
        case "network": return networkLogger
        case "ui": return uiLogger
        default: return generalLogger
        }
    }
    
    private class func getOSLogForCategory(_ category: String) -> OSLog {
        switch category {
        case "network": return networkLog
        case "ui": return uiLog
        default: return generalLog
        }
    }
}
