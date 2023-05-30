# Section3

## SwiftUI 인터넷에서 이미지를 로드하고 비동기적으로 디스플레이 하는 방법

- SwiftUI의 AcyncImage View는 공유 URL 세션 인스턴스를 이용해 원격이미지가 로드될 때까지 지정된 URL에서 이미지를 로드해 화면에 표시
- 로딩 프로세스를 제어하기 위해 initializer를 사용할 수 있음
- 비동기 이미지 단계를 수신하는 콘텐츠 마개를 받아 로딩

![AsyncImage](https://github.com/bulmang/SwfitUI_Study/assets/114594496/83f94578-0cb6-40d7-aef2-97d2a9c1a18c)


### 1. Basic

- 비동기 이미지를 사용하는 가장 간단한 방법은 ImageURL을 지정
- URL은 선택사항이기 때문에 비동기 이미지는 기본 회색 자리 표시자를 보여준다(URL 문자열이 유효하지 않을 때)

### 2. Scale

- scale을 사용하여 이미지의 크기를 조정할 수 있음

### 3. PlaceHolder

- 이니셜라이저를 이용해 콘텐츠와 클로저 매개변수를 이용해 로드된 이미지를 조작

```swift
// MARK: - 3. PLACEHOLDER
        // image는 클로저 매개변수
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
        } placeholder: {
            Image(systemName: "photo.circle.fill")
        }
        .padding(40)
```

- Modifier를 이용하여 이미지를 조작

```swift
.resizable()
.scaledToFit()
.frame(maxWidth: 128)
.foregroundColor(.purple)
.opacity(0.5)
```

**Image Extesion**

- 중복된 코드들을 반복하지 않고 사용하는 방법
- Modifier를 최적화

```swift
extension Image {
    func imageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
    
    func iconeModifier() -> some View {
        self
            .imageModifier()
            .frame(maxWidth: 128)
            .foregroundColor(.purple)
            .opacity(0.5)
    }
}
```

### 4. PHASE(AsyncImage)

- 로딩 프로세스를 더 제어하기 위해서 이니셜라이저를 사용해야함.
- 수신하는 콘테츠 클로저를 받아 로딩 작업의 상태를 표시
- 비동기 이미지는 다른 생성자를 제공함으로서 각 단계마다 다른 이미지를 띄울 수 있음

```swift
AsyncImage(url: URL(string: imageURL)) { phase in
            // 성공: 이미지 불러오기 성공
            // 실패: 이미지 불러오기 실패 오류
            // 없음: 불러올 이미지가 없음
            
            if let image = phase.image {
                image.imageModifier()
            } else if phase.error != nil {
                Image(systemName: "ant.circle.fill").iconeModifier()
            } else { 
                Image(systemName: "photo.circle.fill").iconeModifier()
            }
        }
```

### 5. Animation

- 비동기 이미지 단계는 열거!
- 원격 이미지에 애니메이션을 추가하려면 비동기 이미지에 선택적인 트랙잭션 매개 변수를 명시 해야함.
- Asnyc Image는 Preview에서 작동하지 않음
- iOS에서는 이미지 로드할 때 플러그인이 필요가 없다.

```swift
AsyncImage(url: URL(string: imageURL),transaction: Transaction(animation: .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.25))) { phase in
            switch phase {
            case .success(let image):
                image
                    .imageModifier()
//                    .transition(.move(edge: .bottom))
//                    .transition(.slide)
                    .transition(.scale)
            case .failure(_):
                Image(systemName: "ant.circle.fill").iconeModifier()
            case .empty:
                Image(systemName: "photo.circle.fill").iconeModifier()
            @unknown default:
                ProgressView()
            }
        }
        .padding(40)
```
