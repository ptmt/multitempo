//
//  TempoScreen.swift
//  Multitempo WatchKit Extension
//
//  Created by Dmitriy Loktev on 17.04.2021.
//

import Foundation

import SwiftUI

struct TempoScreenView: View {
//    @State var minutes: Int = 0
//    @State var seconds: Int = 5
    @State var timeInterval: TimeInterval = 5.0
    @State var editing: Bool = false
    @State var started: Bool = false
    @State var numberOfPlays: Int = 0
    
    var body: some View {
        VStack {
            Text("Laps: \(numberOfPlays)")
            Text("\(timeInterval.asTimer())")
                    .font(.system(.title, design: .monospaced))
                    .padding()
            if (!started) {
                if (editing) {
                    VStack {
                        Button("+", action: {
                            timeInterval = timeInterval + 1
                        })
                        Button("-", action: {
                            timeInterval = timeInterval - 1
                        })
                    }
                } else {
                    Button("Edit", action: {
                        editing = true
                    })
                }
            }
            
            if (started) {
                Button("Stop", action: {
                    stop()
                }).foregroundColor(Color.red)
            } else {
                Button("Start", action: {
                    start()
                })
            }
        }
    }
    
    func start() {
        numberOfPlays = 0
        editing = false
        started = true
        scheduleTick()
    }
    
    
    func scheduleTick() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // vibrate
            let ended = timeInterval == 1
            timeInterval = ended ? 5 : timeInterval - 1
            if (ended) {
                // vibrate
                WKInterfaceDevice.current().play(.success)
                numberOfPlays = numberOfPlays + 1
            }
            if (started) {
                scheduleTick()
            }
        }
    }
    
    func stop() {
        started = false
    }
}

extension Double {
  func asTimer() -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.collapsesLargestUnit = false
    formatter.zeroFormattingBehavior = .pad
    formatter.unitsStyle = .positional
    guard let formattedString = formatter.string(from: self) else { return "" }
    return formattedString
  }
}

struct TempoScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TempoScreenView()
            TempoScreenView(started: true)
        }
    }
}
