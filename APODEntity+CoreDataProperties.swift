//
//  APODEntity+CoreDataProperties.swift
//  
//
//  Created by kumaresh shrivastava on 21/01/2022.
//
//

import Foundation
import CoreData


extension APODEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APODEntity> {
        return NSFetchRequest<APODEntity>(entityName: "APODEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var url: String?
    @NSManaged public var title: String?
    @NSManaged public var media_type: String?

}
