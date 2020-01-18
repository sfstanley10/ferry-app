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
      
      List(viewModel.ferries) { ferry in
        VStack(alignment: .leading) {
          FerryListItem(ferry, color: .green)
        }
        .padding(.bottom, 5)
      }
    }
    .padding()
    .background(Color.white)
  }
}

struct FerryListItem: View {
  
  @ObservedObject var ferry: FerryViewModel
  var color: Color
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        FerryIcon(ferry.name, color: color)
        Text("🚲 \(ferry.timeToStartPointString)")
        Spacer()
        LockUp(ferry, color: color)
      }
      HStack { // TODO(ss): convert to list and make sure it scrolls
        ForEach(ferry.departures) { departure in
          Departure(departure)
        }
      }
      .padding(.leading)
    }
  }
  
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
  
  @ObservedObject var ferry: FerryViewModel
  var color: Color
  
  init(_ ferry: FerryViewModel, color: Color) {
    self.ferry = ferry
    self.color = color
  }
}

struct Departure: View {
  
  @ObservedObject var viewModel: DepartureViewModel
  
  var body: some View {
    VStack {
      Text(viewModel.timeString)
        .bold()
        .foregroundColor(viewModel.textColor)
      Text(viewModel.countdownString)
        .font(.subheadline)
        .foregroundColor(viewModel.textColor)
    }
    .padding()
    .background(viewModel.backgroundColor)
    .cornerRadius(8)
  }
    
  init(_ viewModel: DepartureViewModel) {
    self.viewModel = viewModel
  }
}
