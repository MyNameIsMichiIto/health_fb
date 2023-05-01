//
//  SecondView.swift
//  health_fb
//
//  Created by 伊藤倫 on 2023/04/28.
//

import SwiftUI
import FirebaseFirestore

struct SecondView: View {
    
    
    @State private var taiju: String = ""
    @State private var sintyo: String = ""
    
    var body: some View {
        
        VStack{
            
            TextField("体重", text: $taiju)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("身長", text: $sintyo)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("登録"){
                
                let db = Firestore.firestore()
                let userRef = db.collection("users").document()
                let data: [String:Any] = ["taiju": self.taiju,
                                          "sintyo": self.sintyo]
                
                userRef.setData(data){ error in
                    if let error = error{
                        print("エラー\(error)")
                    }else{
                    }
                    
                }
                
                
                
            }
            
        }
        
    }
}
