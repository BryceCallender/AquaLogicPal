//
//  ContentView.swift
//  aqualogicpal
//
//  Created by Bryce Callender on 6/17/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
           Text("The content of the first view")
             .tabItem {
                Image(systemName: "phone.fill")
                Text("First Tab")
              }
            Text("The content of the second view")
             .tabItem {
                Image(systemName: "tv.fill")
                Text("Second Tab")
              }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
