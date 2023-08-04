//
//  JWT.swift
//  testProject
//
//  Created by Emre on 12.07.2023.
//
import JWTDecode
extension JWT {
    var username: String?{
        return self["preferred_username"].string
    }
    var email: String? {
        return self["email"].string
    }
    var name: String?{
        return self["given_name"].string
    }
    var surname: String?{
        return self["family_name"].string
    }
    var userId: String?{
        return self["sub"].string
    }
    var emailVerified: Bool?{
        return self["email_verified"].boolean
    }
}
