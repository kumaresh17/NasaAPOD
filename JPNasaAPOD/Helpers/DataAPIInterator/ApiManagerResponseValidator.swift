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
                completion(NetworkError.responseError)
            return}
        guard let data = data else {
                completion(NetworkError.noDataFound)
            return}
        if data.isInValid()  {
                completion(NetworkError.noDataFound)
            return }
        
        completion(nil)
    }
}
