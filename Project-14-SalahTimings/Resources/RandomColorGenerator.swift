//
//  RandomColorGenerator.swift
//  Project-14-SalahTimings
//
//  Created by suhail on 20/01/24.
//

import Foundation
import UIKit

func generateRandomColor() -> UIColor {
let redValue = CGFloat(drand48())
let greenValue = CGFloat(drand48())
let blueValue = CGFloat(drand48())

let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)

return randomColor
}
