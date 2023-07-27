//
//  GroupNameViewModel.swift
//  testProject
//
//  Created by Emre on 27.07.2023.
//

import Foundation
class GroupNameViewModel{
    private let userService: UserService = UserService()
    private let messageService: MessageService = MessageService()
    
    func addNewGroup(groupRoom: GroupRoom, completion: @escaping(RoomId?) -> Void){
        let url = URL(string: "\(messageService.urlAdress)/api/v1/room/create")!
        let headers = ["Content-Type":"application/json"]
        
        userService.requestDecodableTokens(url: url, method: .post, parameters: groupRoom, headers: headers) { (response : RoomId?) in
            if let roomId = response{
                completion(roomId)
            }else{
                completion(nil)
            }
        }
    }
}
