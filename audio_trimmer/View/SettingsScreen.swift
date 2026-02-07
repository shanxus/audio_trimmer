//
//  SettingsScreen.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/5.
//

import SwiftUI

struct SettingsScreen: View {
    
    @State private var selectedTrackLengthIndex: Int = 0
    @State private var selectedTimelineLengthRatioIndex: Int = 0
    @State private var selectedKeyTimeIndexList: Set<Int> = [0]
    
    var onActionButtonTap: (_ appConfig: AppConfig) -> Void
    
    var body: some View {
        VStack {
            PresetButtonRow(title: "Track Length Selection", items: TrackLengthOptions, selectedIndices: [selectedTrackLengthIndex]) { index in
                selectedTrackLengthIndex = index
            } label: { _, value in
                Text("\(value)")
            }
            
            PresetButtonRow(title: "Key Time Selection", items: KeyTimeOptions, selectedIndices: selectedKeyTimeIndexList) { index in
                
                if selectedKeyTimeIndexList.contains(index) {
                    selectedKeyTimeIndexList.remove(index)
                } else {
                    selectedKeyTimeIndexList.insert(index)
                }
            } label: { _, value in
                Text(value, format: .number.precision(.fractionLength(1)))
            }
            
            PresetButtonRow(title: "Timeline Length Ratio Selection", items: TimelineLengthRatioOptions, selectedIndices: [selectedTimelineLengthRatioIndex]) { index in
                
                selectedTimelineLengthRatioIndex = index
            } label: { _, value in
                Text(value, format: .number.precision(.fractionLength(1)))
            }
            
            Button("Go to audio trimmer") {
                let trackLength = TrackLengthOptions[selectedTrackLengthIndex]
                let keyTimes = selectedKeyTimeIndexList.map { KeyTimeOptions[$0] }
                let trimmedRangeRatio = TimelineLengthRatioOptions[selectedTimelineLengthRatioIndex]
                let appConfig = AppConfig(trackLenght: trackLength, keyTimes: keyTimes, trimmedRangeRatio: trimmedRangeRatio)
                onActionButtonTap(appConfig)
            }
        }
    }
}

struct PresetButtonRow<Item, Label: View>: View {
    let title: String
    let items: [Item]
    let selectedIndices: Set<Int>
    let onTapIndex: (Int) -> Void
    let label: (Int, Item) -> Label

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items.indices, id: \.self) { index in
                        let isSelected = selectedIndices.contains(index)
                        
                        Button {
                            onTapIndex(index)
                        } label: {
                            label(index, items[index])
                        }
                        .buttonStyle(.bordered)
                        .tint(isSelected ? .accentColor : .secondary)
                    }
                }
            }
        }
    }
}



#Preview() {
    SettingsScreen() { appConfig in
        
    }
}
