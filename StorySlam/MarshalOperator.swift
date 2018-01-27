//
//  MarshalOperator.swift
//  StorySlam
//
//  Created by Mark Keller on 7/29/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation

infix operator ~> {}

private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)

func ~> (
    backgroundClosure: () -> (),
    mainClosure: () -> ()
)
{
    dispatch_async(queue) {
        backgroundClosure()
        dispatch_async(dispatch_get_main_queue(), mainClosure)
    }
}

func ~> <R>(
    backgroundClosure: () -> R,
    mainClosure: (result: R) -> ()
    )
{
    dispatch_async(queue) {
        let result = backgroundClosure()
        dispatch_async(dispatch_get_main_queue(),{ mainClosure(result: result)})
    }
}

