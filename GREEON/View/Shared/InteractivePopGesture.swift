//
//  InteractivePopGesture.swift
//  GREEON
//
//  Created by SAN on 8/13/26.
//

import UIKit

// 네이티브 내비게이션 바를 숨기면 엣지 스와이프 뒤로가기도 같이 꺼짐 — 델리게이트를
// 직접 지정해 커스텀 헤더를 써도 스와이프 백은 살아있게 강제
extension UINavigationController: UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
