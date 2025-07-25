//
//  SettingsView.swift
//  TrackWeight
//

import OpenMultitouchSupport
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showDebugView = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Minimal Header
            Text("Settings")
                .font(.title)
                .fontWeight(.medium)
                .padding(.top, 32)
                .padding(.bottom, 32)
            
            // Settings Cards
            VStack(spacing: 20) {
                // Device Card
                SettingsCard {
                    VStack(spacing: 20) {
                        // Status Row
                        HStack {
                            HStack(spacing: 12) {
                                Text("Trackpad")
                                    .font(.headline)
                                    .fontWeight(.medium)
                            }
                            
                            Spacer()
                            
                            if !viewModel.availableDevices.isEmpty {
                                Text("\(viewModel.availableDevices.count) device\(viewModel.availableDevices.count == 1 ? "" : "s")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Device Selector
                        if !viewModel.availableDevices.isEmpty {
                            HStack {
                                Picker("", selection: Binding(
                                    get: { viewModel.selectedDevice },
                                    set: { device in
                                        if let device = device {
                                            viewModel.selectDevice(device)
                                        }
                                    }
                                )) {
                                    ForEach(viewModel.availableDevices, id: \.self) { device in
                                        Text(device.deviceName)
                                            .tag(device as OMSDeviceInfo?)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                
                                Spacer()
                            }
                        } else {
                            HStack {
                                Text("No devices available")
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                    }
                }
                
                // Debug Card
                SettingsCard {
                    Button(action: { showDebugView = true }) {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Debug Console")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Text("Raw touch data & diagnostics")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary.opacity(0.6))
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(CardButtonStyle())
                }
            }
            .frame(maxWidth: 480)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(isPresented: $showDebugView) {
            DebugView()
                .frame(minWidth: 700, minHeight: 500)
        }
        .onAppear {
            viewModel.loadDevices()
        }
    }
}

struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding(24)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 1)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    SettingsView()
} 