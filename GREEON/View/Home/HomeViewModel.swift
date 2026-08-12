//
//  HomeViewModel.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import Observation

// 실 충전/충전소 데이터 연동 없음, placeholder 값만 보유
@Observable
@MainActor
final class HomeViewModel {
    var chargeStats: [ChargeStat] = [
        ChargeStat(title: "충전량", unit: "kWh", imageName: "red_path"),
        ChargeStat(title: "충전금액", unit: "원", imageName: "yellow_path"),
        ChargeStat(title: "충전횟수", unit: "회", imageName: "green_path")
    ]

    // 자주 이용한 충전소 연동 전 빈 슬롯 개수
    let favoriteChargerSlotCount = 3
}
