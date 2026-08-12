//
//  HomeView.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

// 홈 탭 내부 드릴다운 전용 — AppRouter.path(로그인 전 스택)와는 무관
enum HomeRoute: Hashable {
    case notice, inquiry, installRequest

    var title: String {
        switch self {
        case .notice: "공지사항&FAQ"
        case .inquiry: "1:1문의"
        case .installRequest: "충전기 설치 신청"
        }
    }
}

// 즐겨찾기/충전 패턴/공지·문의는 실 데이터·화면 연동 전 placeholder
struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var hapticTrigger = 0
    @State private var path: [HomeRoute] = []
    // 콘텐츠가 헤더 아래로 위로 스크롤됐을 때만 헤더에 그림자를 붙이기 위한 상태
    @State private var isContentScrolled = false

    private let scrollSpace = "homeScroll"

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        intro
                        card
                    }
                    .trackScrollOffset(in: scrollSpace)
                }
                .coordinateSpace(name: scrollSpace)
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                    // 콘텐츠 최상단이 헤더 아래로 살짝이라도 올라가면(음수) 스크롤된 것으로 간주
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isContentScrolled = offset < -1
                    }
                }
            }
            .background(Brand.background)
            .navigationDestination(for: HomeRoute.self) { route in
                ComingSoonView(title: route.title)
            }
            // 네이티브 내비게이션 바 완전히 숨김 — 커스텀 스택 전환
            .toolbar(.hidden, for: .navigationBar)
        }
        .sensoryFeedback(.impact(weight: .heavy), trigger: hapticTrigger)
    }

    private var header: some View {
        ScrollShadowHeader(isScrolled: isContentScrolled) {
            Image("logo")
                .resizable()
                .frame(width: 140, height: 26)
                .padding(.vertical, 12)
        }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Spacer()
                Image("clip-path-group")
            }

            Text("복잡한 ").font(.custom("SUITE-Light", size: 22))
                + Text("회원가입").font(.custom("SUITE-Bold", size: 22)).foregroundStyle(Brand.skyBlue)
                + Text("과").font(.custom("SUITE-Light", size: 22))

            Text("번거로운 ").font(.custom("SUITE-Light", size: 22))
                + Text("충전기 결제").font(.custom("SUITE-Bold", size: 22)).foregroundStyle(Brand.blue)
                + Text("를").font(.custom("SUITE-Light", size: 22))

            Text("손쉽고 간편하게")
                .font(.custom("SUITE-Bold", size: 22))
                .foregroundStyle(Brand.green)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 32) {
            chargeHistorySection
            favoriteChargerSection
            chargingPatternSection
            shortcutSection
        }
        .padding(.top, 28)
        .padding(.bottom, 120) // 원본처럼 흰 카드가 화면 하단까지 이어지도록
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
    }

    private var chargeHistorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("님의 충전 내역")

            ForEach(viewModel.chargeStats) { stat in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stat.title)
                            .font(.custom("SUITE-Medium", size: 16))
                        Text(stat.unit)
                            .font(.custom("SUITE-Medium", size: 16))
                    }
                    Spacer()
                    Image(stat.imageName)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private var favoriteChargerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("자주 이용한 충전소")

            HStack(spacing: 14) {
                ForEach(0..<viewModel.favoriteChargerSlotCount, id: \.self) { _ in
                    OutlinedButton(height: 60) { hapticTrigger += 1 }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var chargingPatternSection: some View {
        OutlinedButton(height: 60, borderColor: Brand.textSecondary) {
            hapticTrigger += 1
        } label: {
            Text("자주 이용하는 패턴을 분석해 결제를 더 손쉽게 할 수 있어요.")
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundStyle(Brand.textSecondary)
        }
        .padding(.horizontal, 20)
    }

    private var shortcutSection: some View {
        HStack(alignment: .top, spacing: 14) {
            // height 미지정 → 오른쪽 두 줄(shortcutButton 68*2 + spacing 10)과 같은 높이로 채워짐
            OutlinedButton(borderColor: Brand.textSecondary) {
                hapticTrigger += 1
                path.append(.installRequest)
            } label: {
                VStack(spacing: 12) {
                    Image("charger_black")
                    Text("충전기 설치 신청")
                        .font(.custom("SUITE-Medium", size: 16))
                }
                .foregroundStyle(Brand.textSecondary)
            }

            VStack(spacing: 10) {
                shortcutButton(title: "공지사항&FAQ", imageName: "notice", borderColor: Brand.red) {
                    path.append(.notice)
                }
                shortcutButton(title: "1:1문의", imageName: "support", borderColor: Brand.orange) {
                    path.append(.inquiry)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private func shortcutButton(
        title: String,
        imageName: String,
        borderColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        OutlinedButton(height: 68, borderColor: borderColor) {
            hapticTrigger += 1
            action()
        } label: {
            HStack {
                Image(imageName)
                Text(title)
                    .font(.custom("SUITE-Medium", size: 16))
                Spacer()
            }
            .padding(.horizontal, 16)
            .foregroundStyle(Brand.textSecondary)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.custom("SUITE-Bold", size: 18))
            .padding(.horizontal, 20)
    }
}

#Preview {
    HomeView()
}
