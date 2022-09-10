//
//  RefreshScrollView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/11.
//

import SwiftUI
import AVFoundation
import Combine

struct RefreshableScrollView<Content: View>: View {
    
    let threshold: CGFloat
    var content: () -> Content
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    
    @Environment(\.refresh) private var refresh
    @State private var startoffset: CGFloat = .zero
    @State private var isRefreshing = false
    
    
    // 렌더링 되면서 threshold에 생기는 문제 방지
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
            ProgressView()
                .isHidden(hidden: !isRefreshing)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                content()
                    .padding(.top, isRefreshing ? 50 : 0)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self, value: $0.frame(in: .global).minY)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) {
                        detector.send($0)
                        if $0 > (threshold+50)  && startoffset < threshold + 50 {
                            print("refreshing")
//                            startoffset = $0 // Offset이 threshold를 넘겼을 때 게속 refresh 되는 것을 방지
                            isRefreshing = true
                            simpleSuccess() // 핸드폰에 진동 주기
                            Task {
                                await refresh?()
                                withAnimation {
                                    isRefreshing = false
                                }
                                print("RefreshableScrollView End")
                            }
                        }
                    }
            }
            .allowsHitTesting(!isRefreshing)
            .onReceive(publisher) {
                startoffset = $0
                print("startoffset :  \(startoffset)")
                print("threshold: \(threshold)")
            }
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
