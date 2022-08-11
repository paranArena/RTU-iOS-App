//
//  RefreshableView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/24.
//
//  https://stackoverflow.com/questions/70610403/swiftui-add-refreshable-to-lazyvstack

import SwiftUI

struct RefreshableView<Content: View>: View {
    
    var content: () -> Content
    
    @Environment(\.refresh) private var refresh  // << refreshable injected !!
    @EnvironmentObject var groupViewModel: GroupViewModel
    @State private var isRefreshing = false

    var body: some View {
        VStack {
            if isRefreshing {
                VStack {
                    ProgressView()
                    Spacer()
                }
                .padding(.top, 0)
            }
            content()
        }
        .animation(.default, value: isRefreshing)
        .background(GeometryReader {
            // detect Pull-to-refresh
            Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).origin.y)
        })
        .onPreferenceChange(ViewOffsetKey.self) {
            if $0 < -250 && !isRefreshing {   // << any creteria we want !!
                Task {
                    isRefreshing = true
                    await refresh?()           // << call refreshable !!
                    try await Task.sleep(nanoseconds: 30000000)
                    withAnimation {
                        isRefreshing = false
                    }
                }
            }
        }
    }
}

public struct ViewOffsetKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

//struct RefreshableView_Previews: PreviewProvider {
//    static var previews: some View {
//        RefreshableView()
//    }
//}
