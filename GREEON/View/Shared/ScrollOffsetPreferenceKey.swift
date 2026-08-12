//
//  ScrollOffsetPreferenceKey.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

// 헤더 아래 콘텐츠가 위로 스크롤됐는지 감지하는 공용 유틸 — 상단 고정 헤더 있는 화면 어디서든 재사용
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    /// `coordinateSpace` 기준 이 뷰(보통 스크롤 콘텐츠 최상단)의 minY를 계속 관찰한다.
    /// 콘텐츠가 아직 맨 위(스크롤 안 됨)면 0, 위로 스크롤될수록 음수로 커진다.
    func trackScrollOffset(in coordinateSpace: String) -> some View {
        background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geo.frame(in: .named(coordinateSpace)).minY
                )
            }
        )
    }
}
