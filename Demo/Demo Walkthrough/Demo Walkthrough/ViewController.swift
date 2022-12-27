//
//  ViewController.swift
//  Demo Walkthrough
//
//  Created by Borinschi Ivan on 13.02.2021.
//

import Foundation
import DSKit
import UIKit

open class ViewController: DSViewController {
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Space
        let space = DSSpaceVM(type: .custom(200))
        
        // Composer
        let composer = DSTextComposer(alignment: .center)
        composer.add(type: .headlineWithSize(36), text: "Welcome")
        composer.add(type: .subheadline, text: "To walkthrough Demo")
        
        // Show space and composer text view models
        show(content: [space, composer.textViewModel()])
        
        // Button
        var button = DSButtonVM(title: "Start")
        
        // Handle button tap
        button.didTap { (_ :DSButtonVM) in
                         
            // Show walkthrough demo
            self.present(vc: WalkthroughViewController(pages: WalktroughtData().getFashionPages()))
        }
        
        // Show bottom button
        showBottom(content: button)
    }
}
