//
//  CoreDataManager.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/17/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import CoreData

struct CoreDataManager {
  static let shared = CoreDataManager()
  
  let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "sampleCoreData")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error {
        fatalError("Loading of store failed \(error)")
      }
    }
    return container
  }()
  
  func fetchCompanies() ->[Company] {
    let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
    let context = persistentContainer.viewContext

    do {
      let companies = try context.fetch(fetchRequest)
      return companies
    } catch let fetchError {
      print("Failed to fetch companies:", fetchError)
      return []
    }
  }
  
  func fetchEmployees() -> [Employee] {
    let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
    let context = persistentContainer.viewContext
    
    do {
      let employees = try context.fetch(fetchRequest)
      return employees
    } catch let fetchError {
      print("Failed to fetch employees:", fetchError)
      return []
    }
  }
  
  func resetCompanies() {
    let context = persistentContainer.viewContext
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
    
    do {
      try context.execute(batchDeleteRequest)
      
    } catch let batchDeleteError {
      print("Failed to delete all core data objects: ", batchDeleteError)
    }
  }
  
  func createEmployee(employeeName: String, employeeType: String, birthday: Date, company: Company) -> (Employee?, Error?) {
    let context = persistentContainer.viewContext
    
    let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
    
    employee.setValue(employeeName, forKey: "name")
    
    employee.company = company
    employee.type = employeeType
    
    let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
    employeeInformation.taxId = "456"
    employeeInformation.birthday = birthday
    employee.employeeinformation = employeeInformation
    
    do {
      try context.save()
      return (employee, nil)
    } catch let saveError {
      print("Failed to create new employee in core data: ", saveError)
      return (nil, saveError)
    }
  }
}
