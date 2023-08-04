//
//  UserTokenRequest.swift
//  testProject
//
//  Created by Emre on 16.07.2023.
//

import Foundation
class UserTokenRequest: Codable {
    let service: Services = Services()
    let username, password: String?
    let clientId,clientSecret: String
    let grantType: GrantType
    let refreshToken: String?
    
    init(username: String, password: String, grantType: GrantType) {
        self.username = username
        self.password = password
        self.grantType = grantType
        self.clientId = service.clientId
        self.clientSecret = service.clientSecret
        refreshToken = nil
    }
    init(refreshToken: String, grantType: GrantType) {
        self.username = nil
        self.password = nil
        self.grantType = grantType
        self.clientId = service.clientId
        self.clientSecret = service.clientSecret
        self.refreshToken = refreshToken
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case grantType = "grant_type"
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case refreshToken = "refresh_token"
    }
}

