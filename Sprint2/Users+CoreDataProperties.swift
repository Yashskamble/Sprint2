//
//  Users+CoreDataProperties.swift
//  Sprint2
//
//  Created by Capgemini-DA230 on 9/22/22.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var username: String?
    @NSManaged public var mobile: String?
    @NSManaged public var password: String?
    @NSManaged public var userEmailId: String?
    

}

extension Users : Identifiable {

}

