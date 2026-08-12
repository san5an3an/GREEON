//
//  BackButton.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

// 네이티브 back chevron 대신 쓰는 커스텀 아이콘 버튼 — GREEON_swift 구버전과 동일 패턴
struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("back")
        }
    }
}
