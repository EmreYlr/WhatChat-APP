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

    func requestDecodable<T: Codable, R: Codable>(url: URL ,method: HTTPMethod,parameters: R?, headers: HTTPHeaders,completion: @escaping(T?) -> Void){
        AF.request(url, method: method, parameters: parameters, headers: headers).responseDecodable(of: T.self){ response in
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
        let authHeaders = userServiceMutualHeaders(headers: headers)
        AF.request(url, method: method, parameters: parameters,encoder: JSONParameterEncoder.default, headers: authHeaders).responseDecodable(of: T.self){ response in
            debugPrint(response)
            switch response.response?.statusCode{
            case 400,401:
                print("Bağlantı Hatası")
                completion(nil)
                break
            default:
                completion(response.value)
                break
            }
        }
    }

    func requestDecodable<T: Codable>(url: URL ,method: HTTPMethod, headers: Dictionary<String, String>? = nil,completion: @escaping(T?) -> Void){
        let authHeaders = userServiceMutualHeaders(headers: headers)
        AF.request(url, method: method, headers: authHeaders).responseDecodable(of: T.self){ response in
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
