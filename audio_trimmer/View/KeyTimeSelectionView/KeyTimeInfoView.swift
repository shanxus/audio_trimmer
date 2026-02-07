//
//  KeyTimeInfoView.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/7.
//

import SwiftUI

struct KeyTimeInfoView: View {
    @Binding var state: KeyTimeInfoState
    
    var body: some View {
        VStack {
            Text("KeyTime Selection")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            Text("Selected: \(state.selectedStartTimeProgressLabelValue) -> \(state.selectedEndTimeProgressLabelValue)")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
            Text("Current: \(state.currentPlaybackProgressLabelValue)")
                .foregroundStyle(Color.white)
            Spacer()
                .frame(height: 5)
        }.background(Color.darkGrey)
    }
}
