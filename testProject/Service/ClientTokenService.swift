//
//  ClientTokenService.swift
//  testProject
//
//  Created by Emre on 14.07.2023.
//
import Foundation
import Alamofire
class ClientTokenService{
    let services: Services = Services()
    var clientToken: ClientToken?
    
    init() {
        debugPrint("Token Defaulttan alınıyor")
        self.clientToken = getClientTokenFromUserDefaults() ?? nil
        if clientToken == nil{
            debugPrint("Token Bulunamadı çekiliyor")
            getClientToken { token in
                self.setClientTokenFromUserDefaults(clientToken: token ?? nil)
                self.clientToken = token
            }
        }
    }
    
    func setClientTokenFromUserDefaults(clientToken: ClientToken?){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(clientToken){
            UserDefaults.standard.set(encoded, forKey: "client")
        }
    }
    func getClientTokenFromUserDefaults() -> ClientToken?{
        if let token = UserDefaults.standard.object(forKey: "client") as? Data{
            let decoder = JSONDecoder()
            if let loadedToken = try? decoder.decode(ClientToken.self, from: token){
                return loadedToken
            }
        }
        return nil
    }
    func getClientToken(completion: @escaping(ClientToken?) -> (Void)){
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "grant_type":"client_credentials",
            "client_id":"ios-test",
            "client_secret":services.clientSecret
        ]
        let url = URL(string:"\(services.urlAdress)/realms/test_realm/protocol/openid-connect/token/")!
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: ClientToken.self){ response in
            if let token = response.value{
                completion(token)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func request(url: URL ,method: HTTPMethod, headers: Dictionary<String, String>, completion: @escaping(AFDataResponse<Data?>?) -> Void){
        var authHeaders: HTTPHeaders = [
            "Authorization": "Bearer \(clientToken!.accessToken)",
        ]
        for temp in headers{
            authHeaders.update(name: temp.key, value: temp.value)
        }
        
        AF.request(url, method: method, headers: authHeaders).response { response in
            switch response.response?.statusCode{
            case 401:
                print("Bağlantı Hatası")
                self.getClientToken {clientToken in
                    if let clientToken = clientToken{
                        self.setClientTokenFromUserDefaults(clientToken: clientToken)
                    }
                }
                if self.getClientTokenFromUserDefaults() == nil{
                    self.request(url: url, method: method, headers: headers) { data in
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
    func requestEncoder<T: Encodable>(url: URL ,method: HTTPMethod,parameters: T, headers: Dictionary<String, String>, completion: @escaping(AFDataResponse<Data?>?) -> Void){
        var authHeaders: HTTPHeaders = [
            "Authorization": "Bearer \(clientToken!.accessToken)",
        ]
        for temp in headers{
            authHeaders.update(name: temp.key, value: temp.value)
        }
        
        AF.request(url, method: method,parameters: parameters,encoder: JSONParameterEncoder.default, headers: authHeaders).response { response in
            switch response.response?.statusCode{
            case 401:
                print("Bağlantı Hatası")
                self.getClientToken {clientToken in
                    if let clientToken = clientToken{
                        self.setClientTokenFromUserDefaults(clientToken: clientToken)
                    }
                }
                if self.getClientTokenFromUserDefaults() == nil{
                    self.request(url: url, method: method, headers: headers) { data in
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
    func requestDecodable<T: Decodable>(url: URL ,method: HTTPMethod, headers: Dictionary<String, String>,completion: @escaping(T?) -> Void){
        var authHeaders: HTTPHeaders = [
            "Authorization": "Bearer \(clientToken!.accessToken)",
        ]
        for temp in headers{
            authHeaders.update(name: temp.key, value: temp.value)
        }
        
        AF.request(url, method: method, headers: authHeaders).responseDecodable(of: T.self){ response in
            switch response.response?.statusCode{
            case 401:
                print("Bağlantı Hatası")
                self.getClientToken {clientToken in
                    if let clientToken = clientToken{
                        self.setClientTokenFromUserDefaults(clientToken: clientToken)
                    }
                }
                if self.getClientTokenFromUserDefaults() == nil{
                    self.request(url: url, method: method, headers: headers) { data in
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
}


