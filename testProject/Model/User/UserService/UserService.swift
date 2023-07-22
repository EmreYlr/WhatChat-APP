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
   
    
}
