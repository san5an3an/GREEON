//
//  PermissionItem.swift
//  GREEON
//
//  Created by SAN on 8/12/26.
//

import Foundation

struct PermissionItem: Identifiable {
    let id = UUID()
    let title: String
    let isRequired: Bool
    let description: String
    let imageName: String
}
