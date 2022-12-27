//
//  View.swift
//  ProNexus
//
//  Created by thanh cto on 28/10/2021.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
    
    func appFont(style: UIFont.TextStyle = .body, weight: Font.Weight = .regular, size: CGFloat = 0, color: Color = .black) -> some View {
        self.modifier(CustomFontModifier(style: style, weight: weight, size: size, color: color))
    }
    
    func myFont(style: UIFont.TextStyle = .body, weight: Font.Weight = .regular, size: CGFloat = 0, color: Color = .black) -> some View {
        self.modifier(CustomFontModifier(style: style, weight: weight, size: size, color: color))
    }
    
    func bold(size: CGFloat = 14, color: Color = .black) -> some View {
        self.modifier(CustomFontModifier(style: .body, weight: .bold, size: size, color: color))
    }
    
    func regular(size: CGFloat = 14, color: Color = .black) -> some View {
        self.modifier(CustomFontModifier(style: .body, weight: .regular, size: size, color: color))
    }
    
    // get chieu rong cua view
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
    func screenWidth()->CGFloat{
        return UIScreen.main.bounds.size.width
    }
    
    func screenHeight()->CGFloat{
        return UIScreen.main.bounds.size.height
    }
    
    func myShadow() -> some View {
          self.modifier(shadowModifier())
    }
    
    func halfWidth()->CGFloat{
        let col = 2.0
        return UIScreen.main.bounds.size.width / CGFloat(col)
    }

    func containerWidth()->CGFloat{
        return UIScreen.main.bounds.size.width - 74
    }
        
    func isAdvisorRole() -> Bool {
        if let user = Defaults.userLogger
        {
            return user.role == UserRole.advisor.rawValue
        } else
        {
            return false
        }
    }
    
    func isUserRole() -> Bool {
        if let user = Defaults.userLogger
        {
            return user.role == UserRole.user.rawValue
        } else
        {
            return false
        }
    }
    
    func getIdByRole() -> String {
        if let user = Defaults.userLogger
        {
            if user.role == UserRole.advisor.rawValue
            {
                return user.providerID ?? ""
            }
            return user.customerID ?? ""
        }
        return ""
    }
}
