//
//  MessageViewModel.swift
//  testProject
//
//  Created by Emre on 26.07.2023.
//

import Foundation

class MessageViewModel{
    private let userService: UserService = UserService()
    private let messageService: MessageService = MessageService()
    
    func getRoomMessage(roomId: RoomId, completion: @escaping ([ChatMessage]?) -> Void) {
        let url = URL(string: "\(messageService.urlAdress)/api/v1/userMessage/\(roomId.roomId)")!
        userService.requestDecodable(url: url, method: .get) { (chatMessages: [ChatMessage]?) in
            if let chatMessages = chatMessages {
                completion(chatMessages)
            } else {
                completion(nil)
            }
        }
    }
}
