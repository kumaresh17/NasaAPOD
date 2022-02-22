//
//  ViewController.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 19/01/2022.
//

import UIKit
import Combine

class NasaViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var apodModelProtocol: [APODModelProtocol]?
    
    private var viewModelProtocol:HomeViewModelProtocol?
    private var anyCancelable = Set<AnyCancellable>()
    lazy var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension;
        viewModelProtocol = HomeViewModel()
        setUpDatePicker()
        bindingOfViewWithViewModel()
        fetchAPOD()
    }
    
    /// Fetch APOD data from Nasa Api
    func fetchAPOD() {
        ActivityIndicator.showActivityIndicator(view: self.view)
        let request = APODRequest(startDate: dateTextField.text, endDate: dateTextField.text)
        viewModelProtocol?.getAODDataForHomeScreen(apodRequest: request)
    }
    
    /// Binding of View with ViewModel here Combine is used
    func bindingOfViewWithViewModel() {
        viewModelProtocol?.dataForViewPub
            .receive(on: DispatchQueue.main)
            .sink {[weak self] (dataView) in
                guard let dataView = dataView else {return}
                self?.apodModelProtocol = dataView
                self?.tableView.reloadData()
                ActivityIndicator.stopActivityIndicator()
            }
            .store(in: &anyCancelable)
        
        viewModelProtocol?.errorPub
            .receive(on:DispatchQueue.main)
            .sink { (error) in
                guard let error = error else {return }
                AlertViewController.showAlert(withTitle:"Alert" , message: error.localizedDescription)
                ActivityIndicator.stopActivityIndicator()
            }
            .store(in: &anyCancelable)
    }

}







