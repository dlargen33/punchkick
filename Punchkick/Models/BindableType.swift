//
//  BindableType.swift
//  Punchkick
//
//  Created by Donald Largen on 6/14/20.
//  Copyright © 2020 Donald Largen. All rights reserved.
//

import Foundation

class BindableType<T> {
    
    var bind: (T) -> () = { _ in }
    
    var value: T {
        didSet {
            bind(value)
        }
    }
    
    init( _ val: T) {
        value = val
    }
}
