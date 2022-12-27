//
//  DetailCouponsView.swift
//  ProNexus
//
//  Created by Tú Dev app on 11/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct DetailCouponsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            ScrollView {
                // Header
                
                VStack(alignment: .center) {
                    WebImage(url: URL(string: "https://media-cdn.laodong.vn/storage/newsportal/2021/7/11/929522/77489_51946_722D.jpeg")).resizable()
                        .frame(width: screenWidth(), height: 250, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                }
                HStack {
                    BackButton(dismissAction: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    Spacer()
                    
                    
                    HStack {
                        
                        Button(action: {
                        }) {
                            CircleButton(icon: "square.and.arrow.up", color: Color(hex: "#EFCE4F"))
                            
                        }
                        Button(action: {  }) {
                            CircleButton(icon: "heart", color: Color(hex: "#49D472"))
                        }
                                                
                    }
                }.offset(x:0,y:-200).padding(.horizontal,20)
                VStack(alignment: .leading, spacing: 10) {
                    HStack{
                        Text("Giảm -45%").font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(Color(.red))
                        .cornerRadius(12)
                    }.padding(.leading,20).offset(y:-40)
                    
                    Text( "[E - voucher Người mới] Tặng ngay mã giảm 25k x 02 khoá học Udemy")
                        .appFont(style: .headline, weight: .bold, size: 20, color: Color(hex: "#4D4D4D"))
                        .fixedSize(horizontal: false, vertical: true).offset(y:-30).padding(.leading,20)
                    
                    HStack (alignment: .center, spacing: 0.0) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray)
                            .frame(height: 18).padding(.trailing,10)

                        
                        Text("ProNexus").appFont(style: .body, size: 10)
                        
                        
                        
                        Spacer()
                    
                        Text("Thời hạn đến :").appFont(style: .body, size: 10)

                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray)
                            .frame(height: 10).padding(.trailing,10)
                        Text("22/12/2012").appFont(style: .body, size: 10)

    //                    Text("  \((Date(fromString: "10/10/2020"[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy")))!)").appFont(style: .body, size: 10)
                    }
                    .padding(.horizontal, 37)
                    .offset(y: -20)
                    
                    // CONTENT
                    VStack(spacing: 10) {
                        
                        Text("Cognitive decline is inevitable as we get older. According to the American Psychologi-cal Association, “the brain’s volume peaks in the early 20s and gradually declines for the rest of life But your lifestyle can slow the process.You can preserve and even enhance your mental capabilities as you age. Simple behaviour changes can help us stay sharp for as long as possible.What you do or don’t do makes a huge difference to your memory skills.Pursuing both intellectual and physical chal-lenges, as uncomfortable as it may be, is one of the best ways to slow the natural memory decline process. New challenges are a way to exercise the mind and build new pathways.Cognitive decline is inevitable as we get older. According to the American Psychologi-cal Association, “the brain’s volume peaks in the early 20s and gradually declines for the rest of life”.").appFont(style: .body, size: 14).padding(20)

                        
                    }
                    .frame(width: screenWidth()-37)
                    .background(Color.white)
                    .cornerRadius(15)
                    .myShadow().padding(.horizontal,20)
                }
                
                VStack{
                    Button(action: {}, label: {
                    Text("Sử dụng ngay").appFont(style: .body, color: .white)
                })
                    .frame(width: screenWidth(), height: 55)
                    .buttonStyle(GradientButtonStyle())}

            }
            .offset(y: 10)
            .padding(.horizontal, 37.0)
            
            
            
        }.padding(.top,-60)
        
    }
    
}


struct DetailCouponsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCouponsView()
    }
}
