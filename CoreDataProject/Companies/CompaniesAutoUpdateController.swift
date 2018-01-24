//
//  CompaniesAutoUpdateController.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/23/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
    let context = CoreDataManager.shared.persistentContainer.viewContext

    let request: NSFetchRequest<Company> = Company.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(key: "name", ascending: true)
    ]
    
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
    frc.delegate = self
    
    do {
      try frc.performFetch()
      
    } catch let fetchError {
      print("Failed to fetch:", fetchError)
    }
    
    return frc
  }()
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
    return sectionName
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .move:
      break
    case .update:
      break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .fade)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .move:
      tableView.moveRow(at: indexPath!, to: newIndexPath!)
    }
  }
  
  @objc private func handleAdd() {
    print("Let's add a company called BMZ")
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    let company = Company(context: context)
    company.name = "BMZ"
    
    do {
      try context.save()
    } catch let saveErr {
      print("Failed to save:", saveErr)
    }
  }
  
  @objc private func handleDelete() {
    let request: NSFetchRequest<Company> = Company.fetchRequest()
    //request.predicate = NSPredicate(format: "name CONTAINS %@", "B")
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    let companiesWithLetter = try? context.fetch(request)
    
    companiesWithLetter?.forEach({ (company) in
      context.delete(company)
    })
    
    try? context.save()
  }
  
  @objc private func handleRefresh() {
    Service.shared.downloadCompaniesFromServer()
    refreshControl?.endRefreshing()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Company Auto Updates"
    
    //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
    
    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
      UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
    ]
    
    tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
    tableView.backgroundColor = UIColor.darkBlue
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    refreshControl.tintColor = .white
    
    self.refreshControl = refreshControl
    
//    fetchedResultsController.fetchedObjects?.forEach({ (company) in
//      //print(company.name ?? "")
//    })
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = IndentedLabel()
    if fetchedResultsController.sectionIndexTitles.count > 0 {
      label.text = fetchedResultsController.sectionIndexTitles[section]
    }
    label.backgroundColor = UIColor.lightBlue
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections![section].numberOfObjects
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
    
    let company = fetchedResultsController.object(at: indexPath)
    cell.company = company
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let employeesListController = EmployeesController()
    employeesListController.company = fetchedResultsController.object(at: indexPath)
    
    navigationController?.pushViewController(employeesListController, animated: true)
  }
}
