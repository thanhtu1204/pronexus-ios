//
//  ProfileUserFormEdit.swift
//  ProNexus
//
//  Created by IMAC on 11/9/21.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfileUserFormEdit: View {
    
    @State var id = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var birthDay = ""
    @State var gender: Int?
    @State var genderDescription = ""
    @State var identityNumber = ""
    @State var phone = ""
    @State var email = ""
    @State var district = ""
    @State var province = ""
    @State var city = ""
    @State var userAvatar = ""
    @State private var checked = false
    @State var showsDatePicker = false
    @State var provinceId: Int?
    @State var provinceName = ""
    @State var districtName = ""
    @State var districtId : Int?
    @State var imagePreview: UIImage?
    @State var showImagePicker: Bool = false
    @State var showProvinceModal = false
    @State var showDistrictModal = false
    @State var onChangeProvince = false
    @State var loading = true
    @State var isChangeAvatar = false
    @State var submit = false
    
    @State var isShowSuccess = false
    
    static var uniqueKey: String {
        UUID().uuidString
    }
    
    static let options: [DropdownOption] = [
        DropdownOption(key: uniqueKey, value: "Nam"),
        DropdownOption(key: uniqueKey, value: "Nữ"),
    ]
    
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var service: UserApiService
    
    var body: some View {
        
        ZStack(alignment: .top) {
            // HEADER
            VStack {
                VStack {
                    Header(title: "Hồ sơ cá nhân", contentView: {
                        ButtonIcon(name: "arrow.left", onTapButton: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        Spacer()
                    })
                }
                .zIndex(99)
                
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else
                {
                    //
                    ZStack {
                        ScrollView (showsIndicators: false) {
                            VStack () {
                                Button(action: {self.showImagePicker.toggle()}, label: {
                                    if imagePreview != nil {
                                        Image(uiImage: imagePreview!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 130, height: 130,alignment: .center)
                                            .cornerRadius(65)
                                            .padding(.top, 20)
                                    } else {
                                        if (userAvatar != "") {
                                            
                                            WebImage(url: URL(string: "\(userAvatar)"))
                                                .resizable()
                                                .onSuccess { image, data, cacheType in
                                                    // Success
                                                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                                }
                                                .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                                                .placeholder {
                                                    Image("ic_picture").resizable().scaledToFit()
                                                }
                                                .indicator(.activity) // Activity Indicator
                                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 130, height: 130)
                                                .clipShape(Circle())
                                                .padding(.top, 30)
                                                .myShadow()
                                            
                                            
                                        } else {
                                            Image("ic_noAvatar")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 130, height: 130,alignment: .center)
                                                .padding(.top, 20)
                                        }
                                    }
                                })
                                
                                
                                
                                VStack(alignment: .center, spacing: 25) {
                                    Group{
                                        HStack{
                                            MyTextField(placeholder: "Họ", value: $firstName)
                                            MyTextField(placeholder: "Tên", value: $lastName)
                                        }
                                        HStack{
                                            VStack(alignment: .leading, spacing: 6){
                                                MyTextField(placeholder: "Ngày sinh", value: $birthDay, readOnly: true)
                                                
                                            }
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                self.showsDatePicker.toggle()
                                            }
                                            Group {
                                                DropdownSelector(
                                                    placeholder: (self.gender == 0) ? "Giới tính" : (self.gender == 2 ? "Nam" : "Nữ"),
                                                    options: ProfileAdvisorFormEdit.options,
                                                    onOptionSelected: { option in
                                                        print(option)
                                                    })
                                                    .appFont(style: .body)
                                                    .textFieldStyle(RoundedTextFieldStyle2())
                                            }
                                            .padding(.vertical, -5)
                                            
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6, content: {
                                            MyTextField(placeholder: "Số CMTND/CCCD/HC", value: $identityNumber)
                                            
                                            
                                        })
                                        
                                        VStack(alignment: .leading, spacing: 6, content: {
                                            MyTextField(placeholder: "Email", type: .email, value: $email)
                                            
                                        })
                                        
                                        VStack(alignment: .leading, spacing: 6, content: {
                                            MyTextField(placeholder: "Điện thoại", type: .phone, value: $phone)
                                            
                                        })
                                        
                                        VStack (alignment: .leading) {
                                            MyTextField(placeholder: "Tỉnh/Thành phố", value: $provinceName.onUpdate {
                                                resetData()
                                            }, required: false, readOnly: true)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            self.showProvinceModal.toggle()
                                        }
                                        
                                        VStack (alignment: .leading) {
                                            MyTextField(placeholder: "Quận/Huyện", value: $districtName, required: false, readOnly: true)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            self.showDistrictModal.toggle()
                                        }
                                        
                                    }.padding(.horizontal, 33)
                                }.padding(.vertical, 30)
                            }
                            .frame(width: UIScreen.screenWidth - 74)
                            .background(Color.white)
                            .cornerRadius(15)
                            .myShadow()
                            .offset(y: 80)
                            
                            Button(action: {updateProfile()}, label: {
                                if $submit.wrappedValue
                                {
                                    ActivityIndicator(isAnimating: true)
                                        .configure { $0.color = .white }
                                } else {
                                    Text("Cập nhật").appFont(style: .body, color: .white)
                                }
                            })
                                .padding(.top, 100)
                                .buttonStyle(BlueButton())
                        }
                    }
                    .myShadow()
                }
                
                Spacer()
            }
            
            if $showsDatePicker.wrappedValue {
                MyDatePicker(show: $showsDatePicker, dateString: $birthDay)
            }
            
            if $showProvinceModal.wrappedValue {
                ProvinceModalView(show: $showProvinceModal, provinceId: $provinceId, provinceName: $provinceName,  onChangeProvince: $onChangeProvince ).environmentObject(ProviderApiService())
            }
            
            if provinceId != nil {
                if $showDistrictModal.wrappedValue {
                    District(provinceId: $provinceId, districtId: $districtId, districtName: $districtName, show: $showDistrictModal ).environmentObject(ProviderApiService())
                }
            }
            if $showImagePicker.wrappedValue {
                ImagePickerViewModal(sourceType: .photoLibrary, showPicker: $showImagePicker) { image in
                    imagePreview = image
                    userAvatar = imagePreview?.toBase64(format: .jpeg(1)) ?? ""
                    self.isChangeAvatar = true
                }.edgesIgnoringSafeArea(.top)
            }
            
            if $isShowSuccess.wrappedValue {
                CustomAlertView(title: "Thông báo", msg: "Cập nhật thông tin thành công", textButton1: "Đồng ý", onPressBtn1: {
                    self.isShowSuccess.toggle()
                    self.presentationMode.wrappedValue.dismiss()
                }, show: $isShowSuccess)
            }
            
        }.onAppear {
            loadData()
        }
        
    }
    
    func loadData() {
        _ = service.loadProfileCustomer().done { response in
            self.loading = false
            if let obj = response.payload {
                self.firstName = obj.firstName ?? ""
                self.lastName = obj.lastName ?? ""
                self.gender = obj.gender ?? 0
                self.phone = obj.phone ?? ""
                self.email = obj.userEmail ?? ""
                self.provinceName = obj.province ?? ""
                self.districtName = obj.district ?? ""
                self.provinceId = obj.provinceID ?? 0
                self.districtId = obj.districtID ?? 0
                self.userAvatar = obj.mediaUrl ?? ""
                self.identityNumber = obj.identityNumber ?? ""
                self.genderDescription = obj.genderDescription ?? ""
                if !obj.dob.isBlank && obj.dob.count >= 10 {
                    self.birthDay = (Date(fromString: obj.dob[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy"))) as! String
                }
            }
        }
    }
    
    func resetData () {
        if onChangeProvince == true {
            self.districtName = ""
        }
    }
    
    func updateProfile () {
        self.submit = true
        var dob: Int64 = 0
        if let birthday = Date(fromString: birthDay, format: .custom("dd/M/yyyy")) {
            dob = Int64(birthday.timeIntervalSince1970)
        }
        
        var data: [String: Any] = [
            "dob": dob,
            "city": city,
            "phone": phone,
            "gender": gender ?? 0,
            "userEmail": email,
            "lastname":lastName,
            "district": district,
            "firstname": firstName,
            "identityNumber": identityNumber,
            
        ]
        
        if isChangeAvatar {
            data["mediaUrl"] = userAvatar
        }
        
        if let provinceId = provinceId {
            data["ProvinceId"] = provinceId
        }
        
        if let districtId = districtId {
            data["DistrictId"] = districtId
        }
        
        
        _ = service.updateProfileCustomer(parameters: data).done { response in
            self.submit = false
            if response.ok {
                self.loadData()
                self.isShowSuccess.toggle()
//                AppUtils.showAlert(text: "Cập nhật thông tin thành công")
//                self.presentationMode.wrappedValue.dismiss()
                
            } else {
                AppUtils.showAlert(text: "Có lỗi xảy ra. Vui lòng kiểm tra lại")
            }
        }
    }
    
}

struct ProfileUserFormEdit_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserFormEdit().environmentObject(UserApiService())
    }
}
