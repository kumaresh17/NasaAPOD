//
//  ApiManager+JsonDecoder.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 03/03/2022.
//

import Foundation
import CoreData

/**
       Deocode the data response to core data model
       Generic T is used to infer any type
 */

extension ApiManager {
    
    func decodeDataResponse<T:Codable>(data:Data,managedObjectContext:NSManagedObjectContext?, completion: @escaping (Result<T,Error>) -> Void) -> Void {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            completion(.failure(NetworkError.coreDataError))
            return
        }
        let result: Result<T, Error>
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        do {
            let response = try decoder.decode(T.self, from: data)
            result = .success(response)
        }
        catch let error {
            result = .failure(error)
        }
        completion(result)
    }
}
