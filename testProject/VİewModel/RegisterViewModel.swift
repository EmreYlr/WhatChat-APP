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
    private let clientTokenService: ClientTokenService
    var statusCode : Int?
    var registerUser: RegisterUser?
    
    init(services: Services = Services(), clientTokenService: ClientTokenService = ClientTokenService()) {
        self.services = services
        self.clientTokenService = clientTokenService
    }
    
    func registerUser(_ username: String, _ surname: String, _ email: String, _ password: String, completion: @escaping(Int?)->(Void)){
        
        let user = User(enabled: true, firstName: username , lastName: surname, email: email, credentials: [Credential(type: "password", value: password, temporary: false)])
        let headers = [
            "Content-Type": "application/json"
        ]
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users")!

        clientTokenService.requestEncoder(url: url, method: .post,parameters: user,headers: headers) { response in
            if let response = response?.response?.statusCode{
                self.statusCode = response
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }
    
    

    func userInformation(email: String, completion: @escaping (RegisterUser?) -> Void) {
        let headers = [
            "Content-Type": "application/json"
        ]
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users/?email=\(email)")!
        
        clientTokenService.requestDecodable(url: url, method: .get, headers: headers) { (user: [RegisterUser]?) in
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
    
    
    func sendEmail(registerUser: RegisterUser){
        let headers = [
            "Content-Type": "application/json"
        ]
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users/\(registerUser.id)/send-verify-email")!
        clientTokenService.request(url: url, method: .put, headers: headers) { response
            in
            if let response = response{
                debugPrint(response)
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

