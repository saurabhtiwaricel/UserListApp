//
//  EditUserView.swift
//  UserListApp
//
//  Created by Celestial on 05/02/25.
//

import SwiftUI

struct EditUserView: View {
    @ObservedObject var viewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    var user: UserEntity
    
    @State private var name: String
    @State private var email: String
    @State private var phone: String

    init(user: UserEntity, viewModel: UserViewModel) {
        self.user = user
        self.viewModel = viewModel
        _name = State(initialValue: user.name ?? "")
        _email = State(initialValue: user.email ?? "")
        _phone = State(initialValue: user.phone ?? "")
    }

    var body: some View {
        Form {
            Section(header: Text("User Details")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                TextField("Phone", text: $phone)
            }

            Button("Save Changes") {
                viewModel.updateUser(user, newName: name, newEmail: email, newPhone: phone)
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Edit User")
    }
}


#Preview {
    let mockUser = UserEntity(context: CoreDataManager.shared.context)
    mockUser.id = 1
    mockUser.name = "John Doe"
    mockUser.email = "john@example.com"
    mockUser.phone = "123-456-7890"
    
    return EditUserView(user: mockUser, viewModel: UserViewModel())
}
