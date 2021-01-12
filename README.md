# PoppableCollectionController

## About
A CollectionController protocol used to create a custom "pop" animation from a UICollectionCell to a fullscreen ViewController and vice versa. 

The "pop" effect is created by the PopAnimator (a subclass of UIViewControllerAnimatedTransitioning). This custom transition is called on UINavigationController's `popViewController()` and `pushViewController()` methods, so your controllers MUST be managed by UINavigationController for the animation to work.

## Usage
1. Ensure that your UICollectionViewController (or  a custom UIViewController containing a CollectionView) conforms to the `PoppableCollectionController` & `UINavigationControllerDelegate` protocols:
```
MyController: UICollectionViewController, UINavigationControllerDelegate, PoppableCollectionController{}`
```
2. Set your UICollectionViewController as the NavigationController's delegate:
```
self.navigationController?.delegate = self
```

2. Implement UINavigationContollerDelegate's `animationControllerForOperation` method:
```
func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimator(operation: operation)
    }
```

