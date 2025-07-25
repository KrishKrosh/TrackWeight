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
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                // Settings Content
                VStack(spacing: 30) {
                    // Device Settings Section
                    SettingsSection(title: "Device") {
                        VStack(alignment: .leading, spacing: 16) {
                            if !viewModel.availableDevices.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Trackpad")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("Select which trackpad device to use for weight tracking")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Picker("", selection: Binding(
                                        get: { viewModel.selectedDevice },
                                        set: { device in
                                            if let device = device {
                                                viewModel.selectDevice(device)
                                            }
                                        }
                                    )) {
                                        ForEach(viewModel.availableDevices, id: \.self) { device in
                                            Text("\(device.deviceName) (ID: \(device.deviceID))")
                                                .tag(device as OMSDeviceInfo?)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            } else {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("No devices found")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Make sure your trackpad is connected and try restarting the app")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    // Advanced Settings Section
                    SettingsSection(title: "Advanced") {
                        VStack(spacing: 12) {
                            SettingsRow(
                                title: "Debug View",
                                subtitle: "View raw touch data and device information",
                                action: {
                                    showDebugView = true
                                }
                            )
                        }
                    }
                }
                .frame(maxWidth: 600)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
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

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                content
            }
            .padding(24)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(12)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isHovered ? Color(NSColor.selectedControlColor).opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovered in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovered
            }
        }
    }
}

#Preview {
    SettingsView()
} 