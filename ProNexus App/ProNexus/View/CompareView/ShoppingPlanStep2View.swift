//
//  ShoppingPlanStep2View.swift
//  ProNexus
//
//  Created by Tú Dev app on 29/11/2021.
//

import SwiftUI

struct ShoppingPlanStep2View: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var thuNhapBinhQuanNam: String
    @State var soTienHienCo: String
    @State var coPhiPhatSinhMuaTaiSan: String
    @State var soNamVayMuaTaiSan: String
    @State var toiDaCoTheMua: Double
    @State var tongSoTienVayDuaTrenTienTra: Double
    @State var soTraTruoc: Double
    @State var soDuPhong: Double
    
    var body: some View {
        VStack{
            Header(title: "Kế hoạch mua sắm", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                    
                })
                Spacer()
                
            }).padding(.bottom,60)
            ScrollView(showsIndicators:false){
                VStack(){
                    VStack(alignment:.leading){
                        Group{
                            VStack(alignment:.leading, spacing: 4, content: {
                                VStack() {
                                    Text("Bạn hiện có thu nhập ")
                                        .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4D4D4D"))
                                    + Text(String(format: "%@ %@", soTienHienCo.convertDoubleToCurrency(), "/năm."))
                                        .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4C99F8"))
                                }
                                VStack() {
                                    Text("Số tiền sẵn có là ")
                                        .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4D4D4D"))
                                    + Text(String(format: "%@", soTienHienCo.convertDoubleToCurrency()))
                                        .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4C99F8"))
                                }
                                VStack() {
                                    Text("Thời gian cần tính toán trong")
                                        .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4D4D4D"))
                                    + Text(" \(soNamVayMuaTaiSan) năm tới.")
                                        .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#FFB331"))
                                }
                            }).padding(.top, 25)
                            
                        }
                        LineDash()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .padding(.vertical,22)
                            .foregroundColor( Color(hex: "#A4A4A4"))
                        
                        Group{
                            HStack{
                                Text("Số tiền tối đa bạn có thể mua sắm là")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                Spacer()
                            }
                            HStack( content: {
                                Text(String(format: "%@", "\(toiDaCoTheMua)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                Text(", trong đó:")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                Spacer()
                                
                            })
                            
                            HStack( content: {
                                Circle().foregroundColor(.black)
                                    .frame(width: 4, height: 4)
                                    .frame(height: 12, alignment: .center)
                                
                                Text("Số tiền vay là")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                Text(String(format: "%@", "\(tongSoTienVayDuaTrenTienTra)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                Spacer()
                            })
                            
                            HStack( content: {
                                Circle().foregroundColor(.black)
                                    .frame(width: 4, height: 4)
                                    .frame(height: 12, alignment: .center)
                                
                                Text("Số tiền trả trước là")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                Text(String(format: "%@", "\(soTraTruoc)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                Spacer()
                            })
                            
                            HStack( content: {
                                Circle().foregroundColor(.black)
                                    .frame(width: 4, height: 4)
                                    .frame(height: 12, alignment: .center)
                                
                                Text("Chi phí dự phòng là")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                Text(String(format: "%@", "\(soDuPhong)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                Spacer()
                            })
                            
                            
                        }
                        
                        
                        LineDash()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .padding(.vertical,22)
                            .foregroundColor( Color(hex: "#A4A4A4"))
                        Group{
                            VStack( content: {
                                Text("Chi phí vận hành phát sinh hàng tháng là ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%@", "\(coPhiPhatSinhMuaTaiSan)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                
                            })
                                .padding(.bottom, 30)
                        }
                        
                    }.padding(.horizontal,10)
                }
                .background(Color.white)
                .frame(width:screenWidth()-74)
                .cornerRadius(15)
                .myShadow()
                .padding(.all,2)
                
                VStack{
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                // closing popup...
                            }, label: {
                                Image(systemName: "xmark").resizable().frame(width: 10, height: 10).foregroundColor(Color(hex: "#CCCCCC"))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 15)
                            })
                        }.padding(.top,15)
                        HStack(alignment:.center){
                            Text("Lựa chọn phương án tối ưu với sự đồng hành của cố vấn tài chính tin cậy.")
                                .appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D")).padding(.all,0)
                        }.padding(.horizontal,22)
                        VStack(alignment: .center, content: {
                            NavigationLink(destination: SearchAdvisorView().environmentObject(ProviderApiService())
                                            .environmentObject(ClassificationApiService())
                                            .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                            ) {
                                Text("Tìm cố vấn").regular(size: 14, color: .white)
                            }.buttonStyle(BlueButton(w: 130))
                            
                        }).padding(.top,15)
                            .padding(.bottom,27)
                    }.padding(.horizontal,20)
                    
                    
                }
                .frame(width:screenWidth()-74)
                .background(Color.white)
                .cornerRadius(15)
                .myShadow()
                .padding(.top,25)
                .padding(.all,2)
                
            }
            Spacer()
        }
        
    }
        
}

//struct ShoppingPlanStep2View_Previews: PreviewProvider {
//    static var previews: some View {
//        ShoppingPlanStep2View()
//    }
//}
