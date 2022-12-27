//
//  VerificationOtp.swift
//  ProNexus
//
//  Created by thanh cto on 05/11/2021.
//

import Foundation

import SwiftUI

struct VerificationOtp: View {
    
    @State var isCreateNewOtp = false
    @State var timerLabel = ""
    @State var countdownTimer: Timer!
    @State var totalTime = 120
    
    @State var isShowAlertError = false
    @State var message = ""
    @State var phone: String
    @State var code: String = ""
    
    @EnvironmentObject var service : UserApiService
    
    @Environment(\.presentationMode) var present
    
    var body: some View {
        ZStack (alignment: .center) {
            Image("bg_login_regsiter").resizable().scaledToFill().offset(x: 0, y: -5)
            VStack (alignment: .center, spacing: 20) {
                
                Image("logo")
                
                Text("XÁC THỰC OTP")
                    .appFont(style: .body, size: 16, color: Color(hex: "#333"))
                
                Text("Vui lòng nhập mã OTP được gửi đến số điện thoại \(phone)")
                    .appFont(style: .body, size: 12, color: Color(hex: "#333"))
                    .padding(.bottom)
                
                VStack(alignment: .center, spacing: 8, content: {
                    
                    
                    TextField("", text: $code)
                        .appFont(style: .body)
                        .padding(.top,5)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .frame(width: 100, alignment: .center)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                    
                    Text("Bạn có thể yêu cầu gửi lại mã mới sau \(timerLabel) giây").appFont(style: .body, size: 10, color: Color(hex: "#A4A4A4"))
                    
                    Button {
                        if (self.totalTime == 0) {
                            //                            txtOTP.text = .none // reset text
                            self.resetTime() // reset time and start
                            self.startTimer()
                            self.requestResendOtp()
                        } else
                        {
                            self.message = "Vui lòng đợi \(timerLabel) giây nữa."
                            self.isShowAlertError = true
                        }
                    } label: {
                        Text("Gửi lại mã").underline().appFont(style: .body, size: 10, color: Color(hex: "#0974DF"))
                    }
                    
                    Button(action: requestConfirmOtp, label: {
                        Text("Xác nhận").appFont(style: .body, color: .white)
                    }).buttonStyle(GradientButtonStyle()).padding(.top, 30)
                    
                    
                }) .padding(.top, 25)
                
            }.padding(.horizontal, 37)
                .offset(x: 0, y: -130)
            
            //            .background(Color("bg").ignoresSafeArea(.all, edges: .bottom))
            
            
            // show screen confirm otp
//            if $service.isShowModalConfirmCode.wrappedValue {
//                VerificationOtp().environmentObject(service).transition(.move(edge: .bottom))
//                    .zIndex(1)
//            }
            
            // show alert if have an error
            if $isShowAlertError.wrappedValue {
                
                AlertView(msg: message, show: $isShowAlertError)
            }
        }
        .onAppear(perform: {
            if service.isCreateNewOtpResetPass {
                requestResendOtp()
            }
            startTimer()
        })
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
    // call api confirm opt
    func requestConfirmOtp() {
        
        // OTP register
        let data: [String: Any] = [
            "Username": self.phone,
            "Code": self.code
        ]
        
        _ = service.postConfirmOtp(parameters: data).done { response in
            if response.ok == false {
                self.message = "Xác thực thất bại, vui lòng thử lại"
                self.isShowAlertError = true
            } else {
                if service.isCreateNewOtpResetPass {
                    
                    service.dataResetPass.phone = self.phone
                    service.dataResetPass.code = self.code
                    // after confirm reset pass ok
                    navigateCreateNewPassScreen()
                    
                } else
                {
                    // after register ok
                    navigateLoginScreen()
                }
               
            }
        }
        
    }
    
    // call api resend OTP
    func requestResendOtp() {
        
        let data: [String: Any] = [
            "Username": self.phone,
        ]
        
        _ = service.postCreateOtp(parameters: data).done { response in
            if response.ok == false {
                self.message = "Không thể gửi lại mã vui lòng thử lại"
                self.isShowAlertError = true
            } else {
//                self.service.isShowModalConfirmCode = true
                // show modal confirm
            }
        }
    }
    
    func navigateLoginScreen() -> Void {
        let vc = UIHostingController(rootView: Login().environmentObject(UserApiService()))
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    func navigateCreateNewPassScreen() -> Void {
        let vc = UIHostingController(rootView: CreateNewPass().environmentObject(service))
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            updateTime()
        }
    }
    
    func updateTime() {
        timerLabel = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func resetTime() {
        countdownTimer.invalidate()
        totalTime = 120
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


struct VerificationOtp_Previews: PreviewProvider {
    static var previews: some View {
        VerificationOtp(phone: "0968868862").environmentObject(UserApiService())
    }
}
