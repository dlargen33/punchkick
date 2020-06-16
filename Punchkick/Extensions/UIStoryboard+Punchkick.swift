//
//  UIStoryboard+Punchkick.swift
//  Punchkick
//
//  Created by Donald Largen on 6/15/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    class func main() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiateReusableViewController<T>() -> T where T:Reusable {
        return self.instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
    }
    
    class func movieDetailViewController() -> MovieDetailViewController {
        let vc: MovieDetailViewController = UIStoryboard.main().instantiateReusableViewController()
        return vc
    }
}
