//
//  userTableViewCell.swift
//  testProject
//
//  Created by Emre on 19.07.2023.
//

import UIKit

class userTableViewCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newMessageCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newMessageCount.backgroundColor = UIColor.systemGreen
        newMessageCount.layer.cornerRadius = newMessageCount.frame.height / 2
        newMessageCount.clipsToBounds = true
    }
}
