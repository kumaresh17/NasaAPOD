//
//  ApiManager+PrepareRequest.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 03/03/2022.
//

import Foundation


extension ApiManager {
/**
   -  Check and Prepare the request URL with the payload data
 */
 func prepareRequest(withPayload payload:HTTPPayloadProtocol?) -> (URLRequest?,NetworkError?) {
     
    var urlRequest:URLRequest?
     guard let payload = payload else {
         return (nil,(NetworkError.invalidPayload))
     }

    if let requestUrl =  payload.url {
        urlRequest = URLRequest(url: requestUrl)
        guard let headers = payload.headers else {
            return (nil,(NetworkError.invalidRequestHeader))}
        
        guard var urlRequest = urlRequest else {
            return (nil,(NetworkError.invalidRequest))}
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpMethod = payload.type?.httpMethod()
        return (urlRequest,nil)
    } else {
        return (nil,(NetworkError.invalidURL))
    }
}
}
