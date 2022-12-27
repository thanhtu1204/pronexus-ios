//
//  WalkthroughViewController.swift
//  Demo Walkthrough
//
//  Created by Borinschi Ivan on 13.02.2021.
//

import Foundation
import DSKit
import UIKit

open class WalkthroughViewController: DSViewController {
    
    let pages: [WalkthroughPage]
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Page control
        let pageControl = DSPageControlVM(type: .pages(pages.walkthroughPages()))
                
        var skipButton = DSButtonVM(title: "Skip page", type: .link)
        skipButton.height = .absolute(20)
        skipButton.didTap = { _ in
            self.dismiss()
        }
        
        // Show gallery
        show(content: [pageControl.list().zeroLeftRightInset(), skipButton.list()])
    }
    
    /// Init walktrought page with pages
    /// - Parameter pages: [WalkthroughPage]
    public init(pages: [WalkthroughPage]) {
        self.pages = pages
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
