//
//  ContentView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        Theme.navigationBarColors(tintColor: .label)
    }
    
    var body: some View {
        Login()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
