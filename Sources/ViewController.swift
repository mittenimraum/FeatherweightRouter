//
//  ViewController.swift
//  
//
//  Created by Stephan Schulz on 24.05.17.
//  Copyright © 2017 Stephan Schulz. All rights reserved.
//

import Foundation
import UIKit

protocol MemoryDisposable {
    mutating func dispose()
}

class ViewController: UIViewController {
    
}

extension ViewController: MemoryDisposable {
    
    @objc
    func dispose() {
        
    }
}
