//
//  TWKDatabaseManager.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation
import CoreData

class TWKDatabaseManager {
    // https://stackoverflow.com/questions/40769106/errors-after-create-nsmanagedobject-subclass-for-coredata-entities
    
    static let shared = TWKDatabaseManager()
    
    let localDB = TWKReference.appDelegate.persistentContainer

    init() {
        self.initializeData()
    }
    
    // MARK: - Private Methods
    
    private func initializeData() {
        
    }
    
    // MARK: - Managed User
        
    public func userCreateOrUpdate(from codableModel: TWKGithubUserCodable) {
        guard let primaryKey = codableModel.id else { return }

        let context = localDB.viewContext

        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id = %d", primaryKey)
        
        var items: [Any] = []
        do {
            items = try context.fetch(fetchRequest)
        }
        catch let error {
            DebugInfoKey.error.log(info: "Fetch error for id=\(primaryKey) :: \(error.localizedDescription)")
        }

        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        // create
        if items.count == 0 {
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(codableModel.id, forKey: "id")
            newUser.setValue(codableModel.login, forKey: "login")
            newUser.setValue(codableModel.avatarUrl, forKey: "avatarUrl")

            do {
                try context.save()
            }
            catch let error {
                DebugInfoKey.error.log(info: "Failed create user for \(codableModel.login ?? "") (\(codableModel.id ?? 0)) :: \(error.localizedDescription)")
            }
        }
        // update
        else {
            if let objectToUpdate = items.first as? NSManagedObject {
                objectToUpdate.setValue(codableModel.id, forKey: "id")
                objectToUpdate.setValue(codableModel.login, forKey: "login")
                objectToUpdate.setValue(codableModel.avatarUrl, forKey: "avatarUrl")
                
                do {
                    try context.save()
                }
                catch let error {
                    DebugInfoKey.error.log(info: "Failed update user for \(codableModel.login ?? "") (\(codableModel.id ?? 0)) :: \(error.localizedDescription)")
                }
            }
        }
       
    }
        
    // MARK: - Managed Note
    
}
