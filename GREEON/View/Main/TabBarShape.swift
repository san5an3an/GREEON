//
//  TabBarShape.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

// 가운데 QR 버튼이 얹히는 곡선 노치가 있는 탭바 배경
struct TabBarShape: Shape {
    var notchHeight: CGFloat = 45

    func path(in rect: CGRect) -> Path {
        let centerX = rect.width / 2
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerX - notchHeight * 2, y: 0))
        path.addCurve(
            to: CGPoint(x: centerX, y: notchHeight),
            control1: CGPoint(x: centerX - 30, y: 0),
            control2: CGPoint(x: centerX - 35, y: notchHeight)
        )
        path.addCurve(
            to: CGPoint(x: centerX + notchHeight * 2, y: 0),
            control1: CGPoint(x: centerX + 35, y: notchHeight),
            control2: CGPoint(x: centerX + 30, y: 0)
        )
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}
