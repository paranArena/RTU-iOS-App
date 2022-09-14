//
//  ManageRentalCell.swift
//  Ren2U
//
//  Created by 노우영 on 2022/08/18.
//

import SwiftUI
import Kingfisher

struct ManageRentalCell: View {
    
    var body: some View {
        
        HStack {
            KFImage(URL(string: "...")).onFailure { err in
                print(err.errorDescription ?? "KFImage err")
                }
                .resizable()
                .cornerRadius(15)
                .frame(width: 80, height: 80)
            
            VStack {
                Text("아이템 이름")
                Text("대여자 이름")
                Text("기간")
            }
            
            Spacer()
            
            VStack {
                
            }
        }
    }
}

struct ManageRentalCell_Previews: PreviewProvider {
    static var previews: some View {
        ManageRentalCell()
    }
}
