//
//  PermissionViewModel.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import AVFoundation
import CoreLocation
import Observation
import Photos
import UIKit // openSettingsURLString 상수 읽기용

// 위치만 필수(거부 시 진행 불가), 카메라/사진은 선택 — 아직 실 기능(QR스캔/이미지 첨부) 없어 바로 요청
@Observable
@MainActor
final class PermissionViewModel {
    let items: [PermissionItem] = [
        PermissionItem(title: "위치", isRequired: true, description: "현재 위치 및 주변 충전소 확인", imageName: "map-fill-1-wght-500-grad-0-opsz-48"),
        PermissionItem(title: "전화", isRequired: true, description: "전화번호로 직접 전화 걸기", imageName: "phone-in-talk-fill-1-wght-500-grad-0-opsz-48"),
        PermissionItem(title: "카메라", isRequired: false, description: "충전 시 충전기 QR코드 스캔", imageName: "photo-camera-fill-1-wght-500-grad-0-opsz-48"),
        PermissionItem(title: "저장공간", isRequired: false, description: "제보 및 문의 이미지 첨부", imageName: "save-fill-1-wght-500-grad-0-opsz-48")
    ]

    private(set) var authorizationStatus: CLAuthorizationStatus
    var isShowingDeniedAlert = false

    private let locationProvider: LocationPermissionProviding

    // locationProvider는 테스트 시 Mock으로 교체 가능
    init(locationProvider: LocationPermissionProviding = LocationPermissionService()) {
        self.locationProvider = locationProvider
        self.authorizationStatus = locationProvider.currentStatus
    }

    var isAuthorized: Bool {
        authorizationStatus.isAuthorized
    }

    var settingsURL: URL? {
        URL(string: UIApplication.openSettingsURLString)
    }

    // 확인 버튼 → 필수(위치) 먼저 요청, 승인되면 선택 항목도 이어서 요청
    func requestAll() async {
        let status = await locationProvider.requestWhenInUseAuthorization()
        authorizationStatus = status
        guard status.isAuthorized else {
            if status.isDenied { isShowingDeniedAlert = true }
            return
        }
        _ = await requestCameraAccess()
        _ = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }

    private func requestCameraAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
    }
}
