//
//  SubmitForm1View.swift
//  ProNexus
//
//  Created by Tú Dev app on 06/11/2021.
//

import SwiftUI

struct HeadingRegisterAdvisor: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var title : String = ""
    
    var body: some View {
        ZStack (alignment: .center) {
            HStack {
                //button left
                Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }).frame(width: 50, alignment: .leading)
                Spacer()
            }
            
            Text(title).appFont(style: .body,weight: .bold, size: 18, color: Color(hex: "#0049C3")).frame(width: containerWidth())
        }
    }
}

struct SubmitForm1View: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var service : UserApiService
    
    @State var showImagePicker: Bool = false
    @State var showFrontImagePicker: Bool = false
    @State var showBackImagePicker: Bool = false
    @State var imagePreview: UIImage?
    @State var imageFrontPreview: UIImage?
    @State var imageBackPreview: UIImage?
    @State var base64: String = ""
    @State var isValidForm = false
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Image("bg_login_regsiter").resizable().scaledToFill().offset(x: 0, y: -5).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 20) {
                    HeadingRegisterAdvisor(title: "Hoàn thiện hồ sơ 1/3") .padding(.top, 60)
                    ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8, content: {
                        HStack{
                            Text("Tải lên ảnh đại diện")
                                .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                            Text("(")
                                .appFont(style: .title1, size: 16, color: Color(hex: "#A4A4A4"))
                            Text("*")
                                .appFont(style: .body, size: 16, color: Color(hex: "#FF0000")).padding(-8)
                            Text(")")
                                .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4")).padding(-8)
                        }
                        HStack{
                            Spacer()
                            Button(action: {self.showImagePicker.toggle()}, label: {
                                
                                if imagePreview != nil {
                                    Image(uiImage: imagePreview!)
                                        .resizable().scaledToFill().frame(width: 130, height: 130,alignment: .center)
                                        .cornerRadius(65)
                                } else {
                                    Image("ic_noAvatar").resizable().scaledToFit().frame(width: 130, height: 130,alignment: .center)
                                    
                                }
                            })
                            Spacer()
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePickerView(sourceType: .photoLibrary) { image in
                                imagePreview = image
                                service.dataRegisterAdvisor.MediaUrl = imagePreview?.toBase64(format: .jpeg(1)) ?? ""
                                checkFormValid()
                            }
                        }
                        
                    }).padding(.top,21)
                    
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        MyTextField(label: "Số CMND/CCCD/Hộ chiếu", type: .number, value: $service.dataRegisterAdvisor.identityNumber.onUpdate(checkFormValid), required: true)
                    }) .padding(.top,21)
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        HStack{
                            Text("Ảnh CMND/CCCD/Hộ chiếu")
                                .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                            Text("(")
                                .appFont(style: .title1, size: 16, color: Color(hex: "#A4A4A4"))
                            Text("*")
                                .appFont(style: .body, size: 16, color: Color(hex: "#FF0000")).padding(-8)
                            Text(")")
                                .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4")).padding(-8)
                        }
                        
                    }) .padding(.top,21)
                    
                    
                    HStack{
                        VStack{
                            Button(action: { self.showFrontImagePicker.toggle() }, label: {
                                VStack{
                                    
                                    if imageFrontPreview != nil {
                                        Image(uiImage: imageFrontPreview!)
                                            .resizable().scaledToFill().frame(width: 99, height: 99,alignment: .center)
                                            .cornerRadius(65)
                                    } else {
                                        Image("ic_addImage").resizable().scaledToFit().frame(width: 99, height: 99,alignment: .center)
                                    }

                                    Text("Mặt Trước")
                                        .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                                    
                                }
                            }).sheet(isPresented: $showFrontImagePicker) {
                                ImagePickerView(sourceType: .photoLibrary) { image in
                                    imageFrontPreview = image
                                    service.dataRegisterAdvisor.forthMediaURL = imagePreview?.toBase64(format: .jpeg(1)) ?? ""
                                    checkFormValid()
                                }
                            }
                            
                        }.padding(.trailing,12)
                        VStack{
                            Button(action: { self.showBackImagePicker.toggle() }, label: {
                                VStack{
                                    if imageBackPreview != nil {
                                        Image(uiImage: imageBackPreview!)
                                            .resizable().scaledToFill().frame(width: 99, height: 99,alignment: .center)
                                            .cornerRadius(65)
                                    } else {
                                        Image("ic_addImage").resizable().scaledToFit().frame(width: 99, height: 99,alignment: .center)
                                    }
                                    
                                    Text("Mặt Sau")
                                        .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                                }
                            }).sheet(isPresented: $showBackImagePicker) {
                                ImagePickerView(sourceType: .photoLibrary) { image in
                                    imageBackPreview = image
                                    service.dataRegisterAdvisor.backMediaURL = imagePreview?.toBase64(format: .jpeg(1)) ?? ""
                                    checkFormValid()
                                }
                            }
                        }
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        HStack{
                            Text("Chức danh")
                                .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4"))
                            Text("(")
                                .appFont(style: .title1, size: 16, color: Color(hex: "#A4A4A4"))
                            Text("*")
                                .appFont(style: .body, size: 16, color: Color(hex: "#FF0000")).padding(-8)
                            Text(")")
                                .appFont(style: .body, size: 16, color: Color(hex: "#A4A4A4")).padding(-8)
                        }
                        TextField("", text: $service.dataRegisterAdvisor.jobTitle.onUpdate(checkFormValid))
                            .appFont(style: .body)
                            .padding(.top,5).textFieldStyle(RoundedTextFieldStyle())
                        
                    }) .padding(.top,21)
                    HStack (alignment: .center, spacing: 15) {
                        Spacer()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Quay lại").appFont(style: .body, color: .white)
                        }).buttonStyle(RoundedSilverButtonStyle())
                        
                        
                        if $isValidForm.wrappedValue {
                            NavigationLink {
                                SubmitForm2View()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarHidden(true)
                            } label: {
                                Text("Tiếp theo").appFont(style: .body, color: .white)
                            }.buttonStyle(GradientButtonStyle())
                        } else
                        {
                            Button(action: {
                                
                            }, label: {
                                Text("Tiếp theo").appFont(style: .body, color: .white)
                            }).buttonStyle(RoundedSilverButtonStyle())
                        }
                        
                        
                        Spacer()
                    }
                    }
                }
                .frame(width: UIScreen.screenWidth - 74)
                .padding(.horizontal, 37)
                .padding(.bottom, 40)
            
        }.padding(0)
    }
    
    func checkFormValid() {
        self.isValidForm = !self.service.dataRegisterAdvisor.identityNumber.isBlank
        && !self.service.dataRegisterAdvisor.MediaUrl.isBlank
        && !self.service.dataRegisterAdvisor.jobTitle.isBlank
        && !self.service.dataRegisterAdvisor.forthMediaURL.isBlank
        && !self.service.dataRegisterAdvisor.backMediaURL.isBlank
    }
}

struct SubmitForm1View_Previews: PreviewProvider {
    static var previews: some View {
//        RegisterAdvisorView().environmentObject(UserApiService())
        SubmitForm1View().environmentObject(UserApiService())
    }
}
