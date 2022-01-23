//
//  AODResponseModel.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 20/01/2022.
//

import Foundation
import CoreData

// MARK: - APOD Model
class APODResponseModel: NSManagedObject,Codable {
   
    enum CodingKeys: String, CodingKey {
        case date, explanation
        case mediaType = "media_type"
        case title, url
    }
    
    // MARK: - Core Data Managed Object
    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var url: String?
    @NSManaged public var title: String?
    @NSManaged public var media_type: String?
    
    // MARK: - Decodable
       required convenience init(from decoder: Decoder) throws {
           guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
                 let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
                 let entity = NSEntityDescription.entity(forEntityName: JPCoreData.APODEntity.rawValue, in: managedObjectContext) else {
               fatalError("Failed to decode User")
           }

           self.init(entity: entity, insertInto: managedObjectContext)

           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.date = try container.decodeIfPresent(String.self, forKey: .date)
           self.title = try container.decodeIfPresent(String.self, forKey: .title)
           self.explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
           self.url = try container.decodeIfPresent(String.self, forKey: .url)
           self.media_type = try container.decodeIfPresent(String.self, forKey: .mediaType)
           
       }
       
       // MARK: - Encodable
       public func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(date, forKey: .date)
           try container.encode(title, forKey: .title)
           try container.encode(explanation, forKey: .explanation)
           try container.encode(url, forKey: .url)
           try container.encode(media_type, forKey: .mediaType)
       }
    
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

enum JPCoreData: String {
    case APODEntity = "APODEntity"
}

typealias APODModelArray = [APODResponseModel]
/**
 This model protocol object will be used  for home screen view
 */
protocol APODModelProtocol {
    var title: String? {get set}
    var explanation: String? {get set}
    var mediaSourceURL: String? {get set}
    var mediaType: String? {get set}
    var date: String? {get set}
}

struct APODModel: APODModelProtocol {
    var title: String?
    var explanation: String?
    var mediaSourceURL: String?
    var mediaType: String?
    var date: String?
}



