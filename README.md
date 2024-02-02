#  Repositionable SwiftUI Views

This project is an attempt to implement an elegant SwiftUI container that allows the user to
reposition and resize the subviews contained within it using drag gestures.

![](assets/BsicContainer.png)

Dragging and selection has been refined a bit.

It should work like this:

```swift
struct
Item : Identifiable, RepositionableItem
{
    let id                                  =   UUID()
    var name            :   String
    var color           :   Color
    var position        :   CGPoint
    var size            :   CGSize
    
    static
    let
    testItems: [Item] =
    [
        Item(name: "Item 1", color: .red, position: CGPoint(x: 150, y: 150), size: CGSize(width: 100, height: 175)),
        Item(name: "Item 2", color: .yellow, position: CGPoint(x: 210, y: 210), size: CGSize(width: 125, height: 80)),
        Item(name: "Item 3", color: .blue, position: CGPoint(x: 110, y: 200), size: CGSize(width: 100, height: 50)),
    ]
}

struct
ItemView : View
{
    let item            :   Item
    
    var
    body: some View
    {
        ZStack
        {
            self.item.color
            Text("\(self.item.name)")
        }
    }
}

struct
ContentView: View
{
    @State  var items               =   Item.testItems
    @State  var selection           =   [Item.ID]()
    
    var
    body: some View
    {
        RepositionableItemContainer(self.$items, selection: self.$selection)
        { inItem in
            ItemView(item: inItem)
        }
        .padding()
        .frame(width: 600, height: 400)
        .toolbar
        {
            Button("Bring to Front")
            {
                let items = self.items.filter { self.selection.contains($0.id) }
                self.items.removeAll { self.selection.contains($0.id) }
                self.items.append(contentsOf: items)
            }
        }
    }
}
```

## Xcode Issues

The preview size is set to 600x400. But the preview is decidedly *not* that size, and it’s positioning the subviews incorrectly. This was solved by adding `.frame(maxWidth: .infinity, maxHeight: .infinity)`,
not sure why. Explore this behavior in commit f7eb238e7437c5a59c1fa19d4b471a2840736d62.

![](assets/Preview.png)

![](assets/Runtime.png)
