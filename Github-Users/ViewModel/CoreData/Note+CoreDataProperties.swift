//
//  Note+CoreDataProperties.swift
//  Github-Users
//
//  Created by William S. Rena on 2/28/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var message: String?
    @NSManaged public var user: User?

}

extension Note : Identifiable {

}
