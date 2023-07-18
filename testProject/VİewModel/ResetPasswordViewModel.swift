//
//  ResetPasswordViewModel.swift
//  testProject
//
//  Created by Emre on 14.07.2023.
//

import Foundation
import Alamofire
class ResetPasswordViewModel{
    var services: Services = Services()
    let userService: UserService = UserService()
    var registerUser : RegisterUser?

    func resetPassword(email: String){
        var url: URL? = nil
        let headers = [
            "Content-Type": "application/json"
        ]
        userService.userInformation(email: email) { registerUser in
            if let registerUser = registerUser{
                url = URL(string: "\(self.services.urlAdress)/admin/realms/test_realm/users/\(registerUser.id)/reset-password-email")!
                self.userService.request(url: url!, method: .put, headers: headers) { response in
                    if let response = response{
                        switch response.result {
                        case .success:
                            print("Şifre sıfırlama isteği gönderildi.")
                        case let .failure(error):
                            print("Şifre sıfırlama isteği gönderilirken hata oluştu: \(error)")
                        }
                    }
                }
            }
        }
        
    }
}
