//
//  GREEONApp.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import SwiftUI

@main
struct GREEONApp: App {
    // TODO: KakaoMapsSDK 초기화는 Map 화면 만들 때 여기에 추가
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            Group {
                if router.isAuthenticated {
                    MainTabView()
                } else {
                    NavigationStack(path: $router.path) {
                        SplashView()
                            .navigationDestination(for: AppRoute.self) { route in
                                switch route {
                                case .permission:
                                    PermissionView()
                                case .login:
                                    LoginView()
                                case .signUp:
                                    ComingSoonView(title: "회원가입")
                                }
                            }
                    }
                }
            }
            .environment(router)
            .preferredColorScheme(.light) // GREEON_swift의 overrideUserInterfaceStyle = .light 대응
        }
    }
}
