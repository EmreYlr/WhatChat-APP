//
//  GrantType.swift
//  testProject
//
//  Created by Emre on 16.07.2023.
//

import Foundation
enum GrantType: String, Codable{
    case PASSWORD = "password"
    case REFRESH_TOKEN = "refresh_token"
    case CLIENT_CREDENTIALS = "client_credentials"
}
