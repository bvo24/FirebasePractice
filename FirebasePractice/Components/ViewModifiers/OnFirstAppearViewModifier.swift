//
//  OnFirstAppearViewModifier.swift
//  FirebasePractice
//
//  Created by Brian Vo on 7/19/24.
//

import Foundation
import SwiftUI

struct OnFirstViewModifer : ViewModifier{
    
    @State private var didAppear: Bool = false
    let perform : (() -> Void)?
    func body(content : Content) -> some View{
        content
            .onAppear{
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}
