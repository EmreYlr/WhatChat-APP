//
//  RegisterViewModel.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import Foundation
import Alamofire

final class RegisterViewModel{
    private let services : Services
    private let userService: UserService
    var statusCode : Int?
    var registerUser: RegisterUser?
    let headers = ["Content-Type": "application/json"]
    
    init(services: Services = Services(), userService: UserService = UserService()) {
        self.services = services
        self.userService = userService
    }
    
    func registerUser(user: User, completion: @escaping(Int?)->(Void)){
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users")!

        userService.requestEncoder(url: url, method: .post,parameters: user,headers: self.headers) { response in
            if let response = response?.response?.statusCode{
                self.statusCode = response
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }
    func sendEmail(email: String){
        var url: URL? = nil
        userService.userInformation(email: email){ registerUser in
            if let user = registerUser{
                url = URL(string: "\(self.services.urlAdress)/admin/realms/test_realm/users/\(user.id)/send-verify-email")!
                self.userService.request(url: url!, method: .put, headers: self.headers) { response
                    in
                    if let response = response{
                        switch response.result {
                        case .success:
                            print("E-posta doğrulama isteği gönderildi.")
                        case let .failure(error):
                            print("E-posta doğrulama isteği gönderilirken hata oluştu: \(error)")
                        }
                    }
                }
            }
        }
    }
    
}

