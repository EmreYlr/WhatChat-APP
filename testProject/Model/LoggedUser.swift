//
//  LoggedUser.swift
//  testProject
//
//  Created by Emre on 21.07.2023.
//

import Foundation

struct LoggedUser: Codable{
    let userId, username, name, surname ,email: String
    let emailVerified: Bool
    init(userId: String, username: String, name: String, surname: String, email: String, emailVerified: Bool) {
        self.userId = userId
        self.username = username
        self.name = name
        self.surname = surname
        self.email = email
        self.emailVerified = emailVerified
    }
}
