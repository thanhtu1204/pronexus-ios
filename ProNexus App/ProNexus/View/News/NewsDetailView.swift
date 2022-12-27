//
//  NewsDetailView.swift
//  ProNexus
//
//  Created by thanh cto on 28/10/2021.
//

import SwiftUI
import WebKit
import UIKit
import Combine
import SDWebImageSwiftUI


struct SheetView: View {

    var body: some View {
        VStack {
            Button("Press to dismiss") {
                
            }
            .font(.title)
            .padding()
            .background(Color.black)
        }
    }
}

struct NewsDetailView: View {
    
    var slug = ""
    
    
    //    @State var dismissAction: (() -> Void) // gọi tắt view từ màn hình list
    @State var show = false
    @State var showLoader = false
    @State var shareURL: URL? = nil
    @State var showUpdate = false
    @State private var webViewHeight: CGFloat = .zero
    @State var showShare = false
    @State var shareUrlString = "#"
    @State var newsDetail: NewsModel = NewsModel()
    @State var loading = true
    
    @Environment(\.isPreview) var isPreview
    @Environment(\.presentationMode) private var presentationMode
    
    
    //    @ObservedObject var viewModel = ViewModel()
    
    // khai bao service
    @EnvironmentObject var service: NewsApiService
    
    
    var body: some View {
        
        VStack() {
            
            if $loading.wrappedValue {
                SectionLoader().frame(width: screenWidth() - 74, height: 80, alignment: .center)
            } else
            {
                if let newsDetail = newsDetail {
                    // Header
                    HStack {
                        BackButton(dismissAction: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        //                    .offset(x: 0)
                        Spacer()
                        //                    Image("ic_more")
                        //                        .resizable()
                        //                        .frame(width: 100, height: 10, alignment: .center)
                        //                    Spacer()
                        
                        
                        
                        if newsDetail.link != nil
                        {
                            HStack {
                                
                                Button(action: {
                                    //                                actionSheet(url: service.newsDetail.link ?? "#")
                                    shareUrlString = newsDetail.link ?? "#"
                                    showShare.toggle()
                                }) {
                                    CircleButton(icon: "square.and.arrow.up", color: Color(hex: "#EFCE4F"))                                    .sheet(isPresented: self.$showShare) {
                                        //                                    let data = URL(string: "#")
                                        //                                    let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                                    }
                                    
                                }
                                
                                Button(action: {  }) {
                                    CircleButton(icon: "heart", color: Color(hex: "#49D472"))
                                        .sheet(isPresented: self.$showUpdate) {
                                            //                      UpdateList()
                                            
                                        }
                                }
                                
                                Button(action: {  }) {
                                    CircleButton(icon: "message.circle.fill", color: Color(hex: "#A27CEB"))
                                        .sheet(isPresented: self.$showUpdate) {
                                            //                      UpdateList()
                                            
                                        }
                                }
                                
                            }
                        }
                    }
                    .offset(y: 10)
                    .padding(.horizontal, 37.0)
                    .padding(.bottom, 15)
                    
                    //END HEADER
                    ScrollView {
                        VStack(alignment: .center) {
                            
                            if let image = newsDetail.postThumbnail
                            {
                                WebImage(url: URL(string: image)!).resizable()
                                    .frame(width: screenWidth() - (37 * 2), height: 227, alignment: .center)
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(8)
                                
                            }
                            
                        }
                        .padding(.horizontal, 30.0)
                        .padding(.top, 40)
                        
                        // TITLE
                        VStack(alignment: .leading, spacing: 10) {
                            
                            
                            if let cate = newsDetail.category?.name {
                                Badge(text: cate, textColorHex: "#fff", bgColorHex: "#1D74FE")
                            }
                            
                            //                    Text(service.newsDetail.category?.name ?? "")
                            //                        .font(.system(size: 12))
                            //                        .padding(4)
                            //                        .background(Color(hex: Theme.buttonColor.primary.rawValue))
                            //                        .foregroundColor(.white)
                            //                        .cornerRadius(10)
                            
                            Text(newsDetail.title ?? "")
                                .appFont(style: .headline, weight: .bold, size: 20, color: Color(hex: "#4D4D4D"))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            if newsDetail.title != nil {
                                let detail = newsDetail
                                
                                HStack (alignment: .center, spacing: 0.0) {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.gray)
                                        .frame(height: 18)
                                    
                                    if let authorName = detail.authorName {
                                        Text("  \(authorName)").appFont(style: .body, size: 10)
                                    }
                                    
                                    
                                    Spacer()
                                    
                                    Image(systemName: "eye")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.gray)
                                        .frame(height: 10)
                                    
                                    Text("  \(detail.viewCount ?? 0)").appFont(style: .body, size: 10)
                                    
                                    Spacer()
                                    
                                    if let createdAt = detail.createdAt {
                                        
                                        
                                        Image(systemName: "calendar")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color.gray)
                                            .frame(height: 10)
                                        Text("  \((Date(fromString: createdAt[0..<11], format: .isoDate)?.toString(format: .custom("dd/M/yyyy")))!)").appFont(style: .body, size: 10)
                                    }
                                }
                            }
                            
                        }
                        .padding(.horizontal, 37)
                        .offset(y: 60)
                        
                        // HTML CONTENT
                        VStack(spacing: 10) {
                            
                            if let content = newsDetail.content {
                                Webview(html: content, dynamicHeight: $webViewHeight)
                                    .padding(.horizontal)
                                    .frame(height: webViewHeight)
                            }
                            
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 30)
                        .offset(y: 60)
                        
                    }
                }
                else
                {
                    NoData()
                }
            }
        }
        .onAppear {
            if isPreview
            {
                _ = service.loadNewsDetail(key: "ngan-hang-dieu-chinh-room-ngoai-va-cau-chuyen-duong-dai").done { NewsModel in
                    self.newsDetail = NewsModel
                    self.loading = false
                }
            } else
            {
                _ = service.loadNewsDetail(key: self.slug).done { NewsModel in
                    self.newsDetail = NewsModel
                    print("share link ", self.newsDetail.link ?? "")
                    self.loading = false
                }
            }            
        }
        .sheet(isPresented: $showShare, content: {
            if let data = URL(string: newsDetail.link!) {
                                            ShareSheet(activityItems: [data])
                                        }
        })
        .navigationBarHidden(true)
        
    }
        
}



struct BackButton: View {
    
    @State var dismissAction: (() -> Void)
    
    var body: some View {
        return ZStack(alignment: .topLeading) {
            Button(action: dismissAction) {
                HStack {
                    Spacer()
                    
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color(hex: Theme.buttonColor.primary.rawValue))
                }
                .padding(.all, 8.0)
                .frame(width: 40, height: 40)
                .background(Color("button"))
                .cornerRadius(8)
                .shadow(color: Color("buttonShadow"), radius: 5, x: 0, y: 5)
            }
            Spacer()
        }
    }
}


struct CircleButton: View {
    
    var icon = "person.crop.circle"
    var color = Color("button")
    
    var body: some View {
        return VStack {
            Image(systemName: icon)
                .foregroundColor(color)
        }
        .frame(width: 44, height: 44)
        .background(Color("button"))
        .cornerRadius(30)
        .myShadow()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}


struct Webview : UIViewRepresentable {
    var html: String
    
    @Binding var dynamicHeight: CGFloat
    var webview: WKWebView = WKWebView()
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: Webview
        
        init(_ parent: Webview) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        let htmlStart = """
                    <HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">
                                                    <style>
                                                        body {
                                                            font-family: "ArialMT"!important;
                                                            font-size: 14px;
                                                        }
                                                                            * {
                                                                                font-family: "ArialMT"!important;
                                                                            }
                                                        img { max-width: 100%!important; width: auto!important; height: auto!important; }
                                                    </style>
                    </HEAD><BODY>
                    """
        
        let htmlEnd = "</BODY></HTML>"
        let body = """
<div class="sidebar-1"><div class="header-content width_common"><ul class="breadcrumb" data-campaign="Header"><li><a data-medium="Menu-PhapLuat" href="/phap-luat" title="Pháp luật" data-itm-source="#vn_source=Detail&amp;vn_campaign=Header&amp;vn_medium=Menu-PhapLuat&amp;vn_term=Desktop" data-itm-added="1">Pháp luật</a></li><span id="parentCateDetail" data-cate="1001007"></span><span id="site-sub-id" data-cate="1001007"></span></ul><span class="date">Thứ năm, 4/11/2021, 17:12 (GMT+7)</span></div><h1 class="title-detail">Thứ trưởng Y tế Trương Quốc Cường bị bắt vì cáo buộc gì?</h1><p class="description"><span class="location-stamp">Hà Nội</span>Ông Trương Quốc Cường, Thứ trưởng Bộ Y tế, bị xác định thiếu trách nhiệm trong xét duyệt khiến 7 loại thuốc giả mang nhãn mác Health 2000 tràn vào Việt Nam.</p><article class="fck_detail "><p class="Normal">Ngày 4/11, tiến sĩ Cường, 60 tuổi, <a href="" rel="nofollow">bị khởi tố</a> về tội <em>Thiếu trách nhiệm gây hậu quả nghiêm trọng,</em> theo Điều 360 Bộ luật Hình sự. Cùng ngày, cơ quan tố tụng khám xét nơi làm việc của Thứ trưởng tại trụ sở Bộ Y tế trên phố Giảng Võ.</p><p class="Normal">Ông Cường bị Cơ quan An ninh điều tra (Bộ Công an) cáo buộc liên quan vụ án Công ty cổ phần VN Pharma nhập thuốc giả. Ông làm Thứ trưởng từ năm 2016, hiện chưa có quyết định liên quan chức vụ này.</p><figure class="tplCaption action_thumb_added" data-href="" data-target=""> <div class="action_thumb flexbox" style="z-index: 9; transform-origin: 0px 0px; opacity: 1; transform: scale(1, 1); display: none;"> <a href="javascript:;" class="share_photo" data-type="fb" data-reference-id="30"><svg class="ic ic-facebook"><use xlink:href="#Facebook"></use></svg></a> <a href="javascript:;" class="share_photo" data-type="tw" data-reference-id="30"><svg class="ic ic-twitte"><use xlink:href="#Twitter"></use></svg></a> <a href="javascript:;" class="vne_zoom" style="transform-origin: 0px 0px; opacity: 1; transform: scale(1, 1); display: none;"><svg class="ic ic-zoom"><use xlink:href="#Zoom"></use></svg></a> </div><div class="fig-picture" data-href="" data-target=""><img alt="Cơ quan An ninh điều tra và VKSND Tối cao đến khám xét phòng làm việc của ông Cường, sáng 4/11. Ảnh: Phạm Dự" data-natural-h="776" data-natural-width="1200" src="https://vcdn-vnexpress.vnecdn.net/2021/11/04/kham-xet-jpeg-1265-1636020597.jpg"></div><figcaption><p class="Image">Cơ quan An ninh điều tra và VKSND Tối cao đến khám xét phòng làm việc của ông Cường, sáng 4/11. Ảnh:<em> Phạm Dự</em></p></figcaption></figure><p class="Normal">Ông Cường làm Cục trưởng Quản lý Dược (Bộ Y tế) từ năm 2007 đến 2016. Ông bị cáo buộc thiếu giám sát hoạt động của nhóm chuyên gia thẩm định và bộ phận thường trực đăng ký thuốc. Hành vi này dẫn đến hồ sơ đăng ký nhập khẩu 7 loại thuốc chữa ung thư giả nhãn mác Health 2000 của VN Pharma được chấp thuận. Tổng số hàng tiêu thụ tại Việt Nam trị giá trên 151 tỷ đồng.</p><p class="Normal">Cơ quan tố tụng cáo buộc, nhận được thông tin về việc Health 2000 Canada không rõ nguồn gốc, xuất xứ nhưng ông Cường không chỉ đạo đình chỉ lưu hành, thu hồi, tiêu hủy. Từ đây, sau ngày 21/11/2014, nhiều cơ sở y tế vẫn mua bán, đấu thầu để cung cấp thuốc giả này cho các bệnh viện, trị giá trên 3,7 tỷ đồng.</p><p class="Normal">Nhà chức trách cho rằng hành vi của ông Cường gây hậu quả nghiêm trọng, khiến nhiều người bệnh phải sử dụng thuốc không rõ nguồn gốc.</p><p class="Normal">Ngược với cáo buộc, ông Cường trình bày những thông tin và tài liệu năm 2014 Cục Quản lý Dược nhận được chưa đủ cơ sở để dừng lưu hành thuốc mang nhãn mác Health 2000, chưa đủ cơ sở để nghi ngờ về nguồn gốc thuốc.</p><p class="Normal">Với cương vị là Cục trưởng Quản lý Dược, ông đã chỉ đạo đơn vị chức năng đề nghị phía Canada trả lời chính thức bằng văn bản để có căn cứ xử lý. Tuy nhiên, phía Canada không có văn bản trả lời nên ông chỉ đạo chuyển thông tin liên quan đề nghị Bộ Công an phối hợp xác minh. Cục Quản lý Dược cũng có văn bản đề nghị hải quan tạm dừng nhập khẩu Health 2000.</p><figure class="tplCaption action_thumb_added" data-href="" data-target=""> <div class="action_thumb flexbox" style="transform-origin: 0px 0px;opacity: 1;transform: scale(1, 1);display: none;z-index:9;"> <a href="javascript:;" class="share_photo" data-type="fb" data-reference-id="30"><svg class="ic ic-facebook"><use xlink:href="#Facebook"></use></svg></a> <a href="javascript:;" class="share_photo" data-type="tw" data-reference-id="30"><svg class="ic ic-twitte"><use xlink:href="#Twitter"></use></svg></a> <a href="javascript:;" class="vne_zoom" style="transform-origin: 0px 0px; opacity: 1; transform: scale(1, 1);"><svg class="ic ic-zoom"><use xlink:href="#Zoom"></use></svg></a> </div><div class="fig-picture" data-href="" data-target=""><img alt="Ông Trương Quốc Cường. Ảnh: Hữu Khoa" data-damid="5430" data-natural-h="1280" data-natural-width="1920" src="https://vcdn-vnexpress.vnecdn.net/2021/11/04/truong-quoc-cuong-44-jpg-16360-2191-5042-1636020597.jpg"></div><figcaption><p class="Image">Ông Trương Quốc Cường. Ảnh:<em> Hữu Khoa</em></p></figcaption></figure><p class="Normal">Theo hồ sơ vụ án, Chủ tịch VN Pharma Nguyễn Minh Hùng thỏa thuận với Võ Mạnh Cường mua 838.000 hộp, 4 loại thuốc mang nhãn mác Health 2000 Canada giả về nguồn gốc, xuất xứ, trị giá hơn 54 tỷ đồng.</p><p class="Normal">Hai bị can thống nhất chỉnh sửa thông tin, giá thuốc trên hóa đơn để phù hợp với giá thuốc đã nâng khống trên các hợp đồng giữa VN Pharma ký với Aust Hong Kong. Nhóm này cũng chỉnh sửa logo của Helix thành logo của Health 2000 nhằm thay đổi nguồn gốc, xuất xứ thành thuốc do Health 2000 sản xuất, phù hợp với visa mà Cục Quản lý Dược đã cấp.</p><p class="Normal">Kết quả tương trợ tư pháp do Canada cung cấp xác định Health 2000 không có nhà máy sản xuất thuốc tại Canada và không sản xuất bất kỳ loại dược phẩm nào. Health 2000 cũng không có văn phòng đại diện tại Việt Nam. Bởi vậy, cơ quan điều tra kết luận hơn 838.000 hộp, 4 loại thuốc mang nhãn mác Health 2000 trên là hàng giả.</p><p class="Normal">Trong vụ án này, trước đó Cơ quan An ninh điều tra đã khởi tố ông Nguyễn Việt Hùng (nguyên Cục phó Quản lý Dược), Phạm Hồng Châu (nguyên Trưởng phòng Đăng ký thuốc thuộc Cục Quản lý Dược) và Lê Đình Thanh (cựu cán bộ hải quan TP HCM) về tội <em>Thiếu trách nhiệm gây hậu quả nghiêm trọng, </em>bà Nguyễn Thị Thu Thủy (cựu Phó phòng của Cục Quản lý Dược) về tội <em>Lợi dụng chức vụ quyền hạn trong khi thi hành công vụ</em>.</p><p class="Normal">Nguyễn Minh Hùng (cựu Chủ tịch HĐQT, Tổng giám đốc Công ty cổ phần VN Pharma), Võ Mạnh Cường (cựu Giám đốc công ty H&amp;C) và 7 người bị khởi tố về tội <em>Buôn bán hàng giả là thuốc chữa bệnh.</em></p><p class="Normal">Trong giai đoạn một của vụ án buôn bán thuốc giả xảy ra tại VN Pharma, Võ Mạnh Cường bị phạt 20 năm tù, Nguyễn Minh Hùng 17 năm; các bị cáo khác nhận mức án từ 3 năm tù treo đến 12 năm tù với cáo buộc buôn bán<a href="https://vnexpress.net/topic/vn-pharma-buon-lau-thuoc-chua-ung-thu-22320" rel="dofollow"> thuốc giả là H-Capita 500mg</a>.</p><ul class="list-news gaBoxLinkDisplay" data-campaign="Box-Related" data-event-category="Article Link Display" data-event-action="Box-Related" data-event-label="Item-0"><li data-id="4326188"><a data-medium="Item-1" href="https://vnexpress.net/nguyen-cuc-pho-quan-ly-duoc-de-vn-pharma-nhap-thuoc-gia-4326188.html" title="Nguyên Cục phó Quản lý Dược 'để VN Pharma nhập thuốc giả'" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="1" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-1&amp;vn_term=Desktop" data-itm-added="1">Nguyên Cục phó Quản lý Dược 'để VN Pharma nhập thuốc giả'</a><span class="meta-news"><a class="count_cmt" href="https://vnexpress.net/nguyen-cuc-pho-quan-ly-duoc-de-vn-pharma-nhap-thuoc-gia-4326188.html#box_comment_vne" style="white-space: nowrap; display: none;" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="1" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-1&amp;vn_term=Desktop" data-itm-added="1"><svg class="ic ic-comment"><use xlink:href="#Comment-Reg"></use></svg><span class="font_icon widget-comment-4326188-1"></span></a></span></li><li data-id="4254150"><a data-medium="Item-2" href="https://vnexpress.net/nguyen-cuc-pho-quan-ly-duoc-bi-de-nghi-truy-to-4254150.html" title="Nguyên Cục phó Quản lý dược bị đề nghị truy tố" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="2" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-2&amp;vn_term=Desktop" data-itm-added="1">Nguyên Cục phó Quản lý dược bị đề nghị truy tố</a><span class="meta-news"><a class="count_cmt" href="https://vnexpress.net/nguyen-cuc-pho-quan-ly-duoc-bi-de-nghi-truy-to-4254150.html#box_comment_vne" style="white-space: nowrap; display: none;" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="2" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-2&amp;vn_term=Desktop" data-itm-added="1"><svg class="ic ic-comment"><use xlink:href="#Comment-Reg"></use></svg><span class="font_icon widget-comment-4254150-1"></span></a></span></li><li data-id="4112513"><a data-medium="Item-3" href="https://vnexpress.net/cuu-cuc-pho-cuc-quan-ly-duoc-bi-khoi-to-4112513.html" title="Cựu cục phó Cục Quản lý dược bị khởi tố" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="3" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-3&amp;vn_term=Desktop" data-itm-added="1">Cựu cục phó Cục Quản lý dược bị khởi tố</a><span class="meta-news"><a class="count_cmt" href="https://vnexpress.net/cuu-cuc-pho-cuc-quan-ly-duoc-bi-khoi-to-4112513.html#box_comment_vne" style="white-space: nowrap; display: none;" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="3" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-3&amp;vn_term=Desktop" data-itm-added="1"><svg class="ic ic-comment"><use xlink:href="#Comment-Reg"></use></svg><span class="font_icon widget-comment-4112513-1">2</span></a></span></li><li data-id="4034357"><a data-medium="Item-4" href="https://vnexpress.net/pho-truong-phong-cuc-quan-ly-duoc-bi-bat-4034357.html" title="Phó trưởng phòng Cục Quản lý dược bị bắt" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="4" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-4&amp;vn_term=Desktop" data-itm-added="1">Phó trưởng phòng Cục Quản lý dược bị bắt</a><span class="meta-news"><a class="count_cmt" href="https://vnexpress.net/pho-truong-phong-cuc-quan-ly-duoc-bi-bat-4034357.html#box_comment_vne" style="white-space: nowrap; display: none;" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="4" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-4&amp;vn_term=Desktop" data-itm-added="1"><svg class="ic ic-comment"><use xlink:href="#Comment-Reg"></use></svg><span class="font_icon widget-comment-4034357-1">1</span></a></span></li><li data-id="3985147"><a data-medium="Item-5" href="https://vnexpress.net/cuc-quan-ly-duoc-bi-dieu-tra-sai-pham-nao-3985147.html" title="Cục Quản lý dược bị điều tra sai phạm nào?" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="5" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-5&amp;vn_term=Desktop" data-itm-added="1">Cục Quản lý dược bị điều tra sai phạm nào?</a><span class="meta-news"><a class="count_cmt" href="https://vnexpress.net/cuc-quan-ly-duoc-bi-dieu-tra-sai-pham-nao-3985147.html#box_comment_vne" style="white-space: nowrap; display: none;" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="5" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-5&amp;vn_term=Desktop" data-itm-added="1"><svg class="ic ic-comment"><use xlink:href="#Comment-Reg"></use></svg><span class="font_icon widget-comment-3985147-1">3</span></a></span></li><li data-id="3984011"><a data-medium="Item-6" href="https://vnexpress.net/khoi-to-vu-an-thieu-trach-nhiem-tai-cuc-quan-ly-duoc-3984011.html" title="Khởi tố vụ án thiếu trách nhiệm tại Cục Quản lý dược" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="6" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-6&amp;vn_term=Desktop" data-itm-added="1">Khởi tố vụ án thiếu trách nhiệm tại Cục Quản lý dược</a><span class="meta-news"><a class="count_cmt" href="https://vnexpress.net/khoi-to-vu-an-thieu-trach-nhiem-tai-cuc-quan-ly-duoc-3984011.html#box_comment_vne" style="white-space: nowrap; display: inline-block;" data-event-category="Article Link Click" data-event-action="Box-Related" data-event-label="6" data-itm-source="#vn_source=Detail&amp;vn_campaign=Box-Related&amp;vn_medium=Item-6&amp;vn_term=Desktop" data-itm-added="1"><svg class="ic ic-comment"><use xlink:href="#Comment-Reg"></use></svg><span class="font_icon widget-comment-3984011-1">11</span></a></span></li></ul><p class="author_mail"><strong>Phạm Dự</strong><a class="email" href="javascript:;" id="send_mail_author" data-article-id="4381438"><i class="ic ic-email"></i></a></p></article><div class="width_common btn_guicauhoi_detail mb20"><svg class="ic ic-mail"><use xlink:href="#Mail"></use></svg>Mời độc giả gửi bài, câu hỏi <a href="/gui-bai-viet?cate_id=1001117">tại đây</a> hoặc về <a href="mailto:phapluat@vnexpress.net">phapluat@vnexpress.net</a></div><div class="footer-content width_common"><a href="/phap-luat" class="save back-folder"><svg class="ic ic-back"><use xlink:href="#Arrow-Right-2"></use></svg>&nbsp;&nbsp;Trở lại Pháp luật<span class="tip">Trở lại Pháp luật</span></a><div class="myvne_save_for_later" data-token="1af1e69ad47e03408d30912efec01934" data-article-id="4381438" title="Lưu bài viết"><a href="javascript:void(0);" class="save"><svg class="ic ic-save-outline"><use xlink:href="#Save-1"></use></svg>Lưu</a></div><div class="social"><span class="txt">Chia sẻ</span><a href="javascript:;" class="fb btn_share" data-type="fb" rel="nofollow" title="Chia sẻ bài viết lên facebook"><svg class="ic ic-facebook"><use xlink:href="#Facebook"></use></svg></a><a href="javascript:;" class="tw btn_share" data-type="tw" rel="nofollow" data-url="https://bit.ly/3EJN1u9" title="Chia sẻ bài viết lên twitter"><svg class="ic ic-twitter"><use xlink:href="#Twitter"></use></svg></a><a href="javascript:;" onclick="window.open('https://mail.google.com/mail/u/0/?view=cm&amp;fs=1&amp;tf=1&amp;su=Th%E1%BB%A9+tr%C6%B0%E1%BB%9Fng+Y+t%E1%BA%BF+Tr%C6%B0%C6%A1ng+Qu%E1%BB%91c+C%C6%B0%E1%BB%9Dng+b%E1%BB%8B+b%E1%BA%AFt+v%C3%AC+c%C3%A1o+bu%E1%BB%99c+g%C3%AC%3F&amp;body=https%3A%2F%2Fvnexpress.net%2Fthu-truong-y-te-truong-quoc-cuong-bi-bat-vi-cao-buoc-gi-4381438.html', '_blank')" class="mail" rel="nofollow" title="Mail"><svg class="ic ic-email"><use xlink:href="#Mail"></use></svg></a><a href="javascript:;" class="share-link btn_copy" rel="nofollow" title="Copy link"><svg class="ic ic-link"><use xlink:href="#Link"></use></svg><span class="tip" style="display: none;">Copy link thành công</span></a></div></div><div id="_detail_topic" class="lazier hidden" data-loaded="1"></div><div class="box-category"><div class="banner-ads"><div id="sis_inarticle"><script>googTagCode.display.push("sis_inarticle");</script></div></div></div></div>
"""
        let htmlString = "\(htmlStart)\(html)\(htmlEnd)"
        webview.loadHTMLString(htmlString, baseURL:  nil)
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

#if DEBUG
struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView().environmentObject(NewsApiService()).navigationBarHidden(true)
    }
}
#endif
