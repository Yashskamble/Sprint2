//
//  CartData+CoreDataProperties.swift
//  
//
//  Created by Capgemini-DA230 on 9/26/22.
//
//

import Foundation
import CoreData


extension CartData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartData> {
        return NSFetchRequest<CartData>(entityName: "CartData")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptionProduct: String?
    @NSManaged public var userEmailId: String?
}
