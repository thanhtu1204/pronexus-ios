//
//  MyTextField.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import SwiftUI
import FieldValidatorLibrary
import Combine

public enum typeField {
    case text
    case phone
    case email
    case number
    case decimal
    case money
}

struct MyTextField: View {
    var label = ""
    var placeholder = ""
    var type: typeField = .text //text, email, phone
    @Binding var value:String
    @StateObject var fieldValid = FieldChecker2<String>()
    @State var showError: Bool = false
    @State var required = false
    @State var readOnly = false
    @State var horizontal = false
    @State var isToolsForm = false
    var height: CGFloat = 45
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        if(horizontal){
            VStack(alignment: .leading, spacing: 2, content: {
                HStack{
                    if !label.isBlank
                    {
                        if (isToolsForm) {
                            ToolsFieldLabel(label: self.label, required: self.required)
                        } else {
                            FieldLabel(label: self.label, required: self.required)
                        }
                    }
                    
                    Spacer()
                    TextField( placeholder,
                               text: $value.onValidate(checker: fieldValid, debounceInMills: 500) { v in
                        // validation closure where ‘v’ is the current value
                        if self.required {
                            if (v.isEmpty) {
                                return "Không được để trống"
                            }
                        }
                        if self.type == .email {
                            if( !v.isEmail() ) {
                                return "Địa chỉ email sai định dạng"
                            }
                        }
                        
                        if self.type == .phone {
                            if(!v.isValidPhone() || !(v.count == 10)) {
                                return "Số điện thoại không đúng định dạng"
                            }
                        }
                        
                        if self.type == .number {
                            if( !v.numericString().isNumber() ) {
                                return "Nhập định dạng số"
                            }
                        }
                        
                        
                        return nil
                    })  .frame(width:screenWidth()/3)
                        .appFont(style: .body, size: isToolsForm ? 12 : 14)
                        .padding(.top, 0)
                        .textFieldStyle(RoundedTextFieldStyle2(height: height))
                        .autocapitalization(.none)
                        .disabled(readOnly).keyboardType(keyBoardType())
                        .multilineTextAlignment(TextAlignment.trailing)
                        .onReceive(Just(value)) { value in
                            if self.type == .money {
                                if self.value.count > 0 {
                                    self.value = String(value).formatDecimalInput()
                                }
                            }
                        }
                    
                }.padding(.all, 0)
//                if $showError.wrappedValue {
//                    HStack {
//                        Text(fieldValid.errorMessage ?? "")
//                            .appFont(style: .body, weight: .light, size: 10, color: .red).frame( maxWidth: .infinity, alignment: .leading)
//                    }
//                }
                
                //                Spacer()
                
            }).onTapGesture {
                self.showError = true
            }
            .padding(.all, 0)
            .frame(height: 50)
            .overlay(
                Text(((fieldValid.errorMessage != nil) && self.showError) ? fieldValid.errorMessage ?? "" : "")
                    .appFont(style: .body, weight: .light, size: 10, color: .red).frame( maxWidth: .infinity, alignment: .leading).padding(.top, 60)
                , alignment: .leading
            )
        }
        else {
            VStack(alignment: .leading, spacing: 2, content: {
                if !label.isBlank
                {
                    if (isToolsForm) {
                        ToolsFieldLabel(label: self.label, required: self.required)
                    } else {
                        FieldLabel(label: self.label, required: self.required)
                    }
                }
                
                TextField(placeholder,
                           text: $value.onValidate(checker: fieldValid, debounceInMills: 500) { v in
                    // validation closure where ‘v’ is the current value
                    print("onChange Text", v)
                    if self.required {
                        if (v.isEmpty) {
                            return "Không được để trống"
                        }
                    }
                    if self.type == .email {
                        if( !v.isEmail() ) {
                            return "Địa chỉ email sai định dạng"
                        }
                    }
                    
                    if self.type == .phone {
                        if(!v.isValidPhone() || !(v.count == 10)) {
                            return "Số điện thoại không đúng định dạng"
                        }
                    }
                    
                    if self.type == .number {
                        if( !v.isNumber() ) {
                            return "Nhập định dạng số"
                        }
                    }
                    
                    if self.type == .money {
                        if(!v.numericString().isNumber() ) {
                            return "Nhập định dạng số"
                        }
                    }
                    
                    if v.isBlank {
                        self.showError = true
                    } else {
//                        self.showError = false;
                    }
                    return nil
                }).appFont(style: .body, size: isToolsForm ? 12 : 14)
                    .padding(.top, 0)
                    .textFieldStyle(RoundedTextFieldStyle2(height: height))
                    .autocapitalization(.none)
                    .disabled(readOnly).keyboardType(keyBoardType())
                    .onReceive(Just(value)) { value in
                        if self.type == .money {
                            if self.value.count > 0 {
                                self.value = String(value).formatDecimalInput()
                            }
                        }
                    }
                
                Spacer()
                
            }).onTapGesture {
                if self.value.isBlank {
                    self.showError = true
                }
            }
            .padding(.all, 0)
            .frame(height: label.isBlank ? 46 : (isToolsForm ? 60 : 98))
            .overlay(
                Text(((fieldValid.errorMessage != nil) && self.showError) ? fieldValid.errorMessage ?? "" : "")
                    .appFont(style: .body, weight: .light, size: 10, color: .red).frame( maxWidth: .infinity, alignment: .leading).padding(.top, 60)
                , alignment: .leading
            )
        }
        
    }
    
    func keyBoardType() -> UIKeyboardType {
        switch self.type {
        case .phone:
            return .phonePad
        case .number:
            return .numberPad
        case .decimal:
            return .decimalPad
        case .money:
            return .decimalPad
        default:
            return .default
        }
    }
}


struct MyTextField_Previews: PreviewProvider {
    static var previews: some View {
        MyTextField(label: "Họ", placeholder: "", value: .constant(""), required: true)
        MyTextField(label: "", placeholder: "PlaceHolder", value: .constant(""), required: true).frame(width: 150)
    }
}
