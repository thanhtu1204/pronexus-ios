//
//  District.swift
//  ProNexus
//
//  Created by TUYEN on 11/27/21.
//

import SwiftUI

struct District: View {
    @EnvironmentObject var service: ProviderApiService
    @State var dataProvice: [ProvinceModel] = []
    
    @State var loading = true
    @Binding var provinceId: Int?
    @Binding var districtId: Int?
    @Binding var districtName: String
    @Binding var show: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            
            Button {
                self.show.toggle()
            } label: {
                Image(systemName: "xmark.circle.fill").resizable().frame(width: 20, height: 20).foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, -10)
            }
            
            ScrollView (showsIndicators: false) {
                if $loading.wrappedValue {
                    SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
                } else {
                    VStack(alignment: .leading) {
                        if let items = dataProvice {
                            ForEach(items) { item in
                                Button(action: {
                                    self.show.toggle()
                                    self.districtId = item.districtId
                                    self.districtName = item.name ?? ""
                                }, label: {
                                    Text("\(item.name ?? "")")
                                        .appFont(style: .body, color: Color(hex: "#999999"))
                                })
                                Divider()
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 300,  maxWidth: screenWidth(), maxHeight: 350)
        })
            .padding(20)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal,50)
            .frame(minWidth: 300,  maxWidth: screenWidth(), maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
        
            .onAppear() {
                self.loading = true
                _ = service.loadDistrictByProvinceId(id: provinceId ?? 0).done { response in
                    if let data = response.results {
                        self.dataProvice = data
                    }
                    self.loading = false
                }
            }
        
    }
}

//struct District_Previews: PreviewProvider {
//    static var previews: some View {
//        District(provinceId: .constant(100), districtId: .constant(10), districtName: .constant(""), show: .constant(true)).environmentObject(ProviderApiService())
//    }
//}
