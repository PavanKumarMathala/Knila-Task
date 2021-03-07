//
//  User+CoreDataProperties.swift
//  
//
//  Created by Pavan Kumar Mathala on 07/03/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var avatar: String?
    @NSManaged public var id: Int16
    @NSManaged public var emailId: String?

}
