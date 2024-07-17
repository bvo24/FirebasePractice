//
//  TabbarView.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/16/24.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showSignInView : Bool
    
    var body: some View {

        TabView {
                    NavigationView {
                        ProductsView()
                    }
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Products")
                    }
                    
                    NavigationView {
                        FavoriteView()
                    }
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
                    
                    NavigationView {
                        ProfileView(showSignInView: $showSignInView)
                    }
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
               
            
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
