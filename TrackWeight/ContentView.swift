//
//  ContentView.swift
//  TrackWeight
//

import SwiftUI

struct ContentView: View {
    @State private var showHomePage = true
    @State private var selectedTab = 1 // Start with Scale tab (index 1)
    
    var body: some View {
        if showHomePage {
            HomeView {
                showHomePage = false
            }
            .frame(minWidth: 700, minHeight: 500)
        } else {
            TabView(selection: $selectedTab) {
                TrackWeightView()
                    .tabItem {
                        Image(systemName: "arrow.3.trianglepath")
                        Text("Guided (Experimental)")
                    }
                    .tag(0)
                
                ScaleView()
                    .tabItem {
                        Image(systemName: "scalemass")
                        Text("Scale")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                    .tag(2)
            }
            .frame(minWidth: 700, minHeight: 500)
        }
    }
}


#Preview {
    ContentView()
}
