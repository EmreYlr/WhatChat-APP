//
//  NewContactViewController.swift
//  testProject
//
//  Created by Emre on 25.07.2023.
//

import UIKit
import Contacts
class NewContactViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
//MARK: Button
extension NewContactViewController{
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty, let firstName = firstNameTextField.text, !firstName.isEmpty, let lastName = lastNameTextField.text,
        !lastName.isEmpty else {
            Alert(title: "Error", alertMessage: "First name, last name or phone number is empty!")
            return
        }
        self.saveContactToAddressBook(givenName: firstName, familyName: lastName, phoneNumber: phoneNumber)
        self.navigationController?.popViewController(animated: true)
    }

    func saveContactToAddressBook(givenName: String, familyName: String, phoneNumber: String) {
        let store = CNContactStore()
        let contact = CNMutableContact()

        contact.givenName = givenName
        contact.familyName = familyName
        
        let phoneNumberValue = CNPhoneNumber(stringValue: phoneNumber)
        let phoneNumberLabel = CNLabeledValue(label: CNLabelPhoneNumberMain, value: phoneNumberValue)
        contact.phoneNumbers = [phoneNumberLabel]
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
            print("Kişi başarıyla rehbere kaydedildi.")
        } catch {
            print("Rehbere kişi kaydedilirken bir hata oluştu: \(error)")
        }
    }
    
}
