//
//  JPNasaExtensionHelper.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 19/01/2022.
//


import UIKit

/// An image view extension to download image
extension UIImageView {
    func load(url:URL) -> Void {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            } 
        }
    }
}

/// Extension for formatting the date
extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

/// Extension for String date formater
extension String {
    func convertToMonthDayYear() -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd"
         let oldDate = olDateFormatter.date(from: self)
         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "MMM dd, yyyy"
         return convertDateFormatter.string(from: oldDate!)
    }
}

/// Extension of UIApplication to get the connected scene
extension UIApplication {
    var keyWindow: UIWindow? {
        /// Get connected scenes
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

/// A Helper to remove view from the superview
extension UIView {
    func remove() {
        self.removeFromSuperview()
    }
}
/// Date extension to check for invalid data
extension Data {
    func isInValid() -> Bool {
        return self.count > 200 ? false : true
    }
}




