//
//  ClientViewModel.swift
//  testProject
//
//  Created by Emre on 11.07.2023.
//

import Foundation
import Alamofire

class ClientViewModel{
    var clientToken : ClientToken?
    let services = Services()
    func getClientToken(completion: @escaping(ClientToken?) -> (Void)){
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "grant_type":"client_credentials",
            "client_id":"ios-test",
            "client_secret":services.clientSecret
        ]
        let url = URL(string:    "\(services.urlAdress)/realms/test_realm/protocol/openid-connect/token/")!
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: ClientToken.self){ response in
            if let token = response.value{
                self.clientToken = token
                DispatchQueue.main.async {
                    completion(token)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        
        
    }
    
}

