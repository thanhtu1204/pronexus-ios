//
//  AdvisorReviewsView.swift
//  ProNexus
//
//  Created by Tú Dev app on 15/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct AdvisorReviewsView: View {
    @State var providerId : Int = 0
    @State var expertise : String = ""
    @State var rating : Int = 0
    @State var noteSpecialize : String = ""
    @State var ratingSpecialize : Int = 0
    @State var noteExperience : String = ""
    @State var ratingExperience : Int = 0
    @State var noteService : String = ""
    @State var ratingService : Int = 0
    @State var imgURL : String = ""
    @State var fullName : String = ""
    @State var jobTitle : String = ""
    
    @EnvironmentObject var service : ProviderApiService
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.isPreview) var isPreview
    
    // khai bao service
    var body: some View {
        VStack{
            Header(title: "Đánh giá Advisor", contentView: {
                ButtonIcon(name: "arrow.left", onTapButton: {
                    self.presentationMode.wrappedValue.dismiss()
                    
                })
                Spacer()
                
            }).padding(.bottom,60)
            
            ScrollView(showsIndicators:false){
                VStack(alignment: .center, spacing: 0) {
                    WebImage(url: URL(string: imgURL))
                        .resizable()
                        .placeholder {
                            Image("ic_picture").resizable().scaledToFit()
                        }
                        .indicator(.progress)
                        .frame(width: 140, height: 140, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(15)
                        .offset(x: 0, y: -30)
                        .myShadow()
                        .padding(.top,40)
                    
                    
                    //                        if let fullName = model.fullName() {
                    Text(fullName).appFont(style: .headline, color: Color(hex: "#4D4D4D"))
                    //                        }
                    //
                    
                    if jobTitle != "" {
                        Text(jobTitle)
                            .myFont(style: .body)
                            .padding(.leading, 6)
                            .padding(.trailing, 6)
                            .padding(.top, 10).padding(.bottom, 4)
                            .background(Color(hex: "#E6E6E6"))
                            .foregroundColor(Color(hex: "#808080"))
                            .cornerRadius(15)
                    }
                }
                
                VStack{
                    HStack(){  Text("Kiến thức chuyên môn")
                        .appFont(style: .body,weight: .regular, size: 16, color: Color(hex: "#4D4D4D"))}
                    RattingView(rating: $ratingSpecialize)
                    TextField("Viết nhận xét", text: $noteSpecialize)
                        .appFont(style: .body)
                        .padding(.top,5).textFieldStyle(RoundedTextFieldStyle())
                    
                }.padding(.horizontal, 18)
                    .padding(.vertical,17)
                    .padding(.bottom,10)
                    .frame(width: screenWidth()-74, height: 140)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow()
                    .offset(x: 0, y: 30)
                
                VStack{
                    HStack(){  Text("Kinh nghiệm thực tế")
                        .appFont(style: .body,weight: .regular, size: 16,  color: Color(hex: "#4D4D4D"))}
                    RattingView(rating: $ratingExperience)
                    TextField("Viết nhận xét", text: $noteExperience)
                        .appFont(style: .body)
                        .padding(.top,5).textFieldStyle(RoundedTextFieldStyle())
                    
                }.padding(.horizontal, 18).padding(.vertical,17).padding(.bottom,10)
                    .frame(width: screenWidth()-74, height: 140)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow()
                    .offset(x: 0, y: 30)
                
                VStack{
                    HStack(){  Text("Thái độ phục vụ")
                        .appFont(style: .body,weight: .regular, size: 16, color: Color(hex: "#4D4D4D"))}
                    RattingView(rating: $ratingService)
                    TextField("Viết nhận xét", text: $noteService)
                        .appFont(style: .body)
                        .padding(.top,5)
                        .textFieldStyle(RoundedTextFieldStyle())
                    
                }.padding(.horizontal, 18)
                    .padding(.vertical,17)
                    .padding(.bottom,10)
                    .frame(width: screenWidth()-74, height: 140)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow()
                    .offset(x: 0, y: 30)
                
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Huỷ bỏ").appFont(style: .body, color: Color(hex: "#4C99F8"))
                    })
                        .buttonStyle(BlueButtonBorder(w: halfWidth() - 50))
                    Spacer()
                    Button(action: {
                        postData()
                    }, label: {
                        Text("Gửi đánh giá").appFont(style: .body, color: .white)
                    })
                        .buttonStyle(BlueButton(w: halfWidth() - 50))
                }
                    .frame(width: screenWidth() - 74)
                    .padding(.horizontal, 40)
                    .padding(.top,40)
                    .padding(.bottom, 60)
                
                
            }
        }
        
    }
    func postData (){
        
        let data: [String: Any] = [
            "ProviderId": providerId,
            "NoteSpecialize" :noteSpecialize,
            "RatingSpecialize": ratingSpecialize,
            "NoteExperience" : noteExperience,
            "RatingExperience": ratingExperience,
            "NoteService" :noteService,
            "RatingService": ratingService
        ]
        _ = service.postAdvisorFeedBack(parameters: data).done({ rs in
            if rs.ok  {
                AppUtils.showAlert(text: "Gửi đánh giá thành công.")
                self.presentationMode.wrappedValue.dismiss()
            } else {
                AppUtils.showAlert(text: "Gửi đánh giá thất bại.")
            }
        })
        
    }
}

struct AdvisorReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvisorReviewsView()
    }
}
