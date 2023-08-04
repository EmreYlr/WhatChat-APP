//
//  NewContactViewModel.swift
//  testProject
//
//  Created by Emre on 25.07.2023.
//

import Foundation
class NewContactViewModel{
    private let userService: UserService = UserService()
    private let messageService: MessageService = MessageService()
    
    func addNewContact(phoneNumbers: PhoneNumbers, completion: @escaping(RoomId?) -> Void){
        let url = URL(string: "\(messageService.urlAdress)/api/v1/room/create")!
        let headers = ["Content-Type":"application/json"]
        
        userService.requestDecodableTokens(url: url, method: .post, parameters: phoneNumbers, headers: headers) { (response : RoomId?) in
            if let roomId = response{
                completion(roomId)
            }else{
                completion(nil)
            }
        }
    }
}
