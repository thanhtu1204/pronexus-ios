//
//  ViewController.swift
//  Demo Appearance
//
//  Created by Borinschi Ivan on 10.02.2021.
//

import UIKit
import DSKit

class ViewController: DSViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appearance"
        updateContent()
    }
    
    func updateContent() {
        show(content: [interfaceStyleSection(), appearancesSection()], animated: false)
    }
}

extension ViewController {
    
    /// Interface style section
    /// - Returns: DSSection
    func interfaceStyleSection() -> DSSection {
        
        let system = getAction(for: .unspecified)
        let dark = getAction(for: .dark)
        let light = getAction(for: .light)
        
        return [system, dark, light].list().headlineHeader("Interface Style")
    }
    
    /// Get appearances section
    /// - Returns: DSSection
    func appearancesSection() -> DSSection {
        
        /// Get all available appearances in dskit
        var appearances = DSAppearance.allAppearances()
        
        let viewModels: [DSViewModel] = appearances.map { (theme) -> DSActionVM in
            return getAction(for: theme)
        }
        
        /// Section
        let listSection = viewModels.list()
        
        /// Set header text view model with headline style
        listSection.headlineHeader("Appearances")
        
        return listSection
    }
}

extension ViewController {
    
    /// Get action for appearance
    /// - Parameter appearance: DSDesignable
    /// - Returns: DSActionVM
    func getAction(for appearance: DSDesignable) -> DSActionVM {
        
        // Action with title
        var action = DSActionVM(title: appearance.title)
        
        /// Set companion object
        action.object = appearance as AnyObject
        
        // If current appearance is equal to appearance then config it as selected one
        if DSAppearance.shared.main.title == appearance.title {
            
            // Set right icon with selected brand color for tint
            action.rightIcon(sfSymbolName: "checkmark.circle.fill", tintColor: .custom(appearance.brandColor))
        } else {
            
            // Set right icon as empty circle
            action.rightIcon(sfSymbolName: "circle")
        }
        
        // Handle did tap on action
        action.didTap { (action: DSActionVM) in
            
            // Get appearance from object
            guard let appearance = action.object as? DSDesignable else {
                return
            }
            
            // Set as current appearance
            DSAppearance.shared.main = appearance
            
            // Call update content to update interface
            self.updateContent()
        }
        
        return action
    }
    
    /// Get action for user interface style
    /// - Parameter style: UIUserInterfaceStyle
    /// - Returns: DSActionVM
    func getAction(for style: UIUserInterfaceStyle) -> DSActionVM {
        
        var name = ""
        var icon = ""
        var description: String?
        
        switch style {
        case .dark:
            name = "Dark"
            icon = "moon.circle.fill"
        case .light:
            name = "Light"
            icon = "sun.max.fill"
        default:
            name = "System"
            icon = "gear"
            description = "Based on user iOS settings"
        }
        
        // Action with title and subtitle
        var action = DSActionVM(title: name, subtitle: description)
        
        // Set style as companion object
        action.object = style as AnyObject
        
        // Set left icon
        action.leftIcon(sfSymbolName: icon)
        
        // If current style is equal to style then config it as selected one
        if DSAppearance.shared.userInterfaceStyle == style {
            
            // Set right icon with selected brand color for tint
            action.rightIcon(sfSymbolName: "checkmark.circle.fill", tintColor: .custom(appearance.brandColor))
            
        } else {
            
            // Set right icon as empty circle
            action.rightIcon(sfSymbolName: "circle")
        }
        
        // Handle did tap on action
        action.didTap { (action: DSActionVM) in
            
            guard let style = action.object as? UIUserInterfaceStyle else {
                return
            }
            
            DSAppearance.shared.userInterfaceStyle = style
            self.updateContent()
        }
        
        return action
    }
}
