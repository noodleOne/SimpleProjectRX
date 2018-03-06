//
//  AnimatedCircleProgressBar.swift
//  SimpleProjectRX
//
//  Created by Hai Vo L. on 3/5/18.
//  Copyright © 2018 Hai Vo L. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}

class AnimatedCircleProgressBar: UIViewController, URLSessionDownloadDelegate {

    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!

    let percentTargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()

    // xử lý khi app foreground
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeGround), name: .UIApplicationWillEnterForeground, object: nil)
    }

    @objc private func handleEnterForeGround() {
        animatePulsatingLayer()
    }

    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 10
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        return layer
    }

    fileprivate func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)

        animatePulsatingLayer()

        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)

        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
    }

    fileprivate func setupPercentageLabel() {
        view.addSubview(percentTargeLabel)
        percentTargeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentTargeLabel.center = view.center
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Animated Circle Progress Bar"
        view.backgroundColor = UIColor.backgroundColor
        setupNotificationObservers()
        setupCircleLayers()
        setupPercentageLabel()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // làm rung động thở ra thở vô
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }


    func handleTap() {
        //animateCircle()
        beginDownloadFile()
    }

    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2

        // nhìn thấy trạng thái cuối cùng của animation
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false

        shapeLayer.add(basicAnimation, forKey: "urlSoBasic")
    }

    fileprivate func beginDownloadFile() {
        print("begin download")
        let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
        shapeLayer.strokeEnd = 0
        let configuration = URLSessionConfiguration.default
        let operation = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operation)
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(percentage)
        DispatchQueue.main.async {
            self.percentTargeLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = CGFloat(percentage)
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finish download ")
    }
}