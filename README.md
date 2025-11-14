# FigmaUILabel

**FigmaUILabel은 Figma에서 정의한 타이포그래피 속성을 UIKit의 기본 UILabel 프로퍼티처럼 직관적으로 수정할 수 있도록 설계된 라이브러리**입니다.
lineHeight, kerning, underlineStyle 등을 일반 프로퍼티처럼 설정하면, 내부적으로 필요한 텍스트 스타일을 자동으로 다시 구성합니다.

UIKit의 기본 UILabel은 Figma와 다르게 작동하는 부분이 많아 디자인 시안과 실제 구현 사이에 미묘한 차이가 발생하기 쉽습니다. FigmaUILabel은 이러한 불일치를 해결하여 디자인과 완전히 동일한 타이포그래피를 손쉽게 구현하는 것을 목표로 합니다.

## 📐 Philosophy

UIKit에서 Figma 스타일을 그대로 구현하기 위해선 다음과 같은 문제가 있습니다:
- line-height를 지정해도 Figma처럼 label 위아래 여백이 동일하게 맞지 않음
- AttributedString과 프로퍼티 적용 순서에 따라 최종 UI가 매번 달라짐.

FigmaUILabel은 이 문제들을 구조적으로 해결하여 “Figma와 동일한 텍스트 스타일”을 만들기 위한 일관된 구현 레이어를 제공합니다.

## ✨ Features
- **Figma Line Height(px/%) 구현**
  - baseline 자동 보정
    
  - min/maxLineHeight 동일 적용
    
-	**Kerning(px/%) 가능**
  
-	**Underline 스타일(NSUnderlineStyle) 가능**
-	**text/Line Height/Kerning 등 변경 시 자동으로 스타일 재적용**
    -	text를 바꾸면 기존 attributedString 관련 설정을 모두 다시 해줘야 하는 번거로움 해소
-	**선언적 TextStyleBuilder 적용**
    -	스타일 구성 코드가 깔끔하고 예측 가능
- **디버깅용 attribute Logger 포함**

| FigmaUILabel 실제 렌더링 | 피그마 디자인 시안 |
| -- | -- |
| <img width="300" alt="FigmaUILabel 실제 렌더링" src="https://github.com/user-attachments/assets/8ac533f2-42ee-4b58-9bba-2ef167d3b0fa" /> | <img width="300" alt="Figma 디자인 시안" src="https://github.com/user-attachments/assets/b528552c-d04b-4a03-92f4-3a1997ba8e49" /> |


## 🚀 Quick Start
기존에는 attributedString으로만 설정할 수 있던 스타일을 UILabel의 일반 프로퍼티처럼 사용할 수 있습니다. 프로퍼티 변경 시마다 자동으로 새 attributedText가 적용됩니다.

```swift
import FigmaUILabel
import UIKit

let label = FigmaUILabel()
label.text = "Hello, FigmaUILabel!"
label.font = .systemFont(ofSize: 16)
label.textColor = .black

label.lineHeight = .point(24)    // Figma line-height(px)
label.kerning = .percent(-2)     // Figma letter spacing(%)
label.underlineStyle = .single   // underline

```

## Without / With FigmaUILabel
### 🙅🏻‍♂️ Without FigmaUILabel

기본 UILabel에서 Figma 스타일을 그대로 구현하려면,
매번 NSMutableAttributedString을 직접 만들고 paragraphStyle, baselineOffset, kern, underline 등을 모두 수동으로 설정해야 합니다.
```swift
let label = UILabel()
label.numberOfLines = 0
label.textAlignment = .left

let text = "테스트입니다."
let font = UIFont.systemFont(ofSize: 16)
let lineHeight: CGFloat = 24
let kerning: CGFloat = -1.2
let underlineStyle: NSUnderlineStyle = .single

let attributed = NSMutableAttributedString(
    string: text,
    attributes: [
        .font: font,
        .kern: kerning,
        .underlineStyle: underlineStyle.rawValue
    ]
)

let paragraph = NSMutableParagraphStyle()
paragraph.minimumLineHeight = lineHeight
paragraph.maximumLineHeight = lineHeight
paragraph.alignment = .left

// Figma와 동일한 라인 높이를 위해 baseline 보정
let baselineOffset = (lineHeight - font.lineHeight) / 2

attributed.addAttributes([
    .paragraphStyle: paragraph,
    .baselineOffset: baselineOffset
], range: NSRange(location: 0, length: attributed.length))

label.attributedText = attributed
```
텍스트를 바꾸거나 underline 또는 font 등 하나의 속성만 변경하더라도
전체 attributedString을 다시 구성해야 합니다.

### ✅ With FigmaUILabel
같은 표현을 FigmaUILabel로 구현하면,
Figma 스타일을 UILabel의 일반 프로퍼티처럼 사용할 수 있습니다.
```swift
let label = FigmaUILabel()
label.numberOfLines = 0
label.textAlignment = .left

label.text = "테스트입니다."
label.font = .systemFont(ofSize: 16)

label.lineHeight = .point(24)     // Figma line-height(px)
label.kerning = .percent(-2)      // Figma letter spacing(%)
label.underlineStyle = .single    // underline
```

텍스트나 underline만 바꾸고 싶을 때도 아래처럼 간단하게 처리할 수 있습니다.
```swift
label.text = "바뀐 텍스트입니다."
label.underlineStyle = nil        // underline 제거
```

FigmaUILabel은 내부에서 TextStyleBuilder를 통해 필요한 attributedText를 자동으로 다시 구성하므로,
직접 NSMutableAttributedString을 다루지 않아도 됩니다.


## 🧩 API Overview

**FigmaMetric**

Figma에서 사용하는 단위를 표현하기 위한 타입입니다.

```swift
public enum FigmaMetric {
    case natural            // 기본값(속성 제거)
    case percent(Double)    // %, 예: -2%
    case point(CGFloat)     // px 단위 값
}
```

**FigmaUILabel**

Figma에서 정의한 타이포그래피 속성을 UIKit의 기본 UILabel 프로퍼티처럼 사용할 수 있도록 추가한 프로퍼티입니다.

```swift
public final class FigmaUILabel: UILabel {
    public var lineHeight: FigmaMetric
    public var kerning: FigmaMetric
    public var underlineStyle: NSUnderlineStyle?
}
```

## 🔧 How It Works

FigmaUILabel은 text/font/alignment 등의 변경을 감지해 updateTextStyle()를 호출합니다. 해당 함수는 체이닝 형태로 구성되어 직관적으로 이해할 수 있습니다.

```swift
updateTextStyle() {
  TextStyleBuilder(self)
      .lineHeight(...)
      .kerning(...)
      .underlineStyle(...)
      .apply()
}
```

**Line Height 처리 방식**
- Figma처럼 min/maxLineHeight를 동일하게 적용
- Figma line-height를 구현하기 위해 baselineOffset 자동 계산: `offset = (lineHeight - font.lineHeight) / 2`


## Requirements
- UIKit, iOS 15.0+
- SwiftUI에서도 UIViewRepresentable을 통해 사용 가능.

## Installation

Swift Package Manager 사용
- File > SwiftPackages > Add Package Dependency
- Add `https://github.com/Naknakk/FigmaUILabel.git`
- Select "Up to Next Major"


## 📄 License
MIT license
