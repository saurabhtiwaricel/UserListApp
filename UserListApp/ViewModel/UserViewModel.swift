import Foundation
import Combine
import CoreData

class UserViewModel: ObservableObject {
    @Published var users: [UserEntity] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchUsersFromCoreData()
    }
    
    func fetchUsersFromAPI() {
        APIService.shared.fetchUsers()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching users: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { users in
                CoreDataManager.shared.saveUsers(users) 
                self.fetchUsersFromCoreData()
            })
            .store(in: &cancellables)
    }

    
    func fetchUsersFromCoreData() {
        self.users = CoreDataManager.shared.fetchUsers()
    }
    
    func deleteUser(_ user: UserEntity) {
        CoreDataManager.shared.deleteUser(user)
        fetchUsersFromCoreData()
    }
    
    func updateUser(_ user: UserEntity, newName: String, newEmail: String, newPhone: String) {
        CoreDataManager.shared.updateUser(user, newName: newName, newEmail: newEmail, newPhone: newPhone)
        fetchUsersFromCoreData()
    }
}
