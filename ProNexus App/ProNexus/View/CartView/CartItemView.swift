//
//  CartItemView.swift
//  ProNexus
//
//  Created by Tú Dev app on 11/11/2021.
//

import SwiftUI

struct CartItemView: View {
    
    
    @EnvironmentObject var service: MarketPlaceApiService
    @Environment(\.presentationMode) private var presentationMode
    
    @State var data: [ProductElement] = []
    
    @State var message = ""
    @State var isShowAlertError = false
    @State var isShowAlertSuccess = false
    
    @State var isChecked: Bool = true
    
    @State var isShowDelete: Bool = false
    @State var isShowDeleteAll: Bool = false
    
    @State var itemIdSelected: Int = 0
    @State var itemIdPreview: Int = 0
    
    @State var totalPrice: Int = 0
    
    @State var loading = true
    
    var body: some View {
        ZStack {
            VStack{
                Header(title: "Giỏ hàng", contentView: {
                    ButtonIcon(name: "xmark", onTapButton: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    Spacer()
                    //                        ButtonIcon(name: "cart.fill", onTapButton: {
                    //
                    //                        })
                })
                
                ScrollView (showsIndicators: false) {
                    VStack{
                        Group{
                            
                            VStack{
                                if $loading.wrappedValue {
                                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                                } else {
                                    
                                    if let arr = data {
                                        if (arr.count > 0 ) {
                                            VStack(alignment:.leading){
                                                HStack{
                                                    //                                                    Toggle(isOn: $isChecked) {
                                                    //
                                                    //                                                    }.padding(.all, 0)
                                                    //                                                        .toggleStyle(CheckboxSquareStyle())
                                                    
                                                    Button {
                                                        isChecked = !isChecked
                                                        for index in 0..<self.data.count {
                                                            self.data[index].isChecked = !(self.data[index].isChecked ?? false)
                                                        }
                                                        calculateTotal()
                                                    } label: {
                                                        Image(systemName: isChecked ? "checkmark.square" : "square").foregroundColor(Color.gray).padding(.trailing, 12)
                                                    }
                                                    
                                                    Text("Tất cả")
                                                        .appFont(style: .body,weight: .bold, size: 16, color: Color(hex: "#4D4D4D"))
                                                    Spacer()
                                                    Button(action:{
                                                        self.isShowDeleteAll = true
                                                    }, label: {
                                                        Image(systemName: "trash").resizable().scaledToFit().frame(width: 18, height: 18).foregroundColor(Color(hex: "#B3B3B3"))
                                                    })
                                                }
                                            }
                                            .padding(.top,60)
                                            .offset(x: 0, y: 0)
                                            
                                            ForEach(arr) {prod in
                                                ItemInCartView(item: prod, isShowDelete: $isShowDelete, itemIdSelected: $itemIdSelected, itemIdPreview: $itemIdPreview.onUpdate(onChangeSelectCheckbox)).environmentObject(MarketPlaceApiService())
                                            }
                                        } else {
                                            NoData()
                                                .padding(.top, 60)
                                        }
                                    }
                                }
                                
                            }
                            .padding(.horizontal, 37)
                            Spacer()
                        }.padding(.bottom, 5)
                    }
                    
                }
                VStack{
                    Divider()
                    HStack{
                        VStack{
                            Text("Tổng thanh toán").appFont(style: .body, weight: .bold, size:14,color: Color(hex:"#4D4D4D"))
                            Text("\(self.totalPrice ?? 0)đ").appFont(style: .body,weight: .bold,size: 20, color: Color(hex:"#4C99F8"))
                        }
                        Spacer()
                        VStack{
                            
                            if self.totalPrice > 0 {
                                NavigationLink {
                                    ConfirmOrderView(data: data, totalPrice: self.totalPrice ?? 0).environmentObject(MarketPlaceApiService())
                                        .environmentObject(UserApiService())
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarHidden(true)
                                } label: {
                                    Text("Tiếp tục").appFont(style: .body, color: .white)
                                }
                                .buttonStyle(GradientButtonStyle())
                            } else
                            {
                                Button(action: {
                                   
                                }, label: {
                                    Text("Tiếp tục").appFont(style: .body, color: .white)
                                }).buttonStyle(RoundedSilverButtonStyle())
                            }
                            
                        }
                    }.padding(.horizontal,37).padding(.top,18)
                }.frame(width: screenWidth(), height: 80)
                
                
                
            }
            if $isShowDelete.wrappedValue {
                CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn xoá sản phẩm này?", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {
                    removeProductInCart()
                    
                }, onPressBtn2: {}, show: $isShowDelete)
            }
            if $isShowDeleteAll.wrappedValue {
                CustomAlertView(title: "", msg: "Bạn có chắc chắn muốn xoá tất cả sản phẩm trong giỏ hàng?", textButton1: "Đồng ý", textButton2: "Quay lại", onPressBtn1: {
                    removeAllCart()
                    
                }, onPressBtn2: {}, show: $isShowDeleteAll)
            }
        }.onAppear{
            loadCarts()
        }
    }
    
    func onChangeSelectCheckbox() {
        for index in 0..<self.data.count {
            if self.data[index].productCartId == self.itemIdPreview {
                self.data[index].isChecked = !(self.data[index].isChecked ?? false)
            }
        }

        if self.data.filter({ $0.isChecked ?? false }).count == self.data.count  {
            self.isChecked = true
        } else
        {
            self.isChecked = false
        }
        calculateTotal()
    }
    
    func onChangeSelectAll() {
         for index in 0..<self.data.count {
                self.data[index].isChecked = false
         }
    }
    
    func loadCarts() -> Void {
        service.loadCart().done { rs in
            self.loading = false
            if let items = rs.payload  {
                self.data = items
                for index in 0..<self.data.count {
                    self.data[index].isChecked = true
                }
                calculateTotal()
            } else {
                self.message = "Có lỗi xảy ra vui lòng kiểm tra dữ liệu"
                self.isShowAlertError = true
                // show modal confirm
            }
        }
    }
    
    func removeAllCart() {
        self.isShowDeleteAll = false
        for item in data {
            if item.isChecked ?? false {
                service.removeProductInCart(id: "\(item.productCartId ?? 0)" ).done { response in
                    loadCarts()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                //call any function
            AppUtils.showAlert(text: "Xoá thành công")
        }
    }
    
    func calculateTotal() {
        self.totalPrice = 0
        for item in self.data {
            if item.isChecked ?? false {
                self.totalPrice += item.price ?? 0
            }
        }
    }
    
    func removeProductInCart(){
        service.removeProductInCart(id: "\(self.itemIdSelected)" ).done { response in
            if response.ok {
                loadCarts()
                AppUtils.showAlert(text: "Xoá thành công")
            } else {
                self.message = "Xảy ra lỗi không thể xoá lịch hẹn"
                self.isShowAlertError = true
            }
        }
        isShowDelete = false
        //        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct CartItemView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(itemIdSelected: 0, itemIdPreview: 0).environmentObject(MarketPlaceApiService())
    }
}
