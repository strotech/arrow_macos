//
//  Member+CoreDataProperties.swift
//  arrowsFirstMac
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var alterEgo: String
    @NSManaged public var name: String
    @NSManaged public var otherAffiliations: String

}
