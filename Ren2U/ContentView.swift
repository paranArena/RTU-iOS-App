//
//  ContentView.swift
//  Ren2U
//
//  Created by 노우영 on 2022/07/12.
//

import SwiftUI

struct ContentView: View {
    
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            Ren2UTab().isHidden(hidden: authViewModel.jwt == nil)
            Login().isHidden(hidden: authViewModel.jwt != nil)
        }
        .onAppear(perform: UIApplication.shared.hideKeyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
