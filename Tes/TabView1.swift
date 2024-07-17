//
//  TabView1.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/16/24.
//

import SwiftUI

struct TabView1: View {
    let words = ["Ohio", "Rizz", "Plump"]
    
    var body: some View {
        List{
            ForEach(words, id: \.self){ word in
                Button(word){
                    
                }
            }
        }
        .navigationTitle("Buttons!")
    }
}

#Preview {
    NavigationStack{
        TabView1()
    }
}
