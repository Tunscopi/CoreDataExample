//
//  UIViewController+Helpers.swift
//  CoreDataProject
//
//  Created by Tunscopi on 1/19/18.
//  Copyright © 2018 Ayotunde. All rights reserved.
//

import UIKit

extension UIViewController {
  // extension/ helper methods

  func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
    let lightBlueBackgroundView = UIView()
    lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
    lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(lightBlueBackgroundView)
    lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
    
    return lightBlueBackgroundView
  }
  
  func setUpPlusButtonInNavBar(selector: Selector) {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
  }
  
  func setupCancelButton() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
  }
  
  @objc func handleCancelModal() {
    dismiss(animated: true, completion: nil)
  }
}
