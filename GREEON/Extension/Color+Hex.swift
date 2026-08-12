//
//  Color+Hex.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

// 브랜드 컬러
enum Brand {
    static let green = Color(hex: 0x00ab84)
    static let blue = Color(hex: 0x0069cb)
    static let skyBlue = Color(hex: 0x428fec)
    static let red = Color(hex: 0xef3346)
    static let orange = Color(hex: 0xff9800)
    static let textSecondary = Color(hex: 0x545860)
    static let background = Color(hex: 0xf3f4f5)
    static let borderDefault = Color(hex: 0xd1d1d1)
}
