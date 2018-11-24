//
//  Delegates.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/20/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public typealias Trigger = (() -> Void)
public typealias Action<T1> = ((T1) ->  Void)

public typealias Function<T1, T2> = ((T1) -> T2)
public typealias Predicate<T1> = Function<T1, Bool>
