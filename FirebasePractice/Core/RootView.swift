//
//  RootView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 6/26/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView : Bool = false
    
    var body: some View {
        
        ZStack{
            
            if !showSignInView{
                NavigationStack{
//                    ProfileView(showSignInView: $showSignInView)
                    ProductsView()
                }
            }
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
            
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
    }
}

#Preview {
    RootView()
}
