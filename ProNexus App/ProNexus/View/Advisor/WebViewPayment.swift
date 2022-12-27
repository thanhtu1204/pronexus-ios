//
//  WebViewPayment.swift
//  ProNexus
//
//  Created by thanh cto on 12/11/2021.
//

import SwiftUI

struct MyWebView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var showLoader = false
    @State var message = ""
    @State var webTitle = ""
    @State var urlAddress: String
    
    @EnvironmentObject var paymentService: PaymentService
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                //                https://sandbox.vnpayment.vn/tryitnow/Home/VnPayReturn?vnp_Amount=1000000&vnp_BankCode=NCB&vnp_BankTranNo=20211112211311&vnp_CardType=ATM&vnp_OrderInfo=Thanh+toan+don+hang+thoi+gian%3A+2021-11-12+21%3A11%3A18&vnp_PayDate=20211112211304&vnp_ResponseCode=00&vnp_TmnCode=2QXUI4J4&vnp_TransactionNo=13626217&vnp_TxnRef=79353&vnp_SecureHashType=SHA256&vnp_SecureHash=12ede6c03ebe25fce2b4028d56ec8cf9feb0f0dbf42fe3ab591d89f841e14fea
                //                    "http://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder"
                WebView(url: .publicUrl, urlAddress: urlAddress, viewModel: viewModel)
                
            }.onReceive(self.viewModel.showLoader.receive(on: RunLoop.main)) { value in
                self.showLoader = value
            }.onReceive(self.viewModel.lastUrlRequest.receive(on: RunLoop.main)) { value in
                print("Last URL Request =>> ", value)

                if let responseCode = getQueryStringParameter(url: value, param: "vnp_ResponseCode")
                {
                    if responseCode == "00" {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
            // A simple loader that is shown when WebView is loading any page and hides when loading is finished.
            if showLoader {
                Loader()
            }
        }.edgesIgnoringSafeArea(.top)
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

struct MyWebView_Previews: PreviewProvider {
    static var previews: some View {
        MyWebView(urlAddress: "https://google.com.vn")
    }
}
