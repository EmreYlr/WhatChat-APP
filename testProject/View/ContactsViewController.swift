//
//  ContactsViewController.swift
//  testProject
//
//  Created by Emre on 24.07.2023.
//

import UIKit
import Contacts
class ContactsViewController: UIViewController {
    @IBOutlet weak var contactsTableView: UITableView!
    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        fetchContacts()
        
    }
    func showDoneButton() {
        let doneButton = UIBarButtonItem(title: "Bitti", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    @objc func doneButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func fetchContacts() {
        DispatchQueue.global(qos: .background).async {
            let store = CNContactStore()
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            
            do {
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                    self.contacts.append(contact)
                })
                
                DispatchQueue.main.async {
                    self.contactsTableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        
    }
    
}
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row]
        
        if let firstPhoneNumber = selectedContact.phoneNumbers.first?.value {
            let phoneNumber = firstPhoneNumber.stringValue
            let numericPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            print(numericPhoneNumber)
        }
        showDoneButton()
    }
    
    
    
}
