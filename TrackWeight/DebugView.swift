//
//  DebugView.swift
//  TrackWeight
//
//  Created by Takuto Nakamura on 2024/03/02.
//

import OpenMultitouchSupport
import SwiftUI

struct DebugView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {

            // Device Selector
            if !viewModel.availableDevices.isEmpty {
                VStack(alignment: .leading) {
                    Text("Trackpad Device:")
                        .font(.headline)
                    Picker("Select Device", selection: Binding(
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
                }
                .padding(.bottom)
            }
            
            if viewModel.isListening {
                Button {
                    viewModel.stop()
                } label: {
                    Text("Stop")
                }
            } else {
                Button {
                    viewModel.start()
                } label: {
                    Text("Start")
                }
            }
            Canvas { context, size in
                viewModel.touchData.forEach { touch in
                    let path = makeEllipse(touch: touch, size: size)
                    context.fill(path, with: .color(.primary.opacity(Double(touch.total))))
                }
            }
            .frame(width: 600, height: 400)
            .border(Color.primary)
        }
        .fixedSize()
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }

    private func makeEllipse(touch: OMSTouchData, size: CGSize) -> Path {
        let x = Double(touch.position.x) * size.width
        let y = Double(1.0 - touch.position.y) * size.height
        let u = size.width / 100.0
        let w = Double(touch.axis.major) * u
        let h = Double(touch.axis.minor) * u
        return Path(ellipseIn: CGRect(x: -0.5 * w, y: -0.5 * h, width: w, height: h))
            .rotation(.radians(Double(-touch.angle)), anchor: .topLeading)
            .offset(x: x, y: y)
            .path(in: CGRect(origin: .zero, size: size))
    }
}

#Preview {
    DebugView()
}