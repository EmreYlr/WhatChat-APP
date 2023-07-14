//
//  ResetPasswordViewModel.swift
//  testProject
//
//  Created by Emre on 14.07.2023.
//

import Foundation
import Alamofire
class ResetPasswordViewModel{
    var services: Services!
    func userInformation(email: String, token: String, completion: @escaping (RegisterUser?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users/?email=\(email)")!
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, headers: headers).responseDecodable(of: [RegisterUser].self) { response in
                if let registerUser = response.value {
                    print(registerUser[0])
                    DispatchQueue.main.async {
                        completion(registerUser[0])
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
