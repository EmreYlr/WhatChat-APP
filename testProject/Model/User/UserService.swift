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
    let clientTokenService: ClientTokenService
    init() {
        self.clientTokenService = ClientTokenService()
    }
    func request(url: URL ,method: HTTPMethod, headers: Dictionary<String, String>, completion: @escaping(AFDataResponse<Data?>?) -> Void){
        
        let authHeaders = userServiceMutualHeaders(headers: headers)
        
        AF.request(url, method: method, headers: authHeaders).response { response in
            switch response.response?.statusCode{
            case 401:
                print("Bağlantı Hatası")
                self.userServiceMutualGetClientToken()
                if self.clientTokenService.getClientTokenFromUserDefaults() == nil{
                    self.request(url: url, method: method, headers: headers) { data in
                        completion(data)
                    }
                }
                break
            default:
                completion(response)
                break
            }
        }
    }
    func requestEncoder<T: Encodable>(url: URL ,method: HTTPMethod,parameters: T, headers: Dictionary<String, String>, completion: @escaping(AFDataResponse<Data?>?) -> Void){
        
        let authHeaders = userServiceMutualHeaders(headers: headers)
        
        AF.request(url, method: method,parameters: parameters,encoder: JSONParameterEncoder.default, headers: authHeaders).response { response in
            switch response.response?.statusCode{
            case 401:
                print("Bağlantı Hatası")
                self.userServiceMutualGetClientToken()
                if self.clientTokenService.getClientTokenFromUserDefaults() == nil{
                    self.requestEncoder(url: url, method: method,parameters: parameters, headers: headers) {_ in
                        completion(response)
                    }
                }
                break
            default:
                completion(response)
                break
            }
        }
    }
    func requestDecodable<T: Codable>(url: URL ,method: HTTPMethod,parameters: T? = nil, headers: Dictionary<String, String>,completion: @escaping(T?) -> Void){
        let authHeaders = userServiceMutualHeaders(headers: headers)
        AF.request(url, method: method, parameters: parameters, headers: authHeaders).responseDecodable(of: T.self){ response in
            switch response.response?.statusCode{
            case 401:
                print("Bağlantı Hatası")
                self.userServiceMutualGetClientToken()
                if self.clientTokenService.getClientTokenFromUserDefaults() == nil{
                    self.request(url: url, method: method, headers: headers) {_ in
                        completion(response.value)
                    }
                }
                break
            default:
                completion(response.value)
                break
            }
        }
    }
    
    func userInformation(email: String, completion: @escaping (RegisterUser?) -> Void) {
        let headers = [
            "Content-Type": "application/json"
        ]
        let url = URL(string: "\(services.urlAdress)/admin/realms/test_realm/users/?email=\(email)")!
        requestDecodable(url: url, method: .get, headers: headers) { (user: [RegisterUser]?) in
            if let registerUser = user{
                completion(registerUser[0])
            }else{
                completion(nil)
            }
                
        }
    }
    
    func userServiceMutualHeaders(headers:  Dictionary<String, String>) ->HTTPHeaders{
        var authHeaders: HTTPHeaders = [
            "Authorization": "Bearer \(clientTokenService.getClientTokenFromUserDefaults()!.accessToken)",
        ]
        for temp in headers{
            authHeaders.update(name: temp.key, value: temp.value)
        }
        return authHeaders
    }
    
    func userServiceMutualGetClientToken() {
        clientTokenService.getClientToken { clientToken in
            if let clientToken = clientToken {
                self.clientTokenService.setClientTokenFromUserDefaults(clientToken: clientToken)
            }
        }
    }
}
