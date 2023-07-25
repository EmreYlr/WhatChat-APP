//
//  PhoneNumbers.swift
//  testProject
//
//  Created by Emre on 25.07.2023.
//

import Foundation
struct PhoneNumbers: Codable {
    let userPhoneList: [String]
    
    init(userPhoneList: [String]) {
        self.userPhoneList = userPhoneList
    }
  
}
