//
//  CategoriesSelectionList.swift
//  ProNexus
//
//  Created by thanh cto on 31/10/2021.
//

import Foundation

import Combine
import SwiftUI
import SDWebImageSwiftUI

struct CategoriesSelectionListView: View {
    //    @State var items: [ClassificationModel] = [
    //        ClassificationModel(id: 1, name: "Hoạch định tài chính"),
    //        ClassificationModel(id: 2, name: "Hoạch định tài chính"),
    //        ClassificationModel(id: 3, name: "Hoạch định tài chính"),
    //        ClassificationModel(id: 4, name: "Hoạch định tài chính"),
    //        ClassificationModel(id: 5, name: "Hoạch định tài chính")]
    
    @State var selections: [Int] = []
    @State var classificationList: [ClassificationModel]?
    
    @State var isPresent = true
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var service: ClassificationApiService
    
    var body: some View {
        NavigationView {
            VStack {               
                Header(title: "Lựa chọn lĩnh vực", contentView: {
                    ButtonIcon(name: "arrow.left", onTapButton: {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    })
                    Spacer()
                })
                
                VStack {
                    Text("Bạn có thể chọn nhiều lĩnh vực quan tâm, chúng tôi sẽ đề xuất danh sách cố vấn phù hợp nhất.").font(.custom("fontName", size: 14)).foregroundColor(Color(hex: "#4D4D4D"))
                }
                .offset(x: 0, y: 60)
                .padding(.horizontal, 30)
                
                VStack {
                    if let items = classificationList {
                        GridStack(minCellWidth: 120, spacing: 20, numItems: items.count,
                                  showsIndicators: false) { index, cellWidth in
                            MultipleSelectionRow(item: items[index], isSelected: self.selections.contains(items[index].id! ), w: (UIScreen.screenWidth / 2) - 40, h: 90) {
                                if self.selections.contains(items[index].id!) {
                                    self.selections.removeAll(where: { $0 == items[index].id! })
                                }
                                else {
                                    self.selections.append(items[index].id!)
                                }
                            }
                        }
                    }
                }
                .offset(x: 0, y: 60)
                .padding(.horizontal, 10)
                .padding(.bottom, 80)
                
                NavigationLink(destination: SearchAdvisorView(selections:self.selections).environmentObject(ProviderApiService())
                                .environmentObject(ClassificationApiService())
                                .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                ) {
                    Text("Tìm cố vấn").font(.custom("fontName", size: 14)).foregroundColor(Color.white).fontWeight(.bold)
                }.frame(width: UIScreen.screenWidth - 60, height: 45, alignment: .center)
                    .background(Color(hex: "#4C99F8")).cornerRadius(30)
                Spacer()
            }.onAppear {
                _ = service.loadClassificationList().done { ClassificationListModel in
                    if let items = ClassificationListModel.results
                    {
                        self.classificationList = items
                    }
                }
            }
            .padding(.bottom, 60)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

struct MultipleSelectionRow: View {
    var item: ClassificationModel
    var isSelected: Bool
    var w: CGFloat
    var h: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            ZStack (alignment: .center) {
                VStack {
                    WebImage(url: URL(string: item.iconUrl ?? "")).resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(Color(hex: "#4C99F8"))
                        .frame(width: 28, height: 28)
                        .padding(0)
                    
                    Text(item.name ?? "").foregroundColor(Color(hex: "#808080")).font(.system(size: 12))
                }
                
                if self.isSelected {
                    VStack {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "#4C99F8")).offset(x: (w/2) - 20, y: 0)
                        Spacer()
                    }
                }
            }
            .padding(.all, 8.0)
            .frame(width: w, height: h)
            .background(Color(hex: self.isSelected ? "#FFFFFF" : "#E5F3FE"))
            //            .border(Color(hex: "#4C99F8"), width: 0.5)
            .cornerRadius(15)
            .shadow(color: self.isSelected ? Color("buttonShadow") : Color(hex: "#FFFFFF"), radius: 5, x: 0, y: 2)
        }
    }
}

#if DEBUG
struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesSelectionListView().environmentObject(ClassificationApiService())
    }
}
#endif

