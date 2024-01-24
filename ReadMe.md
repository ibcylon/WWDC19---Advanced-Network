# LowData Mode 및 URLSessionPublisher 사용 예제
| Non Constrained Network | Low Data mode |
|---|---|
|<img src="https://github.com/ibcylon/WWDC19---Advanced-Network/assets/25360781/7c9a4f70-0733-4a75-baef-0184b0897a6e" alt="drawing" width="200"/>|<img src="https://github.com/ibcylon/WWDC19---Advanced-Network/assets/25360781/0fd0f1a2-c914-402a-99ca-bdc63c2252df" alt="drawing1" width="200"/>|
|---|---|

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
