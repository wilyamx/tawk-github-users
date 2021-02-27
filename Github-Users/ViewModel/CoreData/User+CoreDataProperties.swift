//
//  User+CoreDataProperties.swift
//  Github-Users
//
//  Created by William S. Rena on 2/27/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var id: Int32
    @NSManaged public var login: String?
    @NSManaged public var note: Note?

}

extension User : Identifiable {

}
