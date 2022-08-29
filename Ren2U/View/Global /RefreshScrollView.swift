//
//  RefreshScrollView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/11.
//

import SwiftUI
import AVFoundation
import Combine

struct RefreshScrollView<Content: View>: View {
    
    let threshold: CGFloat
    var content: () -> Content
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    
    @Environment(\.refresh) private var refresh
    @State private var offset: CGFloat = .zero
    @State private var startoffset: CGFloat = .zero
    @State private var isRefreshing = false
    @State private var isScrolled = false

    init(threshold: CGFloat, c: @escaping () -> Content ) {
        self.threshold = threshold
        self.content = c
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.detector = detector
        self.publisher = detector
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if isRefreshing {
                ProgressView()
            }
            
            
            ScrollView(.vertical, showsIndicators: false) {
                content()
                    .padding(.top, isRefreshing ? 50 : 0)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self, value: $0.frame(in: .global).minY)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        offset = $0
                        detector.send($0)
                        if $0 > (threshold+50) && !isRefreshing && (startoffset == threshold) {
                            simpleSuccess() // 핸드폰에 진동 주기
                            Task {
                                isRefreshing = true
                                await refresh?()
                                withAnimation {
                                    isRefreshing = false
                                }
                            }
                        }
                    }
            }
            .allowsHitTesting(!isRefreshing)
            .onReceive(publisher) {
                startoffset = $0
            }
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
