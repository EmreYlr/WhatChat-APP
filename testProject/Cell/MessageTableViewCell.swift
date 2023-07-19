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

    var chatMessage: ChatMessage!{
        didSet{
            bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? .white : .darkGray
            messageLabel.textColor = chatMessage.isIncoming ? .black: .white
            messageLabel.text = chatMessage.text
            if chatMessage.isIncoming{
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }else{
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            messageLabel.topAnchor.constraint (equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint (equalTo: bottomAnchor, constant: -32), messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant:-16) ,
            bubbleBackgroundView.leadingAnchor.constraint(equalTo:messageLabel.leadingAnchor,constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo:messageLabel.bottomAnchor,constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo:messageLabel.trailingAnchor,constant: 16),
            
        ]
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 32)
        leadingConstraint.isActive = false
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true

        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
