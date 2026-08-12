//
//  CustomTabBar.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

// 가운데 QR 탭만 곡선 노치 위로 떠 있는 원형 버튼 — 나머지 4탭은 일반 텍스트+아이콘
struct CustomTabBar: View {
    @Binding var selectedTab: MainTab
    @State private var hapticTrigger = 0

    private let barHeight: CGFloat = 56
    private let notchHeight: CGFloat = 45

    var body: some View {
        ZStack(alignment: .top) {
            TabBarShape(notchHeight: notchHeight)
                .fill(Color.white)
                .overlay(TabBarShape(notchHeight: notchHeight).stroke(Brand.borderDefault, lineWidth: 0.5))
                .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
                // fill+stroke+shadow를 한 레이어로 강제 합성 — 시스템 얼럿(키체인 저장) dismiss 시
                // 윈도우가 재구성되며 이 레이어만 한두 프레임 덜 그려져 뒤 콘텐츠가 비치는 현상 방지
                .compositingGroup()

            HStack(spacing: 0) {
                tabButton(.home)
                tabButton(.map)
                Spacer().frame(width: notchHeight * 2)
                tabButton(.receipt)
                tabButton(.myGreeon)
            }
            .padding(.top, 8)

            qrButton
                .offset(y: -notchHeight + 18)
        }
        .frame(height: barHeight)
        .sensoryFeedback(.impact(weight: .heavy), trigger: hapticTrigger)
    }

    private func tabButton(_ tab: MainTab) -> some View {
        Button {
            selectedTab = tab
            hapticTrigger += 1
        } label: {
            VStack(spacing: 4) {
                Image(selectedTab == tab ? tab.selectedImageName : tab.imageName)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                Text(tab.title)
                    .font(.custom("SUITE-Medium", size: 10))
                    .foregroundStyle(selectedTab == tab ? Brand.green : Brand.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var qrButton: some View {
        Button {
            selectedTab = .qr
            hapticTrigger += 1
        } label: {
            Circle()
                .fill(Color.black)
                .frame(width: notchHeight + 5, height: notchHeight + 5)
                .overlay(
                    Image("qrcode")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                )
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
}
