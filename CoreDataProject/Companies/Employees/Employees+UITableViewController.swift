//
//  Employees+UITableViewController.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/19/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import UIKit

extension EmployeesController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allEmployees[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.backgroundColor = .tealColor
    cell.textLabel?.textColor = .white
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    
    let employee = allEmployees[indexPath.section][indexPath.row]
    cell.textLabel?.text = employee.name
    
    if let birthday = employee.employeeinformation?.birthday {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM dd, yyyy"
    
      cell.textLabel?.text = "\(employee.name ?? "") \(dateFormatter.string(from: birthday))"
    }
    //    if let taxId = employee.employeeinformation?.taxId {
    //      cell.textLabel?.text = "\(employee.name ?? "") \(taxId)"
    //    }
    return cell
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return allEmployees.count
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = IndentedLabel()
    label.backgroundColor = .lightBlue
    label.text = employeeTypes[section]
    label.textColor = .darkBlue
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "No employees available"
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }

  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return allEmployees[section].count == 0 ? 45 : 0
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}
