//
//  PasswordField.swift
//  ProNexus
//
//  Created by thanh cto on 11/11/2021.
//

import SwiftUI
import FieldValidatorLibrary

struct PasswordToggleField : View {
    @Binding var value:String
    @Binding var hidden:Bool
    
    var body: some View {
        Group {
            if( hidden ) {
                SecureField( "", text:$value).appFont(style: .body)
                    .padding(.top,5).textFieldStyle(RoundedTextFieldStyle())
            }
            else {
                TextField( "", text:$value).appFont(style: .body)
                    .padding(.top,5).textFieldStyle(RoundedTextFieldStyle())
            }
        }
    }
}

struct MyPasswordField : View {
    var label = ""
    @Binding var value:String
    @StateObject var passwordValid = FieldChecker2<String>() // validation state of password field
    @State var passwordHidden = true
    @State var showError = false
    @State var required = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            if !label.isBlank
            {
                FieldLabel(label: self.label, required: self.required)
            }
            
            ZStack (alignment: .trailing) {
                PasswordToggleField( value:$value.onValidate( checker: passwordValid ) { v in
                    if(v.isEmpty) {
                        return "Mật khẩu không được trống"
                    }
                    return nil
                }, hidden: $passwordHidden )
                    .autocapitalization(.none)
//                    .padding( .bottom, 15  )
                
                Button( action: { self.passwordHidden.toggle() }) {
                    Group {
                        if( passwordHidden ) {
                            Image( systemName: "eye.slash").resizable().scaledToFit().frame(width: 18, height: 18, alignment: .trailing)
                        }
                        else {
                            Image( systemName: "eye").resizable().scaledToFit().frame(width: 18, height: 18, alignment: .trailing)
                        }
                    }
                    .foregroundColor(Color(hex: "#808080"))
                }.padding(.bottom, -3).padding(.trailing, 15)
                
            }.appFont(style: .body)
                .padding(0)
                .offset(x: 0, y: -3)
            
//            if $showError.wrappedValue {
//                HStack {
//                    Text(passwordValid.errorMessage ?? "")
//                        .appFont(style: .body, weight: .light, size: 10, color: .red).frame( maxWidth: .infinity, alignment: .leading)
//                }
//            }
            
            Spacer()
        }).onTapGesture {
            self.showError = true
        }
        .padding(.all, 0)
        .frame(height: label.isBlank ? 46 : 98)
        .overlay(
            Text(((passwordValid.errorMessage != nil) && self.showError) ? passwordValid.errorMessage ?? "" : "")
                .appFont(style: .body, weight: .light, size: 10, color: .red).frame( maxWidth: .infinity, alignment: .leading).padding(.top, 70)
            , alignment: .leading
        )
    }
}

struct PasswordToggleField_Previews: PreviewProvider {
    static var previews: some View {
        MyPasswordField(label: "Mật khẩu", value: .constant(""), required: true).padding(.horizontal)
    }
}
