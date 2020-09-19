//
//  MenuCenter.swift
//  RedditX
//
//  Created by Gina Mullins on 9/19/20.
//

import UIKit

struct MenuCenter {
    var startCenter: CGPoint
    var endCenter: CGPoint
    
    var isAtStartPos: Bool = true
    
    public init(startCenter: CGPoint, endCenter: CGPoint) {
        self.startCenter = startCenter
        self.endCenter = endCenter
    }
}
