//
//  RoomId.swift
//  testProject
//
//  Created by Emre on 25.07.2023.
//

import Foundation
struct RoomId: Codable {
    let roomId: Int
    enum CodingKeys: String, CodingKey {
        case roomId = "roomId"
    }
}
