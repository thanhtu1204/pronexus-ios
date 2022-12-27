//
//  BuyRentHouseStep1View.swift
//  ProNexus
//
//  Created by Tú Dev app on 28/11/2021.
//

import SwiftUI

struct BuyRentHouseStep1View: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var service: UserApiService
    
    @State var isValidForm = false
    @State var navToResponseTable = false
    @State var compareBuySell: CompareBuySell?
    @State var thuNhapBinhQuanNam: String = "" // 600
    @State var soTienSanCo: String = "" // 500
    @State var tySuatDauTuCaNhan: String = "" // 11
    @State var tongSoTienNoGomLai: String = "" // ex: 180
    @State var soNamThanhToanConLai: String = "" // 1
    @State var chiPhiSinhHoatHangThang: String = "" //34
    @State var giaTriCanHoMuonMua: String = "" // 5000
    @State var soTienDiVay: String = "" // 4500
    @State var thoiGianVay: String = "5" //5 cố định là 5 năm vì trên design ko có field nhập
    @State var khaNangTangGiaCuaCanNhanTheoNam: String = "" //5
    @State var giamGiaBanThanhLyNhaVaoCuoiKy: String = "" //0
    @State var chiPhiThueNhaHangThang: String = "" //30
    @State var lamPhatGiaThueNhaHangNam: String = "" //3
    @State var thoiGianTinhToan: String = "" //10
    @State var laiSuatDiVay: String = "" //11
        

    var body: some View {
        VStack{
            Header(title: "So sánh Mua nhà - Thuê nhà", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                    
                })
                Spacer()
                
            })
            ScrollView(showsIndicators:false){
                VStack{
                    Text("Vui lòng nhập đủ các giá trị, hệ thống sẽ tính toán ra kết quả còn lại.")
                        .appFont(style: .body, size: 14, color: Color(hex: "#A4A4A4"))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 38)

                    VStack(alignment:.leading){
                        Group{
                        HStack{
                            Text("1. Tình trạng tài chính")
                                .appFont(style: .body,weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                            Spacer()
                        }.padding(.top,22)
               
                            MyTextField(label: "Thu nhập bình quân", placeholder: "triệu VNĐ/năm", type: .money, value: $thuNhapBinhQuanNam.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Số tiền sẵn có", placeholder: "triệu VNĐ", type: .money, value: $soTienSanCo.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Tỷ suất đầu tư cá nhân", placeholder: "%/năm", type: .decimal, value: $tySuatDauTuCaNhan.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Tổng số tiền nợ (Gốc và lãi)", placeholder: "triệu VNĐ", type: .money, value: $tongSoTienNoGomLai.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Kỳ hạn nợ còn lại", placeholder: "năm", type: .number, value: $soNamThanhToanConLai.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Chi phí sinh hoạt tháng", placeholder: "triệu VNĐ/năm", type: .money, value: $chiPhiSinhHoatHangThang.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                        }
                        LineDash()
                                   .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                   .frame(height: 1)
                                   .padding(.vertical,27)
                                   .foregroundColor( Color(hex: "#A4A4A4"))
                        
                        Group{
                        HStack{
                            Circle().foregroundColor(.black)
                                    .frame(width: 6, height: 6)
                                    .frame(height: 12, alignment: .center)
                            Text("Phương án mua nhà")
                                .appFont(style: .body,weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                            Spacer()
                        }
                            
                        MyTextField(label: "Giá trị căn nhà", placeholder: "triệu VNĐ", type: .money, value: $giaTriCanHoMuonMua.onUpdate(checkFormValid), required: false, horizontal: true, isToolsForm: true, height: 35)
                            
                        MyTextField(label: "Số tiền cần vay thêm", placeholder: "triệu VNĐ", type: .money, value: $soTienDiVay.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            
                        MyTextField(label: "Lãi suất đi vay bình quân", placeholder: "%/năm", type: .decimal, value: $laiSuatDiVay.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            
                        MyTextField(label: "Khả năng tăng giá tài sản", placeholder: "%/năm", type: .decimal, value: $khaNangTangGiaCuaCanNhanTheoNam.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            
                        MyTextField(label: "Khả năng mất giá khi bán", placeholder: "%", type: .decimal, value: $giamGiaBanThanhLyNhaVaoCuoiKy.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                            
                        }
                        LineDash()
                                   .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                   .frame(height: 1)
                                   .padding(.vertical,27)
                                   .foregroundColor( Color(hex: "#A4A4A4"))
                        
                        
                        Group{
                        HStack{
                            Circle().foregroundColor(.black)
                                    .frame(width: 6, height: 6)
                                    .frame(height: 12, alignment: .center)
                            Text("Phương án thuê nhà")
                                .appFont(style: .body,weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                            Spacer()
                        }
                            
                        MyTextField(label: "Chi phí thuê nhà", placeholder: "triệu VNĐ/năm", type: .money, value: $chiPhiThueNhaHangThang.onUpdate(checkFormValid), required: false,horizontal: true, isToolsForm: true, height: 35)
                        MyTextField(label: "Lạm phát giá thuê nhà", placeholder: "%/năm", type: .decimal, value: $lamPhatGiaThueNhaHangNam.onUpdate(checkFormValid) , required: false,horizontal: true, isToolsForm: true, height: 35).padding(.bottom,27)

                        }

                    }.padding(.horizontal,20)
                        .frame(width:screenWidth()-74)
                        .background(Color.white)
                        .cornerRadius(15)
                        .myShadow()
                        .padding(.top,26)
                    }
                
                VStack(alignment: .center, content: {
                    
                    if $isValidForm.wrappedValue {
                        Button(action: {
                            onSubmit()
                        }, label: {
                            Text("Xem chi tiết").appFont(style: .body, color: .white)
                        })
                            .buttonStyle(BlueButton())
                            .padding(.top,0)
                    } else
                    {
                        Button(action: {
                            
                        }, label: {
                            Text("Xem chi tiết").appFont(style: .body, color: .white)
                        })
                            .buttonStyle(SilverButton())
                            .padding(.top,0)
                    }
                    
//                    NavigationLink {
//                        BuyRentHouseStep2View()
//                            .navigationBarHidden(true)
//                            .navigationBarBackButtonHidden(true)
//                    } label: {
//                        Text("Xem chi tiết")
//                            .appFont(style: .body,weight: .regular, size: 14, color: Color(hex: "#ffffff"))
//                    }
//                    .buttonStyle(BlueButton())

                }).padding(.top,27)
                
                
            }.padding(.top,60)
            
            Spacer()
            
            NavigationLink(isActive: $navToResponseTable) {
                BuyRentHouseStep2View(model: compareBuySell)
                                            .navigationBarHidden(true)
                                            .navigationBarBackButtonHidden(true)
            } label: {
                EmptyView()
            }

        }
    }
    
    func checkFormValid() {
        self.isValidForm = !self.thuNhapBinhQuanNam.isBlank
        && !self.soTienSanCo.isBlank
        && !self.tySuatDauTuCaNhan.isBlank
        && !self.tongSoTienNoGomLai.isBlank
        && !self.soNamThanhToanConLai.isBlank
        && !self.chiPhiSinhHoatHangThang.isBlank
        && !self.giaTriCanHoMuonMua.isBlank
        && !self.soTienDiVay.isBlank
        && !self.khaNangTangGiaCuaCanNhanTheoNam.isBlank
        && !self.giamGiaBanThanhLyNhaVaoCuoiKy.isBlank
        && !self.chiPhiThueNhaHangThang.isBlank
        && !self.thoiGianVay.isBlank
        && !self.lamPhatGiaThueNhaHangNam.isBlank
        && !self.thoiGianTinhToan.isBlank
        && !self.laiSuatDiVay.isBlank
    }
    
    
    func onSubmit() {
        let data: [String: Any] = [
            "ThuNhapBinhQuanNam": self.thuNhapBinhQuanNam.numberValue,
            "SoTienSanCo": self.soTienSanCo.numberValue,
            "TySuatDauTuCaNhan": self.tySuatDauTuCaNhan.percentValue,
            "TongSoTienNoGomLai": self.tongSoTienNoGomLai.numberValue,
            "SoNamThanhToanConLai" : self.soNamThanhToanConLai.numberValue,
            "ChiPhiSinhHoatHangThang": self.chiPhiSinhHoatHangThang.numberValue,
            "GiaTriCanHoMuonMua" : self.giaTriCanHoMuonMua.numberValue,
            "SoTienDiVay": self.soTienDiVay.numberValue,
            "ThoiGianVay": self.thoiGianVay.intValue,
            "KhaNangTangGiaCuaCanNhanTheoNam": self.khaNangTangGiaCuaCanNhanTheoNam.percentValue,
            "GiamGiaBanThanhLyNhaVaoCuoiKy": self.giamGiaBanThanhLyNhaVaoCuoiKy.numberValue,
            "ChiPhiThueNhaHangThang" : self.chiPhiThueNhaHangThang.numberValue,
            "LamPhatGiaThueNhaHangNam" : self.lamPhatGiaThueNhaHangNam.percentValue,
            "ThoiGianTinhToan": self.thoiGianTinhToan.intValue,
            "LaiSuatDiVay": self.laiSuatDiVay.percentValue,
        ]
        _ = service.postCompareBuySell(parameters: data).done { response in
            if response.ok == true {
                if let payload = response.payload {
                    self.compareBuySell = payload
                }
                self.navToResponseTable = true
            } else {
                AppUtils.showAlert(text: "Lỗi dữ liệu, vui lòng kiểm tra lại")
            }
        }
        
    }
    
    func clearForm () {
//        self.amountLoan = ""
//        self.months = ""
//        self.realInterest = ""
//        self.nominalInterest = ""
    }
}

struct BuyRentHouseStep1View_Previews: PreviewProvider {
    static var previews: some View {
        BuyRentHouseStep1View().environmentObject(UserApiService())
    }
}
