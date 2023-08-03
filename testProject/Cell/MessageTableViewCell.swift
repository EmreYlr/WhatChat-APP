//
//  MessageTableViewCell.swift
//  testProject
//
//  Created by Emre on 19.07.2023.
//

import UIKit
import Contacts
class MessageTableViewCell: UITableViewCell {
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    let phoneNumberLabel = UILabel()
    var isGroup: Bool = false
    var previousPhoneNumber: String?

    var chatMessage: ChatMessage!{
        didSet{
            phoneNumberLabel.textColor = .orange
            bubbleBackgroundView.backgroundColor = chatMessage.sentByMe ? .darkGray : .white
            messageLabel.textColor = chatMessage.sentByMe ? .white: .black
            messageLabel.text = chatMessage.message
            if chatMessage.sentByMe{
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                phoneNumberLabel.isHidden = true
            }else{
                if isGroup{
                    if let previousPhoneNumber = previousPhoneNumber, previousPhoneNumber == chatMessage.userPhoneNo {
                        phoneNumberLabel.isHidden = true
                    } else {
                        phoneNumberLabel.text = getContactName(for: chatMessage.userPhoneNo) ?? chatMessage.userPhoneNo
                        phoneNumberLabel.isHidden = false
                    }
                }
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(phoneNumberLabel)
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        let maxWidth = UIScreen.main.bounds.width - 120
        let widthConstraint = messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
        widthConstraint.isActive = true
        widthConstraint.priority = .required - 1
        widthConstraint.isActive = true
        
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
                        
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            phoneNumberLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            phoneNumberLabel.trailingAnchor.constraint(equalTo:bubbleBackgroundView.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func getContactName(for phoneNumber: String) -> String? {
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
                        contactName = [contact.givenName].compactMap { $0 }.joined(separator: " ")
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
