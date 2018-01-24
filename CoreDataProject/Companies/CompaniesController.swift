//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/17/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
  
  var companies = [Company]()
  
  private func fetchCompanies() {
    self.companies = CoreDataManager.shared.fetchCompanies()  // on main  (UI) thread
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchCompanies()
    
    view.backgroundColor = UIColor.white
    
    navigationItem.title = "Companies"
    
    tableView.backgroundColor = .darkBlue
    tableView.separatorColor = .white
    tableView.tableFooterView = UIView()
    tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
    
    setUpPlusButtonInNavBar(selector: #selector(handleAddCompany))
    
    //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
    
    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(doWork)),
      UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
    ]
  }
  
  @objc private func doNestedUpdates() {
    print("Trying to perform nested updates now...")
    
    DispatchQueue.global(qos: .background).async {
      // perform updates
      
      // construct a MOC
      let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
      
      let request: NSFetchRequest<Company> = Company.fetchRequest()
      request.fetchLimit = 1
      do {
        let companies = try privateContext.fetch(request)
        
        companies.forEach({ (company) in
          print(company.name ?? "")
          company.name = "G: \(company.name ?? "")"
        })
        
        do {
          try privateContext.save()
          
          // after save succeeds
          
          DispatchQueue.main.async {
            do
            {
              let context = CoreDataManager.shared.persistentContainer.viewContext
              if context.hasChanges {
                try context.save()
              }
            } catch let finalSaveErr {
              print("Failed to save main context:",finalSaveErr)
            }
            self.tableView.reloadData()
          }
        } catch let saveErr {
          print("Failed to save on private context:", saveErr)
        }
        
      } catch let fetchError {
        print("Failed to fetch on private context:", fetchError)
      }
    }
  }
  
  @objc private func doUpdates() {
    print("Trying to update companies on a background context")
    
    CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
      
      let request: NSFetchRequest<Company> = Company.fetchRequest()
      
      do {
        let companies = try backgroundContext.fetch(request)
        
        companies.forEach({ (company) in
          print(company.name ?? "err")
          company.name = "F: \(company.name ?? "")"
        })

        do {
          try backgroundContext.save()
          
          // update on main UI thread
          DispatchQueue.main.async {
            CoreDataManager.shared.persistentContainer.viewContext.reset()
            self.companies = CoreDataManager.shared.fetchCompanies()
            self.tableView.reloadData()
          }
          
        } catch let saveErr {
          print("Failed to save companies on background:", saveErr)
        }
        
      } catch let fetchError {
        print("Failed to fetch companies on background thread:", fetchError)
      }
      
      
    }
  }
  
  @objc private func doWork() {
    print("Attempting to do work")
    
      CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
        
        (0..<20).forEach { (value) in
          print(value)
          let company = Company(context: backgroundContext)
          company.name = String(value)
        }
        
        do {
          try backgroundContext.save()
          
          DispatchQueue.main.async {
            self.fetchCompanies()
            self.tableView.reloadData()
          }
          
        } catch let error {
          print("Failed to save:", error)
        }
      })
  }
  
  @objc private func handleAddCompany() {
    let createCompanyController = CreateCompanyController()
    let navController = CustomNavigationController(rootViewController: createCompanyController)
    
    createCompanyController.delegate = self
    present(navController, animated: true, completion: nil)
  }
  
  @objc private func handleReset() {
    print("Attempting to delete all core data objects (Batch Delete)")
    
    var indexPathsToRemove = [IndexPath]()
    
    CoreDataManager.shared.resetCompanies()
    
    for(index, _) in companies.enumerated() {
      let indexPath = IndexPath(row: index, section: 0)
      indexPathsToRemove.append(indexPath)
    }
    
    companies.removeAll()
    tableView.deleteRows(at: indexPathsToRemove, with: .left)
  }
}

