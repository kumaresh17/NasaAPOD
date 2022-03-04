//
//  HandledError.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 21/01/2022.
//

import Foundation

enum HandledError: Error {
    case invalidURL
    case responseError
    case noDataFound
    case inValidData
    case unknown
    case invalidRequestHeader
    case invalidRequest
    case invalidPayload
    case emptyData_SucessResponseCode
    case coreDataError
    case inValidApodDate
}


extension HandledError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .invalidPayload:
            return NSLocalizedString("Invalid Payload", comment: "Invalid Payload")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .noDataFound:
            return NSLocalizedString("APOD for the selected date is not found", comment: "noDataFound error")
        case .invalidRequestHeader:
            return NSLocalizedString("InvalidRequestHeader", comment: "InvalidRequestHeader")
        case .invalidRequest:
            return NSLocalizedString("InvalidRequest", comment: "InvalidRequest")
        case .emptyData_SucessResponseCode:
            return NSLocalizedString("EmptyData with valid Success response", comment: "EmptyData")
        case .coreDataError:
            return NSLocalizedString("Local data base error", comment: "coreDataError ")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        case .inValidData:
            return NSLocalizedString("No data found", comment: "inValidData error")
        case .inValidApodDate:
            return NSLocalizedString("Date is missing to get APOD", comment: "inValidApodDate")
            
        }
    }
}

