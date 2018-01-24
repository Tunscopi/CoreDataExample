//
//  JSONService.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/24/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import Foundation
import CoreData

struct Service {
  
  static let shared = Service()
  
  let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
  
  func downloadCompaniesFromServer() {
    print("Attempting to download companies...")
    
    guard let url = URL(string: urlString) else {return}
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      print("Finished downloading:")
      
      if let error = error {
        print("Failed to download companies:", error)
        return
      }
      
      guard let data = data else {return}
      
      let jsonDecoder = JSONDecoder()
      
      do {
        let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
        
        jsonCompanies.forEach({ (jsonCompany) in
          print(jsonCompany.name)
          
          let company = Company(context: privateContext)
          company.name = jsonCompany.name
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MM/dd/yyyy"
          let foundedDate = dateFormatter.date(from: jsonCompany.founded)
          
          company.founded = foundedDate
          
          do {
            try privateContext.save()
            try privateContext.parent?.save()
            
          } catch let error {
            print("Failed to save companies:",error)
          }
          
          jsonCompany.employees?.forEach({ (jsonEmployee) in
            print("  \(jsonEmployee.name)")
            
            let employee = Employee(context: privateContext)
            employee.name = jsonEmployee.name
            employee.company = company
            employee.type = jsonEmployee.type
            
            let employeeInformation = EmployeeInformation(context: privateContext)
            let employeeBirthDate = dateFormatter.date(from: jsonEmployee.birthday)
            
            employeeInformation.birthday = employeeBirthDate
            employee.employeeinformation = employeeInformation
          })
          
          do {
            try privateContext.save()
            try privateContext.parent?.save()
            
          } catch let error {
            print("Failed to save companies:",error)
          }
          
        })
        
      } catch let jsonDecodeErr {
        print("Failed to decode:", jsonDecodeErr)
      }
      
      //let string = String(data: data, encoding: .utf8)
    }.resume()
  }
  
}

struct JSONCompany: Decodable {
  let name: String
  let founded: String
  let employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
  let name: String
  let birthday: String
  let type: String
}
