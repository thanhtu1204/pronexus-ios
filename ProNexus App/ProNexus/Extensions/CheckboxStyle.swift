//
//  CheckboxStyle.swift
//  ProNexus
//
//  Created by thanh cto on 06/11/2021.
//

import SwiftUI


struct CheckboxCirlceStyle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack {

            configuration.label

            Spacer()

            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? .green : .green)
                .font(.system(size: 20, weight: .regular, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }

    }
}

struct CheckboxCirlceLeftStyle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack {

            configuration.label

//            Spacer()

            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? .green : .green)
                .font(.system(size: 20, weight: .regular, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }

    }
}



struct CheckboxSquareStyle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack {
//
//            configuration.label
//
//            Spacer()

            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? .green : .green)
                .font(.system(size: 20, weight: .regular, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }

    }
}

struct CheckboxStyleView: View {
    
    @State var checked = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $checked, label: {
                Image(systemName: "airplane")
                Text("Airplane Mode")
            })
            .toggleStyle(CheckboxCirlceStyle())
            
            
            Toggle(isOn: $checked, label: {
//                Image(systemName: "airplane")
//                Text("Airplane Mode")
            })
            .toggleStyle(CheckboxSquareStyle())
        }
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxStyleView()
    }
}
