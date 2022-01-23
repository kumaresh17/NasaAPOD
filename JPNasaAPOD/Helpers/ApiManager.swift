//
//  Networkmanager.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 20/01/2022.
//

import Foundation
import UIKit
import CoreData

protocol ApiServiceProtocol :AnyObject {
    var urlSession: URLSessionProtocol { get }
}

/// APIManager Protocol
protocol ApiManagerProtocol: AnyObject {
    
    func getAODInfo(payload: HTTPPayloadProtocol, managedObjectContext:NSManagedObjectContext?,completion: @escaping (Result<APODModelArray,Error>) -> Void)
    func decodeDataResponse(data:Data,managedObjectContext:NSManagedObjectContext?, completion: @escaping (Result<APODModelArray,Error>) -> Void) -> Void 
}

extension ApiManager: ApiManagerProtocol {
    /**
     Retrieve the APOD data
     */
    func getAODInfo(payload: HTTPPayloadProtocol, managedObjectContext:NSManagedObjectContext?,completion: @escaping (Result<APODModelArray,Error>) -> Void) {
        self.sendRequest(payLoad:payload,managedObjectContext:managedObjectContext,completion:completion)
    }
}

/// Network status
enum ReachabilityStatus {
    case unknown
    case disconnected
    case connected
}

class ApiManager: ApiServiceProtocol {
    
    /// URLSession used for query
    var urlSession: URLSessionProtocol
    
    var task: URLSessionDataTask?
    
    private let networkReachability: NetworkReachabilityManager?
    private(set) var reachabilityStatus: ReachabilityStatus

    init (urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
        self.networkReachability = NetworkReachabilityManager()
        self.reachabilityStatus = .unknown
        beginListeningNetworkReachability()
    }
    
    deinit {
        self.networkReachability?.stopListening()
    }
    
    /**
     Reachability
     - Start the reachability
     - To checek network status
     */
    private func beginListeningNetworkReachability() {
        networkReachability?.listener = { status in
            switch status {
            case .unknown: self.reachabilityStatus = .unknown
            case .notReachable:
                self.reachabilityStatus = .disconnected
                self.showErrorForNoNetwork()
            case .reachable(.ethernetOrWiFi), .reachable(.wwan): self.reachabilityStatus = .connected
            }
        }
        networkReachability?.startListening()
    }
    /**
     Show Alert message on no network connection
     */
    private func showErrorForNoNetwork()  {
        task?.suspend()
        DispatchQueue.main.async {
            AlertViewController.showAlert(withTitle: "Alert", message: "No Internet Connection")
        }

    }
    
    public convenience init() {
        self.init(urlSession: URLSession.shared)
    }
    
    private func sendRequest<T:Codable>(payLoad:HTTPPayloadProtocol,managedObjectContext:NSManagedObjectContext?, completion: @escaping (Result<T,Error>) -> Void) {
      
        if let requestUrl =  payLoad.url {
            var urlRequest = URLRequest(url: requestUrl)
            guard let headers = payLoad.headers else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidRequestHeader))
                }
                return
            }
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            urlRequest.httpMethod = payLoad.type?.httpMethod()
            
            task = urlSession.dataTask(with: urlRequest, completionHandler: {[weak self] (data, response, error) in
                
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.responseError))
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.noDataFound))
                    }
                    return
                }
                /// Just to check for validita for data
                // TODO: Improvement is needed to handle the invalid data response e.g empty array []
                guard data.count > 200 else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.noDataFound))
                    }
                    return
                }
                self?.decodeDataResponse(data: data, managedObjectContext: managedObjectContext, completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let responseData):
                            completion(.success(responseData as! T))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                })
            })
            task?.resume()
        }
    }
    
    /**
           Deocode the data response to core data model
     */
    
     func decodeDataResponse(data:Data,managedObjectContext:NSManagedObjectContext?, completion: @escaping (Result<APODModelArray,Error>) -> Void) -> Void {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            completion(.failure(NetworkError.coreDataError))
            return
        }
        guard let managedObjectContext = managedObjectContext else {
            completion(.failure(NetworkError.coreDataError))
            return}
        DispatchQueue.global(qos: .background).async {
            managedObjectContext.perform {
                CoreDataStack.shared.clearStorage(name: APODEntity.self,managedObjectContext: managedObjectContext)
                let result: Result<APODModelArray, Error>
                let decoder = JSONDecoder()
                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                do {
                    let response = try decoder.decode(APODModelArray.self, from: data)
                    result = .success(response)
                }
                catch let error {
                    result = .failure(error)
                }
                completion(result)
            }
        }
        
    }
    
}



