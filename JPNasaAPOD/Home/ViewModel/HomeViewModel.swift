//
//  HomeViewModel.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 20/01/2022.
//

import Foundation
import Combine
import CoreData

// MARK: - HomeViewModel

protocol HomeViewModelProtocol: AnyObject {
    
    var dataForViewPub: Published<[APODModelProtocol]?>.Publisher { get  }
    var errorPub: Published<Error?>.Publisher { get }
    func getAODDataForHomeScreen(apodRequest:APODRequestProtocol) -> Void
    func mapToViewModelProtocol(managedObject: [APODEntity]?) ->  [APODModelProtocol]?
}

class HomeViewModel:HomeViewModelProtocol {
    /**
     Combine Publisher for which we have binded with View
    */
    @Published var dataForView:[APODModelProtocol]?
    @Published var error:Error?
    var dataForViewPub: Published<[APODModelProtocol]?>.Publisher {$dataForView}
    var errorPub: Published<Error?>.Publisher {$error}
    /**
      Api Module, ApiResourceIntractor, ManageObject and ApiManager
     */
    var apiModuleProtocol:APIModuleProtocol
    var apodResourceInteractorProtocol:APODResourceAPIInteractorProtocol?
    var manageObjectContext:NSManagedObjectContext
    var apiManagerProtocol:ApiManagerProtocol
    
    /**
     Dependency injection with APimodule payload , api manager and managecontext , to perform mock api and mock inMemory core data context while writing unit test cases for view model.
     */
    init(apiModule:APIModuleProtocol,apiManager:ApiManagerProtocol,mainContext:NSManagedObjectContext) {
        self.apiModuleProtocol = apiModule
        self.apiManagerProtocol = apiManager
        self.manageObjectContext = mainContext
    }
    
    /// init to be called from view controller with default paramater and request
     convenience init(apodRequest:APODRequestProtocol) {
        self.init(apiModule: APIModule(payloadType: .requestMethodGET, dateToSearch: apodRequest.startDate ?? nil), apiManager: ApiManager(), mainContext: CoreDataStack.shared.managedObjectContext)
    }
    
    ///  default init which can be used for test cases of view model
    convenience init() {
        self.init(apiModule: APIModule(payloadType: .requestMethodGET, dateToSearch: nil), apiManager: ApiManager(), mainContext: CoreDataStack.shared.managedObjectContext)
    }
    
    /**
     Fetch the APOD data from the API maanger
     store it in Core data stack and return  the object model in completion handler
     and sink the required mapped data or error to view using the combine publisher stream
     */
    func getAODDataForHomeScreen(apodRequest:APODRequestProtocol) -> Void {
        guard let dateString = apodRequest.startDate  else {
            error = HandledError.inValidApodDate
            return}
        apiModuleProtocol.dateToSearch = dateString
        apodResourceInteractorProtocol = APODResourceAPIInteractor.init(apiModule: self.apiModuleProtocol, mainContext: self.manageObjectContext,apiManager:self.apiManagerProtocol)
        apodResourceInteractorProtocol?.getAPODDataRespose() { [weak self]
            (APODData,error) in
            /// Use of combine to bind viewMode Data to View
            self?.error = error
            self?.dataForView = self?.mapToViewModelProtocol(managedObject: APODData)
        }
    }
    /**
     Mapping NSManaged Object to APODModellProtocol
     Avoid using managed objects directly, instead used a APODModelProtocol
     Prepare Data which is required to display on the View
     */
    func mapToViewModelProtocol(managedObject: [APODEntity]?) ->  [APODModelProtocol]? {
        guard let object:[APODEntity] = managedObject else {
            return nil}
        var result: [APODModelProtocol]? =  [APODModelProtocol]()
        _ = object.map {
            let response = (APODModel(title: $0.title, explanation: $0.explanation, mediaSourceURL: $0.url, mediaType: $0.media_type, date: $0.date))
            result?.append(response)
        }
        return result
    }
}

