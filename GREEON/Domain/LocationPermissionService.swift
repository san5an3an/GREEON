//
//  LocationPermissionService.swift
//  GREEON
//
//  Created by SAN on 8/11/26.
//

import CoreLocation

// CLLocationManager를 async/await로 래핑
final class LocationPermissionService: NSObject, LocationPermissionProviding {
    private let manager = CLLocationManager()
    private var pendingContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?

    override init() {
        super.init()
        manager.delegate = self
    }

    var currentStatus: CLAuthorizationStatus {
        manager.authorizationStatus
    }

    func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        // 이미 결정된 상태면 대화상자 없이 바로 반환
        guard manager.authorizationStatus == .notDetermined else {
            return manager.authorizationStatus
        }
        return await withCheckedContinuation { continuation in
            self.pendingContinuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationPermissionService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        pendingContinuation?.resume(returning: manager.authorizationStatus)
        pendingContinuation = nil
    }
}
