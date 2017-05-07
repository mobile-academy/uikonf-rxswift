//
// Created by Maciej Oczko on 03.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

final class FlightsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let formatter = FlightFormatter()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = true
        return tableView
    }()

    let viewModel: FlightsDisplayable
    private let showDetailsViewController: (Flight, UIViewController) -> Void

    init(viewModel: FlightsDisplayable, showDetailsViewController: @escaping (Flight, UIViewController) -> Void) {
        self.viewModel = viewModel
        self.showDetailsViewController = showDetailsViewController
        super.init(nibName: nil, bundle: nil)
        title = "Flights"
    }

    required init?(coder _: NSCoder) {
        fatalError("😢")
    }

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FlightCell.self, forCellReuseIdentifier: String(describing: FlightCell.self))

        let dataSource = createDataSource()
        viewModel
            .flights.asObservable()
            .map { flights -> [FlightSectionModel] in [FlightSectionModel(items: flights)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                if let flight = self.viewModel.flights.value[safe: indexPath.row] {
                    self.showDetailsViewController(flight, self)
                }
            })
            .disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refresh().disposed(by: disposeBag)
    }

    private func createDataSource() -> RxTableViewSectionedAnimatedDataSource<FlightSectionModel> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<FlightSectionModel>()
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .none, reloadAnimation: .none, deleteAnimation: .none)
        dataSource.configureCell = {
            _, tableView, indexPath, flight in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FlightCell.self), for: indexPath)
            cell.textLabel?.text = self.formatter.generalInfo(of: flight)
            cell.detailTextLabel?.text = self.formatter.details(of: flight)
            return cell
        }
        return dataSource
    }
}
