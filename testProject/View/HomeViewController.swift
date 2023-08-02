//
//  HomeViewController.swift
//  testProject
//
//  Created by Emre on 12.07.2023.
//

import UIKit
import JWTDecode
import SocketIO
import Contacts
class HomeViewController: UIViewController {
    let userTokenService: UserTokenService = UserTokenService()
    let homeViewModel: HomeViewModel = HomeViewModel()
    @IBOutlet weak var chatTableView: UITableView!
    let addButton = UIButton()
    fileprivate let cellId = "userCell"
    var rooms = [RoomProfile]()
    var messageCounts: [Int: Int] = [:]
    var selectedRoomId: Int?
    
    var manager = SocketManager(socketURL: URL(string: "http://3.71.199.20:8085")!,config: [.log(true), .compress ])
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSocketIO()
        self.navigationItem.setHidesBackButton(true, animated: false)
        chatTableView.dataSource = self
        chatTableView.delegate = self
        addUserButton()
        addHandler()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socket.connect()
        selectedRoomId = nil
        getAllRoom()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        manager.disconnect()
        socket.disconnect()
    }

}
//MARK: Button
extension HomeViewController{
    @IBAction func singOutButton(_ sender: UIBarButtonItem) {
        homeViewModel.logoutUser()
        // Emin misin sorusunu sor
        backLoginScreen()
        self.navigationController?.popViewController(animated: true)
    }
    
    func addUserButton(){
        addButton.setImage(UIImage(systemName: "ellipsis.bubble"), for: .normal)
        addButton.imageView?.tintColor = .white
        addButton.backgroundColor = UIColor.systemGreen
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.layer.cornerRadius = 25
    }
    
    @objc func addButtonTapped(){
        performSegue(withIdentifier: "showContactsView", sender: nil)
    }
    
}
//MARK: SOCKET
extension HomeViewController{
    func setupSocketIO() {
        let userId = userTokenService.getLoggedUser()!.userId
        manager.setConfigs([.connectParams(["room": userId])])
        socket = manager.defaultSocket
        socket.connect()
    }
    func addHandler(){
        socket.on("get_message") { (data, ack) in
            if let message = data[0] as? [String: Any],
               let content = message["content"] as? String,
               let phoneNo = message["phoneNo"] as? String,
               let roomId = message["roomId"] as? Int,
                let sentAt = message["sentAt"] as? String{
                let homeGetMessage = HomeGetMessage(content:content ,phoneNo:phoneNo, roomId: roomId,sentAt: sentAt)
                
                self.newMessage(homeGetMessage: homeGetMessage)
            }
        }
        socket.on("create_room") { (data, ack) in
            self.getAllRoom()
        }
    }
}
//MARK: DATA
extension HomeViewController{
    
    func backLoginScreen(){
        if let loginVC = self.navigationController?.viewControllers.first as? LoginViewController{
            loginVC.passwordTextField.text = ""
            loginVC.emailTextField.text = ""
            loginVC.emailTextField.resignFirstResponder()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessageView" {
            if let messageVC = segue.destination as? MessageViewController {
                messageVC.room =  sender as! RoomId?
            }
        }
    }
    func getAllRoom() {
        homeViewModel.getAllRooms(completion: { room in
            if let room = room{
                self.rooms = room
                //self.phoneNoToName(phoneNumbers: self.getAllPhoneNo())
                self.chatTableView.reloadData()
            }
        })
    }
    
    func newMessage(homeGetMessage: HomeGetMessage) {
        if let currentCount = messageCounts[homeGetMessage.roomId] {
            messageCounts[homeGetMessage.roomId] = currentCount + 1
        } else {
            messageCounts[homeGetMessage.roomId] = 1
        }
        
        if homeGetMessage.roomId == selectedRoomId {
            messageCounts[homeGetMessage.roomId] = 0
            chatTableView.reloadData()
        } else {
            if let index = rooms.firstIndex(where: { $0.roomId == homeGetMessage.roomId }) {
                let topIndexPath = IndexPath(row: index, section: 0)
                chatTableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
                rooms[index].lastMessage = homeGetMessage.content
                rooms[index].lastMessageTime = homeGetMessage.sentAt
                let room = rooms.remove(at: index)
                rooms.insert(room, at: 0)
                chatTableView.reloadData()
            }
        }
    }
    
    
}


//MARK: TABLEVIEW
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userProfile = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! userTableViewCell
        let lastMessageUserPhoneNo = "\(userProfile.lastMessageUserPhoneNo ?? ""): "
        if userProfile.isGroup{
            cell.userNameLabel.text = userProfile.roomName
            cell.userMessageLabel.text = (userProfile.lastMessageUserPhoneNo != nil) ? "\(lastMessageUserPhoneNo)\(userProfile.lastMessage ?? "")" : " "
        }else{
            cell.userNameLabel.text = getContactName(for: userProfile.userPhoneNo!)
            cell.userMessageLabel.text = userProfile.lastMessage
        }
        cell.userProfileImage.image = UIImage(named: userProfile.roomPhoto ?? "DefaultProfile.svg")
        cell.timeLabel.text = dateChange(date: userProfile.lastMessageTime ?? userProfile.roomCreateDate)
        if let count = messageCounts[userProfile.roomId], count > 0 {
            cell.newMessageCount.isHidden = false
            cell.newMessageCount.text = "\(count)"
        } else {
            cell.newMessageCount.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = rooms[indexPath.row]
        selectedRoomId = room.roomId
        messageCounts[selectedRoomId!] = 0
        let roomId = RoomId(roomId: room.roomId)
        performSegue(withIdentifier: "showMessageView", sender: roomId)
    }
    
    
}
//MARK: CONTACT
extension HomeViewController{
    func getContactName(for phoneNumber: String) -> String? {
        let store = CNContactStore()
        var contactName: String?
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey]
                let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phoneNumber))
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                fetchRequest.predicate = predicate
                
                do {
                    try store.enumerateContacts(with: fetchRequest) { contact, stop in
                        contactName = [contact.givenName, contact.familyName].compactMap { $0 }.joined(separator: " ")
                        stop.pointee = true
                    }
                } catch {
                    print("Hata oluştu: \(error)")
                }
            } else {
                print("Rehbere erişim izni reddedildi.")
            }
        }
        return contactName
    }
}
//MARK: Date
extension HomeViewController{
    func dateChange(date: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let dateString = date, let parsedDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: parsedDate)
        } else {
            return ""
        }
    }
}
