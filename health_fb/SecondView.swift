//
//  SecondView.swift
//  health_fb
//
//  Created by 伊藤倫 on 2023/04/28.
//

import SwiftUI
import FirebaseFirestore

struct SecondView: View {
    
    @State private var taiju: String
    @State private var sintyo: String
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        VStack{
            
            TextField("体重", text: $taiju)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("身長", text: $sintyo)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("登録"){
                
                
            }
            
        }
        
    }
}
