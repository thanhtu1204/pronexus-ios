//
//  FF.swift
//  Demo Walkthrough
//
//  Created by Borinschi Ivan on 13.02.2021.
//

import DSKit
import UIKit

public enum WalkthroughPage {
    case simple(WalkthroughSimplePage)
}

extension Array where Element == WalkthroughPage {
    
    func walkthroughPages() -> [DSPageVM] {
        
        self.map { (type) -> DSPageVM in
            switch type {
            case.simple(let page):
                return page.viewModel()
            }
        }
    }
}
