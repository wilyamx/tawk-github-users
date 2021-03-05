//
//  TWKDatabaseManager.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation
import CoreData

enum TWKDatabaseRequestError: Error {
    case fetchUsers(offset:Int, message: String)
    
    private var errorCode: Int {
        switch self {
        case .fetchUsers(_, _): return 200
        }
    }
    
    var description: String {
        switch self {
        case .fetchUsers(let offset, let message):
            return "Fetch users from offset=\(offset) :: \(message)"
        }
    }
}

enum TWKDatabaseRequestResult<T> {
    case success(T)
    case failure(TWKDatabaseRequestError)
}

class TWKDatabaseManager {
    // https://stackoverflow.com/questions/40769106/errors-after-create-nsmanagedobject-subclass-for-coredata-entities
    // https://www.avanderlee.com/swift/core-data-performance/
    // https://duncsand.medium.com/threading-43a9081284e5
    
    static let shared = TWKDatabaseManager()
    
    var readContext: NSManagedObjectContext = TWKReference.appDelegate.persistentContainer.viewContext
    //var writeContext: NSManagedObjectContext = TWKReference.appDelegate.persistentContainer.viewContext
    lazy var writeContext: NSManagedObjectContext = {
        let newbackgroundContext = TWKReference.appDelegate.persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
    
    init() {
        if let dbDescription = TWKReference.appDelegate.persistentContainer.persistentStoreDescriptions.first,
           let path = dbDescription.url {
            DebugInfoKey.database.log(info: "Local database path: \(path)")
        }
        self.initializeData()
    }
    
    // MARK: - Private Methods
    
    private func initializeData() {
        
    }
    
    // MARK: - Managed User for Writing
    
    public func userCreateOrUpdate(from codableModel: TWKGithubUserCodable) {
        guard let primaryKey = codableModel.id else { return }

        self.writeContext.performAndWait({
            let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "id = %d", primaryKey)
            
            var items: [Any] = []
            do {
                items = try self.writeContext.fetch(fetchRequest)
            }
            catch let error {
                DebugInfoKey.error.log(info: "Fetch error for id=\(primaryKey) :: \(error.localizedDescription)")
            }

            let entity = NSEntityDescription.entity(forEntityName: "User", in: self.writeContext)
            
            // create
            if items.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: self.writeContext)
                newUser.setValue(codableModel.id, forKey: "id")
                newUser.setValue(codableModel.login, forKey: "login")
                newUser.setValue(codableModel.avatarUrl, forKey: "avatarUrl")

                do {
                    try self.writeContext.save()
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
                        try self.writeContext.save()
                    }
                    catch let error {
                        DebugInfoKey.error.log(info: "Failed update user for \(codableModel.login ?? "") (\(codableModel.id ?? 0)) :: \(error.localizedDescription)")
                    }
                }
            }
        })
            
    }
    
    public func userCreateOrUpdateNote(
        userId: Int32,
        message: String,
        completion: @escaping (String?) -> ()) {
        
        let user = self.getUserById(userId: userId)
        guard let managedUser = user as? User else {
            completion(nil)
            return
        }
        
        self.writeContext.performAndWait({
            // has existing note (update)
            if let managedNote = managedUser.note {
                managedNote.setValue(message, forKey: "message")
                do {
                    try self.readContext.save()
                    completion(message)
                }
                catch let error {
                    DebugInfoKey.error.log(info: "Failed update note for userId (\(userId)) :: \(error.localizedDescription)")
                    completion(nil)
                }
            }
            // no associated note (create)
            else {
                let entity = NSEntityDescription.entity(forEntityName: "Note", in: self.readContext)
                let newNote = NSManagedObject(entity: entity!, insertInto: self.readContext)
                newNote.setValue(message, forKey: "message")
                
                managedUser.setValue(newNote, forKey: "note")
                do {
                    try self.readContext.save()
                    completion(message)
                }
                catch let error {
                    DebugInfoKey.error.log(info: "Failed create note for userId (\(userId)) :: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        })
        
    }
    
    public func seenUser(userId: Int32) {
        let user = self.getUserById(userId: userId)
        guard let managedUser = user as? User else { return }
        
        self.writeContext.performAndWait({
            managedUser.seen = true
            do {
                try self.writeContext.save()
            }
            catch let error {
                DebugInfoKey.error.log(info: "Failed update user seen status for userId (\(userId)) :: \(error.localizedDescription)")
            }
        })
        
    }
    
    // MARK: - Managed User for Reading
        
    public func getUsers(
        offset: Int,
        limit: Int,
        completion: @escaping (TWKDatabaseRequestResult<[NSManagedObject]?>) -> ()) {
        
        // sorting
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = offset
        fetchRequest.sortDescriptors = sortDescriptors
        
        var items: [Any] = []
        do {
            items = try self.readContext.fetch(fetchRequest)
            completion(TWKDatabaseRequestResult.success(items as? [NSManagedObject]))
        }
        catch let error {
            completion(TWKDatabaseRequestResult.failure(.fetchUsers(offset: offset, message: error.localizedDescription)))
        }
    }
    
    public func getUserById(userId: Int32) -> NSManagedObject? {
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id = %d", userId)
        
        var items: [Any] = []
        do {
            items = try self.readContext.fetch(fetchRequest)
        }
        catch let error {
            DebugInfoKey.error.log(info: "Fetch error for id=\(userId) :: \(error.localizedDescription)")
            return nil
        }
        
        if items.count == 1 {
            if let user = items.first as? NSManagedObject {
                return user
            }
        }
        return nil
    }
    
    public func getUsersByIds(userIds: [Int32]) -> [NSManagedObject]? {
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id in %@", userIds)
        
        var items: [Any] = []
        do {
            items = try self.readContext.fetch(fetchRequest)
            return items as? [NSManagedObject]
        }
        catch let error {
            DebugInfoKey.error.log(info: "Fetch error for ids=\(userIds) :: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Managed Note
    
    func getNotesCount() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let count = try self.readContext.count(for: fetchRequest)
            print("]>> notes.count \(count)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
