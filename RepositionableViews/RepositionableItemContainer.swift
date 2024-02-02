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
	let	content			:	() -> Content
	
	var
	body: some View
	{
		self.content()
	}
}

struct
RepositionableItemContainer<Content : View, Item : RepositionableItem> : View
{
	@Binding	var	items							:	[Item]
				let itemViewContent					:	(Item) -> Content
	
	init(_ inItems: Binding<[Item]>, itemViewContent: @escaping (Item) -> Content)
	{
		self._items = inItems
		self.itemViewContent = itemViewContent
	}
	
	var
	body: some View
	{
		ZStack
		{
			Color.cyan
			
			ForEach(self.items)
			{ inItem in
				RepositionableItemView
				{
					self.itemViewContent(inItem)
				}
				.frame(width: inItem.size.width, height: inItem.size.height)
				.position(inItem.position)
				.gesture(
					DragGesture()
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
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	@State				private	var	dragOffset					:	CGPoint?
}


