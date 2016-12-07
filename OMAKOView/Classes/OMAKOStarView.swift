import UIKit

@IBDesignable
open class OMAKOStarView: UIView {
    @IBInspectable open var strokeWidth: CGFloat = 5
    @IBInspectable open var hasStroke: Bool = false
    @IBInspectable open var strokeColor: UIColor = UIColor.red

    @IBInspectable open var fillColor: UIColor = UIColor(red: 0.05, green: 0.5, blue: 1.0, alpha: 1.0)

    /// Caches calculation for placement of star vertices on the first
    /// call to draw(_:) if true.
    @IBInspectable open var cacheVertices: Bool = true

    /**
     Ratio of inner to outer radius.

     Higher values result in wider arms, while lower values
     result in narrower arms.
     */
    @IBInspectable open var innerToOuterRadiusRatio: CGFloat = 0.45

    /// Ratio of outer radius to minimum view dimension.  I.e., star size.
    @IBInspectable open var starToViewRatio: CGFloat = 1.0

    fileprivate let π: CGFloat = CGFloat(M_PI)
    fileprivate let numVertices: Int = 5

    /// 72 degrees (angle between each star's vertex) in radians
    fileprivate let angleBetweenVertices: CGFloat = 2 * CGFloat(M_PI) / 5

    /// Vertex set for the outer star
    fileprivate var outerPathPoints = [CGPoint]()

    /**
        Vertex set for the inner star.  Only populated if a stroke is specified.
        
        Varying the stroke width, unfortunately has undesireable side effects, 
        where the stroke can extend beyond the bounds of the view frame.
     
        Therefore, to achieve the effect of an outline, a second star must
        be drawn within, with the larger star acting as the stroke, and the 
        inner star the fill.
    */
    fileprivate var innerPathPoints = [CGPoint]()

    fileprivate var isDebug = false

    // MARK: - UIView Overrides

    override open func awakeFromNib() {
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

    override open func draw(_ rect: CGRect) {
        /// Recalculate vertices if this is the initial render
        /// or caching is disabled.
        if outerPathPoints.isEmpty || !cacheVertices {
            outerPathPoints.removeAll(keepingCapacity: true)
            innerPathPoints.removeAll(keepingCapacity: true)

            for index in 0...4 {
                /// Determine outer star vertices
                addVerticesToPoints(
                    radius: starOuterRadius(),
                    index: index,
                    points: &outerPathPoints
                )

                guard hasStroke else {
                    continue
                }

                /// Determine inner star vertices.  Only if 
                /// a stroke is desired.
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

        /// Check star center relative to view center.
        if isDebug {
            let center = CGPoint(x: bounds.width/2.0, y: bounds.width/2.0)
            renderPoint(point: center, size: 2, color: UIColor.blue)
            renderPoint(point: starCenter(), size: 2, color: UIColor.red)
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
        valley vertex, where the base of two arms meet.

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
        let yCenter = bounds.height/CGFloat(2) + yDelta/CGFloat(2)

        return CGPoint(x: bounds.width/2, y: yCenter)
    }

    fileprivate func distanceFromStarCenterToBottom() -> CGFloat {
        /// Length of the plumb line dropped from the star center to the
        /// bottom of the star.
        return starOuterRadius() * cos(π/CGFloat(numVertices * 2))
    }

    fileprivate func starOuterRadius() -> CGFloat {
        assert(starToViewRatio > 0 && starToViewRatio <= 1.0, "Star to view ratio must be between 0 (exclusive) and 1.0 (inclusive)")
        return (min(bounds.width, bounds.height)/2) * starToViewRatio
    }

    // MARK: - Diagnostics

    fileprivate func renderPoint(point: CGPoint, size: CGFloat, color: UIColor = UIColor.black) {
        let path = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: size, height: size)))
        color.setFill()
        path.fill()
    }
}
