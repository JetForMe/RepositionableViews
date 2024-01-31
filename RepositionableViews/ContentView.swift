//
//  ContentView.swift
//  RepositionableViews
//
//  Created by Rick Mann on 2024-01-30.
//

import SwiftUI






struct
Item : Identifiable, RepositionableItem
{
	let id									=	UUID()
	var	name			:	String
	var color			:	Color
	var	position		:	CGPoint
	var	size			:	CGSize
	
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
	let	item			:	Item
	
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
RepositionableContainer<Content : View, Item : RepositionableItem> : View
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
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

struct
ContentView: View
{
	var
	body: some View
	{
		RepositionableContainer(Item.testItems)
		{ inItem in
			ItemView(item: inItem)
		}
		.padding()
		.frame(width: 600, height: 400)
	}
}

#Preview
{
	ContentView()
		.previewLayout(.fixed(width: 600, height: 400))
}
