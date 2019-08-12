//
//  ScrollView.swift
//  StretchyScrollApp
//
//  Created by Thomas Sivilay on 8/8/19.
//  Copyright © 2019 Thomas Sivilay. All rights reserved.
//

import SwiftUI

struct ScrollViewExample: View {
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            ScrollViewHeaderView(offset: $offset)
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) {
                    print($0)
                    self.offset = $0
                }
            ScrollViewContentView()
                .offset(x: 0, y: 220 + offset)
                .padding(.bottom, 220 + offset)
        }
    }
}

struct ScrollViewHeaderView: View {
    
    @Binding var offset: CGFloat
    
    var body: some View {
        GeometryReader { proxy -> AnyView in
            let frame = proxy.frame(in: .global)
            let height = min(frame.maxY, 400)

            return AnyView(
                ZStack {
                    Image("willian-justen-de-vasconcellos")
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(height: 400)
                        .clipped()
                    VStack(spacing: 4) {
                        Text("Willian\nJusten de Vasconcellos")
                            .foregroundColor(.white)
                            .bold()
                            .multilineTextAlignment(.center)
                            .font(.title)
                        Text("debugFrame: \(frame.debugDescription)")
                        Text("maxY: \(self.offset)")
                    }
                }
                .frame(width: proxy.size.width, height: 300)
            )
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollViewContentView: View {
    
    var body: some View {
        GeometryReader { proxy -> AnyView in
            print(proxy)
            
            return AnyView(
                Form {
                    Section(header: Text("0")) {
                        NavigationLink(destination: DetailView(title: "Nav")) {
                            GeometryReader { subProxy -> AnyView in
                                return AnyView(
                                    Text("Navigation link")
                                        .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("myZstack")).maxY)
                                )
                            }
                        }
                        Text("\(proxy.size.debugDescription)")
                            .onTapGesture {
                                print("TEST")
                        }
                    }
                    Section(header: Text("1")) {
                        NavigationLink(destination: DetailView(title: "Nav")) {
                            Text("Row 2")
                        }
                        Text("Row 3")
                        Text("Row 4")
                        Text("Row 5")
                        NavigationLink(destination: DetailView(title: "Nav")) {
                            Text("Row 6")
                        }
                    }
                    Section(header: Text("2")) {
                        Text("Row 7")
                        Text("Row 8")
                        Text("Row 9")
                        Text("Row 10")
                        Text("Row 11")
                    }
                    Section(header: Text("3")) {
                        Text("Row 12")
                        Text("Row 13")
                        Text("Row 14")
                        Text("Row 15")
                        Text("Row 16")
                    }

                }
                .frame(width: proxy.size.width)
                .coordinateSpace(name: "myZstack")
            )
        }
    }
}

#if DEBUG
struct ScrollViewExample_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewExample()
    }
}
#endif


