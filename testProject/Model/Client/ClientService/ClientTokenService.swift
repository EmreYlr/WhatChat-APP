//
//  ClientTokenService.swift
//  testProject
//
//  Created by Emre on 14.07.2023.
//
import Foundation
import Alamofire
final class ClientTokenService{
    let services: Services = Services()
    private var clientToken: ClientToken?
    init() {
        self.clientToken = getClientTokenFromUserDefaults() ?? nil
        if clientToken == nil{
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
    
    
}


