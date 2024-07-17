//
//  MainViewTab.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/16/24.
//

import SwiftUI

struct MainViewTab: View {
    var body: some View {
        
        TabView{
            
            NavigationView{
                TabView1()
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorites")
            }
            
            
        }
        
    }
}

#Preview {
    MainViewTab()
}
