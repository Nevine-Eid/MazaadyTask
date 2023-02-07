//
//  ErrorManager.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//

import Foundation

// MARK: - Error
enum TKError: Int, Error {
    case unAuthorized = 401
    case badRequest = 400
    case forbidden = 403
    case notFound = 404
    case apiError = 500
    case notHandleStatusCode = 0
}

extension TKError {
    func getErrorMessage() -> String? {
        switch self {
        case .unAuthorized:
            return "Unauthorized"
        case .notFound:
           return "unknownError"
        case .badRequest:
            return "badRequst"
        case .apiError:
            return "unknownError"
        case .notHandleStatusCode:
            return "unknownError"
        case .forbidden:
            return "unknownError"
        }
    }
}
