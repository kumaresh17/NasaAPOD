//
//  ViewController.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 19/01/2022.
//

import UIKit
import Combine

class JPNasaViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = HomeViewModel()
    var anyCancelable = Set<AnyCancellable>()
    var spinner: UIActivityIndicatorView?
    lazy var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension;
        setUpDatePicker()
        bindingOfViewWithViewModel()
       // fetchAPOD()
    }
    
    /// Fetch APOD data from Nasa Api
    func fetchAPOD() {
       
        ActivityIndicator.showActivityIndicator(view: self.view)
        let request = APODRequest(startDate: dateTextField.text, endDate: dateTextField.text)
        viewModel.getAODDataForHomeScreen(apodRequest: request)
    }
    
    /// Binding of View with ViewModel here Combine is used
    func bindingOfViewWithViewModel() {
        viewModel.$dataForView
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                guard ((self?.viewModel.dataForView) != nil) else {return}
                self?.tableView.reloadData()
                ActivityIndicator.stopActivityIndicator()
            }
            .store(in: &anyCancelable)
        
        viewModel.$error
            .receive(on:DispatchQueue.main)
            .sink {[weak self] _ in
                guard let error = self?.viewModel.error else { return }
                AlertViewController.showAlert(withTitle:"Alert" , message: error.localizedDescription)
                ActivityIndicator.stopActivityIndicator()
            }
            .store(in: &anyCancelable)
    }

}







