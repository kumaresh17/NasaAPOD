//
//  AlertViewController.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 21/01/2022.
//

import UIKit

protocol AlertDelegate {
    func alert(buttonClickedIndex:Int, buttonTitle: String, tag: Int)
}

class AlertViewController {
    class func showAlert(withTitle title: String, message:String, buttons:[String] = ["Ok"], delegate: AlertDelegate? = nil, tag: Int = 0){
        let keyWindow = UIApplication.shared.keyWindow
        
        var presentingViewController = keyWindow?.rootViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tag = tag
        var index = 0
        for button in buttons {
            let action =  UIAlertAction(title: button, style: .default, handler: { (alertAction) in
                
                if let d = delegate{
                    d.alert(buttonClickedIndex: index, buttonTitle: alertAction.title != nil ? alertAction.title! : title, tag: tag)
                }
            })
            alert.addAction(action)
            index = index + 1
        }
        
        while presentingViewController?.presentedViewController != nil {
            presentingViewController = presentingViewController?.presentedViewController
        }
        
        presentingViewController?.present(alert, animated: true, completion: nil)
    }
}


