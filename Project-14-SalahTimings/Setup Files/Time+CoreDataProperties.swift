//
//  Time+CoreDataProperties.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 23/01/24.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time")
    }

    @NSManaged public var fajr: String?
    @NSManaged public var dhuhr: String?
    @NSManaged public var asr: String?
    @NSManaged public var maghrib: String?
    @NSManaged public var isha: String?

}

extension Time : Identifiable {

}
