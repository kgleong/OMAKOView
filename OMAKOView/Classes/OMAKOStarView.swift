import UIKit

@IBDesignable
class OMAKOStarView: UIView {
    @IBInspectable var strokeWidth: CGFloat = 5
    @IBInspectable var hasStroke: Bool = false
    @IBInspectable var strokeColor: UIColor = UIColor.red

    @IBInspectable var fillColor: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.8, alpha: 1.0)

    @IBInspectable var cacheVertices: Bool = true

    /**
     Ratio of inner to outer radius.

     Higher values result in wider arms, while lower values
     result in narrower arms.
     */
    @IBInspectable var innerToOuterRadiusRatio: CGFloat = 0.45

    let π: CGFloat = CGFloat(M_PI)
    let numVertices: Int = 5

    /// 72 degrees (angle between each star's vertex) in radians
    let angleBetweenVertices: CGFloat = 2 * CGFloat(M_PI) / 5

    var outerPathPoints = [CGPoint]()
    var innerPathPoints = [CGPoint]()

    // MARK: - UIView Overrides

    override func awakeFromNib() {
        assert(
            innerToOuterRadiusRatio < 1.0 && innerToOuterRadiusRatio > 0.0,
            "Ratio between inner and outer ratio must be between 0 and 1.0"
        )

        if hasStroke {
            assert(
                strokeWidth < starOuterRadius(),
                "Stroke width must be less than the star's radius"
            )
        }

        /// Set background color to clear so the transparent black 
        /// background isn't displayed.
        if backgroundColor == nil && isOpaque {
            backgroundColor = UIColor.clear
        }
    }

    override func draw(_ rect: CGRect) {
        /// Recalculate vertices if this is the initial render
        /// or caching is disabled.
        if outerPathPoints.isEmpty || !cacheVertices {
            outerPathPoints.removeAll(keepingCapacity: true)
            innerPathPoints.removeAll(keepingCapacity: true)

            for index in 0...4 {
                addVerticesToPoints(
                    radius: starOuterRadius(),
                    index: index,
                    points: &outerPathPoints
                )

                guard hasStroke else {
                    continue
                }

                addVerticesToPoints(
                    radius: starOuterRadius() - strokeWidth,
                    index: index,
                    points: &innerPathPoints
                )
            }
        }

        assert(!outerPathPoints.isEmpty, "Outer path is empty.")

        if hasStroke {
            assert(!innerPathPoints.isEmpty, "Inner path is empty and a stroke is specified.")

            drawStar(pathPoints: outerPathPoints, fillColor: strokeColor)
            drawStar(pathPoints: innerPathPoints, fillColor: fillColor)
        }
        else {
            drawStar(pathPoints: outerPathPoints, fillColor: fillColor)
        }
    }

    // MARK: - Star construction

    fileprivate func drawStar(pathPoints: [CGPoint], fillColor: UIColor) {
        assert(pathPoints.count == numVertices * 2, "10 points are required to construct star.")

        let starPath = UIBezierPath()

        for(index, point) in pathPoints.enumerated() {
            /// Move to first point
            if index == 0 {
                starPath.move(to: point)
            }
            else {
                starPath.addLine(to: point)

                /// Close the path after the last point.
                if(index == pathPoints.count - 1) {
                    starPath.close()
                }
            }
        }

        /// Fill
        fillColor.setFill()
        starPath.fill()
    }

    /**
        Adds a pair of points, one for the tip and another for the adjacent valley,
        to a list of points.

        Each star consists of 10 vertices, where each tip vertex has an adjacent
        valley vertex.

        Terms:
            * **Star tip**: The tip of a star's arm
            * **Star valley**: The vertex where two arms intersect.

        - parameters:
            - radius: The distance from the center of the view to a star tip.
            - index: Determines which pair of vertices to add to the list of points.
            - points: An array of CGPoints that will be used to construct the star's path.
     */
    fileprivate func addVerticesToPoints(radius: CGFloat, index: Int, points: inout [CGPoint]) {
        let endAngleDelta = CGFloat(index) * angleBetweenVertices

        /// Start at 12 o'clock.  The UIBezier path is going in a clockwise direction, so
        /// 3π/2 is noon.
        let starTipStartAngle = CGFloat(3) * π/2

        let starTipPath = UIBezierPath(
            arcCenter: starCenter(),
            radius: radius,
            startAngle: starTipStartAngle,
            endAngle: starTipStartAngle + endAngleDelta,
            clockwise: true
        )

        /// The associated valley needs to be offset from the tip by π/5 (36 degrees)
        let starValleyStarAngle = starTipStartAngle + angleBetweenVertices/2
        let starValleyPath = UIBezierPath(
            arcCenter: starCenter(),
            radius: radius * innerToOuterRadiusRatio,
            startAngle: starValleyStarAngle,
            endAngle: starValleyStarAngle + endAngleDelta,
            clockwise: true
        )

        points.append(starTipPath.currentPoint)
        points.append(starValleyPath.currentPoint)
    }

    // MARK: - Measurements & Calculations

    fileprivate func starCenter() -> CGPoint {
        let yDelta = starOuterRadius() - distanceFromStarCenterToBottom()
        let yCenter = starOuterRadius() + yDelta/CGFloat(2)

        return CGPoint(x: bounds.width/2, y: yCenter)
    }

    fileprivate func distanceFromStarCenterToBottom() -> CGFloat {
        return starOuterRadius() * cos(π/CGFloat(numVertices))
    }

    fileprivate func starOuterRadius() -> CGFloat {
        return min(bounds.width, bounds.height)/2
    }
}
