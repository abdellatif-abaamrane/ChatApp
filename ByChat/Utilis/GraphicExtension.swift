//
//  GraphicExtension.swift
//  Uber
//
//  Created by macbook-pro on 22/05/2020.
//

import UIKit

extension CGMutablePath {
    func catmullRomInterpolatedPoints( points: [CGPoint], closed: Bool, alpha: CGFloat) {
        guard points.count > 3 else { return }
        assert(alpha >= 0 && alpha <= 1.0, "Alpha must be between 0 and 1")
        
        let endIndex = closed ? points.count : points.count - 2
        
        let startIndex = closed ? 0 : 1
        
        let kEPSILON: CGFloat = 1.0e-5
        
        move(to: points[startIndex])
        
        for index in startIndex ..< endIndex {
            let nextIndex = (index + 1) % points.count
            let nextNextIndex = (nextIndex + 1) % points.count
            let previousIndex = index < 1 ? points.count - 1 : index - 1
            
            let point0 = points[previousIndex]
            let point1 = points[index]
            let point2 = points[nextIndex]
            let point3 = points[nextNextIndex]
            
            let d1 = hypot(CGFloat(point1.x - point0.x), CGFloat(point1.y - point0.y))
            let d2 = hypot(CGFloat(point2.x - point1.x), CGFloat(point2.y - point1.y))
            let d3 = hypot(CGFloat(point3.x - point2.x), CGFloat(point3.y - point2.y))
            
            let d1a2 = pow(d1, alpha * 2)
            let d1a  = pow(d1, alpha)
            let d2a2 = pow(d2, alpha * 2)
            let d2a  = pow(d2, alpha)
            let d3a2 = pow(d3, alpha * 2)
            let d3a  = pow(d3, alpha)
            
            var controlPoint1: CGPoint, controlPoint2: CGPoint
            
            if abs(d1) < kEPSILON {
                controlPoint1 = point2
            } else {
                controlPoint1 = (point2 * d1a2 - point0 * d2a2 + point1 * (2 * d1a2 + 3 * d1a * d2a + d2a2)) / (3 * d1a * (d1a + d2a))
            }
            
            if abs(d3) < kEPSILON {
                controlPoint2 = point2
            } else {
                controlPoint2 = (point1 * d3a2 - point3 * d2a2 + point2 * (2 * d3a2 + 3 * d3a * d2a + d2a2)) / (3 * d3a * (d3a + d2a))
            }
            
            addCurve(to: point2, control1: controlPoint1, control2: controlPoint2)
                if closed { closeSubpath() }
        }
        
    }
}
func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x * rhs, y: lhs.y * CGFloat(rhs))
}

func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x / rhs, y: lhs.y / CGFloat(rhs))
}

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
