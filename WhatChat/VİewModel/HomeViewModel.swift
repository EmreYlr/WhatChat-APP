//
//  HomeViewModel.swift
//  testProject
//
//  Created by Emre on 17.07.2023.
//

import Foundation
import JWTDecode
class HomeViewModel{
    let clientService: ClientService = ClientService()
    let userService: UserService = UserService()
    let userTokenService: UserTokenService = UserTokenService()
    let service: Services = Services()
    let messageService: MessageService = MessageService()
    
    func logoutUser(){
        if let user = userTokenService.getLoggedUser(){
            let headers = ["Content-Type": "application/json"]
            let url = URL(string: "\(service.urlAdress)/admin/realms/test_realm/users/\(user.userId)/logout")!
            clientService.request(url: url, method: .post, headers: headers) { response in
                if let response = response{
                    switch response.result {
                    case .success:
                        print("Çıkış Yapıldı.")
                        self.userTokenService.setUserTokenFromUserDefaults(userToken: nil)
                    case let .failure(error):
                        print("Çıkış yapılamadı.Bir hata oluştu: \(error)")
                    }
                }
            }
        }
    }
    func getAllRooms(completion: @escaping([RoomProfile]?) -> Void){
        let url = URL(string: "\(messageService.urlAdress)/api/v1/room/getAllRooms")
        userService.requestDecodable(url: url!, method: .get) { (room: [RoomProfile]?) in
            if let room = room{
                completion(room)
            }else{
                completion(nil)
            }
        }
    }
    
    
}
