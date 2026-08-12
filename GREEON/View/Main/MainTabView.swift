//
//  MainTabView.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

enum MainTab: Hashable {
    case home, map, qr, receipt, myGreeon

    var title: String {
        switch self {
        case .home: "홈"
        case .map: "충전소 찾기"
        case .qr: "QR 스캔"
        case .receipt: "이용내역"
        case .myGreeon: "나의 그리온"
        }
    }

    // 탭별로 활성/비활성 아이콘이 따로 있음 (qr 제외)
    var imageName: String {
        switch self {
        case .home: "home_disable"
        case .map: "map_disable"
        case .qr: "qrcode"
        case .receipt: "receipt_disable"
        case .myGreeon: "myGreeon_disable"
        }
    }

    var selectedImageName: String {
        switch self {
        case .home: "home"
        case .map: "map"
        case .qr: "qrcode"
        case .receipt: "receipt"
        case .myGreeon: "myGreeon"
        }
    }
}

// 로그인 후 루트. 5탭은 서로 독립된 화면이라 AppRouter.path(로그인 전 스택)와는 무관 — 탭 전환만 로컬 상태로 관리
struct MainTabView: View {
    @State private var selectedTab: MainTab = .home

    var body: some View {
        VStack(spacing: 0) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab)
        }
        // 로그인 화면 키보드가 닫히며 발행하는 지연된 키보드 세이프에어리어 통지에
        // 탭바가 반응해 사라졌다가 슬라이드업하는 버그 방지 (2026-08-12 영상 분석으로 확인)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .home: HomeView()
        case .map: ComingSoonView(title: MainTab.map.title, showsBackButton: false)
        case .qr: ComingSoonView(title: MainTab.qr.title, showsBackButton: false)
        case .receipt: ComingSoonView(title: MainTab.receipt.title, showsBackButton: false)
        case .myGreeon: ComingSoonView(title: MainTab.myGreeon.title, showsBackButton: false)
        }
    }
}

#Preview {
    MainTabView()
}
