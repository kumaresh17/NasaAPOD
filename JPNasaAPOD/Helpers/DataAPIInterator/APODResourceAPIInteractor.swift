//
//  APODResourceInteractor.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 20/01/2022.
//

import Foundation
import CoreData

// MARK: - Configure and Fetch APOD response

protocol APODResourceAPIInteractorProtocol:AnyObject {

    var apiModule: APIModuleProtocol {get set}
    var apiManager: ApiManagerProtocol { get }
    func getAPODDataRespose(completion:@escaping (_ result:[APODEntity]?,_ error:Error?) -> Void) -> Void
}

final class APODResourceAPIInteractor:PayLoadFormat,APODResourceAPIInteractorProtocol {
    var apiManager: ApiManagerProtocol
    var apiModule:APIModuleProtocol
    let mainContext: NSManagedObjectContext
    
    /// Dependency injection for APOD Request and Payload data as a abstact protocol object  (which are used for fetching the APOD data) and  manage object context
    /// Manage object context is injected so that we can have a separate persistance Core data stack with NSInMemoryStoreType for Unit test
    init (apiModule:APIModuleProtocol,mainContext: NSManagedObjectContext,apiManager:ApiManagerProtocol) {
        self.apiModule = apiModule
        self.mainContext = mainContext
        self.apiManager = apiManager
    }
    
    func getAPODDataRespose(completion:@escaping (_ result:[APODEntity]?,_ error:Error?) -> Void) -> Void {

        let payload = formatGetPayload(url: .AODURL, module: apiModule)
        self.apiManager.getAODInfo(payload: payload,managedObjectContext:mainContext) { [unowned self] result in
            var responseError: Error? = nil
            switch result {
            case .success(let data):
                data.isEmpty ? responseError = NetworkError.noDataFound : CoreDataStack.shared.saveToMainContext(managedObjectContext: self.mainContext)
            case .failure(let error):
                responseError = error
            }
            guard let aopdData = CoreDataStack.shared.fetchFromCoreData(name: APODEntity.self, managedObjectContext: self.mainContext) else {
                let errorDes = responseError ?? NetworkError.noDataFound
                completion(nil,errorDes)
                return }
            completion(aopdData,responseError)
        }
    }
}

