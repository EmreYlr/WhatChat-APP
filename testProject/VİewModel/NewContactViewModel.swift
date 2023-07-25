//
//  NewContactViewModel.swift
//  testProject
//
//  Created by Emre on 25.07.2023.
//

import Foundation
import Alamofire
class NewContactViewModel{
    private let userService: UserService = UserService()
    private let userTokenService: UserTokenService = UserTokenService()
    private let messageService: MessageService = MessageService()
    
    func addNewContact(phoneNumbers: PhoneNumbers, completion: @escaping(RoomId?) -> Void){
        let url = URL(string: "\(messageService.urlAdress)/api/v1/room/create")
        let headers: HTTPHeaders = ["Content-Type":"application/json",
            "Authorization": "Bearer \(userTokenService.getUserTokenFromUserDefaults()!.accessToken)"]
        
        AF.request(url!, method: .post , parameters: phoneNumbers,encoder: JSONParameterEncoder.default,headers: headers).responseDecodable(of: RoomId.self){ response in
            debugPrint(response)
            switch response.response?.statusCode{
            case 500:
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
