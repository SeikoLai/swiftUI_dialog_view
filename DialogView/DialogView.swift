//
//  DialogView.swift
//  DialogView
//
//  Created by Sam on 2024/5/22.
//

import SwiftUI

struct DialogView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    
    var trailingButtonTapped: Binding<Bool>
    
    private let title: String
    private let titleFont: Font
    /// The maximum is 2
    private let titleLineLimit: Int
    private let leadingButtonTitle: String
    private let leadingButtonTitleFont: Font
    private let trailingButtonTitle: String
    private let trailingButtonTitleFont: Font
    /// The maximum is 5
    private let contentLineLimit: Int
    private let content: Content
    
    init(title: String,
         titleFont: Font = .system(.title).monospaced(),
         titleLineLimit: Int = 2,
         leadingButtonTitle: String = "Cancel",
         leadingButtonTitleFont: Font = .system(.title3).monospaced(),
         trailingButtonTitle: String = "Done",
         trailingButtonTitleFont: Font = .system(.title3).monospaced(),
         trailingButtonTapped: Binding<Bool>,
         contentLineLimit: Int = 5,
         @ViewBuilder _ message: () -> Content) {
        self.title = title
        self.titleFont = titleFont
        self.titleLineLimit = titleLineLimit
        self.leadingButtonTitle = leadingButtonTitle
        self.leadingButtonTitleFont = leadingButtonTitleFont
        self.trailingButtonTitle = trailingButtonTitle
        self.trailingButtonTitleFont = trailingButtonTitleFont
        self.trailingButtonTapped = trailingButtonTapped
        self.contentLineLimit = contentLineLimit
        self.content = message()
    }
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(title)
                    .lineLimit(max(2, titleLineLimit))
                    .font(titleFont)
                    .bold()
                
                content
                    .lineLimit(max(5, contentLineLimit))
                
                Divider()
                    .padding(.horizontal, -20)
                
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text(leadingButtonTitle)
                            .frame(maxWidth: .infinity)
                            .font(leadingButtonTitleFont)
                    })
                    
                    Button(action: {
                        trailingButtonTapped.wrappedValue.toggle()
                    }, label: {
                        Text(trailingButtonTitle)
                            .frame(maxWidth: .infinity)
                            .font(trailingButtonTitleFont)
                    })
                }
                
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 40)
        }
        .zIndex(.greatestFiniteMagnitude)
    }
}

struct DialogViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    var title: String
    var titleFont: Font = .system(.title).monospaced()
    var titleLineLimit: Int = 2
    var leadingButtonTitle: String = "Cancel"
    var leadingButtonTitleFont: Font = .system(.title3).monospaced()
    var trailingButtonTitle: String = "Done"
    var trailingButtonTitleFont: Font = .system(.title3).monospaced()
    var trailingButtonTapped: Binding<Bool>
    var contentLineLimit: Int = 5
    var content: any View
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                DialogView(title: title,
                           titleFont: titleFont,
                           titleLineLimit: titleLineLimit,
                           leadingButtonTitle: leadingButtonTitle,
                           leadingButtonTitleFont: leadingButtonTitleFont,
                           trailingButtonTitle: trailingButtonTitle,
                           trailingButtonTitleFont: trailingButtonTitleFont,
                           trailingButtonTapped: $isPresented,
                           contentLineLimit: contentLineLimit) {
                    content
                }
            }
        }
    }
}

#if DEBUG
struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        DialogView(title: "The unanimous Declaration of the thirteen united States of America,", trailingButtonTapped: .constant(true)) {
            VStack {
                Text("When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.\nWe hold these truths to be self-evident, that all men are created equal, that they are endowed by their Creator with certain unalienable Rights, that among these are Life, Liberty and the pursuit of Happiness.—That to secure these rights, Governments are instituted among Men, deriving their just powers from the consent of the governed,—That whenever any Form of Government becomes destructive of these ends, it is the Right of the People to alter or to abolish it, and to institute new Government, laying its foundation on such principles and organizing its powers in such form, as to them shall seem most likely to effect their Safety and Happiness. Prudence, indeed, will dictate that Governments long established should not be changed for light and transient causes; and accordingly all experience hath shewn, that mankind are more disposed to suffer, while evils are sufferable, than to right themselves by abolishing the forms to which they are accustomed. But when a long train of abuses and usurpations, pursuing invariably the same Object evinces a design to reduce them under absolute Despotism, it is their right, it is their duty, to throw off such Government, and to provide new Guards for their future security.".uppercased())
                    .font(.system(.body).monospaced())
            }
        }
    }
}
#endif
