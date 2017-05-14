//
// Created by Maciej Oczko on 11.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DateInputView: UIView {
    lazy var titleLabel = UILabel()
    lazy var yearInputView = TitleValueInputView(label: "Year")
    lazy var monthInputView = TitleValueInputView(label: "Month")
    lazy var dayInputView = TitleValueInputView(label: "Day")

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.yearInputView,
            self.monthInputView,
            self.dayInputView,
        ])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    var dateStringObservable: Observable<String?> {
        // TODO: 2: Write code that combines text from inputs into one date string (e.g. "2017-05-10").
        // Requirement: When one of the elements is empty, `nil` should be passed over.
        // Year, month and day strings are required to build valid date string (e.g. "2017-05-10").
        //
        // HINT 1: Look at UITextField+Rx.swift to find out how to detect text change using reactive API
        // HINT 2: Default reactive API returns `String?`; to return always `String` (empty if nil), chain it with `orEmpty` operator
        // HINT 3: Remember about `asObservable()` operator on `ControlProperty` to treat it as Observable
        // HINT 4: Use `combineLatest` operator

        return Observable.combineLatest(
            yearInputView.inputField.rx.text.orEmpty.asObservable(),
            monthInputView.inputField.rx.text.orEmpty.asObservable(),
            dayInputView.inputField.rx.text.orEmpty.asObservable(),
            resultSelector: {
                year, month, day in
                guard !year.isEmpty, !month.isEmpty, !day.isEmpty else { return nil }
                return "\(year)-\(month)-\(day)"
        })
    }

    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .white
        titleLabel.text = title
        addSubview(titleLabel)
        addSubview(dateStackView)
        configureConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("😢")
    }

    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            make in
            make.leading.top.trailing.equalToSuperview()
        }
        dateStackView.snp.makeConstraints {
            make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}
