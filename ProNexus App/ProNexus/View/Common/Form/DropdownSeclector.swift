//
//  DropdownSeclector.swift
//  ProNexus
//
//  Created by TUYEN on 11/15/21.
//

import SwiftUI

struct DropdownOption: Hashable {
    let key: String
    let value: String
    
    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }
}

struct DropdownRow: View {
    var option: DropdownOption
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    
    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                Text(self.option.value)
                    .appFont(style: .body, color: Color.black)
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.white)
    }
}

struct Dropdown: View {
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                }
            }
        }
        .frame(minHeight: CGFloat(options.count) * 30, maxHeight: 250)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(hex: "#CCCCCC"), lineWidth: 0.5)
        ).background(Color.white)
    }
}

struct DropdownSelector: View {
    @State private var shouldShowDropdown = false
    @State private var selectedOption: DropdownOption? = nil
    var label = ""
    var placeholder = ""
    @State var required = false
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    private let buttonHeight: CGFloat = 45
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 2, content: {
                if !label.isBlank
                {
                    FieldLabel(label: self.label, required: self.required)
                }
                
                Button(action: {
                    self.shouldShowDropdown.toggle()
                }) {
                    HStack {
                        Text(selectedOption == nil ? placeholder : selectedOption!.value)
                            .appFont(style: .body, color: selectedOption == nil ? Color.gray: Color.black)
                        
                        Spacer()
                        
                        Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 9, height: 5)
                        //                    .font(Font.system(size: 9, weight: .regular))
                            .foregroundColor(Color(hex: "#808080"))
                    }
                }
                .padding(.horizontal)
                //        .cornerRadius(15)
                //        .padding(10)
                .frame(height: self.buttonHeight)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color(hex: "#B3B3B3"), lineWidth: 0.2)
                )
                .overlay(
                    VStack {
                        if self.shouldShowDropdown {
                            Spacer(minLength: 10)
                            Dropdown(options: self.options, onOptionSelected: { option in
                                shouldShowDropdown = false
                                selectedOption = option
                                self.onOptionSelected?(option)
                            })
                        }
                    }, alignment: .topLeading
                )
                Spacer()
            })
        }
//            .background(Color.gray)
    }
}

struct DropdownSelector_Previews: PreviewProvider {
    static var uniqueKey: String {
        UUID().uuidString
    }
    
    static let options: [DropdownOption] = [
        DropdownOption(key: uniqueKey, value: "Sunday"),
        DropdownOption(key: uniqueKey, value: "Monday"),
        DropdownOption(key: uniqueKey, value: "Tuesday"),
        DropdownOption(key: uniqueKey, value: "Wednesday"),
        DropdownOption(key: uniqueKey, value: "Thursday"),
        DropdownOption(key: uniqueKey, value: "Friday"),
        DropdownOption(key: uniqueKey, value: "Saturday")
    ]
    
    
    static var previews: some View {
        Group {
            DropdownSelector(
                label: "sdgs",
                placeholder: "Day of the week", required: true,
                options: [
                    DropdownOption(key: uniqueKey, value: "Sunday"),
                    DropdownOption(key: uniqueKey, value: "Monday"),
                    DropdownOption(key: uniqueKey, value: "Tuesday"),
                    DropdownOption(key: uniqueKey, value: "Wednesday"),
                    DropdownOption(key: uniqueKey, value: "Thursday"),
                    DropdownOption(key: uniqueKey, value: "Friday"),
                    DropdownOption(key: uniqueKey, value: "Saturday")
                ],
                onOptionSelected: { option in
                    print(option)
                })
                .padding(.horizontal)
            
        }
    }
}
