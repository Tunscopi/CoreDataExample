//
//  EmployeeCell.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/19/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
  
  var employee: Employee? {
    didSet {
      
    }
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
