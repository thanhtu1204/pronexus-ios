//
//  GridView.swift
//  ProNexus
//
//  Created by Tú Dev app on 07/11/2021.
//

import SwiftUI

struct GridView<Content, T>: View where Content: View {
    // MARK: - Properties
    var totalNumberOfColumns: Int
    var numberRows: Int {
        return (items.count - 1) / totalNumberOfColumns
    }
    var items: [T]
    /// A parameter to store the content passed in the ViewBuilder.
    let content: (_ calculatedWidth: CGFloat,_ type: T) -> Content
    
    // MARK: - Init
    init(columns: Int, items: [T], @ViewBuilder content: @escaping(_ calculatedWidth: CGFloat,_ type: T) -> Content) {
        self.totalNumberOfColumns = columns
        self.items = items
        self.content = content
    }
    
    // MARK: - Helpers
    /// A function which help checking if the item exist in the specified index to avoid index out of range error.
    func elementFor(row: Int, column: Int) -> Int? {
        let index:Int = row * self.totalNumberOfColumns + column
        return index < items.count ? index : nil
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false){
                VStack (alignment: .center) {
                    ForEach(0...self.numberRows,id: \.self) { (row) in
                        HStack {
                            ForEach(0..<self.totalNumberOfColumns) { (column) in
                                Group {
                                    if (self.elementFor(row: row, column: column) != nil)  {
                                        self.content(geometry.size.width / CGFloat(self.totalNumberOfColumns), self.items[self.elementFor(row: row, column: column)!])
                                            .frame(width: geometry.size.width / CGFloat(self.totalNumberOfColumns), height: geometry.size.width / (CGFloat(self.totalNumberOfColumns)), alignment: .center).background(Color.red)
                                    }else {
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
}
