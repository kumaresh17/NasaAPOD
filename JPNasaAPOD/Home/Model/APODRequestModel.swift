//
//  APODRequestModel.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 21/01/2022.
//

import Foundation

// MARK: - APOD request

protocol APODRequestProtocol{
    var startDate : String? {get set }
    var endDate: String? {get set}

}

struct APODRequest : APODRequestProtocol {
    var startDate, endDate: String?
}
