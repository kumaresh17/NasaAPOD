//
//  URLSessionProtocol.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 20/01/2022.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol: AnyObject {
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
    
}

extension URLSession: URLSessionProtocol { }

