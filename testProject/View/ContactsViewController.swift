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
    var selectedContacts = Set<CNContact>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contactsTableView.allowsMultipleSelection = true
        fetchContacts()
        showDoneButton()
        
    }
}

//MARK: BUTTON
extension ContactsViewController{
    func isContactSelected(_ contact: CNContact) -> Bool {
        return selectedContacts.contains { $0.identifier == contact.identifier }
    }
    
    func showDoneButton() {
        let rightButtonItem: UIBarButtonItem
        if !selectedContacts.isEmpty {
            rightButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        } else {
            rightButtonItem = UIBarButtonItem(title: "New Contact", style: .plain, target: self, action: #selector(newContactButtonTapped))
        }
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func doneButtonTapped() {
        if selectedContacts.count > 1 {
            print("Birden fazla kişi seçildi")
        } else {
            print("Tek kişi seçildi")
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func newContactButtonTapped() {
        performSegue(withIdentifier: "newContactShow", sender: nil)
    }
    
}


//MARK: CONTACTS
extension ContactsViewController{
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


//MARK: TABLEVIEW
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        
        if isContactSelected(contact) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row]
        
        if isContactSelected(selectedContact) {
            selectedContacts.remove(selectedContact)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectedContacts.insert(selectedContact)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        showDoneButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedContact = contacts[indexPath.row]
        selectedContacts.remove(deselectedContact)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        if selectedContacts.isEmpty {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    
}
