//
//  ViewController.swift
//  Demo Layout
//
//  Created by Borinschi Ivan on 10.02.2021.
//

import UIKit
import DSKit

class ViewController: DSViewController {
    
    struct Product {
        let title: String
        let price: DSPrice
        let pictureName: String
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Furniture"
        
        show(content: [gallerySection(),
                       gridSection(),
                       listSection()])
    }
    
    /// Make gallery section
    /// - Returns: DSSection
    func gallerySection() -> DSSection {
        
        // Gallery
        let galleryModels = galleryProducts().map { (product) -> DSViewModel in
            
            let composer = DSTextComposer()
            composer.add(type: .headline, text: product.title)
            composer.add(price: product.price)
            
            var action = DSActionVM(composer: composer)
            action.rightButton(sfSymbolName: "cart.fill.badge.plus") {
                print("Add to cart")
            }
            action.topImage(image: UIImage(named: product.pictureName), contentMode: .scaleAspectFill)
            action.height = .absolute(250)
            
            return action
        }
        
        let pageControl = DSPageControlVM(type: .viewModels(galleryModels))
        
        return pageControl.list().zeroLeftRightInset()
    }
    
    /// Make grid section
    /// - Returns: DSSection
    func gridSection() -> DSSection {
        
        // Grid
        let gridImagesModels = gridProducts().map { (product) -> DSViewModel in
            
            // Text composer
            let composer = DSTextComposer(alignment: .center)
            composer.add(type: .caption1, text: product.title)
            
            // Action
            var action = DSActionVM(composer: composer)
            action.height = .absolute(150)
            action.topImage(image: UIImage(named: product.pictureName), height: .unknown, contentMode: .scaleAspectFill)
            return action
        }
        
        // Grid section
        let gridSection = gridImagesModels.grid(columns: 3)
        
        // Grid header view model
        var headerViewModel = DSActionVM(title: "Styled Chairs")
        headerViewModel.style.displayStyle = .default
        headerViewModel.rightButton(title: "View All", sfSymbolName: "chevron.right", style: .small) {
            print("View All")
        }
        
        // Set header view model to grid section header
        gridSection.header = headerViewModel
        
        return gridSection
    }
    
    /// Make list section
    /// - Returns: DSSection
    func listSection() -> DSSection {
        
        // List
        let listImagesModels = listProducts().map { (product) -> DSViewModel in
            DSImageVM(image: UIImage(named: product.pictureName), height: .absolute(150))
        }
        
        return listImagesModels.list().headlineHeader("Office Furniture")
    }
}

extension ViewController {
    
    func gridProducts() -> [Product] {
        
        return [Product(title: "Dark color chair", price: DSPrice(amount: "45.0", currency: "$"), pictureName: "p1"),
                Product(title: "White leather chair", price: DSPrice(amount: "80.0", currency: "$"), pictureName: "p2"),
                Product(title: "Beige wood chair", price: DSPrice(amount: "50.0", regularAmount: "100.0", currency: "$", discountBadge: "50% Off"), pictureName: "p3"),
                Product(title: "Fabric gray chair", price: DSPrice(amount: "50.0", currency: "$"), pictureName: "p4"),
                Product(title: "Two chairs and table", price: DSPrice(amount: "400.0", currency: "$"), pictureName: "p5")]
    }
    
    func galleryProducts() -> [Product] {
        
        return [Product(title: "Orange Sofa", price: DSPrice(amount: "120.0", currency: "$"), pictureName: "l2"),
                Product(title: "White plastic chair", price: DSPrice(amount: "140.0", regularAmount: "100.0", currency: "$", discountBadge: "50% Off"), pictureName: "l3"),
                Product(title: "White leather office chair", price: DSPrice(amount: "80.0", currency: "$"), pictureName: "l5"),
                Product(title: "Blue office chair", price: DSPrice(amount: "70.0", currency: "$"), pictureName: "l4"),
                Product(title: "White table", price: DSPrice(amount: "67.0", currency: "$"), pictureName: "l1")]
    }
    
    func listProducts() -> [Product] {
        
        return [Product(title: "Blue office chair", price: DSPrice(amount: "70.0", currency: "$"), pictureName: "l4"),
                Product(title: "White leather office chair", price: DSPrice(amount: "80.0", currency: "$"), pictureName: "l5"),
                Product(title: "White table", price: DSPrice(amount: "67.0", currency: "$"), pictureName: "l1"),
                Product(title: "Orange sofa", price: DSPrice(amount: "120.0", currency: "$"), pictureName: "l2"),
                Product(title: "White plastic chair", price: DSPrice(amount: "140.0", regularAmount: "100.0", currency: "$", discountBadge: "50% Off"), pictureName: "l3"),]
    }
}
