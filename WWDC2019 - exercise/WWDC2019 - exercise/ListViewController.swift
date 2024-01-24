//
//  ViewController.swift
//  WWDC2019 - exercise
//
//  Created by Kanghos on 2024/01/23.
//

import UIKit
import Combine

let sessionConfiguration = URLSessionConfiguration.ephemeral
let pubSession = URLSession.init(configuration: sessionConfiguration)

final class ListViewController: UIViewController {
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.id)
    tableView.dataSource = self
    return tableView
  }()

  lazy var dataArray: [MenuItem] = .testData()

  override func viewDidLoad() {
    super.viewDidLoad()



    self.view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }
}

extension ListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.id, for: indexPath) as? ImageCell
    else {
      fatalError()
    }
    let item = dataArray[indexPath.item]
    cell.bind(item)
    cell.subscriber = adaptiveLoader(
      session: pubSession,
      regularURL: item.highResolutionURL,
      lowDataURL: item.lowResolutionURL
    )
    .retry(1)
    .tryMap { data -> UIImage? in
      UIImage(data: data)
    }
    .replaceError(with: UIImage(systemName: "exclamationmark.triangle.fill"))
    .receive(on: DispatchQueue.main)
    .assign(to: \.image, on: cell)

    return cell
  }

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
}
