//
//  UserListView.swift
//  UserListApp
//
//  Created by Celestial on 05/02/25.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var selectedUser: UserEntity?
    @State private var isEditPresented = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users, id: \.id) { user in
                    Button(action: {
                        selectedUser = user
                        isEditPresented = true
                    }) {
                        VStack(alignment: .leading) {
                            Text(user.name ?? "Unknown")
                                .font(.headline)
                            Text(user.email ?? "No Email")
                                .foregroundColor(.gray)
                            Text(user.phone ?? "No Phone")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let user = viewModel.users[index]
                        viewModel.deleteUser(user)
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fetch Users") {
                        viewModel.fetchUsersFromAPI()
                    }
                }
            }
            .sheet(isPresented: $isEditPresented) {
                if let user = selectedUser {
                    EditUserView(user: user, viewModel: viewModel)
                }
            }
        }
    }
}



#Preview {
    UserListView()
}
