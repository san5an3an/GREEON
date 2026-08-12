//
//  ComingSoonView.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import SwiftUI

// 미구현 화면 placeholder
struct ComingSoonView: View {
    let title: String
    // 탭 루트로 직접 표시될 때(맵/QR/이용내역/나의그리온)는 뒤로갈 곳이 없어 헤더 자체를 숨김
    var showsBackButton: Bool = true

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            if showsBackButton {
                header
            }

            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "hammer.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Brand.green)
                Text("\(title) 준비 중입니다")
                    .font(.custom("SUITE-Bold", size: 18))
                Text("다음 세션에서 이어서 구현됩니다.")
                    .font(.custom("SUITE-Regular", size: 14))
                    .foregroundStyle(Brand.textSecondary)
            }

            Spacer()
        }
        // 네이티브 뒤로가기 chevron 대신 커스텀 헤더를 쓰므로 시스템 내비게이션 바는 항상 숨김
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 15)
            HStack {
                BackButton { dismiss() }
                Spacer()
            }
            Spacer().frame(height: 23)
            Text(title)
                .font(.custom("SUITE-Bold", size: 18))
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationStack {
        ComingSoonView(title: "홈")
    }
}
