//
//  ContentView.swift
//  RepositionableViews
//
//  Created by Rick Mann on 2024-01-30.
//

import SwiftUI






struct
Item : Identifiable
{
	let id									=	UUID()
	var	name			:	String
	var	position		:	CGPoint
	var	size			:	CGSize
	
	static
	let
	testItems: [Item] =
	[
		Item(name: "Item 1", position: CGPoint(x: 150, y: 150), size: CGSize(width: 100, height: 200)),
		Item(name: "Item 2", position: CGPoint(x: 200, y: 50), size: CGSize(width: 75, height: 100)),
		Item(name: "Item 3", position: CGPoint(x: 100, y: 75), size: CGSize(width: 100, height: 50)),
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
			Color.green
			Text("\(self.item.name)")
		}
		.frame(width: self.item.size.width, height: self.item.size.height)
	}
}

struct
RepositionableContainer<Content : View> : View
{
	let content				:	() -> Content
	
	var
	body: some View
	{
		content()
	}
}

struct
ContentView: View
{
	var
	body: some View
	{
		RepositionableContainer
		{
			ForEach(Item.testItems)
			{ inItem in
				ItemView(item: inItem)
					.position(inItem.position)
			}
		}
		.frame(width: 600, height: 400)
	}
}

#Preview
{
	ContentView()
}
