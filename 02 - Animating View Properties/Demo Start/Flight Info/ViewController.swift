/**
* Copyright (c) 2017 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
* distribute, sublicense, create a derivative work, and/or sell copies of the
* Software in any work that is designed, intended, or marketed for pedagogical or
* instructional purposes related to programming, coding, application development,
* or information technology.  Permission for such use, copying, modification,
* merger, publication, distribution, sublicensing, creation of derivative works,
* or sale is expressly withheld.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore


//MARK: ViewController
class ViewController: UIViewController {
  
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNr: UILabel!
  @IBOutlet var gateNr: UILabel!
  @IBOutlet var departingFrom: UILabel!
  @IBOutlet var arrivingTo: UILabel!
  @IBOutlet var planeImage: UIImageView!
  
  @IBOutlet var flightStatus: UILabel!
  @IBOutlet var statusBanner: UIImageView!
  
  var snowView: SnowView!
  
  //MARK:- animations
  func fade(
		toImage: UIImage,
		showEffects: Bool
	) {
		//TODO: Create a crossfade animation for the background
    
    // Lolita :
    // 1. create and set up temp view
    let tempView = UIImageView(frame: bgImageView.frame)
    tempView.image = toImage
    tempView.alpha = 0.0
    
    // 沒有autolayout的影響
    tempView.center.y -= 15
    tempView.bounds.size.width =  bgImageView.bounds.size.width * 1.3
    
    //    bgImageView.superview?.addSubview(tempView)
    bgImageView.superview?.insertSubview(tempView, aboveSubview: bgImageView)
    
    UIView.animate(withDuration: 0.5, animations: {
        // 2. fade the temp view on top of the background view
        tempView.alpha = 1.0
        
        tempView.center.y += 15
        tempView.bounds.size.width = self.bgImageView.bounds.size.width
    }) { (completed) in
        // 3. update the background view and remove the temp view
        self.bgImageView.image = toImage
        tempView.removeFromSuperview()
        
//        self.cubeTransition(label: self.arrivingTo, text: "London")
//        self.cubeTransition(label: self.departingFrom, text: "Taiwan")
    }
    
    
		
		//TODO: Create a fade animation for snowView
    UIView.animate(withDuration: 1.0, animations: {
        self.snowView.alpha = showEffects ? 1.0 : 0.0
    }, completion: nil)
  }
  
    func moveLabel(label: UILabel, text: String, offset: CGPoint) {
		//TODO: Animate a label's translation property
    // Lolita :
    // 1. Create & position the temp label with alpha 0.0
    let tempLabel = duplicateLabel(label: label) // tempLabel's frame和label's frame相同
    tempLabel.alpha = 0.0
    tempLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
    label.superview?.addSubview(tempLabel)
        
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
        // 2. Translate the real label down & alpha to 0.0
        label.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
        label.alpha = 0.0
        
    }) { _ in
        
    }

    UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseIn, animations: {
        // 3. Translate the temp label up & alpha to 1.0
        tempLabel.transform = .identity
        tempLabel.alpha = 1.0
    }) { _ in
        label.text = text
        label.transform = .identity //CGAffineTransform(translationX: -offset.x, y: -offset.y)
        label.alpha = 1.0
        
        tempLabel.removeFromSuperview()
    }
  }
  
    func cubeTransition(label: UILabel, text: String) {
		//TODO: Create a faux rotating cube animation
    
    // Lolita :
    // 1. Create & set up temp label
    let tempLabel = duplicateLabel(label: label)
        tempLabel.text = text
    let scale = CGAffineTransform(scaleX: 1.0, y: 0.1)
        
    let tempLabelYOffset = label.frame.size.height / 2
    let translate = CGAffineTransform(translationX: 0.0, y: tempLabelYOffset) // center會向下移動
        
    tempLabel.transform = scale.concatenating(translate)
    label.superview?.addSubview(tempLabel)
        
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
        // 2. Scale temp label up & translate it up
        tempLabel.transform = .identity
        
        // 3. Scale real label down & translate it up
        label.transform = scale.concatenating(CGAffineTransform(translationX: 0.0, y: -tempLabelYOffset))
//        label.transform = scale.concatenating(translate.inverted())
    }, completion: { _ in
        // 4. Update the real label's text and  reset its transform
        label.text = tempLabel.text
        label.transform = .identity
        
        tempLabel.removeFromSuperview()
    })
        
  }

  
  func planeDepart() {
		//TODO: Animate the plane taking off and landing
    // Lolita :
    // 1. Store the plane's center value
    let originalCenter = planeImage.center
   
    // Create a keyframe animation
    UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: {
        // 2. Move the plane to the right & up
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
            //self.planeImage.transform = CGAffineTransform(translationX: 80.0, y: -10) // 因為center有受到autolayout的constraits, 所以在動畫結束後, 飛機會回到原本的x座標點, 但因爲rotation 不受autolayout 限制, 所以角度不會回到原本的水平位置
            self.planeImage.center.x += 80.0
            self.planeImage.center.y -= 10
        })
        
        // 3. Rotate the plane : 若是作用在不同的properties, 則時間上可重疊 : e.g. 上一key animation, 改以center做動畫, 在此則對transform做動畫, 可以有時間上的重疊....
        // 角度不會回到原本的水平位置, 且多次呼叫self.planeImage.transform = CGAffineTransform(rotationAngle: -.pi/8)角度仍維持在-.pi/8
        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: {
            self.planeImage.transform = CGAffineTransform(rotationAngle: -.pi/8)
        })
        
        // 4. Move the plane right & up offscreen, fade out
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
            self.planeImage.center.x += 100.0
            self.planeImage.center.y -= 50
            
            self.planeImage.alpha = 0.0
        })
        
        // 5. Move the plane off left side of screen, reset transform & height
        UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01, animations: {
            self.planeImage.center.x = 0
            self.planeImage.center.y = originalCenter.y
            
            self.planeImage.transform = .identity
        })
        
        // 6. Move the place back to the original position & fade in
        UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
            self.planeImage.center.x = originalCenter.x
            self.planeImage.center.y = originalCenter.y
            
            self.planeImage.alpha = 1.0
        })
        
    }, completion: { _ in
        
    });
  }
  
  func changeSummary(to summaryText: String) {
		//TODO: Animate the summary text
		
//    let tempLabel = duplicateLabel(label: summary)
//    tempLabel.text = summaryText
//    summary.superview?.addSubview(tempLabel)

    UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.45, animations: {
            self.summary.center.y -= 100
//            self.summary.alpha = 0.0
        })
        
//        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
//            self.summary.text = summaryText
//        })
        
//        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
//            tempLabel.center.y -= 150
//            tempLabel.alpha = 0.0
//        })
        
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.45, animations: {
            self.summary.center.y += 100
//            self.summary.alpha = 1.0
        })
    }, completion: { _ in
//        tempLabel.removeFromSuperview()
    })
    
    // Lolita : 這是為了精準的計時, label offscreen 計算變更文字的時間?
    delay(seconds: 0.5) {
      self.summary.text = summaryText
    }
  }

  
  //MARK:- custom methods
  
  func changeFlight(to data: FlightData, animated: Bool = false) {
		// populate the UI with the next flight's data
		flightNr.text = data.flightNr
		gateNr.text = data.gateNr
		
		if animated {
			//TODO: Call your animation
            self.fade(toImage: UIImage(named: data.weatherImageName)! , showEffects: data.showWeatherEffects)
            
            let offset = CGPoint(x: -80, y: -10.0)
            moveLabel(label: departingFrom, text: data.departingFrom, offset: offset)
            moveLabel(label: arrivingTo, text: data.arrivingTo, offset: offset)
            
            // Lolita : 這些動畫之間有順序性嗎?同時啟動的嗎?之後各自的週期呢?
            cubeTransition(label: flightStatus, text: data.flightStatus)
            planeDepart()
            changeSummary(to: data.summary)
		} else {
			bgImageView.image = UIImage(named: data.weatherImageName)
            snowView.alpha = (data.showWeatherEffects == true) ? 1.0 : 0.0
            departingFrom.text = data.departingFrom
            arrivingTo.text = data.arrivingTo
            flightStatus.text = data.flightStatus
            summary.text = data.summary
		}
    
    // schedule next flight
    delay(seconds: 3.0) {
      self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis, animated: true)
    }
  }
  
  //MARK:- view controller methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //adjust UI
    summary.addSubview(summaryIcon)
    summaryIcon.center.y = summary.frame.size.height/2
    
    //add the snow effect layer
    snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
    let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
    
    //start rotating the flights
    changeFlight(to: londonToParis, animated: false)
  }

  
  //MARK:- utility methods
  func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
  }
  
  func duplicateLabel(label: UILabel) -> UILabel {
    let newLabel = UILabel(frame: label.frame)
    newLabel.font = label.font
    newLabel.textAlignment = label.textAlignment
    newLabel.textColor = label.textColor
    newLabel.backgroundColor = label.backgroundColor
    return newLabel
  }
}
