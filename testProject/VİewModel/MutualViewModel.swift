//
//  MutualVİewModel.swift
//  testProject
//
//  Created by Emre on 16.07.2023.
//

import Foundation

class MutualViewModel{
    let services : Services
    let userService: UserService
    let headers = ["Content-Type": "application/json"]
    
    init(services: Services = Services(), userService: UserService = UserService()) {
        self.services = services
        self.userService = userService
    }
    
    func userInformation(email: String, completion: @escaping (RegisterUser?) -> Void) {
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users/?email=\(email)")!
        
        userService.requestDecodable(url: url, method: .get, headers: self.headers) { (user: [RegisterUser]?) in
            if let registerUser = user{
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
