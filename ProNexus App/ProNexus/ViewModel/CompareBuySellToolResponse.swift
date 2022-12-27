//
//  CompareBuySellToolResponse.swift
//  ProNexus
//
//  Created by thanh cto on 18/12/2021.
//

import Foundation

class CompareBuySellToolResponse: Codable {
    var ok: Bool = false
    var message: String?
    var payload: CompareBuySell?
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case ok = "Ok"
        case message = "Message"
        case payload = "Payload"
        case count = "Count"
    }
}

// MARK: - CompareBuySell
class CompareBuySell: Codable {
    var thuNhapBinhQuanNam: Int?
    var soTienSANCo: Int?
    var thoiGianTinhToan: Int?
    var giaTriCanHoMuonMUA: Int?
    var laiSuatDiVay: Double?
    var dongTienMUANha: Int?
    var chiPhiThueNha: Int?
    var tyLETangGiaThueNha: Double?
    var dongTienThueNha: Int?
    var phuongAn: String?
    var charts: [[String]]?

    enum CodingKeys: String, CodingKey {
        case thuNhapBinhQuanNam = "ThuNhapBinhQuanNam"
        case soTienSANCo = "SoTienSanCo"
        case thoiGianTinhToan = "ThoiGianTinhToan"
        case giaTriCanHoMuonMUA = "GiaTriCanHoMuonMua"
        case laiSuatDiVay = "LaiSuatDiVay"
        case dongTienMUANha = "DongTienMuaNha"
        case chiPhiThueNha = "ChiPhiThueNha"
        case tyLETangGiaThueNha = "TyLeTangGiaThueNha"
        case dongTienThueNha = "DongTienThueNha"
        case phuongAn = "PhuongAn"
        case charts = "Charts"
    }

    init(thuNhapBinhQuanNam: Int?, soTienSANCo: Int?, thoiGianTinhToan: Int?, giaTriCanHoMuonMUA: Int?, laiSuatDiVay: Double?, dongTienMUANha: Int?, chiPhiThueNha: Int?, tyLETangGiaThueNha: Double?, dongTienThueNha: Int?, phuongAn: String?, charts: [[String]]?) {
        self.thuNhapBinhQuanNam = thuNhapBinhQuanNam
        self.soTienSANCo = soTienSANCo
        self.thoiGianTinhToan = thoiGianTinhToan
        self.giaTriCanHoMuonMUA = giaTriCanHoMuonMUA
        self.laiSuatDiVay = laiSuatDiVay
        self.dongTienMUANha = dongTienMUANha
        self.chiPhiThueNha = chiPhiThueNha
        self.tyLETangGiaThueNha = tyLETangGiaThueNha
        self.dongTienThueNha = dongTienThueNha
        self.phuongAn = phuongAn
        self.charts = charts
    }
}
