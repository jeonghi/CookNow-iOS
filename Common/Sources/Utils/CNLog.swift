//
//  CNLog.swift
//  Common
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation

/// - verbose: Log type verbose
/// - info: Log type info
/// - debug: Log type debug
/// - warning: Log type warning
/// - error: Log type error
public enum LogEvent: String {
  case v = "[🔬]" // verbose
  case d = "[💬]" // debug
  case i = "[ℹ️]" // info
  case w = "[⚠️]" // warning
  case e = "[‼️]" // error
}

/// 로그레벨입니다.
public enum LogLevel : Int {
  case v = 0
  case d = 1
  case i = 2
  case w = 3
  case e = 4
}

/// Log 클래스 입니다.
open class CNLog {
  public static let shared = CNLog()
  
  public let maxLogs = 10
  
  var _debugLogs : [(Date, String)]
  public var debugLogs : [(Date, String)] {
    get {
      return _debugLogs
    }
  }
  
  public let developLoglevel : LogLevel
  public let releaseLogLevel : LogLevel
  
  public init(developLogLevel : LogLevel = LogLevel.v, releaseLogLevel: LogLevel = LogLevel.i) {
    _debugLogs = [(Date, String)]()
    self.developLoglevel = developLogLevel
#if DEBUG
    self.releaseLogLevel = LogLevel.v
#else
    self.releaseLogLevel = releaseLogLevel
#endif
  }
  
  class var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
  }
  
  class var simpleDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd hh:mm:ssSSS"
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
  }
  
  public func clearLog() {
    _debugLogs.removeAll()
  }
  
  public class func sourceFileName(filePath: String) -> String {
    let components = filePath.components(separatedBy: "/")
    return components.isEmpty ? "" : components.last!
  }
  
  class func appPrint(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function, logEvent:LogEvent = LogEvent.e, printLogLevel: LogLevel = LogLevel.e) {
    
    let currentTime = Date()
    
    // Only allowing in DEBUG mode
#if DEBUG
    let debugLog = "\(currentTime.toString()) \(logEvent.rawValue)[\(CNLog.sourceFileName(filePath: filename)) \(line):\(column)] -> \(object)"
    if (printLogLevel.rawValue >= CNLog.shared.developLoglevel.rawValue) {
      Swift.print(debugLog)
    }

    if (printLogLevel.rawValue >= CNLog.shared.releaseLogLevel.rawValue) {
      if (CNLog.shared._debugLogs.count >= CNLog.shared.maxLogs) {
        CNLog.shared._debugLogs.removeFirst()
      }
      
      let simpleDebugLog = "\(currentTime.toSimpleString()) \(logEvent.rawValue) -> \(object)"
      CNLog.shared._debugLogs.append((currentTime, simpleDebugLog))
    }
#endif
  }
  
  public class func v( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    appPrint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.v, printLogLevel: LogLevel.v)
  }
  
  public class func d( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    appPrint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.d, printLogLevel: LogLevel.d)
  }
  
  public class func i( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    appPrint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.i, printLogLevel: LogLevel.i)
  }
  
  public class func w( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    appPrint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.w, printLogLevel: LogLevel.w)
  }
  
  public class func e( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    appPrint(object, filename: filename, line: line, column: column, funcName: funcName, logEvent: LogEvent.e, printLogLevel: LogLevel.e)
  }
}

extension Date {
  public func toString() -> String {
    return CNLog.dateFormatter.string(from: self as Date)
  }
  
  public func toSimpleString() -> String {
    return CNLog.simpleDateFormatter.string(from: self as Date)
  }
}
