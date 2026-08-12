//
//  AppRouter.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import Observation

enum AppRoute: Hashable {
    case permission
    case login
    case signUp
}

@Observable
final class AppRouter {
    // 로그인 전(Splash/Permission/Login/SignUp) 흐름 전용
    var path: [AppRoute] = []
    var isAuthenticated = false

    func push(_ route: AppRoute) {
        path.append(route)
    }

    // 스택 비우고 새 루트로 교체
    func replaceStack(with route: AppRoute) {
        path = [route]
    }

    func popToRoot() {
        path.removeAll()
    }

    // 로그인 성공 → 루트를 MainTabView로 전환
    func completeAuth() {
        isAuthenticated = true
        path.removeAll()
    }
}
