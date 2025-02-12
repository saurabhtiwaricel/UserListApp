//
//  User.swift
//  UserListApp
//
//  Created by Celestial on 05/02/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let phone: String
}

