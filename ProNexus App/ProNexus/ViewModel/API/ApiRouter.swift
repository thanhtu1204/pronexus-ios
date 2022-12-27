//
//  API_Router.swift
//  ProNexus
//
//  Created by thanh cto on 14/10/2021.
//

import Foundation

class ApiRouter {

    //home
    static let GET_BANNER = "banner";
    
    //authentication
    static let POST_LOGIN = "token"; // đăng nhập
    static let DEVICE_TOKEN = "device"; // đăng nhập
    static let POST_RESET_PASS = "Account/ResetPasswordByPhone"; // đăng nhập
    static let POST_REGISTER = "Account/RegisterCustomer" // đăng ký user
    static let POST_REGISTER_PROVIDER = "Provider" // đăng ký advisor
    static let POST_REGISTER_FIREBASE = "Account/loginWithFirebase" // đăng ký firebase account
    static let POST_CONFIRM = "Account/ConfirmPhone" // xác thực phone
    static let POST_GENERATE_OTP = "Account/GenerateOTP" // tạo mã otp cho tài khoản có sữn
    static let GET_ADVISER = "Provider" // danh sách advisor
    static let GET_USER_CUSTOMER = "Customer/username" // thông tin cá nhân user
    static let GET_USER_PROVIDER = "Provider/username" // thông tin cá nhận advisor
    static let GET_CLASSIFICATION = "Classification" // danh mục tư vẫn
    static let GET_BANK = "bank" // list bank
    static let GET_PRODUCT = "Product" // danh sách sản phẩm
    static let GET_CATEGORY = "ProductCategory" // danh mục sản phẩm
    static let GET_PRODUCT_BY_ID = "item/"
    static let GET_PROVINCE_BY_ID = "Province/Country/238"
    static let GET_DISTRICT_BY_PROVINCE_ID = "District/Province"
    static let GET_ADD_PRODUCT_TO_CART = "CartItems/username"
    static let ADD_PRODUCT_TO_CART = "ProductCart/AddToCart"
    static let GET_CART = "ProductCart/username"
    static let GET_WITHDRAW_HISTORY = "AdvisorUsageRequest/username"
    static let DELETE_ITEM_IN_CART = "CartItems/"
    static let POST_ORDER = "Order"
    static let CREATE_ORDER = "Order/CreateOrder"
    static let GET_FEATURED_NEWS = "hot-article?page=" // bài viết nổi bật
    static let GET_CATEGORY_NEWS = "listcategory" // danh mục bài viết
    static let GET_CATEGORY_NEWS_BY_ID = "article" // tất cả bài viết
    static let GET_NEWS_BY_ADVISOR = "list-article-advisor?limit=40" // bài viết của advisor
    static let GET_EXPERTISE_ARTICLE = "expertise-article?page=1" // bài viết về kiến thức
    static let GET_SCHEDULE_EMPTY_ADVISOR = "schedule/username" // danh sách lịch trống của advisor
    static let GET_SCHEDULE_EMPTY_ADVISOR_BY_ID = "schedule" // danh sách lịch trống của advisor
    static let POST_CREATE_SCHEDULE_EMPTY_ADVISOR = "schedule" // advisor tạo lịch trống
    static let GET_SCHEDULE_ADVISOR = "CustomerSchedule/advisor" // advisor xem danh sách lịch đã đặt
    static let GET_SCHEDULE_CUSTOMER = "CustomerSchedule/Customer" // custom xem danh sách lịch đã đặt
    static let POST_SCHEDULE_TO_ADVISOR = "schedule/username" // customer đặt lịch hẹn
    static let POST_CREATE_PAYMENT_VNPAY = "VnPay/CreateOrder"
    static let GET_SCHEDULE_BY_ID = "CustomerSchedule" // custom xem danh sách lịch đã đặt
    static let GET_TOTAL_INCOME_PROVIDER = "ProviderIncome/username" // Tổng doanh thu của advisor đang login
    static let GET_CHART_INCOME_PROVIDER = "ProviderIncome/income" // Biểu đồ doanh thu theo ngày
    static let GET_PROVIDER_CONNECTED = "Provider/connected" // Danh sách Advisors đã kết nối
    static let REQUEST_WITHDRAW_MONEY = "AdvisorUsageRequest/username"
    static let GET_INCOME_PROVIDER = "ProviderIncome" //Danh sách customer advisor đã tư vấn thành công
    static let GET_CUSTOMER_CONNECTED = "Provider/advised" // Danh sách customer đã kết nối
    static let POST_FAVORITE_ADVISOR = "AdvisorFavorite/username" // yêu thích advisor
    static let POST_FEEDBACK_ADVISOR = "Provider/Feedback" // đánh giá advisor
    static let GET_LIST_BANK = "bank" // yêu thích advisor
    static let ADD_FAVORITE_PRODUCT = "ProductFavorite/username" // thêm sản phẩm yêu thích
    static let REMOVE_FAVORITE_PRODUCT = "ProductFavorite/username" // xoá sản phẩm yêu thích
    static let GET_FAVORITE_PRODUCT = "ProductFavorite/username" // get sản phẩm yêu thích
    static let GET_NOTIFICATION = "Announcement/username" //Thông báo
    static let GET_RETIEMENT = "NsDrNd/Retire" //RetiementPlan
    static let GET_SAVING_PLAN = "NsDrNd/Save" //RetiementPlan
    static let GET_LOAN_1 = "NsNrNd/loan-1" //RetiementPlan
    
    

}
