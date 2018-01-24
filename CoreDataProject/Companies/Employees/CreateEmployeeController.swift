//
//  CreateEmployeeController.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/19/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
  func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
  
  var delegate: CreateEmployeeControllerDelegate?
  
  var company: Company?
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Name"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let birthdayLabel: UILabel = {
    let label = UILabel()
    label.text = "Birthday"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter name"
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let birthdayTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "MM/dd/yyyy"
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .darkBlue
    
    navigationItem.title = "Create Employee"
    
    setupCancelButton()
    
    setupUI()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
  }
  
  @objc private func handleSave() {
    guard let employeeName = nameTextField.text else {return}
    guard let company = company else {return}
    
    // turn birthdayTextField.text to a date object
    guard let birthdayText = birthdayTextField.text else {return}
    
    // validation
    if birthdayText.isEmpty {
      showAlertError(title: "Missing Birthday", message: "Please enter birthday date")
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    
    guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
      showAlertError(title: "Invalid Date", message: "Please use the MM/dd/yyyy format")
      return
    }
    
    guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else {return}
    
    let tuple  = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
    
    if let error = tuple.1 {
      print(error)
    } else {
      dismiss(animated: true, completion: {
        self.delegate?.didAddEmployee(employee: tuple.0!)
      })
    }
  }
  
  private func showAlertError(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
  
  let employeeTypeSegmentedControl: UISegmentedControl = {
    let types = [
      EmployeeType.Executive.rawValue,
      EmployeeType.SeniorManagement.rawValue,
      EmployeeType.Staff.rawValue,
      EmployeeType.Intern.rawValue
    ]
    let sc = UISegmentedControl(items: types)
    sc.selectedSegmentIndex = 0
    sc.translatesAutoresizingMaskIntoConstraints = false
    sc.tintColor = UIColor.darkBlue
    return sc
  }()
  
  private func setupUI() {
    _ = setupLightBlueBackgroundView(height: 150)
    
    view.addSubview(nameLabel)
    nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(nameTextField)
    nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
    nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
    nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
    nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
    
    view.addSubview(birthdayLabel)
    birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
    birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    view.addSubview(birthdayTextField)
    birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
    birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
    birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
    birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
    
    view.addSubview(employeeTypeSegmentedControl)
    employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
    employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
    employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
  }
}
