#  Repositionable SwiftUI Views

This project is an attempt to implement an elegant SwiftUI container that allows the user to
reposition and resize the subviews contained within it using drag gestures.

![](assets/BsicContainer.png)

Right now I’m trying to add the drag gesture to allow repositioning the items, but I can’t modify the immutable items. I think I need some kind of Binding here, but I’m not yet sure how to set that up.

## Xcode Issues

The preview size is set to 600x400. But the preview is decided NOT that size, and it’s positioning the subviews incorrectly. Thsi was solved by adding `.frame(maxWidth: .infinity, maxHeight: .infinity)`,
not sure why.

![](assets/Preview.png)

![](assets/Runtime.png)
