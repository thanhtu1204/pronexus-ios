//
//  BuyRentHouseStep2View.swift
//  ProNexus
//
//  Created by Tú Dev app on 28/11/2021.
//

import SwiftUI

struct BuyRentHouseStep2View: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State var model: CompareBuySell?
    
    var body: some View {
        VStack{
            Header(title: "So sánh Mua nhà - Thuê nhà", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                    
                })
                Spacer()
                
            }).padding(.bottom,60)
            ScrollView(showsIndicators:false){
                VStack(alignment:.leading){
                    VStack(alignment:.leading, spacing: 4){
                        Group{
                            VStack( content: {
                                Text("Bạn hiện có thu nhập ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%@", "\(model?.thuNhapBinhQuanNam ?? 0)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))

                            }).padding(.top,27)
                            VStack( content: {
                                Text("Số tiền sẵn có là ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%@", "\(model?.soTienSANCo ?? 0)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                            })
                            VStack( content: {
                                Text("Thời gian cần tính toán trong ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text("\( model?.thoiGianTinhToan ?? 0 ) năm tới.")
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                            })
                        }
                        LineDash()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .padding(.vertical,22)
                            .foregroundColor( Color(hex: "#A4A4A4"))
                        Group{
                            VStack( content: {
                                Text("Nếu mua nhà có giá trị ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%@", "\(model?.giaTriCanHoMuonMUA ?? 0)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                Spacer()

                            })
                            VStack( content: {
                                Text("Lãi suất đi vay bình quân ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%.1f %@", (model?.laiSuatDiVay ?? 0) * 100, "%/Năm "))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                Spacer()
                            })

                            VStack( content: {
                                Text("Dòng tiền ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text("sau \( model?.thoiGianTinhToan ?? 0 ) năm ")
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                + Text("là ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%@", "\(model?.dongTienMUANha ?? 0)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))

                                Spacer()
                            })

                        }

                        Group{
                            VStack( content: {
                                Text("Nếu thuê nhà chi phí ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%@", "\(model?.chiPhiThueNha ?? 0)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                Spacer()

                            }).padding(.top,20)
                            VStack( content: {
                                Text("Tỷ lệ tăng giá ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%.1f %@", (model?.tyLETangGiaThueNha ?? 0) * 100, "%/Năm "))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4C99F8"))
                                Spacer()
                            })

                            VStack( content: {
                                Text("Dòng tiền")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(" sau \( model?.thoiGianTinhToan ?? 0) năm")
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                + Text(" là ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text(String(format: "%@", "\(model?.dongTienThueNha ?? 0)".convertDoubleToCurrency()))
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                            })

                        }
                        LineDash()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .padding(.vertical,22)
                            .foregroundColor( Color(hex: "#A4A4A4"))
                        Group{
                            VStack( content: {
                                Text("Đề xuất:")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))

                                Spacer()

                            })
                            VStack( content: {
                                Text("Phương án tốt nhất cho bạn là: ")
                                    .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#4D4D4D"))
                                + Text("Mua nhà")
                                    .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                    .foregroundColor( Color(hex: "#FFB331"))
                                Spacer()

                            }).padding(.bottom,26)
                        }

                    }.padding(.horizontal, 10)
                }
                .background(Color.white)
                .frame(width:screenWidth()-74)
                .cornerRadius(15)
                .myShadow()
                .padding(.all,2)

                Spacer(minLength: 20)
                
                
                VStack () {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            Text("Mua")
                                .frame(minWidth: 30)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#F5F5F5"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                            ForEach((1...16), id: \.self) {
                                Text("\($0).000")
                                    .frame(minWidth: 50)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 5)
                                    .background(Color(hex: "#F5F5F5"))
                                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                            }
                        }
                        .frame(height: 30)
                        
                        if let items = model?.charts {
                            ForEach(0..<items.count) { index in
                                let item = items[index]
                                let i = index + 2
                                HStack(spacing: 4) {
                                    Text("\(i * 5)")
                                        .frame(minWidth: 30)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 5)
                                        .background(Color(hex: "#F5F5F5"))
                                        .appFont(style: .body, size: 10, color: Color(hex: "#0D0D0D"))
                                    
                                    ForEach(item, id: \.self) { row in
                                        HStack(spacing: 4) {
                                            Text("\(row)")
                                                .frame(minWidth: 50, alignment: .center)
                                                .padding(.horizontal, 15)
                                                .padding(.vertical, 5)
                                                .appFont(style: .body, size: 10, color: Color(hex: "#6E6E6E"))
                                        }.background(Color(hex: row == "Mua" ? "#E3F2FF" : "#FFFFFF"))
                                    }
                                }
                            }
                        }
                     
                    }
                    .padding()
                }
                .padding(.all, 0)
                .frame(width: UIScreen.screenWidth - 74)
                .background(Color("button"))
                .cornerRadius(15)
                .myShadow()
                
            }
            Group {
                VStack{
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                // closing popup...
                            }, label: {
                                Image(systemName: "xmark").resizable().frame(width: 10, height: 10).foregroundColor(Color(hex: "#CCCCCC"))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            })
                        }.padding(.top,15)

                        VStack(alignment:.center){
                            Text("Lựa chọn phương án tối ưu với sự đồng hành của cố vấn tài chính tin cậy.")
                                .appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D")).padding(.all,0)
                        }
                        .padding(.horizontal,22)

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
                .padding(.top,36)
                .padding(.all,2)
            }
            
            Spacer()
        }
        
    }
    
}

struct BuyRentHouseStep2View_Previews: PreviewProvider {
    static var previews: some View {
        BuyRentHouseStep2View()
    }
}
