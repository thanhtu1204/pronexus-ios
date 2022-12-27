//
//  Double.swift
//  ProNexus
//
//  Created by thanh cto on 04/12/2021.
//

import Foundation


//yourDouble.round(to:2)
extension Double {
    func round(to decimalPlaces: Int) -> Double {
        let precisionNumber = pow(10, Double(decimalPlaces))
        var n = self // self is a current value of the Double that you will round
        n = n * precisionNumber
        n.round()
        n = n / precisionNumber
        return n
    }
}
