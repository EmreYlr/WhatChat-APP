//
//  HomeViewModel.swift
//  testProject
//
//  Created by Emre on 17.07.2023.
//

import Foundation
import JWTDecode
class HomeViewModel{
    let userService: UserService = UserService()
    let userTokenService: UserTokenService = UserTokenService()
    let service: Services = Services()
    
    func logoutUser(){
        if let user = userTokenService.getLoggedUser(){
            let headers = ["Content-Type": "application/json"]
            let url = URL(string: "\(service.urlAdress)/admin/realms/test_realm/users/\(user.userId)/logout")!
            userService.request(url: url, method: .post, headers: headers) { response in
                if let response = response{
                    switch response.result {
                    case .success:
                        print("Çıkış Yapıldı.")
                        self.userTokenService.setUserTokenFromUserDefaults(userToken: nil)
                    case let .failure(error):
                        print("Çıkış yapılamadı.Bir hata oluştu: \(error)")
                    }
                }
            }
        }
    }
    
}
