//
//  ShoppingPlanStep1View.swift
//  ProNexus
//
//  Created by Tú Dev app on 28/11/2021.
//

import SwiftUI

struct ShoppingPlanStep1View: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var isValidForm = false
    @State var navToResult = false
    
//    @State var thuNhapBinhQuanNam: String = "600" //ex: 600
//    @State var tyLeMuaSamTrenThuNhap: String = "75"  //ex: 75
//    @State var traNoHangThang: String = "3"  //ex: 3
//    @State var chiTieuHangThang: String = "15.5"  //ex: 600
//    @State var noThuNhapDti: String = "80"  //ex: 80
//    @State var coTheChiMuaTaiSan: String = ""  //ex:
//    @State var coPhiPhatSinhMuaTaiSan: String = ""  //ex:
//    @State var soTienHienCo: String = "500"  //ex: 500
//    @State var tyLeDatCoc: String = "15"  //ex: 15
//    @State var duPhongChiPhi: String = "2"  //ex: 2
//    @State var soNamVayMuaTaiSan: String = "10"  //ex: 10
//    @State var laiSuatVay: String = "7"  //ex: 7
    
    @State var thuNhapBinhQuanNam: String = ""
    @State var tyLeMuaSamTrenThuNhap: String = ""
    @State var traNoHangThang: String = ""
    @State var chiTieuHangThang: String = ""
    @State var noThuNhapDti: String = ""
    @State var coTheChiMuaTaiSan: String = ""
    @State var coPhiPhatSinhMuaTaiSan: String = ""
    @State var soTienHienCo: String = ""
    @State var tyLeDatCoc: String = ""
    @State var duPhongChiPhi: String = ""
    @State var soNamVayMuaTaiSan: String = ""
    @State var laiSuatVay: String = ""
    
    @State var toiDaCoTheMua: Double = 0
    @State var tongSoTienVayDuaTrenTienTra: Double = 0
    @State var soTraTruoc: Double = 0
    @State var soDuPhong: Double = 0
    
    //M3 = Khoản tiền thực có thể bỏ mua nhà hàng tháng sau chi phí
    @State var minM1m2: Double = 0
    @State var m3: Double = 0
    @State var m4: Double = 0
    @State var minM3M4: Double = 0
    
    var body: some View {
        VStack{
            Header(title: "Kế hoạch mua sắm", contentView: {
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
                            
                            MyTextField(label: "Thu nhập bình quân", placeholder: "triệu VNĐ/năm", type: .money, value: $thuNhapBinhQuanNam.onUpdate(calM4), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Tỷ lệ chi mua sắm trên thu nhập", placeholder: "%", type: .decimal, value: $tyLeMuaSamTrenThuNhap.onUpdate(calM4), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Số tiền trả nợ hàng tháng", placeholder: "triệu VNĐ", type: .money, value: $traNoHangThang.onUpdate(calM4), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Chi tiêu hàng tháng", placeholder: "triệu VNĐ", type: .money, value: $chiTieuHangThang.onUpdate(calM4), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Tỷ lệ nợ/thu nhập (DTI)", placeholder: "%", type: .decimal, value: $noThuNhapDti.onUpdate(calM4), required: false,horizontal: true, isToolsForm: true, height: 35)
                            MyTextField(label: "Số tiền hàng tháng có thể chi để mua tài sản", placeholder: "triệu VNĐ", type: .money, value: $coTheChiMuaTaiSan, required: false,readOnly: true, horizontal: true, isToolsForm: true, height: 35)
                        }
                        LineDash()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .padding(.vertical,27)
                            .foregroundColor( Color(hex: "#A4A4A4"))
                        
                        Group{
                            HStack{
                                Text("2. Kế hoạch mua tài sản")
                                    .appFont(style: .body,weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                                Spacer()
                            }
                            HStack{
                                Circle().foregroundColor(.black)
                                    .frame(width: 6, height: 6)
                                    .frame(height: 12, alignment: .center)
                                MyTextField(label: "Chi phí phát sinh khi mua tài sản", placeholder: "triệu VNĐ", type: .money, value: $coPhiPhatSinhMuaTaiSan, required: false, readOnly: true,horizontal: true, isToolsForm: true, height: 35)
                                Spacer()
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
                                    Text("Phương án tài chính")
                                        .appFont(style: .body,weight: .bold, size: 12, color: Color(hex: "#4D4D4D"))
                                    Spacer()
                                }
                                
                                
                                MyTextField(label: "Số tiền hiện có", placeholder: "triệu VNĐ", type: .money, value: $soTienHienCo.onUpdate(calM4), required: false, horizontal: true, isToolsForm: true, height: 35)
                                
                                MyTextField(label: "Tỷ lệ đặt cọc", placeholder: "%", type: .decimal, value: $tyLeDatCoc.onUpdate(calM4), required: false, horizontal: true, isToolsForm: true, height: 35)
                                
                                MyTextField(label: "Dự phòng chi phí", placeholder: "%", type: .decimal, value: $duPhongChiPhi.onUpdate(calM4), required: false, horizontal: true, isToolsForm: true, height: 35)
                                
                                MyTextField(label: "Số năm vay mua tài sản", placeholder: "Năm", type: .number, value: $soNamVayMuaTaiSan.onUpdate(calM4), required: false, horizontal: true, isToolsForm: true, height: 35)
                                
                                MyTextField(label: "Lãi suất vay", placeholder: "%/năm", type: .decimal, value: $laiSuatVay.onUpdate(calM4), required: false, horizontal: true, isToolsForm: true, height: 35)
                                    .padding(.bottom,34)
                                
                            }
                            
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
                    
                    
                }).padding(.top,27)
                
                
                if $navToResult.wrappedValue {
                    NavigationLink(isActive: $navToResult, destination: {
                        ShoppingPlanStep2View(thuNhapBinhQuanNam: self.thuNhapBinhQuanNam, soTienHienCo: self.soTienHienCo, coPhiPhatSinhMuaTaiSan: self.coPhiPhatSinhMuaTaiSan, soNamVayMuaTaiSan: self.soNamVayMuaTaiSan, toiDaCoTheMua: self.toiDaCoTheMua, tongSoTienVayDuaTrenTienTra: self.tongSoTienVayDuaTrenTienTra, soTraTruoc: self.soTraTruoc, soDuPhong: self.soDuPhong).navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    }) {
                        EmptyView()
                    }
                }
                
            }.padding(.top,60)
            
            Spacer()
            
        }
    }
    
    
    // tính số tiền trả mua hàng tháng theo tỷ lệ nợ tối đa
    func calM2() {
        let muaSamTrenThuNhap = self.tyLeMuaSamTrenThuNhap.percentValue
        let dti = self.noThuNhapDti.percentValue
        let thuNhapBinhQuan = Double(self.thuNhapBinhQuanNam) ?? 0
        let soTienTraNoHangThang = Double(self.traNoHangThang) ?? 0
        let m2 = dti * (thuNhapBinhQuan / 12) - soTienTraNoHangThang
        let m1 = muaSamTrenThuNhap * thuNhapBinhQuan / 12
        let arr = [m1, m2]
        self.minM1m2 = arr.min() ?? 0
        
        print("m1 ", m1)
        print("m2 ", m2)
        print("minM1m2 ", self.minM1m2)
        
        self.coTheChiMuaTaiSan = "\(self.minM1m2)"
        //phat sinh
        self.coPhiPhatSinhMuaTaiSan = self.chiTieuHangThang;
    }
    
    func calM3() {
        self.m3 = self.minM1m2 - (Double(self.chiTieuHangThang) ?? 0)
    }
    
    func calM4() {
        calM2()
        calM3()
        
        let x = self.laiSuatVay.percentValue // lãi suất vay
        let y = (Double(self.soNamVayMuaTaiSan) ?? 0) // số năm vay
        let z = self.tyLeDatCoc.percentValue // tỷ lệ cọc tối thiểu
        
        let soHienCo = Double(self.soTienHienCo) ?? 0 // số hiện có
        
        let duPhongChiPhiKhac = self.duPhongChiPhi.percentValue // dự phòng chi phí khác
        
        let max: Double = soHienCo / (duPhongChiPhiKhac + z) // giá trị nhà tối đa
        
        self.m4 = pmt(rate: (x / 12), nper: (y * 12), pv: -max * (1 - z))
        self.minM3M4 = [m3, m4].min() as! Double
        
        print("m3 ", self.m3)
        print("m4 ", self.m4)
        print("minM3M4 ", self.minM3M4)
        
        self.tongSoTienVayDuaTrenTienTra = pv(rate: x / 12, numberOfPeriod: (y * 12), payment: -minM3M4)
        self.soTraTruoc = ((soHienCo) - duPhongChiPhiKhac * self.tongSoTienVayDuaTrenTienTra)/(1 + duPhongChiPhiKhac)
        self.toiDaCoTheMua = self.tongSoTienVayDuaTrenTienTra + self.soTraTruoc
        self.soDuPhong = duPhongChiPhiKhac * self.toiDaCoTheMua
        
        print("Tổng số tiền vay dựa vào số tiền trả hàng tháng", self.tongSoTienVayDuaTrenTienTra)
        print("Số tiền trả trước", self.soTraTruoc)
        print("Chi phí dự phòng", self.soDuPhong)
        print("Giá tối đa có thể mua", self.toiDaCoTheMua)
        checkFormValid()
    }
    
    
    
    func pmt(rate : Double, nper : Double, pv : Double, fv : Double = 0, type : Double = 0) -> Double {
        return ((-pv * pvif(rate: rate, nper: nper) - fv) / ((1.0 + rate * type) * fvifa(rate: rate, nper: nper)))
    }
    
    func pow1pm1(x : Double, y : Double) -> Double {
            return (x <= -1) ? pow((1 + x), y) - 1 : exp(y * log(1.0 + x)) - 1
    }
        
        func pow1p(x : Double, y : Double) -> Double {
            return (abs(x) > 0.5) ? pow((1 + x), y) : exp(y * log(1.0 + x))
        }
        
        func pvif(rate : Double, nper : Double) -> Double {
            return pow1p(x: rate, y: nper)
        }
        
        func fvifa(rate : Double, nper : Double) -> Double {
            return (rate == 0) ? nper : pow1pm1(x: rate, y: nper) / rate
        }
    
    func pv(rate : Double, numberOfPeriod : Double, payment: Double) -> Double {
        var retval : Double = 0;
        let t: Bool = false;
            if (rate == 0) {
                retval = -1*((numberOfPeriod*payment));
            }
            else {
            let r1: Double = rate + 1;
            retval = (( ( 1 - pow(r1, numberOfPeriod) ) / rate ) * (t ? r1 : 1)  * payment - 0) / pow(r1, numberOfPeriod);
            }
            return retval;
    }
    
    func checkFormValid() {
        self.isValidForm = !self.thuNhapBinhQuanNam.isBlank
        && !self.tyLeMuaSamTrenThuNhap.isBlank
        && !self.traNoHangThang.isBlank
        && !self.chiTieuHangThang.isBlank
        && !self.noThuNhapDti.isBlank
//        && !self.coPhiPhatSinhMuaTaiSan.isBlank
        && !self.soTienHienCo.isBlank
        && !self.tyLeDatCoc.isBlank
        && !self.duPhongChiPhi.isBlank
        && !self.soNamVayMuaTaiSan.isBlank
        && !self.laiSuatVay.isBlank
    }
    
    func onSubmit() {
        self.navToResult = true
    }
}

struct ShoppingPlanStep1View_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingPlanStep1View()
    }
}
