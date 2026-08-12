//
//  ScrollShadowHeader.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

// 콘텐츠가 위로 스크롤됐을 때만 그림자 붙는 공용 헤더 — 내용물은 content로 주입, isScrolled만 바인딩
struct ScrollShadowHeader<Content: View>: View {
    var isScrolled: Bool
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .frame(maxWidth: .infinity)
            .background(Brand.background)
            .shadow(color: .black.opacity(isScrolled ? 0.12 : 0), radius: 6, x: 0, y: 2)
            .animation(.easeInOut(duration: 0.15), value: isScrolled)
    }
}
