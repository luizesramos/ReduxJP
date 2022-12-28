//
//  Log.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/28/22.
//

import Foundation

/// Namespace for custom loggers
enum Log {
    static var verbosityLevel: LoggerVerbosity = .debug
}

struct Logger {
    let context: String
    
    /// Most verbose. contains activity names, types, variable values, arguments
    func d(_ message: String) {
        log(message, for: .debug)
    }
    /// Typically used to notify state transitions without details or sensitive information
    func i(_ message: String) {
        log(message, for: .info)
    }
    /// Used to notify unexpected scenarios that may disturb execution but don't prevent the app from making progress
    func w(_ message: String) {
        log(message, for: .warning)
    }
    /// Execution encounters an error and stops progress on the task at hand
    func e(_ message: String) {
        log(message, for: .error)
    }
    
    private func log(_ message: String, for verbosityLevel: LoggerVerbosity) {
        guard Log.verbosityLevel <= verbosityLevel else { return }
        debugPrint("\(context)/D: \(message)")
    }
}

enum LoggerVerbosity: Int, Comparable {
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    case silent = 5
    
    static func < (lhs: LoggerVerbosity, rhs: LoggerVerbosity) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
