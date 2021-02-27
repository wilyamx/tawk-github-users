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

        let context = self.localDB.viewContext

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
        
    public func getUserById(userId: Int32) -> NSManagedObject? {
        let context = self.localDB.viewContext

        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id = %d", userId)
        
        var items: [Any] = []
        do {
            items = try context.fetch(fetchRequest)
        }
        catch let error {
            DebugInfoKey.error.log(info: "Fetch error for id=\(userId) :: \(error.localizedDescription)")
        }
        
        if items.count == 1 {
            if let user = items.first as? NSManagedObject {
                return user
            }
        }
        return nil
    }
    
    // MARK: - Managed Note
    
    public func userCreateOrUpdateNote(userId: Int32, message: String) {
        let user = self.getUserById(userId: userId)
        guard let managedUser = user as? User else { return }
        
        let context = self.localDB.viewContext
        
        // has existing note (update)
        if let managedNote = managedUser.note {
            managedNote.setValue(message, forKey: "message")
            do {
                try context.save()
            }
            catch let error {
                DebugInfoKey.error.log(info: "Failed update note for userId (\(userId)) :: \(error.localizedDescription)")
            }
        }
        // no associated note (create)
        else {
            let note = Note(context: context)
            note.message = message
            
            managedUser.note = note
            do {
                try context.save()
            }
            catch let error {
                DebugInfoKey.error.log(info: "Failed create note for userId (\(userId)) :: \(error.localizedDescription)")
            }
        }
    }
}
