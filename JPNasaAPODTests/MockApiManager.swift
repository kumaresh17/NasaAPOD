//
//  MockAPODApiClient.swift
//  JPNasaAPODTests
//
//  Created by kumaresh shrivastava on 23/01/2022.
//

import Foundation
import CoreData
@testable import JPNasaAPOD

class MockApiManager {
     var shouldReturnError = false
     var getAPODApiCalled = true
    
    enum MockServiceError:Error {
        case APODAPIERROR
    }
    
    func reset(){
        shouldReturnError = false
        getAPODApiCalled = false
    }
    let mockAPODResponse = "[{\"copyright\":\"Luk\\ufffd Vesel\\ufffd\",\"date\":\"2019-01-23\",\"explanation\":\"Do you recognize this constellation? Through the icicles and past the mountains is Orion, one of the most identifiable star groupings on the sky and an icon familiar to humanity for over 30,000 years. Orion has looked pretty much the same during the past 50,000 years and should continue to look the same for many thousands of years into the future.  Orion is quite prominent in the sky this time of year, a recurring sign of (modern) winter in Earth\'s northern hemisphere and summer in the south. Pictured, Orion was captured recently above the Austrian Alps in a composite of seven images taken by the same camera in the same location during the same night. Below and slightly to the right of Orion\'s three-star belt is the Orion Nebula, while the four bright stars surrounding the belt are, clockwise from the upper left, Betelgeuse, Bellatrix, Rigel, and Saiph.    New: Instagram page features cool images recently submitted to APOD\",\"hdurl\":\"https://apod.nasa.gov/apod/image/1901/OrionAlps_Vesely_740.jpg\",\"media_type\":\"image\",\"service_version\":\"v1\",\"title\":\"Orion over the Austrian Alps\",\"url\":\"https://apod.nasa.gov/apod/image/1901/OrionAlps_Vesely_960.jpg\"}]\n"
    
    convenience init() {
        self.init(false)
    }
    
    init(_ shouldReturnError:Bool) {
        self.shouldReturnError = shouldReturnError
    }
}

extension MockApiManager: ApiManagerProtocol{
    
    func sendRequest<T:Codable>(payLoad:HTTPPayloadProtocol,managedObjectContext:NSManagedObjectContext?, completion: @escaping (Result<T,Error>) -> Void) {
        
        getAPODApiCalled = true
        
        if shouldReturnError == true {
            completion(.failure(MockServiceError.APODAPIERROR))
        } else {
            let data = Data(mockAPODResponse.utf8)
            decodeDataResponse(data: data, managedObjectContext: managedObjectContext, completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let responseData):
                        completion(.success(responseData as! T))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            })
        }
    }
    
    func getAODInfo(payload: HTTPPayloadProtocol, managedObjectContext: NSManagedObjectContext?, completion: @escaping (Result<APODModelArray, Error>) -> Void) {
      
        self.sendRequest(payLoad:payload,managedObjectContext:managedObjectContext,completion:completion)
    }
    
    func decodeDataResponse(data: Data, managedObjectContext: NSManagedObjectContext?, completion: @escaping (Result<APODModelArray, Error>) -> Void) {
        
        let apiManager = ApiManager()
        apiManager.decodeDataResponse(data: data, managedObjectContext: managedObjectContext) { result in
            switch result {
            case .success(let responseData):
                completion(.success(responseData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
