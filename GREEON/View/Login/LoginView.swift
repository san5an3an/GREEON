//
//  LoginView.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import SwiftUI

// 이메일/비밀번호 찾기는 미구현
struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    @Environment(AppRouter.self) private var router
    @FocusState private var focusedField: Field?

    private enum Field {
        case email, password
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            header
            Spacer().frame(height: 48)
            form
            Spacer().frame(height: 20)
            loginButton
            Spacer().frame(height: 40)
            footerLinks
          Spacer()
        }
        .padding(.horizontal, 14)
        .contentShape(Rectangle())
        // 빈 영역 탭하면 키보드 내림
        .onTapGesture {
            focusedField = nil
        }
        .alert("로그인 오류", isPresented: $viewModel.isShowingAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        // 네이티브 내비게이션 바(뒤로가기 chevron 포함) 완전히 숨김 — 커스텀 스택 전환
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image("logo")
            Text("안녕하세요.")
                .font(.custom("SUITE-Medium", size: 18))
            Text("쉽고 빠른 전기차 충전 GREEON 입니다.")
                .font(.custom("SUITE-Medium", size: 18))
            Text("로그인해주세요.")
                .font(.custom("SUITE-Regular", size: 14))
                .foregroundStyle(Brand.textSecondary)
        }
    }

    private var form: some View {
        VStack(spacing: 16) {
            TextField("이메일 주소", text: $viewModel.credentials.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .font(.custom("SUITE-Regular", size: 16))
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                // 리턴 누르면 비밀번호로 포커스 이동
                .onSubmit {
                    focusedField = .password
                }

            SecureField("비밀번호", text: $viewModel.credentials.password)
                .textFieldStyle(.roundedBorder)
                .font(.custom("SUITE-Regular", size: 16))
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                // 리턴 누르면 로그인 시도
                .onSubmit {
                    attemptLogin()
                }
        }
    }

    private func attemptLogin() {
        focusedField = nil
        guard viewModel.login() else { return }
        // iOS 비밀번호 저장 AutoFill 얼럿이 LoginView에 붙을 시간을 벌어주는 지연 — 즉시 전환하면 프레젠테이션 실패로 탭바 자리에 유령 애니메이션이 발생
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(500))
            router.completeAuth()
        }
    }

    private var loginButton: some View {
        Button {
            attemptLogin()
        } label: {
            Text("로그인")
                .font(.custom("SUITE-Bold", size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(Brand.green))
        }
    }

    private var footerLinks: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Text("아직 회원이 아니신가요?")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundStyle(Brand.textSecondary)
                Spacer()
                Button {
                    router.push(.signUp)
                } label: {
                    Text("회원가입")
                        .font(.custom("SUITE-Bold", size: 16))
                        .foregroundStyle(Brand.textSecondary)
                        .frame(width: 94, height: 38)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Brand.green, lineWidth: 4))
                }
            }
            HStack {
                Text("이메일을 잊으셨나요?")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundStyle(Brand.textSecondary)
                Spacer()
                Button("이메일 찾기") {}
                    .font(.custom("SUITE-Bold", size: 16))
                    .foregroundStyle(Brand.blue)
            }
            HStack {
                Text("비밀번호를 잊으셨나요?")
                    .font(.custom("SUITE-Medium", size: 16))
                    .foregroundStyle(Brand.textSecondary)
                Spacer()
                Button("비밀번호 찾기") {}
                    .font(.custom("SUITE-Bold", size: 16))
                    .foregroundStyle(Brand.blue)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .environment(AppRouter())
}
