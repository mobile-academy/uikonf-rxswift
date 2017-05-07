//
// Created by Maciej Oczko on 10.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

protocol FlightsFilterViewType {
    var fromDateStringObservable: Observable<String?> { get }
    var toDateStringObservable: Observable<String?> { get }
}

final class FlightsFilterView: UIView, FlightsFilterViewType {

    private lazy var fromDateInputView = DateInputView(title: "From date:")
    var fromDateStringObservable: Observable<String?> { return fromDateInputView.dateStringObservable }

    private lazy var toDateInputView = DateInputView(title: "To date:")
    var toDateStringObservable: Observable<String?> { return toDateInputView.dateStringObservable }

    private lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.fromDateInputView, self.toDateInputView])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(overallStackView)
        configureConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("😢")
    }

    private func configureConstraints() {
        overallStackView.snp.makeConstraints {
            make in
            make.topMargin.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
