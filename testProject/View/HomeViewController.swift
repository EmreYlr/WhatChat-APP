//
//  HomeViewController.swift
//  testProject
//
//  Created by Emre on 12.07.2023.
//

import UIKit

class HomeViewController: UIViewController {
    var name : String?
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        welcomeLabel.text = name
    }
    @IBAction func singOutButton(_ sender: UIBarButtonItem) {
        
    }
    
    
    

}
