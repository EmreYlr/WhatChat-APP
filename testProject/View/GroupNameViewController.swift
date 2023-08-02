//
//  GroupNameViewController.swift
//  testProject
//
//  Created by Emre on 27.07.2023.
//

import UIKit

class GroupNameViewController: UIViewController {
    @IBOutlet weak var groupNameTextField: UITextField!
    var groupNameViewModel: GroupNameViewModel = GroupNameViewModel()
    var phoneNumbers: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
//MARK: Button
extension GroupNameViewController{
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        addNewGroup()
        if let homeViewController = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
            navigationController?.popToViewController(homeViewController, animated: true)
        }
    }
}
//MARK: Data
extension GroupNameViewController{
    func addNewGroup(){
        guard let groupName = groupNameTextField.text, !groupName.isEmpty else{
            Alert(title: "Error", alertMessage: "Group name is empty")
            return
        }
        let groupRoom = GroupRoom(userPhoneList: phoneNumbers, roomName: groupName)
        groupNameViewModel.addNewGroup(groupRoom: groupRoom) { roomId in
            if let roomId = roomId{
                print(roomId)
            }else{
                self.Alert(title: "Error", alertMessage: "These people are not on TestApp")
            }
        }
    }
}
