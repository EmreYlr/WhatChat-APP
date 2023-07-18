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
    
    //JWT yerine arkada user at
    
    func logoutUser(){
        if let jwt = userTokenService.getJWT(){
            let headers = ["Content-Type": "application/json"]
            let url = URL(string: "\(service.urlAdress)/admin/realms/test_realm/users/\(jwt.userId!)/logout")!
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
