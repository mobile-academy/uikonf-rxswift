//
// Created by Maciej Oczko on 10.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

typealias FilterChangeCallback = (FlightsFilter?) -> Void

final class FlightsFilterViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var closeBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: nil, action: nil)
    private lazy var resetBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: nil, action: nil)
    private lazy var applyBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: nil, action: nil)

    private var flightsFilterView: FlightsFilterViewType {
        guard let view = self.view as? FlightsFilterViewType else { fatalError("Invalid view type!") }
        return view
    }

    private let filterChange: FilterChangeCallback
    private let dismissViewController: () -> Void

    init(filterChange: @escaping FilterChangeCallback, dismissViewController: @escaping () -> Void) {
        self.filterChange = filterChange
        self.dismissViewController = dismissViewController
        super.init(nibName: nil, bundle: nil)
        title = "Flights Filter"
    }

    required init?(coder _: NSCoder) {
        fatalError("😢")
    }

    override func loadView() {
        view = FlightsFilterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItems = [applyBarButtonItem, resetBarButtonItem]

        configureFiltering()
        configureDismissing()
    }

    private func configureDismissing() {
        // TODO: 1: Write dismissing logic for every bar button item in the reactive way
        // HINT 1: Look at UIBarButtonItem+Rx.swift to find out how to detect taps using reactive API
        // HINT 2: Remember about `asObservable()` operator on `ControlProperty` to treat it as Observable
        // HINT 3: Use `merge` operator
        // HINT 4: Remember about disposing

        Observable.merge(
            closeBarButtonItem.rx.tap.asObservable(),
            applyBarButtonItem.rx.tap.asObservable(),
            resetBarButtonItem.rx.tap.asObservable()
        )
        .subscribe(onNext: dismissViewController)
        .disposed(by: disposeBag)
    }

    private func configureFiltering() {
        // TODO: 3: Write logic that combines fromDate and toDate from view into `FlightsFilter`,
        // and applies it to `filterChange` ONLY when apply bur button item is pressed.

        // HINT 1: Use `combineLatest` operator
        // HINT 2: Use `sample` operator

        Observable.combineLatest(
            flightsFilterView.fromDateStringObservable,
            flightsFilterView.toDateStringObservable,
            resultSelector: { from, to in FlightsFilter(fromDate: from, toDate: to) }
        )
        .sample(applyBarButtonItem.rx.tap.asObservable())
        .subscribe(onNext: filterChange)
        .disposed(by: disposeBag)

        // TODO: 4: Write logic that changes filter to `nil`, i.e. puts `nil` to `filterChanges` as parameter
        // when reset bar button item is tapped

        resetBarButtonItem.rx.tap
            .map { _ in nil }
            .subscribe(onNext: filterChange)
            .disposed(by: disposeBag)
    }
}
