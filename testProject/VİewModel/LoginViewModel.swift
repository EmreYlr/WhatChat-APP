//
//  TokenViewModel.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import Alamofire
import JWTDecode

class LoginViewModel{
    var token: UserToken?
    private var userService: UserService = UserService()
    private var userTokenService: UserTokenService = UserTokenService()
    private var services: Services = Services()
    
    func checkUser(_ username: String, _ password: String, completion: @escaping (Bool?) -> Void) {
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let user = UserTokenRequest(username: username, password: password, grantType: .PASSWORD)
        
        let url = URL(string: "\(services.urlAdress)/realms/test_realm/protocol/openid-connect/token/")!
        
        userService.requestDecodable(url: url, method: .post, parameters: user , headers: headers) { (response: UserToken?)  in
            if let token = response {
                self.userTokenService.setUserTokenFromUserDefaults(userToken: token)
                DispatchQueue.main.async {
                    completion(true)
                }
            }
            else{
                DispatchQueue.main.async {
                    completion(false)
                }
            }

        }

        /*
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .post, parameters: user, headers: headers).responseDecodable(of: UserToken.self) { response in
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
         */
         
    }
}



