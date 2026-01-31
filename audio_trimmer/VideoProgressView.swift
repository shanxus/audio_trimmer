//
//  VideoProgressView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/27.
//

import SwiftUI

struct VideoProgressView: View {
    let keyTimes: [Double]
    let height: CGFloat = 24
    let onTap: (Double) -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.gray.opacity(0.3))
                .frame(maxWidth: .infinity, maxHeight: height)
                .clipShape(RoundedRectangle(cornerRadius: height/2))
                .overlay {
                    GeometryReader { geo in
                        ForEach(Array(keyTimes.enumerated()), id: \.offset) { index, keyTime in
                            KeyTimeIndicator()
                                .position(x: keyTime * geo.size.width, y: geo.size.height / 2)
                                .onTapGesture {
                                    onTap(keyTime)
                                }
                        }
                    }
                }
        }
    }
}

struct KeyTimeIndicator: View {
    var body: some View {
        Circle()
            .fill(.gray)
            .frame(width: 20, height: 20)
    }
}
