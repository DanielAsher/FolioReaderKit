//
//  SKControllerOperations.swift
//  AlienPhonicsSpriteKit
//
//  Created by GEORGE QUENTIN on 26/02/2016.
//  Copyright © 2016 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension SKNode {
    
    public func randomColorRepeatActionForever(shape:SKNode,longevity: NSTimeInterval)
    {
        let color = 
            UIColor(red: CGFloat.random(0.0,maxi: 1.0), green: CGFloat.random(0.0, maxi: 1.0), blue: CGFloat.random(0.0,maxi: 1.0), alpha: 1)
        let colorize = 
            SKAction.colorizeWithColor(color, colorBlendFactor: 1, duration: longevity)
        
        shape.runAction(SKAction.repeatActionForever(colorize))
    }
    
    public func createCircle (radius: CGFloat, position: CGPoint, color: UIColor) -> SKNode {
        
        let circleShape = SKShapeNode(circleOfRadius: radius);
        circleShape.fillColor = color
        circleShape.lineWidth = 1
        circleShape.position = position
        //self.addChild(circleShape);
        
        return circleShape
        
    }
    public func circle (radius: CGFloat, position: CGPoint, color: UIColor) -> SKNode {
        
        let c = SKShapeNode()
        
        let myPath = CGPathCreateMutable()
        CGPathAddArc(myPath, nil, 0, 0, radius, 0, CGFloat(M_PI * 2), true)
        c.path = myPath;
        
        c.fillColor = color
        c.position = position
        
        return c
        
    }
    
    public func createRect (anchorPoint: CGPoint, width: CGFloat, height:CGFloat,position: CGPoint, color: UIColor) -> SKNode {
        
        let rect = CGRect(x: anchorPoint.x, y: anchorPoint.y, width: width, height: height)
        let path = CGPathCreateWithRect(rect, nil)
        let shape = SKShapeNode(path: path, centered: true)
        shape.fillColor = color
        shape.lineWidth = 1
        shape.position = position
        //self.addChild(rect);
        return shape
        
    }
    public func createRoundedRect (width: CGFloat, height:CGFloat, position: CGPoint, color: UIColor, curve:CGFloat) -> SKNode
    {
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: -width/2, y: -height/2, width: width, height: height), cornerRadius: curve).CGPath
        shape.position = position
        shape.fillColor = color
        shape.strokeColor = UIColor.blackColor()
        shape.lineWidth = 10
        //self.addChild(shape)
        
        return shape
    }
    public func addChildWithBlur (node:SKNode) -> SKNode
    {
        let effect : SKEffectNode = SKEffectNode()
    
        effect.filter =  addFilter()
        effect.addChild(node)
        self.addChild(effect) 
         
        return node
    }
    public func addFilter() -> CIFilter? {
        
        guard let filter = CIFilter(name:"CIGaussianBlur") else {return nil }//CIBoxBlur 
        filter.setDefaults()
        filter.setValue(10, forKey: "inputRadius")
        return filter
    }

    
}
extension CGPath {
    
    public static func drawPath (type:String,path: UIBezierPath,sP:CGPoint,eP:CGPoint, cP:CGPoint) -> CGPath
    {
        
        path.removeAllPoints()
        path.moveToPoint(sP)
        
        if type == "line"{
            path.addLineToPoint(eP)
        }else if type == "curve"
        {
            let t = Double(0.5) 
            let x1 = pow(1.0 - t, 2.0) * Double(sP.x) 
            let x2 = 2.0 * (1.0 - t) * t * Double(cP.x) 
            let x3 = pow(t, 2.0) * Double(eP.x) 
            let x = x1 + x2 + x3
            let y1 = pow(1.0 - t, 2.0) * Double(sP.y) 
            let y2 = 2.0 * (1.0 - t) * t * Double(cP.y) 
            let y3 = pow(t, 2.0) * Double(eP.y)
            let y = y1 + y2 + y3
            
            path.addQuadCurveToPoint(eP, controlPoint:CGPoint(x: x, y: y))
        }
        return path.CGPath
        
    }
}