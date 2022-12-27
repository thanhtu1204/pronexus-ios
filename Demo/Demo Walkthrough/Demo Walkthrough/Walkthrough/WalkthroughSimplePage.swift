//
//  WalkthroughSimplePage.swift
//  Demo Walkthrough
//
//  Created by Borinschi Ivan on 13.02.2021.
//

import DSKit
import UIKit

public struct WalkthroughSimplePage {
    
    public init(text: (title: String, description: String, alignment: NSTextAlignment),
                image: (content: DSImageContent, style: DSImageDisplayStyle, height: CGFloat)) {
        
        self.text = text
        self.image = image
    }
    
    let text: (title: String, description: String, alignment: NSTextAlignment)
    let image: (content: DSImageContent, style: DSImageDisplayStyle, height: CGFloat)
}

extension WalkthroughSimplePage {
    
    func viewModel() -> DSPageVM {
        
        let appearance = DSAppearance.shared.main
        
        // Image
        let image = DSImageVM(imageValue: self.image.content,
                              height: .absolute(self.image.height),
                              displayStyle: self.image.style)
        
        // Compose text
        let composer = DSTextComposer(alignment: self.text.alignment)
        let spacing = appearance.interItemSpacing
        
        // Title
        composer.add(type: .headlineWithSize(36), text: self.text.title, spacing: spacing, maximumLineHeight: 34)
        
        // Description
        composer.add(type: .body, text: self.text.description, spacing: spacing)
        
        // Space
        let space = DSSpaceVM()
        
        // Page with view models
        var page = DSPageVM(viewModels: [image, space, composer.textViewModel()])
        page.contentInsets = appearance.margins.edgeInsets
        page.height = .absolute(UIDevice.current.contentAreaHeigh - 90)
        
        return page
    }
}
