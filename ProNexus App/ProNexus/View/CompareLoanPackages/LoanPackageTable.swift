//
//  LoanPackageTable.swift
//  ProNexus
//
//  Created by TUYEN on 12/8/21.
//

import SwiftUI

struct LoanPackageTable: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var loan1: [Loan] = []
    @State var loan2: [Loan] = []
    @State var loan3: [Loan] = []
    @State var model: LoanPackage?
    
    @State var tabIndex = 0
    var body: some View {
        VStack{
            Header(title: "So sánh gói vay tiêu dùng", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                    
                })
                Spacer()
                
            }).padding(.bottom,50)
            ScrollView(showsIndicators:false){

                VStack (spacing: 25) {
                    VStack(){
                        VStack(alignment:.leading){
                            Group{
                                VStack(alignment:.leading, spacing: 4, content: {
                                    VStack(alignment:.leading) {
                                        Text("Khoản vay ")
                                            .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                            .foregroundColor( Color(hex: "#4D4D4D"))
                                        + Text("\( model?.khoanVay ?? 0 )".convertDoubleToCurrency())
                                            .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                            .foregroundColor( Color(hex: "#4C99F8"))
                                    }
                                    VStack(alignment:.leading) {
                                        Text("Kỳ hạn ")
                                            .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                            .foregroundColor( Color(hex: "#4D4D4D"))
                                        + Text("\( model?.kyHan ?? 0 )")
                                            .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                            .foregroundColor( Color(hex: "#4C99F8"))
                                    }
                                    VStack(alignment:.leading) {
                                        Text("Lãi suất theo dư nợ giảm dần ")
                                            .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                            .foregroundColor( Color(hex: "#4D4D4D"))
                                        + Text(String(format: "%.1f %@", (model?.laiSuatDuNo ?? 0) * 100, "%/Năm "))
                                            .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                            .foregroundColor( Color(hex: "#4C99F8"))
                                    }
                                    VStack(alignment:.leading) {
                                        Text("Tương đương lãi suất danh nghĩa ")
                                            .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                            .foregroundColor( Color(hex: "#4D4D4D"))
                                        
                                        + Text(String(format: "%.1f %@", (model?.laiSuatDanhNghia ?? 0) * 100, "%/Năm "))
                                            .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                            .foregroundColor( Color(hex: "#FFB331"))
                                    }
                                    
                                }).padding(.top,25)
                                
                                
                                
                            }
                            LineDash()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                .frame(height: 1)
                                .padding(.vertical,22)
                                .foregroundColor( Color(hex: "#A4A4A4"))
                            
                            Group{
                                VStack(alignment:.leading, spacing: 4) {
                                    Text("Gợi ý lựa chọn:")
                                        .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4D4D4D"))
                                    Text("Gói vay dự kiến có số tiền lãi thấp nhất: ")
                                        .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4D4D4D"))
                                    + Text("\( model?.laiSuatThapNhat ?? 0 )".convertDoubleToCurrency())
                                        .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#FFB331"))
                                }
                            }
                            
                            LineDash()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                .frame(height: 1)
                                .padding(.vertical,22)
                                .foregroundColor( Color(hex: "#A4A4A4"))
                            Group{
                                VStack(alignment:.leading, spacing: 4) {
                                    Text("Đề xuất:")
                                        .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4D4D4D"))
                                    Text("Nếu nhận được lời đề nghị gói vay theo lãi suất danh nghĩa dưới ")
                                        .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4D4D4D"))
                                    + Text(String(format: "%.1f %@", (model?.laiSuatDanhNghia ?? 0) * 100, "%/Năm "))
                                        .font(Font.custom(Theme.fontName.bold.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#FFB331"))
                                    + Text("thì bạn nên chọn gói vay đó.")
                                        .font(Font.custom(Theme.fontName.regular.rawValue, size: 14))
                                        .foregroundColor( Color(hex: "#4D4D4D"))
                                }
                            }
                            .padding(.bottom, 25)
                            
                        }.padding(.horizontal,20)
                    }
                    .background(Color.white)
                    .frame(width:screenWidth()-74)
                    .cornerRadius(15)
                    .myShadow()
                    .padding(.all,2)
                    
                    VStack (alignment: .center) {
                        LoanTabBar(tabIndex: $tabIndex)
                            .frame(width: UIScreen.screenWidth - 74)
                        if tabIndex == 0 {
                            Loan1TableView(data: $loan1)
                        }
                        if tabIndex == 1 {
                            Loan2TableView(data: $loan2)
                        }
                        if tabIndex == 2 {
                            Loan3TableView(data: $loan3)
                        }
                        
                    }
                    .padding(.all, 0)
                    .frame(width: UIScreen.screenWidth - 74)
                    .background(Color("button"))
                    .cornerRadius(10)
                    .myShadow()
                    
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
                            HStack(alignment:.center){
                                Text("Lựa chọn phương án tối ưu với sự đồng hành của cố vấn tài chính tin cậy.")
                                    .appFont(style: .body, size: 14, color: Color(hex: "#4D4D4D"))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(SwiftUI.TextAlignment.leading)
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
                    .padding(.all,2)
                }
            }
            Spacer()
        }
        
    }
}

struct LoanTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 0) {
            TabBarButtonRadius2(text: "Gói 1", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButtonRadius2(text: "Gói 2", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            Spacer()
            TabBarButtonRadius2(text: "Gói 3", isSelected: .constant(tabIndex == 2))
                .onTapGesture { onButtonTapped(index: 2) }
        }
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}


struct LoanTableView: View {
    
    @Binding var data: [Loan]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                Text("Kỳ")
                    .frame(minWidth: 45)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Gốc")
                    .frame(minWidth: 90)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Lãi")
                    .frame(minWidth: 70)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Dư nợ")
                    .frame(minWidth: 80)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
                Text("Tổng số tiền")
                    .frame(minWidth: 80)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#F5F5F5"))
                    .appFont(style: .body, size: 12, color: Color(hex: "#0D0D0D"))
            }
            .frame(height: 30)
            
            if let items = data {
                ScrollView(showsIndicators: false) {
                    ForEach(items) { item in
                        HStack(spacing: 4) {
                            Text("\(item.months ?? 0)")
                                .frame(minWidth: 45, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text("\(item.principal ?? 0)".convertDoubleToCurrency(symbol: ""))
                                .frame(minWidth: 90, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text("\(item.interest ?? 0)".convertDoubleToCurrency(symbol: ""))
                                .frame(minWidth: 70, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text("\(item.debt ?? 0)".convertDoubleToCurrency(symbol: ""))
                                .frame(minWidth: 80, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                            Text("\(item.amount ?? 0)".convertDoubleToCurrency(symbol: ""))
                                .frame(minWidth: 80, alignment: .trailing)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color(hex: "#FFFFFF"))
                                .appFont(style: .body, size: 12, color: Color(hex: "#6E6E6E"))
                        }
                        .frame(height: 30)
                    }
                }
            }
         
        }
        .padding()
    }
}


struct Loan1TableView: View {
    @Binding var data: [Loan]
    var body: some View {
        LoanTableView(data: $data)
    }
}
struct Loan2TableView: View {
    @Binding var data: [Loan]
    var body: some View {
        LoanTableView(data: $data)
    }
}
struct Loan3TableView: View {
    @Binding var data: [Loan]
    var body: some View {
        LoanTableView(data: $data)
    }
}

struct LoanPackageTable_Previews: PreviewProvider {
    static var previews: some View {
        LoanPackageTable()
    }
}
