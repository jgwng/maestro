# 프로젝트 설명

이 프로젝트는 UI 자동화 테스트 툴중에 하나인 Maestro(https://maestro.mobile.dev/)툴을 보다 손쉽게 활용하기 위해 개발되어 있는 프로젝트 입니다.

Node.js를 사용하여 웹 서버를 구축하고, 이를 통해 작성한 스크립트와 연결되어 있는 Android/IOS 기기(에뮬레이터만!)들을 조회하고 간편하게 실행할 수 있습니다.

-  Maestro툴에서 IOS 실 기기는 지원을 하지 않기에 IOS 실기기는 조회하지 않습니다!<br><br>



## 프로젝트 구조 설명

해당 프로젝트는 크게 4가지로 구분 되어 있다고 볼수 있다.<br>
프로젝트의 파일 구조는 아래와 같다.
```
.
├── README.md
├── client - 테스트를 진행할 앱. 
├── script - Maestro를 이용하여 작성한 스크립트 모음
├── server - 테스트 웹 페이지에 사용하는 API 
│   └── server.js
├── web - 테스트 웹 페이지의 UI 관련 
│   ├── css
│   │   └── styles.css
│   ├── index.html
│   └── js
│       └── script.js
└── 파일구조.txt
```

## 프로젝트 시작하기
프로젝트를 경험하며 느꼈지만 Windows보단 macos에서 사용하기 더 편하기 때문에 가급적이면 macos에서 Maestro 설치 및 진행을 권장드립니다. 

### 1. Maestro 설치
Maestro를 설치하지 않았다면 먼저 설치하세요! <br>Windows와 macOS를 모두 지원하지만 macOS를 추천드립니다.<br>

```
curl -Ls "https://get.maestro.mobile.dev" | bash
```

(Windows에서 Maestro 설치하는 방법 - https://maestro.mobile.dev/getting-started/installing-maestro/windows)
### 2. 프로젝트 설치 및 실행
프로젝트를 클론하고 필요한 패키지를 설치한 후 서버를 실행합니다.

```
git clone https://github.com/jgwng/maestro.git
cd maestro
npm  install express
```

### 3. 서버 실행 
```
node server/server.js
```

### 4. 웹 페이지 열기 (http://localhost:8080)

모든 과정을 끝마치셨다면 해당 주소에 아래와 같은 웹페이지가 열리게 됩니다.


![스크린샷](https://github.com/user-attachments/assets/85ca94c8-0b5a-482c-88ca-b4f65490899e)