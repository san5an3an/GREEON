//
//  LoginViewModel.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import Foundation
import Observation

// 실 로그인 API 연동 없음, 클라이언트 검증만
@Observable
@MainActor
final class LoginViewModel {
    var credentials = AuthCredentials()
    var isShowingAlert = false
    var alertMessage = ""

    // 이메일 정규식
    private let emailPredicate = NSPredicate(
        format: "SELF MATCHES %@",
        "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    )
    // 비밀번호 정규식
    private let passwordPredicate = NSPredicate(
        format: "SELF MATCHES %@",
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,}"
    )

    // 검증 통과 시 true
    func login() -> Bool {
        if credentials.email.isEmpty {
            fail("\n이메일 주소를 입력해주세요.")
            return false
        }
        if !emailPredicate.evaluate(with: credentials.email) {
            fail("\n올바른 이메일 형식이 아닙니다.\n다시 확인해주세요.")
            return false
        }
        if credentials.password.isEmpty {
            fail("\n비밀번호를 입력해주세요.")
            return false
        }
        if !passwordPredicate.evaluate(with: credentials.password) {
            fail("\n잘못된 비밀번호입니다.\n다시 확인해주세요.")
            return false
        }
        return true
    }

    private func fail(_ message: String) {
        alertMessage = message
        isShowingAlert = true
    }
}
