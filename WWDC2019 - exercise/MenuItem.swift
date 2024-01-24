//
//  MenuItem.swift
//  WWDC2019 - exercise
//
//  Created by Kanghos on 2024/01/23.
//

import Foundation

struct MenuItem: Codable {
  let highResolutionURL: URL
  let lowResolutionURL: URL
  let title: String
  let subTitle: String
}

extension Array where Array.Element == MenuItem {
  static func testData() -> Array {
    [
      MenuItem(highResolutionURL: URL(string: "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&h=130")!,
               lowResolutionURL: URL(string: "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
               )!,
               title: "BrownRocks During Golden Hour",
               subTitle: "Deden Dicky Ramdhani"),
      MenuItem(highResolutionURL: URL(string: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=130")!,
               lowResolutionURL: URL(string: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
               )!,
               title: "BrownRocks During Golden Hour",
               subTitle: "Deden Dicky Ramdhani"),
      MenuItem(highResolutionURL: URL(string: "https://images.pexels.com/photos/2061057/pexels-photo-2061057.jpeg?auto=compress&cs=tinysrgb&h=130")!,
               lowResolutionURL: URL(string: "https://images.pexels.com/photos/2061057/pexels-photo-2061057.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
               )!,
               title: "BrownRocks During Golden Hour",
               subTitle: "Deden Dicky Ramdhani"),
    ]
  }
}
