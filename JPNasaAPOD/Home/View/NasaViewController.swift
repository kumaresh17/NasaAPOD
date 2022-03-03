//
//  ViewController.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 19/01/2022.
//

import UIKit
import Combine

class NasaViewController: UIViewController {
    
    /// UITextfield and UITableview is unwrap as they are properties of Storyboard interface builder and expected to have instance value.
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var apodModelProtocol: [APODModelProtocol]?
    
    private var viewModelProtocol:HomeViewModelProtocol?
    
    /// To store the publisher stream, if we don't store,  it will not sink the stream and will be cancelled immediatelly.
    private var anyCancelable = Set<AnyCancellable>()
    lazy var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        setUpDatePicker()
        let request = APODRequest(startDate: dateTextField.text, endDate: dateTextField.text)
        viewModelProtocol = HomeViewModel.init(apodRequest: request)
        bindingOfViewWithViewModel()
        fetchAPOD()
    }
    
    /// Ask View Model to get APOD data
    func fetchAPOD() {
        ActivityIndicator.showActivityIndicator(view: self.view)
        viewModelProtocol?.getAODDataForHomeScreen(apodRequest: APODRequest(startDate: dateTextField.text, endDate: dateTextField.text))
    }
    
    /// Binding of View with ViewModel here Combine is used
   private func bindingOfViewWithViewModel() {
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







