//
//  RepositionableItemContainer.swift
//  RepositionableViews
//
//  Created by Rick Mann on 2024-01-31.
//

import SwiftUI





protocol
RepositionableItem : Identifiable
{
	var position		:	CGPoint		{ get set }
	var	size			:	CGSize		{ get set }
}

struct
RepositionableItemView<Content : View> : View
{
	let	selected		:	Bool
	let	content			:	() -> Content
	
	init(selected: Bool, content: @escaping () -> Content)
	{
		self.selected = selected
		self.content = content
	}
	
	var
	body: some View
	{
		ZStack
		{
			self.content()
			
			if self.selected
			{
				Rectangle()
					.strokeBorder(.blue, lineWidth: 4.0)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				Rectangle()
					.strokeBorder(.black, lineWidth: 1.0)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding(4.0)
			}
		}
	}
}

struct
RepositionableItemContainer<Content : View, Item : RepositionableItem> : View
{
	@Binding	var	items						:	[Item]
				var	selection					:	Binding<[Item.ID]>?
				let itemViewContent				:	(Item) -> Content
	
	init(_ inItems: Binding<[Item]>, selection inSelection: Binding<[Item.ID]>? = nil, itemViewContent: @escaping (Item) -> Content)
	{
		self._items = inItems
		self.selection = inSelection
		self.itemViewContent = itemViewContent
	}
	
	var
	body: some View
	{
		ZStack
		{
			Color.cyan					//	TODO: This will have to be .clear for production code.
				
				//	Install a click handler that deselects any current selection…
				
				.gesture(
					TapGesture()
						.modifiers([])
						.onEnded
						{ _ in
							self.selection?.wrappedValue.removeAll()
						}
				)
			
			ForEach(self.items)
			{ inItem in
				let selected = self.selection?.wrappedValue.contains(inItem.id) ?? false
				RepositionableItemView(selected: selected)
				{
					self.itemViewContent(inItem)
				}
				.frame(width: inItem.size.width, height: inItem.size.height)
				.position(inItem.position)
				
				//	Drag handler for moving whole items…
				
				.gesture(
					DragGesture(minimumDistance: 2.0)
						.onChanged
						{ gesture in
							if self.dragOffset == nil
							{
//								let _ = print("Drag start:   \(gesture.startLocation)")
								self.dragOffset = inItem.position - gesture.startLocation
							}
							
							if let idx = self.items.firstIndex(where: { $0.id == inItem.id })
							{
								self.items[idx].position = gesture.location + self.dragOffset!		//	Can’t do this!
							}
						}
						.onEnded
						{ _ in
							self.dragOffset = nil
						}
				)
				
				//	Click handler for extending the selection…
				
				.gesture(
					TapGesture()
						.modifiers(.shift)
						.onEnded
						{ _ in
							if self.selection?.wrappedValue.contains(inItem.id) == false
							{
								self.selection?.wrappedValue.append(inItem.id)
							}
						}
				)
				
				//	Click handler for selecting a new item and deselecting any others…
				
				.gesture(
					TapGesture()
						.modifiers([])
						.onEnded
						{ _ in
							//	TODO: Call removeAll before test to always deselect, even when clicking on a selected
							//			item. Call it inside the test to only deselect if clicking on an unselected
							//			item.
							
							if self.selection?.wrappedValue.contains(inItem.id) == false
							{
								self.selection?.wrappedValue.removeAll()
								self.selection?.wrappedValue.append(inItem.id)
							}
						}
				)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	@State	private	var	dragOffset					:	CGPoint?
}


