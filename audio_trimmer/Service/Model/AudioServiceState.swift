//
//  AudioServiceState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/29.
//

enum AudioServiceStateUpdateAction {
    case setup
    case playback
    case seek
}

struct PlaybackRange: Equatable {
    var startTime: Double
    var endTime: Double
    
    var duration: Double {
        return endTime - startTime
    }
    
    static let `default` = PlaybackRange(startTime: 0, endTime: 0)
    
    static func from(startTime: Double?, endTime: Double?) -> PlaybackRange? {
        guard let startTime = startTime, let endTime = endTime else {
            return nil
        }
        return PlaybackRange(startTime: startTime, endTime: endTime)
    }
}

struct AudioServiceState: Equatable {
    var currentPlaybackTime: Double
    var trackDuration: Double
    var isPlaying: Bool
    var playbackProgressInRange: Double
    var playbackRange: PlaybackRange
    var updateAction: AudioServiceStateUpdateAction?
    var seekActionSource: SeekActionSource?
    
    var currentPlaybackProgress: Double {
        return (currentPlaybackTime / trackDuration).clamped()
    }
    
    var currentPlaybackProgressInRange: Double {
        return ((currentPlaybackTime - playbackRange.startTime) / playbackRange.duration).clamped()
    }
    
    var rangeStartRatio: Double {
        return (playbackRange.startTime / trackDuration).clamped()
    }
    
    var rangeEndRatio: Double {
        return (playbackRange.endTime / trackDuration).clamped()
    }
    
    static let initial: AudioServiceState = .init(currentPlaybackTime: 0, trackDuration: 0, isPlaying: false, playbackProgressInRange: 0, playbackRange: .default)
    
    func copyWith(
        currentPlaybackTime: Double? = nil,
        playbackEndTime: Double? = nil,
        isPlaying: Bool? = nil,
        playbackProgressInRange: Double? = nil,
        playbackRange: PlaybackRange? = nil,
        updateAction: AudioServiceStateUpdateAction? = nil,
        seekActionSource: SeekActionSource? = nil
    ) -> AudioServiceState {
        return .init(
            currentPlaybackTime: currentPlaybackTime ?? self.currentPlaybackTime,
            trackDuration: playbackEndTime ?? self.trackDuration,
            isPlaying: isPlaying ?? self.isPlaying,
            playbackProgressInRange: playbackProgressInRange ?? self.playbackProgressInRange,
            playbackRange: playbackRange ?? self.playbackRange,
            updateAction: updateAction ?? self.updateAction,
            seekActionSource: seekActionSource ?? self.seekActionSource
        )
    }
}
