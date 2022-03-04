//
//  ApiManager+ResponseValidator.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 03/03/2022.
//

import Foundation

extension ApiManager {
    
    func apiManagerResponseDataValidator(data:Data?,urlResponse:HTTPURLResponse?,completion:(Error?) -> Void ) -> Void {
        
        guard let httpResponse = urlResponse, 200...299 ~= httpResponse.statusCode else {
            completion(HandledError.responseError)
            return}
        guard let data = data else {
            completion(HandledError.noDataFound)
            return}
        if data.isInValid()  {
            completion(HandledError.inValidData)
            return }
        
        completion(nil)
    }
}
