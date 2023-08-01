//
//  MessageTableViewCell.swift
//  testProject
//
//  Created by Emre on 19.07.2023.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    var previousPhoneNumber: String?

    var chatMessage: ChatMessage!{
        didSet{
            bubbleBackgroundView.backgroundColor = chatMessage.sentByMe ? .darkGray : .white
            messageLabel.textColor = chatMessage.sentByMe ? .white: .black
            messageLabel.text = chatMessage.message
            if chatMessage.sentByMe{
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }else{
//                if chatMessage.userPhoneNo == previousPhoneNumber {
//                    messageLabel.text = chatMessage.message
//                } else {
//                    messageLabel.text = "\(chatMessage.userPhoneNo): \(chatMessage.message)"
//                }
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
                
            }
            //previousPhoneNumber = chatMessage.userPhoneNo
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let maxWidth = UIScreen.main.bounds.width - 120
        let widthConstraint = messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
        widthConstraint.isActive = true
        widthConstraint.priority = .required - 1
        widthConstraint.isActive = true
        
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            
        ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 32)
        leadingConstraint.isActive = false
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true

        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
