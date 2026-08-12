//
//  OutlinedButton.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

struct OutlinedButton<Label: View>: View {
    var height: CGFloat? = nil
    var borderColor: Color = Brand.borderDefault
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    var body: some View {
        Button(action: action) {
            // height 미지정 시 부모(HStack 등)가 준 높이를 그대로 채움 — 형제 뷰와 높이를 맞출 때 사용
            Group {
                if let height {
                    label().frame(maxWidth: .infinity).frame(height: height)
                } else {
                    label().frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

extension OutlinedButton where Label == Color {
    // EmptyView는 .frame()이 적용돼도 크기가 0으로 접혀서 대신 Color.clear 사용
    init(height: CGFloat? = nil, borderColor: Color = Brand.borderDefault, action: @escaping () -> Void) {
        self.init(height: height, borderColor: borderColor, action: action) { Color.clear }
    }
}
