//
//  NasaViewControllerExtension.swift
//  JPNasaAPOD
//
//  Created by kumaresh shrivastava on 20/01/2022.
//
import UIKit
import Foundation

// MARK: - Table data source delegates

extension NasaViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return  self.apodModelProtocol?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ADOTableViewCell.cellIdentifier, for: indexPath) as? ADOTableViewCell else {
            fatalError("no cell initialized")
        }
        guard let dataValue = self.apodModelProtocol else {return cell}
        cell.configureCell(with: dataValue[indexPath.row] )
        
        return cell
    }
    
}
