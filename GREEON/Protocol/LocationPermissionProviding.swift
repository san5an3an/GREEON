//
//  LocationPermissionProviding.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import CoreLocation

// 구현체는 Domain/LocationPermissionService.swift
protocol LocationPermissionProviding {
    // 현재 권한 상태 즉시 조회
    var currentStatus: CLAuthorizationStatus { get }

    // 권한 요청 후 최종 상태 반환
    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus
}

extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        self == .authorizedWhenInUse || self == .authorizedAlways
    }

    var isDenied: Bool {
        self == .denied || self == .restricted
    }
}
