//
//  NetworkError.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 21/01/2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case responseError
    case noDataFound
    case unknown
    case invalidRequestHeader
    case coreDataError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .noDataFound:
            return NSLocalizedString("APOD for the selected date is not found", comment: "noDataFound error")
        case .invalidRequestHeader:
            return NSLocalizedString("InvalidRequestHeader", comment: "InvalidRequestHeader")
        case .coreDataError:
            return NSLocalizedString("Local data base error", comment: "coreDataError ")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}

