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
    
    var dataForViewPub: Published<[AODViewModelProtocol]?>.Publisher { get  }
    var errorPub: Published<Error?>.Publisher { get }
    func getAODDataForHomeScreen(apodRequest:APODRequestProtocol) -> Void
    func mapToViewModelProtocol(managedObject: [APODEntity]?) ->  [AODViewModelProtocol]?
}

class HomeViewModel:HomeViewModelProtocol {
    /**
     Combine Publisher for which we have binded with View
    */
    @Published var dataForView:[AODViewModelProtocol]?
    @Published var error:Error?
    var dataForViewPub: Published<[AODViewModelProtocol]?>.Publisher {$dataForView}
    var errorPub: Published<Error?>.Publisher {$error}
    var apiModuleProtocol:APIModuleProtocol?
    var apodResourceInteractorProtocol:APODResourceAPIInteractorProtocol?
    var manageObjectContext:NSManagedObjectContext = CoreDataStack.shared.managedObjectContext
    /**
     Dependency injection of APODRequest from home screen
     */
    func getAODDataForHomeScreen(apodRequest:APODRequestProtocol) -> Void {
        guard let dateString = apodRequest.startDate else {return}
        self.error = nil
        apiModuleProtocol = APIModule(payloadType: .requestMethodGET, dateToSearch: dateString)
        apodResourceInteractorProtocol = APODResourceAPIInteractor.init(apiModule: apiModuleProtocol!, apodRequest: apodRequest, mainContext: manageObjectContext)
        apodResourceInteractorProtocol?.getAPODDataRespose() { [weak self]
            (APODData,error) in
            /// Use of combine to bind viewMode Data to View
            self?.error = error
            self?.dataForView = self?.mapToViewModelProtocol(managedObject: APODData)
        }
    }
    /**
     Mapping NSManaged Object to AODViewModelProtocol
     Avoid using managed objects directly, instead used a AODViewModelProtocol
     Prepare Data which is required to display on the View
     */
    func mapToViewModelProtocol(managedObject: [APODEntity]?) ->  [AODViewModelProtocol]? {
        guard let object:[APODEntity] = managedObject else {
            return nil}
        var result: [AODViewModelProtocol]? =  [AODViewModelProtocol]()
        _ = object.map {
            let response = (AODViewModel(title: $0.title, explanation: $0.explanation, mediaSourceURL: $0.url, mediaType: $0.media_type, date: $0.date))
            result?.append(response)
        }
        return result
    }

}

