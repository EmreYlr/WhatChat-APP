//
//  RegisterViewModel.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import Foundation
import Alamofire

final class RegisterViewModel{
    private let services : Services = Services()
    private let clientService: ClientService = ClientService()
    var statusCode : Int?
    var registerUser: RegisterUser?
    let headers = ["Content-Type": "application/json"]
    

    
    func registerUser(user: User, completion: @escaping(Int?)->(Void)){
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users")!

        clientService.requestEncoder(url: url, method: .post,parameters: user,headers: self.headers) { response in
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
        clientService.userInformation(email: email){ registerUser in
            if let user = registerUser{
                url = URL(string: "\(self.services.urlAdress)/admin/realms/test_realm/users/\(user.id)/send-verify-email")!
                self.clientService.request(url: url!, method: .put, headers: self.headers) { response
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

