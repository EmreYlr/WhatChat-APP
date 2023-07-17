//
//  UserTokenService.swift
//  testProject
//
//  Created by Emre on 17.07.2023.
//

import Foundation
import Alamofire
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
    }

}
