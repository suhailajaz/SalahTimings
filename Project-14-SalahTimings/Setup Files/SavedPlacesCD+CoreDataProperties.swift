//
//  SavedPlacesCD+CoreDataProperties.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 23/01/24.
//
//

import Foundation
import CoreData


extension SavedPlacesCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedPlacesCD> {
        return NSFetchRequest<SavedPlacesCD>(entityName: "SavedPlacesCD")
    }

    @NSManaged public var city: String?
    @NSManaged public var qiblaDirection: String?
    @NSManaged public var temp: String?
    @NSManaged public var pressure: String?
    @NSManaged public var times: Time?

}

extension SavedPlacesCD : Identifiable {

}
