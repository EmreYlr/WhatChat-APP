//
//  UserTokenService.swift
//  testProject
//
//  Created by Emre on 17.07.2023.
//

import Foundation
import Alamofire
import JWTDecode
final class UserTokenService{
    let services: Services = Services()
    private var userToken: UserToken?
    init() {
        self.userToken = getUserTokenFromUserDefaults() ?? nil
    }
    func setUserTokenFromUserDefaults(userToken: UserToken?){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userToken){
            UserDefaults.standard.set(encoded, forKey: "userToken")
        }
    }
    func getUserTokenFromUserDefaults() -> UserToken?{
        if let token = UserDefaults.standard.object(forKey: "userToken") as? Data{
            let decoder = JSONDecoder()
            if let loadedToken = try? decoder.decode(UserToken.self, from: token){
                return loadedToken
            }
        }
        return nil
    }/*
    func refreshToken(comletion: @escaping(Bool) -> Void){
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let url = URL(string: "\(services.urlAdress)/realms/test_realm/protocol/openid-connect/token/")!
        if let getUserToken = getUserTokenFromUserDefaults(){
            let user = UserTokenRequest(refreshToken: getUserToken.refreshToken,grantType: .REFRESH_TOKEN)
            userService.requestDecodable(url: url, method: .post, parameters: user , headers: headers) { (response: UserToken?)  in
                if let token = response {
                    self.setUserTokenFromUserDefaults(userToken: token)
                    comletion(true)
                }
                else{
                    self.setUserTokenFromUserDefaults(userToken: nil)
                }
            }
        }else{
            comletion(false)
        }
    }*/
    
    func getLoggedUser() -> LoggedUser?{
        do{
            let jwt = try decode(jwt: getUserTokenFromUserDefaults()!.accessToken)
            let loggedUser = LoggedUser(userId: jwt.userId!, username: jwt.username!, name: jwt.name!, surname: jwt.surname!, email: jwt.email!, emailVerified: jwt.emailVerified!)
            return loggedUser
        }catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
}
