//
//  AudioService.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/27.
//

import Foundation
import Combine

protocol AudioService {
    func play()
    func pause()
    func reset()
    func seek(withRatio ratio: Double, source: SeekActionSource)
    
    func setupConfig(_ config: AudioConfig)
    
    var state: AudioServiceState { get }
    var statePublisher: AnyPublisher<AudioServiceState, Never> { get }
}

final class AudioServiceImpl: AudioService {
    private var audioConfig: AudioConfig?
    
    private let fps: Double = 30
    private var timer: Timer?
    
    @Published private(set) var state: AudioServiceState = .initial
    
    var statePublisher: AnyPublisher<AudioServiceState, Never> {
        return $state.eraseToAnyPublisher()
    }
    
    var playbackRangeStartTime: Double?
    var playbackRangeEndTime: Double?
    
    func play() {                
        guard !state.isPlaying else { return }
        print("[AudioServiceImpl] play")
        state = state.copyWith(isPlaying: true, updateAction: .playPause)
        
        let interval: TimeInterval = 1.0 / fps
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: {[weak self] _ in
            self?.tick(delta: interval)
        })
    }
    
    func tick(delta: TimeInterval) {
        guard let config = audioConfig else { return }
        
        var newPlaybackTime = state.currentPlaybackTime + delta
        let trackLength = Double(config.totalTrackLength)
        
        let endTime = min(trackLength, (playbackRangeEndTime ?? trackLength))
        
        let playToEnd = newPlaybackTime >= endTime
        newPlaybackTime = playToEnd ? endTime : newPlaybackTime
        
        var playbackProgressInRange: Double = 0
        if let rangeStartTime = playbackRangeStartTime, let rangeEndTime = playbackRangeEndTime {
            playbackProgressInRange = ((newPlaybackTime - rangeStartTime) / (rangeEndTime - rangeStartTime)).clamped()
        }
        
        state = state.copyWith(currentPlaybackTime: newPlaybackTime, playbackProgressInRange: playbackProgressInRange, updateAction: .playback)
        
        if playToEnd {
            pause()
        }
    }
    
    func pause() {
        guard state.isPlaying else { return }
        print("[AudioServiceImpl] pause")
        state = state.copyWith(isPlaying: false, updateAction: .playPause)
        
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        if let rangeStartTime = playbackRangeStartTime {
            state = state.copyWith(
                currentPlaybackTime: rangeStartTime,
                playbackProgressInRange: 0,
                updateAction: .reset
            )
        }
    }
    
    func seek(withRatio ratio: Double, source: SeekActionSource) {
        guard let config = audioConfig else { return }
        
        let newPlaybackTime = Double(config.totalTrackLength) * ratio
        playbackRangeStartTime = newPlaybackTime
        playbackRangeEndTime = newPlaybackTime + config.playRangeDuration
        
        let playbackRange = PlaybackRange.from(startTime: playbackRangeStartTime, endTime: playbackRangeEndTime)
        
        state = state.copyWith(
            currentPlaybackTime: newPlaybackTime,            
            playbackProgressInRange: 0,
            playbackRange: playbackRange,
            updateAction: .seek,
            seekActionSource: source,
        )
    }
    
    func setupConfig(_ config: AudioConfig) {
        audioConfig = config
        playbackRangeStartTime = 0
        playbackRangeEndTime = config.playRangeDuration
        
        let playbackRange = PlaybackRange.from(startTime: playbackRangeStartTime, endTime: playbackRangeEndTime)
        state = state.copyWith(
            playbackEndTime: Double(config.totalTrackLength),
            playbackRange: playbackRange,
            updateAction: .setup
        )
    }
}
