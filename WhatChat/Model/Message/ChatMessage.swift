//
//  ChatMessages.swift
//  testProject
//
//  Created by Emre on 19.07.2023.
//

import Foundation

struct ChatMessage:Codable{
    let userPhoneNo: String
    let message: String
    let sentByMe: Bool
    let sentAt: String
}
