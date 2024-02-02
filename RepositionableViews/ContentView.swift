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

struct
ContentView: View
{
	@State	var	items				=	Item.testItems
	@State	var	selection			=	[Item.ID]()
	
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

#Preview
{
	ContentView()
		.previewLayout(.fixed(width: 600, height: 400))
}








extension
CGPoint
{
	static
	func
	+(lhs: CGPoint, rhs: CGPoint)
		-> CGPoint
	{
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	static
	func
	+(lhs: CGPoint, rhs: CGSize)
		-> CGPoint
	{
		return CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
	}
	
	static
	func
	+=(lhs: inout CGPoint, rhs: CGSize)
	{
		lhs = CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
	}
	
	static
	func
	-(lhs: CGPoint, rhs: CGPoint)
		-> CGPoint
	{
		return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	var
	magnitudeSqr: CGFloat
	{
		return self.x * self.x + self.y + self.y
	}
}

