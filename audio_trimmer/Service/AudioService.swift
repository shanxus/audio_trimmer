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
        
        let endTime = min(trackLength, state.playbackRange.endTime)
        
        let playToEnd = newPlaybackTime >= endTime
        newPlaybackTime = playToEnd ? endTime : newPlaybackTime
        
        var playbackProgressInRange: Double = 0
        
        let rangeStartTime = state.playbackRange.startTime
        let rangeEndTime = state.playbackRange.endTime
        playbackProgressInRange = ((newPlaybackTime - rangeStartTime) / (rangeEndTime - rangeStartTime)).clamped()
        
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
        state = state.copyWith(
            currentPlaybackTime: state.playbackRange.startTime,
            playbackProgressInRange: 0,
            updateAction: .reset
        )
    }
    
    func seek(withRatio ratio: Double, source: SeekActionSource) {
        guard let config = audioConfig else { return }
        
        let newPlaybackTime = Double(config.totalTrackLength) * ratio
        let newPlaybackRangeStartTime = newPlaybackTime
        let newPlaybackRangeEndTime = newPlaybackTime + config.playRangeDuration
        
        let playbackRange = PlaybackRange.from(startTime: newPlaybackRangeStartTime, endTime: newPlaybackRangeEndTime)
        
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
        let newPlaybackRangeStartTime: Double = 0
        let newPlaybackRangeEndTime = config.playRangeDuration
        
        let playbackRange = PlaybackRange.from(startTime: newPlaybackRangeStartTime, endTime: newPlaybackRangeEndTime)
        state = state.copyWith(
            playbackEndTime: Double(config.totalTrackLength),
            playbackRange: playbackRange,
            updateAction: .setup
        )
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
