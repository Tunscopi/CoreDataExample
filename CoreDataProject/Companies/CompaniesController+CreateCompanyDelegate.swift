//
//  CompaniesController+CreateCompanyDelegate.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/19/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
  
  // we implement the CreateCompanyController Delegate functions
  func didAddCompany(company: Company) {
    companies.append(company)
    
    let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
    tableView.insertRows(at: [newIndexPath], with: .automatic)
  }
  
  func didEditCompany(company: Company) {
    let row = companies.index(of: company)
    
    let reloadIndexPath = IndexPath(row: row!, section: 0)
    tableView.reloadRows(at: [reloadIndexPath], with: .middle)
  }
  
  // specify extension methods here
  
}
