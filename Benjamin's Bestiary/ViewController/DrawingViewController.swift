import UIKit
import CoreGraphics
import SwiftUI

// MARK: - Custom Error Type

/// Validation errors for the parental gate circle-drawing challenge.
enum ParentalGateError: Error {
    case notEnoughPoints
    case shapeNotClosed
    case notCircular
}

// MARK: - Custom UIGestureRecognizer Subclass

/// A gesture recognizer that tracks a finger drawing path and validates it as a circle.
/// Overrides touchesBegan, touchesMoved, and touchesEnded as required by the spec.
class CircleDrawingGestureRecognizer: UIGestureRecognizer {

    /// Collected touch points
    private(set) var points = [CGPoint]()

    /// Configurable validation thresholds
    var minPoints: Int = 20
    var maxClosingDistance: CGFloat = 100
    var circularityTolerance: CGFloat = 0.35

    /// Callback fired on every touchesMoved so the view controller can draw the stroke
    var onPointAdded: ((_ from: CGPoint, _ to: CGPoint) -> Void)?

    private var lastPoint: CGPoint = .zero

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        points.removeAll()
        if let touch = touches.first {
            lastPoint = touch.location(in: view)
            points.append(lastPoint)
        }
        state = .began
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: view)
        onPointAdded?(lastPoint, currentPoint)
        lastPoint = currentPoint
        points.append(currentPoint)
        state = .changed
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        // If the user just tapped without moving, draw a dot
        if points.count <= 1 {
            onPointAdded?(lastPoint, lastPoint)
        }
        state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = .cancelled
    }

    override func reset() {
        super.reset()
        points.removeAll()
    }

    // MARK: - Circle Validation (do-try-throw)

    /// Validate that the collected points form a circle.
    /// Uses do-try-throw with the custom ParentalGateError type.
    func validateCircle() throws {
        guard points.count >= minPoints else {
            throw ParentalGateError.notEnoughPoints
        }

        let start = points.first!
        let end = points.last!
        let closingDistance = hypot(end.x - start.x, end.y - start.y)
        guard closingDistance < maxClosingDistance else {
            throw ParentalGateError.shapeNotClosed
        }

        let sumX = points.reduce(0.0) { $0 + $1.x }
        let sumY = points.reduce(0.0) { $0 + $1.y }
        let centerX = sumX / Double(points.count)
        let centerY = sumY / Double(points.count)

        let distances = points.map { hypot($0.x - centerX, $0.y - centerY) }
        let avgRadius = distances.reduce(0.0, +) / Double(distances.count)

        let maxDeviation = avgRadius * circularityTolerance
        for distance in distances {
            if abs(distance - avgRadius) > maxDeviation {
                throw ParentalGateError.notCircular
            }
        }
    }
}

// MARK: - DrawingViewController

class DrawingViewController: UIViewController {

    var tempImageView: UIImageView!

    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0

    /// Configurable validation thresholds (passed through to the gesture recognizer)
    var minPoints: Int = 20
    var maxClosingDistance: CGFloat = 100
    var circularityTolerance: CGFloat = 0.35
    var strokeColor: UIColor = .black
    var viewBackgroundColor: UIColor = .white

    /// Callback when circle validation succeeds
    var onCircleValidated: (() -> Void)?

    private var circleRecognizer: CircleDrawingGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        tempImageView = UIImageView(frame: view.bounds)
        tempImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tempImageView.backgroundColor = .clear
        view.addSubview(tempImageView)

        // Install the custom gesture recognizer
        circleRecognizer = CircleDrawingGestureRecognizer(target: self, action: #selector(handleCircleGesture(_:)))
        circleRecognizer.minPoints = minPoints
        circleRecognizer.maxClosingDistance = maxClosingDistance
        circleRecognizer.circularityTolerance = circularityTolerance
        circleRecognizer.onPointAdded = { [weak self] from, to in
            self?.drawLineFrom(fromPoint: from, toPoint: to)
        }
        view.addGestureRecognizer(circleRecognizer)
    }

    @objc private func handleCircleGesture(_ recognizer: CircleDrawingGestureRecognizer) {
        guard recognizer.state == .ended else { return }

        do {
            try recognizer.validateCircle()
            print("Circle accepted!")
            onCircleValidated?()
        } catch ParentalGateError.notEnoughPoints {
            print("Not enough points drawn")
        } catch ParentalGateError.shapeNotClosed {
            print("Shape not closed")
        } catch ParentalGateError.notCircular {
            print("Not circular enough")
        } catch {
            print("Validation failed: \(error)")
        }

        // Clear the canvas for the next attempt
        tempImageView.image = nil
    }

    /// Draw a line segment on the canvas
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0,
                                             width: view.frame.size.width,
                                             height: view.frame.size.height))

        context!.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context!.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

        context!.setLineCap(.round)
        context!.setLineWidth(brushWidth)
        context!.setStrokeColor(strokeColor.cgColor)
        context!.setBlendMode(.normal)

        context!.strokePath()

        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
}
