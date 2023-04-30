//
//  AuthView.swift
//  health_fb
//
//  Created by 伊藤倫 on 2023/04/29.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var mailText: String = ""
    @State private var passwardText: String = ""
    
    var body: some View {
        
        VStack{
            
            TextField("メール", text: $mailText)
                .textFieldStyle(.roundedBorder)
                .padding()
            TextField("パスワード", text: $passwardText)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("登録"){
                Auth.auth().createUser(withEmail: self.mailText,
                                       password: self.passwardText){(authResult, error) in
                    if error != nil{
                        
                        print("失敗\(error)")
                        return
                    }else{
                        print("成功")
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                    
                    
                    
                    
                }
            }
        }
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
