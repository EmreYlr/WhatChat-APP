//
//  RegisteredUser.swift
//  testProject
//
//  Created by Emre on 13.07.2023.
//

import Foundation
struct RegisterUser: Codable {
    let id: String
    let createdTimestamp: Int
    let username: String
    let enabled, totp, emailVerified: Bool
    let firstName, lastName, email: String
    let disableableCredentialTypes: Set<String>
    let requiredActions: [String]
    let notBefore: Int
    let access: Access
}
struct Access: Codable {
    let manageGroupMembership, view, mapRoles, impersonate: Bool
    let manage: Bool
}
