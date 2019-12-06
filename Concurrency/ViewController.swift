//
//  ViewController.swift
//  Concurrency
//
//  Created by Alex Paul on 12/5/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var planetImageView: UIImageView!
  @IBOutlet weak var explanationLabel: UILabel!
  
  let imageURLString = "https://apod.nasa.gov/apod/image/1912/NGC6744_FinalLiuYuhang.jpg"
  
  
  let str = """
  Explanation: Beautiful spiral galaxy NGC 6744 is nearly 175,000 light-years across, larger than our own Milky Way. It lies some 30 million light-years distant in the southern constellation Pavo and appears as only a faint, extended object in small telescopes. We see the disk of the nearby island universe tilted towards our line of sight in this remarkably detailed galaxy portrait, a telescopic view that spans an area about the angular size of a full moon. In it, the giant galaxy's elongated yellowish core is dominated by the light from old, cool stars. Beyond the core, grand spiral arms are filled with young blue star clusters and speckled with pinkish star forming regions. An extended arm sweeps past a smaller satellite galaxy (NGC 6744A) at the lower right. NGC 6744's galactic companion is reminiscent of the Milky Way's satellite galaxy the Large Magellanic Cloud.
  """

  override func viewDidLoad() {
    super.viewDidLoad()
    if Thread.isMainThread {
      print("on the main thread")
    }
    explanationLabel.text = str
  }
  
  @IBAction func loadImage(_ sender: UIBarButtonItem) {
    
    // disable the load button so the user does not make multiple network requests
    sender.isEnabled = false
    
    guard let url = URL(string: imageURLString) else {
      fatalError("bad url \(imageURLString)")
    }
    
    // NOT CONCURRENT - BLOCKS THE MAIN THREAD - USER IS NOT ABLE
    // TO SCROLL AS IMAGE IS LOADING
//    do {
//      // querying the url online resource and downloading to a Data object
//      // anytime you are querying an online source DO NOT use
//      // Data(contentOf:), use URLSession() instead
//
//
//      let imageData = try Data(contentsOf: url)
//      let image = UIImage(data: imageData)
//      planetImageView.image = image
//    } catch {
//      print("loading contents error: \(error)")
//    }
    
    // disptach to a gloabl queue - get off the main thread
    DispatchQueue.global().async {
      // data processing off the main-thread
      do {
        let imageData = try Data(contentsOf: url)
        let image = UIImage(data: imageData)
        
        // we have the image converted from data
        // now we need to update the UI
        DispatchQueue.main.async {
          self.planetImageView.image = image
          sender.isEnabled = true // re-enable the load button
        }
      } catch {
        print("contents of error: \(error)")
      }
    }
    
    
    
  }

}

