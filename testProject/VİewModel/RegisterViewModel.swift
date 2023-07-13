//
//  RegisterViewModel.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import Foundation
import Alamofire

class RegisterViewModel{
    let services = Services()
    var statusCode : Int?
    var registerUser: RegisterUser?
    
    func registerUser(_ token: String, _ username: String, _ surname: String, _ email: String, _ password: String, completion: @escaping(Int?)->(Void)){
        
        let user = User(enabled: true, firstName: username , lastName: surname, email: email, credentials: [Credential(type: "password", value: password, temporary: false)])
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users")!
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .post, parameters: user,encoder: JSONParameterEncoder.default, headers: headers).responseData{ response in
                if let response = response.response?.statusCode{
                    self.statusCode = response
                    DispatchQueue.main.async {
                        completion(response)
                    }
                }
            }
        }
    }
    
    func userIsVerified(email: String, token: String, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users/?email=\(email)")!
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, headers: headers).responseDecodable(of: [RegisterUser].self) { response in
                if let registerUser = response.value {
                    print(registerUser[0].emailVerified)
                    DispatchQueue.main.async {
                        completion(registerUser[0].emailVerified)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    
                }
            }
        }
    }
    
}

