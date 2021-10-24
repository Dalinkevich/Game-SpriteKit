//
//  Utils.swift
//  SpriteKitTest
//
//  Created by Роман далинкевич on 22.10.2021.
//

import Foundation
import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
