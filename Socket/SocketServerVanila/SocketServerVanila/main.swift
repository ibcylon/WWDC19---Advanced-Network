//
//  main.swift
//  SocketServerVanila
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation

func initServer(port: UInt16) {
  let server = SwiftVanilaSocketServer(port: port)
  try! server.connect()
}
print("input the port: ")
guard 
  let line = readLine(),
  let argument = line.components(separatedBy: " ").first,
  let port = UInt16(argument)
else {
  fatalError("port is invalid")
}
initServer(port: port)

RunLoop.current.run()

