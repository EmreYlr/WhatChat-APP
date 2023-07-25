//
//  HomeViewController.swift
//  testProject
//
//  Created by Emre on 12.07.2023.
//

import UIKit
import JWTDecode
import SocketIO

class HomeViewController: UIViewController {
    let userTokenService: UserTokenService = UserTokenService()
    let homeViewModel: HomeViewModel = HomeViewModel()
    @IBOutlet weak var chatTableView: UITableView!
    let addButton = UIButton()
    fileprivate let cellId = "userCell"
    var rooms = [RoomProfile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.getAllRooms(completion: { room in
            if let room = room{
                self.rooms = room
                self.chatTableView.reloadData()
            }
        })
        self.navigationItem.setHidesBackButton(true, animated: false)
        chatTableView.dataSource = self
        chatTableView.delegate = self
        addUserButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.chatTableView.reloadData()
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
                messageVC.room =  sender as! RoomProfile?
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
        cell.userNameLabel.text = userProfile.roomName
        cell.userMessageLabel.text = userProfile.lastMessage
        cell.userProfileImage.image = UIImage(named: userProfile.roomPhoto ?? "DefaultProfile.svg")
        cell.timeLabel.text = dateChange(date: userProfile.lastMessageTime ?? "00:00")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = rooms[indexPath.row]
        performSegue(withIdentifier: "showMessageView", sender: room)
        print(room.roomName)
        print(room.roomId)
    }
}
//MARK: Date
extension HomeViewController{
    func dateChange(date: String) -> String {
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date ?? Date())

    }
}
