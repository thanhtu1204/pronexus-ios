//
//  SubmitForm3View.swift
//  ProNexus
//
//  Created by Tú Dev app on 06/11/2021.
//

import SwiftUI

struct SubmitForm3View: View {
    @State var isShowAlertError = false
    @State var message = ""
    @State private var checked = false
    @State private var checkedOK = false
    @State private var showingSheet = false
    
    @EnvironmentObject var service : UserApiService
    @Environment(\.presentationMode) private var presentationMode
    @State var isValidForm = false
    
    @State var showImagePickerFirst: Bool = false
    @State var showImagePickerSecond: Bool = false
    @State var showImagePickerThird: Bool = false
    
    @State var imageFirstPreview: UIImage?
    @State var imageSecondPreview: UIImage?
    @State var imageThirdPreview: UIImage?
    @State var imagePreview: UIImage?
    @State var certificateMediaList: [String] = []
    
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Image("bg_login_regsiter").resizable().scaledToFill().offset(x: 0, y: -5).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                HeadingRegisterAdvisor(title: "Hoàn thiện hồ sơ 3/3").padding(.top, 60)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        Text("Liên kết cá nhân")
                            .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                        
                        HStack {
                            Image(systemName:  "link").accentColor(.gray).padding(.leading, 10)
                            TextField("", text: $service.dataRegisterAdvisor.linkUrl)
                                .appFont(style: .body)
                                .padding(.top,5)
                        }.frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color(hex: "#0974DF"),lineWidth:0.1))
                        
                    }) .padding(.top,21)
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        Text("Giới thiệu (< 250 từ)")
                            .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                        TextView(text: $service.dataRegisterAdvisor.aboutMe).appFont(style: .body)
                            .padding(.top,5).padding(10)
                            .frame(height: 76)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color(hex: "#0974DF"), lineWidth: 0.1))
                        
                    }) .padding(.top,21)
                    
                    VStack(alignment: .leading, content: {
                        
                        Text("Tải lên bằng cấp, chứng chỉ, giải thưởng (jpg, png, pdf)")
                            .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                    }) .padding(.top,21)
                    
                    
                    HStack() {
                        Button(action: { self.showImagePickerFirst.toggle() }, label: {
                            VStack{
                                
                                if imageFirstPreview != nil {
                                    Image(uiImage: imageFirstPreview!)
                                        .resizable().scaledToFill().frame(width: 99, height: 99,alignment: .center)
                                        .cornerRadius(65)
                                } else {
                                    Image("ic_addImage").resizable().scaledToFit().frame(width: 99, height: 99,alignment: .center)
                                }

                                
                            }
                        }).sheet(isPresented: $showImagePickerFirst) {
                            ImagePickerView(sourceType: .photoLibrary) { image in
                                imageFirstPreview = image
                                certificateMediaList.append(imageFirstPreview?.toBase64(format: .jpeg(1)) ?? "")
//                                service.dataRegisterAdvisor.certificateMediaList = self.certificateMediaList
                                checkFormValid()
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: { self.showImagePickerSecond.toggle() }, label: {
                            VStack{
                                
                                if imageSecondPreview != nil {
                                    Image(uiImage: imageSecondPreview!)
                                        .resizable().scaledToFill().frame(width: 99, height: 99,alignment: .center)
                                        .cornerRadius(65)
                                } else {
                                    Image("ic_addImage").resizable().scaledToFit().frame(width: 99, height: 99,alignment: .center)
                                }

                                
                            }
                        }).sheet(isPresented: $showImagePickerSecond) {
                            ImagePickerView(sourceType: .photoLibrary) { image in
                                imageSecondPreview = image
                                certificateMediaList.append(imageSecondPreview?.toBase64(format: .jpeg(1)) ?? "")
//                                service.dataRegisterAdvisor.certificateMediaList = self.certificateMediaList
                                checkFormValid()
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: { self.showImagePickerThird.toggle() }, label: {
                            VStack{
                                
                                if imageThirdPreview != nil {
                                    Image(uiImage: imageFirstPreview!)
                                        .resizable().scaledToFill().frame(width: 99, height: 99,alignment: .center)
                                        .cornerRadius(65)
                                } else {
                                    Image("ic_addImage").resizable().scaledToFit().frame(width: 99, height: 99,alignment: .center)
                                }
                                
                            }
                        }).sheet(isPresented: $showImagePickerThird) {
                            ImagePickerView(sourceType: .photoLibrary) { image in
                                imageThirdPreview = image
                                certificateMediaList.append(imageThirdPreview?.toBase64(format: .jpeg(1)) ?? "")
//                                service.dataRegisterAdvisor.certificateMediaList = self.certificateMediaList
                                checkFormValid()
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        Text("Hồ sơ cá nhân (PDF, docx)")
                            .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                        
                        Button(action: {}, label: {
                            VStack (alignment: .center) {
                                Image("ic_upload_files").resizable().scaledToFit().frame(width: containerWidth(), height: 98 ,alignment: .center)
                                
                            }
                        })
                        
                    }) .padding(.vertical, 21)
                    
                    HStack (alignment: .center, spacing: 4) {
                        Toggle(isOn: $checked.onUpdate(checkFormValid)) {
                            
                        }.padding(.all, 0).padding(.trailing, 4)
                            .toggleStyle(CheckboxSquareStyle())
                        
                        Text("Tôi đã đọc và đồng ý với các")
                            .appFont(style: .body, size: 10, color: Color(hex: "#707070"))
                        Spacer()
                        
                        Button(action: {
                            showingSheet.toggle()
                            checkedOK.toggle()
                        }, label: {
                            Text("điều khoản sử dụng của Pronexus")
                                .appFont(style: .body, size: 10, color: Color(hex: "#0974DF"))
                        }).sheet(isPresented: $showingSheet) {
                            
                            VStack {
                                ZStack {
                                    Text("ĐIỀU KHOẢN PHÁP LÝ")
                                        .appFont(style: .body, weight: .bold, size: 16, color: Color(hex: "#4D4D4D")).padding(.vertical, 30).frame(maxWidth: .infinity, alignment: .center)
                                    Button {
                                        showingSheet.toggle()
                                    } label: {
                                        Image(systemName: "xmark.circle.fill").resizable().frame(width: 18, height: 18).foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .padding(.trailing, 0)
                                    }
                                    
                                }
                                MyWebView(urlAddress: "https://pronexus.com.vn/dieu-khoan-su-dung.html")
                                
                                VStack(alignment: .center) {
                                    HStack (alignment: .center, spacing: 4) {
                                        Spacer()
                                        Toggle(isOn: .init(
                                            get: { checkedOK },
                                            set: {
                                                checkedOK = $0
                                                self.showingSheet.toggle()
                                            }
                                        )) {
                                            
                                        }.padding(.all, 0).padding(.trailing, 4)
                                            .toggleStyle(CheckboxSquareStyle())
                                        
                                        Text("Tôi đã hiểu")
                                            .appFont(style: .body, color: Color(hex: "#707070"))
                                        Spacer()
                                    }.padding(0)
                                }.padding(.top, 20)
                                
                            }.padding(.horizontal, 30)
                        }
                        
                        
                    }.padding(0)
                    
                    VStack (alignment: .center) {
                        HStack (spacing: 15){
                            Spacer()
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Quay lại").appFont(style: .body, color: .white)
                            })
                                .buttonStyle(RoundedSilverButtonStyle())
                            
                            
                            if $isValidForm.wrappedValue {
                                Button(action: requestRegister, label: {
                                    Text("Hoàn thành").appFont(style: .body, color: .white)
                                })
                                    .buttonStyle(GradientButtonStyle())
                            } else
                            {
                                Button(action: {
                                   
                                }, label: {
                                    Text("Hoàn thành").appFont(style: .body, color: .white)
                                }).buttonStyle(RoundedSilverButtonStyle())
                            }
                            
                           
                            Spacer()
                        }
                    }
                }
             
                
            }
            .padding(.horizontal, 37)
            
            // show screen confirm otp
            if $service.isShowModalConfirmCode.wrappedValue {
                VerificationOtp(phone: self.service.dataRegisterAdvisor.userName).environmentObject(service).transition(.move(edge: .bottom))
                    .zIndex(1)
            }
            // show alert if have an error
            if $isShowAlertError.wrappedValue {
                
                AlertView(msg: message, show: $isShowAlertError)
            }
            
        }.padding(0)
    }
    
    func checkFormValid() {
        self.isValidForm = !self.service.dataRegisterAdvisor.firstname.isBlank
        && !self.service.dataRegisterAdvisor.lastname.isBlank
        && !self.service.dataRegisterAdvisor.userName.isBlank
        && !self.service.dataRegisterAdvisor.dob.isBlank
        && !self.service.dataRegisterAdvisor.gender.isBlank
        && !self.service.dataRegisterAdvisor.userEmail.isBlank
        && !self.service.dataRegisterAdvisor.password.isBlank
        &&
        checked
    }
    
    func requestRegister() {
        var dob: Int64 = 0
        if let birthday = Date(fromString: service.dataRegisterAdvisor.dob, format: .custom("dd/M/yyyy")) {
            dob = Int64(birthday.timeIntervalSince1970)
        }
        
        let data: [String: Any] = [
//            "dob": service.dataRegisterAdvisor.dob,
            "dob": dob ,
            "gender": service.dataRegisterAdvisor.gender == "Nam" ? 1 : 2, // number 1 hoặc 2
            "aboutMe": service.dataRegisterAdvisor.aboutMe,
            "linkUrl": service.dataRegisterAdvisor.linkUrl,
            "company": service.dataRegisterAdvisor.company,
            "lastname": service.dataRegisterAdvisor.lastname,
            "password": service.dataRegisterAdvisor.password,
            "jobTitle": service.dataRegisterAdvisor.jobTitle,
            "username": service.dataRegisterAdvisor.userName,
            "mediaUrl": service.dataRegisterAdvisor.MediaUrl,
            "firstname": service.dataRegisterAdvisor.firstname,
            "referCode": service.dataRegisterAdvisor.referCode,
            "userEmail": service.dataRegisterAdvisor.userEmail,
            "identityNumber": service.dataRegisterAdvisor.identityNumber,
            "yearsExperience": service.dataRegisterAdvisor.yearsExperience,
            "BackMediaUrl": service.dataRegisterAdvisor.backMediaURL ?? "",
            "ForthMediaURL": service.dataRegisterAdvisor.forthMediaURL ?? "",
            "ClassificationIdList": service.dataRegisterAdvisor.classificationIDList ?? [],
            "CertificateMediaList": self.certificateMediaList,
            "type": 1
        ]
        service.postRegisterAdvisor(parameters: data).done { response in
            if response.message == "The request is invalid." {
                if let modal = response.modalState{
                    if ((modal.name?.isEmpty) != nil) {
                        self.message = "Số điện thoại đã tồn tại"
                    } else if ((modal.email?.isEmpty) != nil) {
                        self.message = "Email đã tồn tại"
                    } else if ((modal.passwords?.isEmpty) != nil) {
                        self.message = "Mật khẩu không nhỏ hơn 6 ký tự"
                    }
                }
                self.isShowAlertError = true
            } else {
                self.service.isShowModalConfirmCode = true
                // show modal confirm
            }
        }
    }
    
}

struct SubmitForm3View_Previews: PreviewProvider {
    static var previews: some View {
        SubmitForm3View().environmentObject(UserApiService())
    }
}
