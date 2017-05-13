//
// Created by Maciej Oczko on 10.05.2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class TitleValueInputView: UIView {
    lazy var inputLabel: UILabel = UILabel()
    lazy var inputField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 4
        return textField
    }()

    init(label: String) {
        super.init(frame: .zero)
        inputLabel.text = label
        addSubview(inputLabel)
        addSubview(inputField)
        configureConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("😢")
    }

    private func configureConstraints() {
        snp.makeConstraints {
            make in make.width.greaterThanOrEqualTo(50)
        }
        inputLabel.snp.makeConstraints {
            make in
            make.left.top.right.equalToSuperview()
        }
        inputField.snp.makeConstraints {
            make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(inputLabel).offset(20)
        }
    }
}
