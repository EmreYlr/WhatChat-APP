//
//  Extension.swift
//  testProject
//
//  Created by Emre on 12.07.2023.
//

import Foundation
import UIKit

extension UIViewController{
    func Alert(title: String, alertMessage: String){
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    func startLoader(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func stopLoader() {
        if let appDelegate = UIApplication.shared.delegate,
           let window = appDelegate.window ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let presentedViewController = window.rootViewController?.presentedViewController {
               if let alert = presentedViewController as? UIAlertController {
                   alert.dismiss(animated: true, completion: nil)
               }
        }
    }

}
