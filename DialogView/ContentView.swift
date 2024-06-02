//
//  ContentView.swift
//  DialogView
//
//  Created by Sam on 2024/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresentedAlert: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                isPresentedAlert.toggle()
            }, label: {
                Text("Trigger alert".capitalized)
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
