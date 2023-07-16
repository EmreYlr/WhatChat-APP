//
//  User.swift
//  testProject
//
//  Created by Emre on 9.07.2023.
//

import Foundation
struct User: Codable {
    let enabled: Bool
    let firstName, lastName, email: String
    let credentials: [Credential]
}

struct Credential: Codable {
    let type, value: String
    let temporary: Bool
}
