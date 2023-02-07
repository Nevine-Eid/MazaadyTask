
//
//  BaseViewController.swift
//  MazaadyTask
//
//  Created by Nevine on 05/02/2023.
//


import Foundation
import MBProgressHUD
import SwiftMessages


class BaseViewController: UIViewController {
    
    func showIndicator(withTitle title: String = "", and Description: String = "") {
      let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
      Indicator.label.text = title
      Indicator.isUserInteractionEnabled = false
      Indicator.detailsLabel.text = Description
      Indicator.show(animated: true)
    }

    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func displayMessage(message: String, messageError: Bool) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        if messageError == true {
            view.configureTheme(.error)
            view.configureTheme(backgroundColor: .clear, foregroundColor: .blue)
        } else {
            view.configureTheme(.success)
            view.configureTheme(backgroundColor: .clear, foregroundColor: .green)
        }
        
        view.titleLabel?.isHidden = true
        view.bodyLabel?.text = message
        view.titleLabel?.textColor = UIColor.white
        view.bodyLabel?.textColor = UIColor.white
        view.button?.isHidden = true
        view.alpha = 0.9
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        SwiftMessages.show(config: config, view: view)
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

