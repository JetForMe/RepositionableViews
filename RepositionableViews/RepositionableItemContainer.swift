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
				.border(self.strokeStyle)				//	Show selection
		}
	}
	
	private
	var
	strokeStyle: AnyShapeStyle
	{
		self.selected ? AnyShapeStyle(.selection) : AnyShapeStyle(.clear)
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
			
			//	Add views for each item…
			
			ForEach(self.$items)
			{ $inItem in
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
							
							//	If the clicked item is not in the selection, deselect all and select it…
								
							if self.dragStartPositions.isEmpty
							{
								if self.selection?.wrappedValue.contains(inItem.id) == false
								{
									if !NSEvent.modifierFlags.contains(.shift)
									{
										self.selection?.wrappedValue.removeAll()
									}
									self.selection?.wrappedValue.append(inItem.id)
								}
							}
							
							//	Get the indices of the selected items…
							
							let indexes: [Int]
							if let selection = self.selection
							{
								indexes = self.items
												.filter { selection.wrappedValue.contains($0.id) }
												.map { item in self.items.firstIndex(where: { $0.id == item.id }) }
												.compactMap { $0 }
							}
							else
							{
								indexes = [self.items.firstIndex(where: { $0.id == inItem.id })!]
							}
							
							//	Remember where each one started…
							//	This redundantly moves inItem twice, if it’s part of the selection,
							//	but I don’t think it’ll be an issue…
							
							if self.dragStartPositions.isEmpty
							{
								self.dragStartPositions = self.items.map { $0.position }
								self.dragStartPositions.append(inItem.position)
							}
							
							for idx in indexes
							{
								self.items[idx].position = self.dragStartPositions[idx] + gesture.translation
							}
							inItem.position = self.dragStartPositions.last! + gesture.translation
						}
						.onEnded
						{ _ in
							self.dragStartPositions.removeAll()
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
	
	@State	private	var	dragStartPositions				:	[CGPoint]		=	[]
}

