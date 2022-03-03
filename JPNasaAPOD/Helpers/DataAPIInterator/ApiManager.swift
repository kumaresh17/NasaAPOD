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
    func sendRequest<T:Codable>(payLoad:HTTPPayloadProtocol,managedObjectContext:NSManagedObjectContext?, completion: @escaping (Result<T,Error>) -> Void)
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
    
    /**
        Send request
        -  dataTask with request based on the HTTPSPayload data
        -  validate the response data and decode the data into graph reperentation of core data managed object
        -  send the completion block to the calling method with generic T result can be of any type
     */
    
    func sendRequest<T:Codable>(payLoad:HTTPPayloadProtocol,managedObjectContext:NSManagedObjectContext?, completion: @escaping (Result<T,Error>) -> Void) {
        
        let (urlRequest,error) = self.prepareRequest(withPayload: payLoad)
        if error != nil  {
            completion(.failure(error!))
            return
        }
        guard let urlRequest = urlRequest else {
            completion(.failure(NetworkError.invalidRequestHeader))
            return
        }
        task = urlSession.dataTask(with: urlRequest, completionHandler: {[weak self] (data, response, error) in
            guard let managedObjectContext = managedObjectContext else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.coreDataError))
                }
                return}
            self?.apiManagerResponseDataValidator(data: data, urlResponse: response as? HTTPURLResponse, completion: { error in
                if error == nil {
                    DispatchQueue.global(qos: .background).async {
                        managedObjectContext.perform {
                            CoreDataStack.shared.clearStorage(name: APODEntity.self,managedObjectContext: managedObjectContext)
                            self?.decodeDataResponse(data: data!, managedObjectContext: managedObjectContext, completion: completion)
                        }}
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(error!))
                    }
                }
            })
        })
        task?.resume()
    }

}

