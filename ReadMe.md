# WWDC19 Demo Repository
* LowData mode exercise with URLSession Publisher 프로젝트
* WebSocket Client with URLSessionWebSocketTask 프로젝트
* WebSocket Server with Network WebSocket 프로젝트

## LowData Mode 및 URLSessionPublisher 사용 예제
| Non Constrained Network | Low Data mode |
|---|---|
|<img src="https://github.com/ibcylon/WWDC19---Advanced-Network/assets/25360781/7c9a4f70-0733-4a75-baef-0184b0897a6e" alt="drawing" width="200"/>|<img src="https://github.com/ibcylon/WWDC19---Advanced-Network/assets/25360781/0fd0f1a2-c914-402a-99ca-bdc63c2252df" alt="drawing1" width="200"/>|

### ImageLodaer publisher
```swift
func adaptiveLoader(session: URLSession = .shared, regularURL: URL, lowDataURL: URL) -> AnyPublisher<Data, Error> {
    var request = URLRequest(url: regularURL)
    request.allowsConstrainedNetworkAccess = false
    return session.dataTaskPublisher(for: request)
      .tryCatch { error -> URLSession.DataTaskPublisher in
        guard error.networkUnavailableReason == .constrained else {
          throw error
        }
        return session.dataTaskPublisher(for: lowDataURL)
      }
      .tryMap { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw CustomError.invalidserverResponse
        }
        return data
      }
      .eraseToAnyPublisher()
  }
```
## WebSocket
<img width="500" alt="example" src="https://github.com/ibcylon/WWDC19---Advanced-Network/assets/25360781/1c951e74-c187-45fd-a72a-b8f0ab2b80fb">

```swift
// NativeClient.swift
func readMessage() {
 guard let task = self.webSocketTask else { return }
 task.receive { result in
   switch result {
   case .success(.data(let data)):
     self.delegate?.onMessage(connection: self, data: data)
     self.readMessage()
   default:
     self.disconnect()
   }
 }
}

func send(_ message: MessageDTO) {
 if let data = try? JSONEncoder().encode(message) {
   webSocketTask?.send(.data(data), completionHandler: { error in
     if let error = error {
       self.delegate?.onError(connection: self, error: error)
     }
   })
 }
}
```

