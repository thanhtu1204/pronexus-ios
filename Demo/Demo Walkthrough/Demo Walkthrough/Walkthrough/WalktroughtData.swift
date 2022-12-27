//
//  WalktroughtData.swift
//  Demo Walkthrough
//
//  Created by Borinschi Ivan on 16.02.2021.
//

import UIKit

class WalktroughtData {
    
    func getFashionPages() -> [WalkthroughPage] {
        
        return [.simple(getDiscoverPage()),
                .simple(getFindPage()),
                .simple(getDifferencePage())]
    }
    
    func getDiscoverPage() -> WalkthroughSimplePage {
        
        let title = "Discover clothes, accessories, and more."
        let subtitle = "Get all brands in one place.\nFill the bag full of joy."
        let image = UIImage(named: "s1")
        
        return WalkthroughSimplePage(text: (title: title, description: subtitle, alignment: .center),
                                     image: (content: .image(image: image), style: .circle, height: 300))
    }
    
    func getFindPage() -> WalkthroughSimplePage {
        
        let title = "Find everything you need"
        let subtitle = "Get all brands in one place.\nFill the bag full of joy."
        let image = UIImage(named: "s2")
        
        return WalkthroughSimplePage(text: (title: title, description: subtitle, alignment: .left),
                                     image: (content: .image(image: image), style: .themeCornerRadius, height: 350))
    }
    
    func getDifferencePage() -> WalkthroughSimplePage {
        
        let title = "Feel the difference"
        let subtitle = "Get all brands at one place, Fill the bag with full of joy."
        let image = UIImage(named: "s3")
        
        return WalkthroughSimplePage(text: (title: title, description: subtitle, alignment: .left),
                                     image: (content: .image(image: image), style: .themeCornerRadius, height: 350))
    }
}
