//
//  AudioServiceState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/29.
//

enum PlaybackTimeUpdateAction {
    case playback
    case seek
}

struct AudioServiceState: Equatable {
    var currentPlaybackTime: Double
    var isPlaying: Bool
    var playbackProgressInRange: Double
    var playbackTimeUpdateAction: PlaybackTimeUpdateAction?
    var seekActionSource: SeekActionSource?
    
    static let initial: AudioServiceState = .init(currentPlaybackTime: 0,  isPlaying: false, playbackProgressInRange: 0)
    
    func copyWith(
        currentPlaybackTime: Double? = nil,
        isPlaying: Bool? = nil,
        playbackProgressInRange: Double? = nil,
        playbackTimeUpdateAction: PlaybackTimeUpdateAction? = nil,
        seekActionSource: SeekActionSource? = nil
    ) -> AudioServiceState {
        return .init(
            currentPlaybackTime: currentPlaybackTime ?? self.currentPlaybackTime,
            isPlaying: isPlaying ?? self.isPlaying,
            playbackProgressInRange: playbackProgressInRange ?? self.playbackProgressInRange,
            playbackTimeUpdateAction: playbackTimeUpdateAction ?? self.playbackTimeUpdateAction,
            seekActionSource: seekActionSource ?? self.seekActionSource
        )
    }
}
