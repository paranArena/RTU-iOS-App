//
//  ContentView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct ContentView: View {
    
    
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        Group {
            if authModel.jwt != nil {
                Ren2UTab()
            } else {
                Login()
            }
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
