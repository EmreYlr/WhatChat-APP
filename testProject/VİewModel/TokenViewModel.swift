//
//  TokenViewModel.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import Alamofire

class TokenViewModel {
    var token: Token?
    
    func getUserToken(_ username: String, _ password: String, completion: @escaping (Token?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "grant_type": "password",
            "username": username,
            "password": password,
            "client_id": "ios-test",
            "client_secret": "7KeVk6d08bomnt8omhcE9y5zTdSzpFi0"
        ]
        let url = URL(string: "https://testkeycloak.azurewebsites.net/realms/test_realm/protocol/openid-connect/token/")!
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: Token.self) { response in
                if let token = response.value {
                    self.token = token
                    DispatchQueue.main.async {
                        completion(token)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
}



