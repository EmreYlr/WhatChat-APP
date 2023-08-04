//
//  HomeGetMessage.swift
//  testProject
//
//  Created by Emre on 28.07.2023.
//

import Foundation
struct HomeGetMessage: Codable {
    let content: String
    let phoneNo: String
    let roomId: Int
    let sentAt: String
}
