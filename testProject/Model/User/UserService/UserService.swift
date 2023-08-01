//
//  UserService.swift
//  testProject
//
//  Created by Emre on 16.07.2023.
//

import Foundation
import Alamofire

class UserService{
    let services: Services = Services()
    let userTokenService: UserTokenService = UserTokenService()

    func refreshToken(comletion: @escaping(Bool) -> Void){
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let url = URL(string: "\(services.urlAdress)/realms/test_realm/protocol/openid-connect/token/")!
        if let getUserToken = userTokenService.getUserTokenFromUserDefaults(){
            let user = UserTokenRequest(refreshToken: getUserToken.refreshToken,grantType: .REFRESH_TOKEN)
            self.requestDecodable(url: url, method: .post, parameters: user , headers: headers) { (response: UserToken?)  in
                if let token = response {
                    self.userTokenService.setUserTokenFromUserDefaults(userToken: token)
                    comletion(true)
                }
                else{
                    self.logoutUser()
                    return
                }
            }
        }else{
            self.logoutUser()
            return
        }
    }
    func logoutUser() {
        userTokenService.setUserTokenFromUserDefaults(userToken: nil)
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.windows.first?.rootViewController = loginViewController
    }
    
    
    func requestDecodable<T: Codable, R: Codable>(url: URL ,method: HTTPMethod,parameters: R?, headers: HTTPHeaders,completion: @escaping(T?) -> Void){
        AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self){ response in
            //debugPrint(response)
            switch response.response?.statusCode{
            case 401:
                print("Bağlantı Hatası")
                completion(nil)
                break
            default:
                completion(response.value)
                break
            }
        }
    }
    func requestDecodableTokens<T: Codable, R: Codable>(url: URL ,method: HTTPMethod,parameters: R?, headers: Dictionary<String, String>? = nil,completion: @escaping(T?) -> Void){
        var authHeaders = userServiceMutualHeaders(headers: headers)
        AF.request(url, method: method, parameters: parameters,encoder: JSONParameterEncoder.default, headers: authHeaders).responseDecodable(of: T.self){ response in
            //debugPrint(response)
            switch response.response?.statusCode{
            case 401:
                print("Bağlantı Hatası")
                self.refreshToken { success in
                    if success {
                        authHeaders = self.userServiceMutualHeaders(headers: headers)
                        AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: authHeaders).responseDecodable(of: T.self) { response in
                            //debugPrint(response)
                            completion(response.value)
                        }
                    }
                    else {
                        self.logoutUser()
                        completion(nil)
                    }
                }
                break
            default:
                completion(response.value)
                break
            }
        }
    }

    func requestDecodable<T: Codable>(url: URL ,method: HTTPMethod, headers: Dictionary<String, String>? = nil,completion: @escaping(T?) -> Void){
        var authHeaders = userServiceMutualHeaders(headers: headers)
        AF.request(url, method: method, headers: authHeaders).responseDecodable(of: T.self){ response in
            switch response.response?.statusCode{
            case 401:
                self.refreshToken { success in
                    if success {
                        authHeaders = self.userServiceMutualHeaders(headers: headers)
                        AF.request(url, method: method, headers: authHeaders).responseDecodable(of: T.self) { response in
                            //debugPrint(response)
                            completion(response.value)
                        }
                    } else {
                        self.logoutUser()
                        completion(nil)
                    }
                }
                break
            default:
                completion(response.value)
                break
            }
        }
    }
    func userServiceMutualHeaders(headers:  Dictionary<String, String>?) ->HTTPHeaders{
        var authHeaders: HTTPHeaders = [
            "Authorization": "Bearer \(userTokenService.getUserTokenFromUserDefaults()!.accessToken)",
        ]
        if let headers = headers{
            for temp in headers{
                authHeaders.update(name: temp.key, value: temp.value)
            }
            return authHeaders
        }
        return authHeaders
    }
}
