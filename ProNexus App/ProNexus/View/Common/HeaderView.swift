//
//  HeaderView.swift
//  ProNexus
//
//  Created by thanh cto on 01/11/2021.
//

import SwiftUI

// Hỗ trợ title center

struct HeaderView<RightView: View>: View {
    
    var onTapButtonLeft: (() -> Void)
    var titleHeader: String
    @ViewBuilder var rightView: () -> RightView
    
    
    var body: some View {
        VStack {
            // HEADER
            ZStack(alignment: .center) {
                HStack(spacing: 0) {
                    //button left
                    Button(action: onTapButtonLeft, label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    }).frame(width: 50, alignment: .center)
                    
                    Spacer()
                    rightView()
                }.offset(x: 0, y: -2)
                HStack(alignment: .center, spacing: 0) {
                    Text(titleHeader).appFont(style: .headline)
                    
                }.offset(x: 0, y: -2)
            }.background(
                Image("bg_header")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth())
                    .offset(x: 0, y: 0)
//                    .edgesIgnoringSafeArea(.top)
            )
            // HEADER
        }
        .offset(x: 0, y: -4)
        .zIndex(10)
    }
}

struct Header<Content: View>: View {
    
    var title: String
    @ViewBuilder var contentView: () -> Content
        
    var body: some View {
        VStack {
            // HEADER
            ZStack(alignment: .center) {
                
                HStack(spacing: 0) {
                    contentView()
                }.offset(x: 0, y: -2)
                    .padding(.leading, 15)
                    .padding(.trailing, 37)
                
                HStack(alignment: .center, spacing: 0) {
                    Text(title).appFont(style: .headline)
                    
                }.offset(x: 0, y: -2)
            }.background(
                Image("bg_header")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth())
                    .offset(x: 0, y: 0)
//                    .edgesIgnoringSafeArea(.top)
            )
            // HEADER
        }
        .offset(x: 0, y: -4)
        .zIndex(10)
    }
}

// button back, button x
struct ButtonIcon: View {
    var name: String
    var onTapButton: (() -> Void)
    var color: Color = .white
    
    var body: some View {
        Button(action: onTapButton, label: {
            Image(systemName: name)
                .foregroundColor(color)
        })
    }
}

struct HeaderSearchView: View {
    
    @State var onTapButtonLeft: (() -> Void)
    @State var titleHeader: String
    @State var keyWord: String = "" //create State
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            // common header
            VStack (alignment: .center) {
                
                
                HeaderView(onTapButtonLeft: {
                    self.presentationMode.wrappedValue.dismiss()
                }, titleHeader: "Danh sách bài viết mới") {
                    
                }
                // end header
                //                Spacer()
                // input search
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Gõ từ khoá bạn muốn tìm kiếm", text: $keyWord)
                    }
                    .textFieldStyle(OvalTextFieldStyle())
                }.padding()
                Spacer()
            }
            //end input search
            Spacer()
        }
        .padding(.horizontal, 0.0)
        //        .edgesIgnoringSafeArea(.all)
    }
}



struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //            HeaderView(onTapButtonLeft: {
            //
            //            }, titleHeader: "Tite Header")
            //
//            HeaderSearchView(onTapButtonLeft: {
//
//            }, titleHeader: "Tite Header")
            
            Header(title: "Chi tiết sản phẩm", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    
                })
                Spacer()
                ButtonIcon(name: "cart.fill", onTapButton: {
                    
                })
            })
        }
    }
}

