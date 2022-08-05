//
//  ContentView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct ContentView: View {
    
    
    @EnvironmentObject var authModel: AuthViewModel
    
    var body: some View {
        Group {
            Ren2UTab().isHidden(hidden: authModel.jwt == nil)
            Login().isHidden(hidden: authModel.jwt != nil)
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
