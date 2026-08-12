//
//  SplashView.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import SwiftUI

struct SplashView: View {
    @Environment(AppRouter.self) private var router
    private let permissionProvider: LocationPermissionProviding = LocationPermissionService()

    var body: some View {
        VStack {
            Spacer()

            // SplashLogo 에셋 자체에 "Green Energy Networks" 태그라인 + GREEON 워드마크가 함께 그려져 있음
            Image("SplashLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 192, height: 64)

            Spacer()

            poweredBy
                .padding(.bottom, 22)
        }
        .task {
            // 최소 노출 시간
            try? await Task.sleep(for: .milliseconds(600))
            if permissionProvider.currentStatus.isAuthorized {
                router.replaceStack(with: .login)
            } else {
                router.replaceStack(with: .permission)
            }
        }
        // 네이티브 내비게이션 바 완전히 숨김 — 커스텀 스택 전환
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension SplashView {
    var poweredBy: some View {
        HStack(spacing: 4) {
            Text("Powered by").foregroundStyle(Brand.textSecondary)
            Text("GREENCUBE").foregroundStyle(Brand.green)
        }
        .font(.custom("Outfit-Regular", size: 14))
    }
}

#Preview {
    NavigationStack {
        SplashView()
    }
    .environment(AppRouter())
}
