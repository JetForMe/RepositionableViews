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
	let	items							:	[Item]
	let itemViewContent					:	(Item) -> Content
	
	init(_ inItems: [Item], itemViewContent: @escaping (Item) -> Content)
	{
		self.items = inItems
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
								let _ = print("Drag start:   \(gesture.startLocation)")
								self.dragOffset = inItem.position - gesture.startLocation
							}
							
							inItem.position = gesture.location + self.dragOffset!		//	Can’t do this!
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


