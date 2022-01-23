//
//  JPNasaViewDatePickerExtension.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 21/01/2022.
//

import UIKit

// MARK: - Date Picker and Toolbar

/**
 This extension is used for just to show Date picker and bind with UiTextField and handle the user interaction of done and cancel.
 */
extension JPNasaViewController {
    
    func setUpDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        ///Taking frame here as the toolbar doens't have ancestor to qualify for layout constraints to be set
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:44))
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        dateTextField.text = DateFormatter.yyyyMMdd.string(from: Date())
    }
    
    @objc func doneDatePicker() {
        dateTextField.text = DateFormatter.yyyyMMdd.string(from: self.datePicker.date)
        self.view.endEditing(true)
        fetchAPOD()
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}
