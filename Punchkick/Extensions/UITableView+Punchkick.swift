//
//  UITableView+Punchkick.swift
//  Punchkick
//
//  Created by Donald Largen on 6/11/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable {
  static var reuseIdentifier: String { get }
  static var nib: UINib { get }
}

extension Reusable {
  static var reuseIdentifier: String { return String(describing: self) }
  static var nib : UINib { return UINib(nibName: String(describing: self), bundle: nil) }
}

extension UITableView {
  func dequeueReusableCell<T>(indexPath: IndexPath) -> T where T: Reusable {
    return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
  
  func dequeueReusableCell<T>() -> T where T: Reusable {
    return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
  }
  
  func dequeReusableHeaderFooter<T>() -> T where T: Reusable {
    return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
  }
  
  func registerReusableCell<T>(type: T.Type) where T: Reusable {
    self.register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
  }
  
  func registerReusableHeaderFooter<T>(type: T.Type) where T: Reusable {
    self.register(type.nib, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
  }
}
