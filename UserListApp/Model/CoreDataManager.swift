import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "UserListApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func saveUsers(_ users: [User]) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            let existingUserIDs = Set(existingUsers.map { Int($0.id) })
            
            users.forEach { user in
                if !existingUserIDs.contains(user.id) {
                    let newUser = UserEntity(context: context)
                    newUser.id = Int64(user.id)
                    newUser.name = user.name
                    newUser.email = user.email
                    newUser.phone = user.phone
                }
            }
            
            saveContext()
        } catch {
            print("Failed to fetch existing users: \(error)")
        }
    }

    
    func fetchUsers() -> [UserEntity] {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }
    
    func deleteUser(_ user: UserEntity) {
        context.delete(user)
        saveContext()
    }
    
    func updateUser(_ user: UserEntity, newName: String, newEmail: String, newPhone: String) {
        user.name = newName
        user.email = newEmail
        user.phone = newPhone
        saveContext()
    }
}
