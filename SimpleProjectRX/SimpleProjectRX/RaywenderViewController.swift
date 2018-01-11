//
//  SearchViewController.swift
//  SimpleProjectRX
//
//  Created by Hai Vo L. on 1/2/18.
//  Copyright © 2018 Hai Vo L. All rights reserved.
//

import UIKit

final class RaywenderViewController: UIViewController {

    // MARK: - IBoutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Dummy Data
    fileprivate enum Demo: Int {
        case DesignPattern
    }

    fileprivate let dummyDatas: [String] = [
        "Design Patterns"
        ]

    // MARK: - private func
    fileprivate func controllerDemo(demo: Demo) -> UIViewController {
        let vc: UIViewController!
        switch demo {
        case .DesignPattern:
            vc = DesignPatternViewController()
            return vc
        }
    }


    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self

    }

}

// MARK: - UITableViewDelegate
extension RaywenderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dummyDatas[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RaywenderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let demo = Demo(rawValue: indexPath.row) else { return }
        let controller = controllerDemo(demo: demo)
        navigationController?.pushViewController(controller, animated: true)
    }
}