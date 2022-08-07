//
//  KeyboardHandler.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/29.
//

import SwiftUI
import Combine

final class KeyboardHandler: ObservableObject {
    @Published private(set) var keyboardHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        cancellable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.self.keyboardHeight, on: self)
    }

    private let keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap { notification in
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
        }

    private let keyboardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero}
    
}

