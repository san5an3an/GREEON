//
//  ChargeStat.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import Foundation

// 실 충전 데이터 연동 전 placeholder 값
struct ChargeStat: Identifiable {
    let id = UUID()
    let title: String
    let unit: String
    let imageName: String
}
