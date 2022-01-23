//
//  ActivityIndicator.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 22/01/2022.
//

import UIKit

// MARK: - Core Data stack
/**
 Activity indicator helper
 */
struct ActivityIndicator {
    
    static var spinner: UIActivityIndicatorView?
    static func showActivityIndicator(view:UIView) {
        
        spinner = UIActivityIndicatorView(style: .large)
        spinner?.translatesAutoresizingMaskIntoConstraints = false
        spinner?.startAnimating()
        view.addSubview(spinner!)
        
        spinner?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    static func stopActivityIndicator() {
        spinner?.stopAnimating()
        /// UiView extesion is been used here
        spinner?.remove()
    }
}
