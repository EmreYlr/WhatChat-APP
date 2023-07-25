//
//  NewContactViewController.swift
//  testProject
//
//  Created by Emre on 25.07.2023.
//

import UIKit

class NewContactViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    var phone : [String] = []
    var newContactViewModel : NewContactViewModel = NewContactViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}
//MARK: Button
extension NewContactViewController{
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let phoneNumberText = phoneTextField.text, !phoneNumberText.isEmpty else {
            return
        }
        phone.append(phoneNumberText)
        let phoneNumbers = PhoneNumbers(userPhoneList: phone)
        newContactViewModel.addNewContact(phoneNumbers: phoneNumbers) { roomId in
            print(roomId)
        }
    }
    
}
