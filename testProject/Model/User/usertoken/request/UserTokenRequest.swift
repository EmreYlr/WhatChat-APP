//
//  UserTokenRequest.swift
//  testProject
//
//  Created by Emre on 16.07.2023.
//

import Foundation
class UserTokenRequest: Codable {
    let service: Services = Services()
    let username, password,clientId,clientSecret: String
    let grantType: GrantType
    
    init(username: String, password: String, grantType: GrantType) {
        self.username = username
        self.password = password
        self.grantType = grantType
        self.clientId = service.clientId
        self.clientSecret = service.clientSecret
    }
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case grantType = "grant_type"
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
}

