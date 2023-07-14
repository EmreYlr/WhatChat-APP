//
//  TokenViewModel.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import Alamofire
import JWTDecode
class LoginViewModel{
    var token: Token?
    var services: Services!
    
    func getUserToken(_ username: String, _ password: String, completion: @escaping (Token?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        //user kullan
        let parameters = [
            "grant_type": "password",
            "username": username,
            "password": password,
            "client_id": "ios-test",
            "client_secret": services.clientSecret
        ]
        
        let url = URL(string: "\(services.urlAdress)/realms/test_realm/protocol/openid-connect/token/")!
        
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



