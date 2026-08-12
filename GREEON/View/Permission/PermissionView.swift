//
//  PermissionView.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import SwiftUI

struct PermissionView: View {
    @State private var viewModel = PermissionViewModel()
    @Environment(AppRouter.self) private var router
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 26)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

            Text("GREEON을 이용하기 위해\n아래 접근 권한을 허용해주세요.")
                .font(.custom("SUITE-Medium", size: 16))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 48)

            Spacer()

            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(viewModel.items) { item in
                        permissionRow(item)
                    }
                }
                Spacer()
            }

            Spacer()

            confirmButton
        }
        .padding(.horizontal, 20)
        .task {
            if viewModel.isAuthorized {
                router.replaceStack(with: .login)
            }
        }
        .alert("위치서비스를 허용해주세요.", isPresented: $viewModel.isShowingDeniedAlert) {
            Button("설정하러 가기") {
                if let url = viewModel.settingsURL {
                    openURL(url)
                }
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("GREEON은 주변의 충전소를 찾기 위해 위치서비스를 필수적으로 사용합니다.\n\n[항상 또는 사용하는 동안으로 설정]")
        }
        // 네이티브 내비게이션 바(뒤로가기 chevron 포함) 완전히 숨김 — 커스텀 스택 전환
        .toolbar(.hidden, for: .navigationBar)
    }

    private func permissionRow(_ item: PermissionItem) -> some View {
        HStack(spacing: 18) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title).font(.custom("SUITE-Bold", size: 16))
                    + Text(item.isRequired ? " (필수)" : " (선택)")
                        .font(.custom("SUITE-Medium", size: 14))
                        .foregroundColor(item.isRequired ? Brand.green : Brand.textSecondary)

                Text(item.description)
                    .font(.custom("SUITE-Regular", size: 14))
                    .foregroundStyle(Brand.textSecondary)
            }
        }
    }

    private var confirmButton: some View {
        HStack {
            Spacer()
            Text("확인")
                .font(.custom("SUITE-Bold", size: 16))
            Button {
                Task { await requestAndProceed() }
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Brand.green)
            }
        }
        .padding(.bottom, 20)
    }

    private func requestAndProceed() async {
        await viewModel.requestAll()
        if viewModel.isAuthorized {
            router.replaceStack(with: .login)
        }
    }
}

#Preview {
    NavigationStack {
        PermissionView()
    }
    .environment(AppRouter())
}
