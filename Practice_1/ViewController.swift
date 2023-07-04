import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    var verticalConstraint: NSLayoutConstraint!
    var horizontalConstraint: NSLayoutConstraint!
    var transform: CGAffineTransform!
    var offSet:CGPoint!
    var initialPositionX:CGFloat!
    var initialPositionY:CGFloat!
    
    var widthConstraint: NSLayoutConstraint!
    var initialWidthConstraint: CGFloat!
    var initialHeightConstraint: CGFloat!
    var heightConstraint: NSLayoutConstraint!
    var viewSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(didDrag(_:)))
        
        imageViewOutlet.addGestureRecognizer(tapGesture)
        imageViewOutlet.addGestureRecognizer(pinchGesture)
        imageViewOutlet.addGestureRecognizer(rotationGesture)
        imageViewOutlet.addGestureRecognizer(dragGesture)
        
        alignImageView(imageViewToConstrain: imageViewOutlet)
        
        initialWidthConstraint = widthConstraint.constant
        initialHeightConstraint = heightConstraint.constant
        initialPositionX = horizontalConstraint.constant
        initialPositionY = verticalConstraint.constant
    }
    
    @objc private func didTap(_ gesture: UIGestureRecognizer) {
        self.imageViewOutlet.transform = CGAffineTransformIdentity
        widthConstraint.constant = initialWidthConstraint
        heightConstraint.constant = initialHeightConstraint
        horizontalConstraint.constant = initialPositionX
        verticalConstraint.constant = initialPositionY
    }
    
    @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
        imageViewOutlet.layoutIfNeeded()
        let scale = gesture.scale
        switch (gesture.state) {
            case .began:
                viewSize = CGSize(width: widthConstraint.constant, height: heightConstraint.constant)
                break;
                
            case .changed:
                widthConstraint.constant = viewSize.width * scale
                heightConstraint.constant = viewSize.height * scale
                imageViewOutlet.layoutIfNeeded()
                break;
                
            case .ended:
                break;
                
            default:
                break;
        }
    }
    @objc private func didRotate(_ gesture: UIRotationGestureRecognizer) {
        let rotation = gesture.rotation
        if let viewToTransform = gesture.view {
            switch (gesture.state) {
                case .began:
                    transform = viewToTransform.transform
                    break;
                    
                case .changed:
                    viewToTransform.transform = transform.concatenating(CGAffineTransform(rotationAngle: rotation))
                    break;
                    
                    
                case .ended:
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    
    @objc private func didDrag(_ gesture: UIPanGestureRecognizer) {
        imageViewOutlet.layoutIfNeeded()
                
                let translation = gesture.translation(in: self.view)
                switch (gesture.state) {
                case .began:
                    offSet = CGPoint(x: horizontalConstraint.constant, y: verticalConstraint.constant)
                    break;
                    
                case .changed:
                    horizontalConstraint.constant = offSet.x + translation.x
                    verticalConstraint.constant = offSet.y + translation.y
                    
                    view.layoutIfNeeded()
                    break;
                    
                    
                case .ended:
                    break;
                    
                default:
                    break;
                }
    }
    func alignImageView(imageViewToConstrain:UIImageView) {
        imageViewToConstrain.translatesAutoresizingMaskIntoConstraints = false

        horizontalConstraint =  imageViewToConstrain.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        horizontalConstraint.isActive = true
        verticalConstraint = imageViewToConstrain.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        verticalConstraint.isActive = true

        heightConstraint =  imageViewToConstrain.heightAnchor.constraint(equalToConstant: imageViewToConstrain.frame.height)
        heightConstraint.isActive = true
        widthConstraint = imageViewToConstrain.widthAnchor.constraint(equalToConstant: imageViewToConstrain.frame.width)
        widthConstraint.isActive = true
    }
}

