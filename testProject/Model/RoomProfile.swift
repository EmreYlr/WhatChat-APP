//
//  UserMessageProfile.swift
//  testProject
//
//  Created by Emre on 19.07.2023.
//

import Foundation
struct RoomProfile: Codable{
    let roomId: Int
    let roomName: String
    let lastMessage: String?
    let lastMessageTime: String?
    let roomPhoto: String?
    
}
