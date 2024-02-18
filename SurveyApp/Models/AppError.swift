//
//  AppError.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

public enum AppError: Error {
    case failedToDecode
    case networkFailure
    case wrongStatusCode
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToDecode:
            return "Filed to decode current response."
        case .networkFailure:
            return "Error occured in network layer"
        case .wrongStatusCode:
            return "Status code is out of bounds 200 to 300"
        }
    }
}
