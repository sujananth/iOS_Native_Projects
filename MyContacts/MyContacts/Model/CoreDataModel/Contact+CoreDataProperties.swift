//
//  Contact+CoreDataProperties.swift
//  MyContacts
//
//  Created by Sujananth on 10/28/18.
//  Copyright © 2018 sujananth. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var firstName: String
    @NSManaged public var lastName: String?
    @NSManaged public var emailID: String?
    @NSManaged public var mobileNumber: Int64
    @NSManaged public var countryCode: String?
    @NSManaged public var profileImagePath: String?

}
