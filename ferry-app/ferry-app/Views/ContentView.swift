//
//  ContentView.swift
//  ferry-app
//
//  Created by Sydnee Stanley on 11/2/19.
//  Copyright © 2019 Sydnee Stanley. All rights reserved.
//

import SwiftUI

struct ContentView: View {  
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      MapView().edgesIgnoringSafeArea(.all)
      InfoView().frame(height: 400) // TODO(ss)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}

struct InfoView: View {
  
  @ObservedObject var viewModel = TimetablesViewModel()
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Departures")
        .font(.title)
      Text(viewModel.directionTitle)
        .font(.subheadline)
        .padding(.bottom)
      
      List() {
        ForEach(viewModel.ferries) { ferry in
          VStack(alignment: .leading) {
            FerryRow(ferry, color: .green)
              .padding(.bottom, 5)
            // TODO(ss): turn this into a horizontal thing
            HStack {
              Departure(ferry.departureTimes.first ?? "", state: .unavailable)
              Departure()
              Departure()
            }
            .padding(.leading)
          }
          .padding(.bottom, 5)
        }
      }
    }
    .padding()
    .background(Color.white)
  }
}

struct FerryRow: View {
  var body: some View {
    HStack {
      FerryIcon(ferry.name, color: color)
      Text("🚲 \(ferry.timeToStartPointString)") // TODO(ss): ferry.estimatedTravelTime
      Spacer()
      LockUp(ferry, color: color)
    }
  }
  
  var ferry: FerryViewModel
  var color: Color
  
  init(_ ferry: FerryViewModel, color: Color = .black) {
    self.ferry = ferry
    self.color = color
  }
}

struct FerryIcon: View {
  var body: some View {
    Text(text)
      .font(.headline)
      .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
      .foregroundColor(.white)
      .background(color)
      .cornerRadius(8)
  }
  
  var text: String
  var color: Color
  
  init(_ text: String, color: Color = .black) {
    self.text = text
    self.color = color
  }
}

struct LockUp: View {
  var body: some View {
    VStack(alignment: .trailing, spacing: -5, content: {
      HStack {
        Text(ferry.startPointName)
          .font(.subheadline)
        Circle()
          .fill(color)
          .frame(width: 10, height: 10)
      }
      Rectangle()
        .fill(color)
        .frame(width: 2, height: 15).padding(.trailing, 4)
      HStack {
        Text(ferry.endPointName)
          .font(.subheadline)
        Circle()
          .fill(color)
          .frame(width: 10, height: 10)
      }
    })
  }
  
  var ferry: FerryViewModel
  var color: Color
  
  init(_ ferry: FerryViewModel, color: Color) {
    self.ferry = ferry
    self.color = color
  }
}

struct Departure: View {
  
  enum State {
    case available
    case unavailable
  }
  
  var body: some View {
    VStack {
      Text(time)
        .bold()
        .foregroundColor(textColor)
      Text("in 2 min")
        .font(.subheadline)
        .foregroundColor(textColor)
    }
    .padding()
    .background(backgroundColor)
    .cornerRadius(8)
  }
  
  var time: String
  var state: State
  
  var backgroundColor: Color {
    switch state {
    case .available:
      return .gray
    case .unavailable:
      return Color.gray.opacity(0.5)
    }
  }
  
  var textColor: Color {
    switch state {
    case .available:
      return .white
    case .unavailable:
      return Color.white.opacity(0.5)
    }
  }
  
  init(_ time: String = "00:00", state: State = .available) {
    self.time = time
    self.state = state
  }
}
