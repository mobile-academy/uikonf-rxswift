//
// Created by Krzysztof Siejkowski on 03/05/2017.
// Copyright (c) 2017 Mobile Academy. All rights reserved.
//

import Foundation

func shouldBeFakedByTheTimeWeCheck<A>() -> A {
    return { fatalError() }()
}