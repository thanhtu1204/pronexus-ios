//
//  Data.swift
//  ProNexus
//
//  Created by IMAC on 11/10/21.
//

import Foundation

struct Place: Identifiable, Hashable {
    let id: Int
    let label: String
    let field1: String
    let field2: String

    
    static func samples() -> [Place] { (1..<2).map(Place.fixture) }
    
    private static func fixture(_ id: Int) -> Place {
        Place(
            id: id,
            label: "01. Đăng ký tài khoản",
            field1: "Tài khoản khách hàng",
            field2: "Tài khoản Cố vấn - Advisor"
        )
    }
}

struct Pack1: Identifiable, Hashable {
    let id: Int
    let label: String
    let field1: String
    let field2: String

    
    static func samples() -> [Pack1] { (1..<2).map(Pack1.fixture) }
    
    private static func fixture(_ id: Int) -> Pack1 {
        Pack1(
            id: id,
            label: "Gói vay 1. Lãi suất trên dư nợ thực tế",
            field1: "Lãi tính trên số dư thực tế giảm dần",
            field2: "Số tiền trả hàng tháng (Gốc + Lãi) cố định"
        )
    }
}

struct Pack2: Identifiable, Hashable {
    let id: Int
    let label: String
    let field1: String
    let field2: String

    
    static func samples() -> [Pack2] { (1..<2).map(Pack2.fixture) }
    
    private static func fixture(_ id: Int) -> Pack2 {
        Pack2(
            id: id,
            label: "Gói vay 2. Lãi suất trên dư nợ thực tế",
            field1: "Lãi tính trên số dư thực tế giảm dần",
            field2: "Gốc trả đều hàng tháng, Lãi theo dư nợ thực tế"
        )
    }
}

struct Pack3: Identifiable, Hashable {
    let id: Int
    let label: String
    let field1: String

    
    static func samples() -> [Pack3] { (1..<2).map(Pack3.fixture) }
    
    private static func fixture(_ id: Int) -> Pack3 {
        Pack3(
            id: id,
            label: "Gói vay 3. Lãi suất danh nghĩa",
            field1: "Lãi suất cố định theo gốc vay ban đầu. Gốc và Lãi trả đều hàng tháng."
        )
    }
}

struct AppointmentSchedule: Identifiable, Hashable {
    let id: Int
    let labelAppointmentSchedule: String
    let fieldAppointmentSchedule1: String
    let fieldAppointmentSchedule2: String

    
    static func lists() -> [AppointmentSchedule] { (1..<2).map(AppointmentSchedule.fixture) }
    
    private static func fixture(_ id: Int) -> AppointmentSchedule {
        AppointmentSchedule(
            id: id,
            labelAppointmentSchedule: "02. Lịch hẹn",
            fieldAppointmentSchedule1: "Đặt lịch hẹn với Cố vấn - Advisor",
            fieldAppointmentSchedule2: "Nhận lịch hẹn với khách hàng"
        )
    }
}

struct MarketPlace: Identifiable, Hashable {
    let id: Int
    let labelMarketPlace: String
    let fieldMarketPlace1: String
    let fieldMarketPlace2: String
    let fieldMarketPlace3: String

    
    static func lists3() -> [MarketPlace] { (1..<2).map(MarketPlace.fixture) }
    
    private static func fixture(_ id: Int) -> MarketPlace {
        MarketPlace(
            id: id,
            labelMarketPlace: "03. MarketPlace",
            fieldMarketPlace1: "Tìm kiếm khoá học",
            fieldMarketPlace2: "Chọn khoá học và thanh toán",
            fieldMarketPlace3: "Mua hộ khoá học"
        )
    }
}
