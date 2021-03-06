//
//  WSRTestCoreDataStack.swift
//  Github-Users
//
//  Created by William S. Rena on 3/6/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation
import CoreData

class TestCoreDataStack: CoreDataStack {
    
    override init() {
        super.init()
        
        self.persistentStoreCoordinator = {
            let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            do {
                try psc.addPersistentStore(
                    ofType: NSInMemoryStoreType,
                    configurationName: nil,
                    at: nil,
                    options:nil)
            }
            catch {
                fatalError()
            }
            
            return psc
            }()
    }
}
