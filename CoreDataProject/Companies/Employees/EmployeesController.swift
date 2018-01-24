//
//  EmployeesController.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/19/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import UIKit

// Create a UILabel subclass for custom text drawing
class IndentedLabel: UILabel {
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    let customRect = UIEdgeInsetsInsetRect(rect, insets)
    super.drawText(in: customRect)
  }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
  
  func didAddEmployee(employee: Employee) {
    guard let section = employeeTypes.index(of: employee.type!) else {return}
    let row = allEmployees[section].count
    let insertionIndexPath  = IndexPath(row: row, section: section)
    
    allEmployees[section].append(employee)
    tableView.insertRows(at: [insertionIndexPath], with: .middle)
  }
  
  var company: Company?

  var allEmployees = [[Employee]]()
  let cellId = "cellE"
  
  var employeeTypes = [
    EmployeeType.Executive.rawValue,
    EmployeeType.SeniorManagement.rawValue,
    EmployeeType.Staff.rawValue,
    EmployeeType.Intern.rawValue
  ]
  
  private func fetchEmployees() {
    print("fetching employees..")
    
    guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}

    allEmployees = []
    // filter employees based on type
    employeeTypes.forEach { (employeeType) in
      allEmployees.append(
        companyEmployees.filter { $0.type == employeeType }
      )
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = company?.name
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = UIColor.darkBlue
    tableView.tableFooterView = UIView()
    tableView.register(EmployeeCell.self, forCellReuseIdentifier: cellId)

    setUpPlusButtonInNavBar(selector: #selector(handleAdd))
    
    fetchEmployees()
  }
  
  @objc func handleAdd() {
    print("Attempting to add new employee")
    
    let createEmployeeController = CreateEmployeeController()
    createEmployeeController.delegate = self
    createEmployeeController.company = company
    let navController = UINavigationController(rootViewController: createEmployeeController)
    present(navController, animated: true, completion: nil)
  }
}
