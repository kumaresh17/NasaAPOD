//
//  HomePayLoad.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 20/01/2022.
//

import Foundation

protocol HTTPPayloadProtocol {
    var type: HTTPPayloadType? { get }
    var headers: Dictionary<String, String>? { get set }
    var url: URL? {get}
}

protocol PayLoadFormat {
    func formatGetPayload(url: HTTPSUrl, module: APIModuleProtocol) -> HTTPPayloadProtocol
}

extension PayLoadFormat {
    
    func formatGetPayload(url: HTTPSUrl, module: APIModuleProtocol) -> HTTPPayloadProtocol {
        var payload = HomePayLoad(url: url,payload: module)
        payload.headers = Dictionary<String, String>()
        payload.addHeader(name: HTTPHeaderType.contentType.rawValue, value: HTTPMimeType.applicationJSON.rawValue)
        return payload
    }
}

struct HomePayLoad: HTTPPayloadProtocol {
    
    var type: HTTPPayloadType?
    var headers: Dictionary<String, String>?
    var url: URL?
    fileprivate init(url: HTTPSUrl, payload: APIModuleProtocol) {
        self.type = payload.payloadType
        var components = URLComponents()
        components.scheme = "https"
        components.host = url.rawValue
        components.path = "/planetary/apod"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "DEMO_KEY"),
            URLQueryItem(name: "start_date", value: payload.dateToSearch),
            URLQueryItem(name: "end_date", value: payload.dateToSearch)
        ]
        
        self.url = components.url
    }
    fileprivate mutating func addHeader(name: String, value: String) {
        headers?[name] = value
    }
}

enum HTTPMimeType: String {
    case applicationJSON = "application/json; charset=utf-8"
}

enum HTTPHeaderType: String{
    case contentType = "Content-Type"
}

struct APIModule:APIModuleProtocol {
    var payloadType: HTTPPayloadType?
    var dateToSearch:String?
}

protocol APIModuleProtocol {
    var payloadType: HTTPPayloadType? {get set}
    var dateToSearch:String? {get set}
}
/**
 More HTTPS method can be added here
 */
enum HTTPMethod: String {
    case get
}

enum HTTPPayloadType {
    case requestMethodGET
    
    func httpMethod() -> String {
        switch self{
        case .requestMethodGET: return HTTPMethod.get.rawValue
        }
    }
}

enum HTTPSUrl: String {
    case AODURL = "api.nasa.gov"
}

