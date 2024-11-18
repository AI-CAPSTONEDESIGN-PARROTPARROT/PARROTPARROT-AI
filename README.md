
# 발음 평가 애플리케이션

## 개요
이 애플리케이션은 사용자가 발음 실력을 향상시킬 수 있도록 **발음 평가 기능**을 제공합니다. :
- 연습하고 싶은 텍스트 입력
- 자신의 발음을 녹음
- 정확도, 유창성, 완전성 및 종합 발음 점수에 대한 피드백 받기
- 입력한 텍스트의 TTS(Text-to-Speech) 오디오 듣기

---

## 프로젝트 파일 구성 및 설명

### 1. 파일 구성


#### **1.1 `application.py`**
- Flask 기반 백엔드 서버 애플리케이션.
- RESTful 엔드포인트를 제공하며, `/gettoken`, `/gettts`, `/ackaud`와 같은 요청을 처리.
- Azure Speech SDK를 활용한 발음 평가 및 TTS(Text-to-Speech) 기능.

#### **1.2 `requirements.txt`**
- 프로젝트의 Python 의존성 라이브러리 목록.
- 주요 라이브러리:
  - `azure-cognitiveservices-speech`: Azure Speech 서비스 활용.
  - `Flask`: 웹 애플리케이션 프레임워크.
  - `requests`: HTTP 요청을 위한 라이브러리.

#### **1.3 `start_flask.sh`**
- Flask 서버를 실행하기 위한 스크립트.
- `FLASK_APP`과 `FLASK_ENV` 설정 후, 서버를 실행.

#### **1.4 `index.html`**
- 사용자 인터페이스(UI)를 구성하는 HTML 파일.
- 주요 UI 요소:
  - `textarea`: 사용자 입력 텍스트 필드.
  - 버튼: **발음 배우기**, **랜덤 발음 연습**, **녹음하기**.
  - 평가 결과 표시 테이블(`summarytable`)과 상세 점수 테이블(`detailedtable`).

#### **1.5 `index.js`**
- 애플리케이션의 클라이언트 로직 담당.
- 주요 기능:
  - **TTS 요청**: `/gettts` 엔드포인트를 호출하여 TTS 오디오를 생성.
  - **녹음**: 사용자의 음성 녹음 및 업로드를 처리.
  - **발음 평가**: 서버로부터 평가 결과를 받아 UI에 표시.
  - UI 이벤트 핸들러 등록: 버튼 클릭 및 텍스트 입력 핸들링.

#### **1.6 `microsoft.cognitiveservices.speech.sdk.bundle.js`**
- Microsoft Azure Speech SDK의 번들.
- Azure Speech API와 상호작용을 위한 라이브러리 제공.

#### **1.7 `style.css`**
- UI 디자인을 정의하는 CSS 파일.
- 주요 스타일:
  - 버튼 및 테이블 디자인.
  - 반응형 웹 스타일(Media Query).
  - 로더 애니메이션(`loader`) 정의.

---

### 2. 핵심 코드 설명

#### **2.1 서버 실행 (`start_flask.sh`)**
```bash
#!/bin/bash
export FLASK_APP=application.py
export FLASK_ENV=development
flask run --host=0.0.0.0 --port=3000
```
- Flask 개발 서버를 로컬에서 실행하며, `3000`번 포트에서 요청을 처리.

#### **2.2 사용자 인터페이스 (HTML 구조)**
```html
<form id="reftextform">
    <textarea id="reftext" placeholder="Enter Reference Text here..."></textarea>
</form>
<div class="button-container">
    <button id="randomtt" class="blue-button">랜덤 발음 연습</button>
    <button id="buttonmic" class="green-button">녹음하기</button>
</div>
```
- **`textarea`**: 사용자가 연습할 텍스트 입력.
- 버튼:
  - **랜덤 발음 연습**: 서버에서 랜덤 텍스트를 가져옴.
  - **녹음하기**: 사용자 음성을 녹음하고 서버로 전송.

#### **2.3 클라이언트 로직 (`index.js`)**

- **TTS 요청**
```javascript
function getttsforword(word) {
    var request = new XMLHttpRequest();
    request.open('POST', '/getttsforword', true);
    request.responseType = "blob";
    request.onload = () => {
        var blobpronun = request.response;
        var objectUrl = URL.createObjectURL(blobpronun);
        wordaudiourls.push({ word, objectUrl });
    };
    const dat = new FormData();
    dat.append("word", word);
    request.send(dat);
}
```
- 특정 단어의 발음을 생성하는 오디오를 서버로부터 가져옴.

- **녹음**
```javascript
navigator.mediaDevices.getUserMedia({ audio: true })
    .then(soundAllowed)
    .catch(soundNotAllowed);

function soundAllowed(stream) {
    audioContent = new AudioContext();
    gumStream = stream;
    audioStream = audioContent.createMediaStreamSource(stream);
    rec = new Recorder(audioStream, { numChannels: 1 });
    rec.record();
}
```
- 브라우저에서 마이크 접근 권한을 요청하고, 오디오를 녹음.

---

### 3. 프로젝트 실행 방법

#### **1. 의존성 설치**
Python 환경에서 아래 명령어를 실행하여 필요한 라이브러리를 설치합니다:
```bash
pip install -r requirements.txt
```

#### **2. Flask 서버 실행**
`start_flask.sh` 스크립트를 실행하여 서버를 시작합니다:
```bash
chmod +x start_flask.sh
./start_flask.sh
```

#### **3. 브라우저에서 애플리케이션 접속**
웹 브라우저를 열고 아래 URL에 접속합니다:
```
http://localhost:3000
```

---

## 주요 기술 및 라이브러리
- **Frontend**
  - HTML, CSS, JavaScript
  - `Recorder.js`: 녹음 기능 지원
- **Backend**
  - Flask: 웹 애플리케이션 프레임워크
  - Azure Speech SDK: 발음 평가 및 TTS 기능
- **의존성 라이브러리**
  - Flask, azure-cognitiveservices-speech, requests 등 (`requirements.txt` 참고)

---

## 참고
- 프로젝트를 실행하기 전에 Azure Speech 서비스에 가입하고, API 키와 엔드포인트를 설정해야 합니다.
- `application.py` 내에 Azure Speech SDK와 관련된 설정을 업데이트해야 합니다.
---
# 발음 평가의 세분성

발음 평가 기능의 세부적인 평가 기준과 점수 체계.

## 1. 평가 항목

### 1.1 정확도 점수 (accuracyscore)
- 발음의 정확도를 평가합니다.

### 1.2 유창성 점수 (fluencyscore)
- 말하기의 부드러움과 자연스러움의 수준을 측정합니다.

### 1.3 완전성 점수 (completenessscore)
- 올바르게 발음된 단어 수를 반영합니다.

### 1.4 운율 점수 (pronscore)
- 적절한 억양, 리듬, 강세의 사용을 평가합니다.
- 예기치 않은 중단, 누락된 중단, 모노톤 등 운율과 관련된 추가적인 오류 유형을 포함합니다.
- 이전 엔진에 비해 발음 오류에 대한 더 자세한 정보를 제공합니다.

---

## 2. 텍스트 수준 평가

텍스트 수준에서 발음 평가는 다음과 같은 점수와 정보를 제공합니다:

### 2.1 유창성
- 화자가 원어민의 단어 사이 묵음 중지 사용과 얼마나 밀접하게 일치하는지 나타냅니다.

### 2.2 완전성
- 참조 텍스트 입력에 대해 음성에서 발음되는 단어 수를 측정합니다.

### 2.3 운율
- 자연스러움, 표현력, 전반적인 운율 요소 전달 능력을 평가합니다.

### 2.4 종합 점수
- 정확성, 유창성, 완전성, 운율 점수를 합산하여 음성의 전반적인 발음 품질을 나타냅니다.

### 2.5 콘텐츠 점수
- 텍스트 수준에서 어휘, 문법, 토픽과 같은 추가적인 콘텐츠 관련 점수도 제공합니다.

---

## 3. 단어 수준 평가

### 3.1 단어 수준 평가 기능
- 발음 평가에서는 단어 수준에서 누락, 반복, 삽입, 잘못된 발음에 대한 자세한 정보를 제공합니다.

### 3.2 정확성 점수
- 단어 단위에서 발음의 정확성을 평가하여 학습자가 특정 단어 발음을 개선할 수 있도록 지원합니다.

---

## 4. 음절 및 음소 수준 평가

### 4.1 음절 수준 평가
- 음절 수준의 정확도 점수는 **JSON 파일** 또는 **Speech SDK**를 통해 확인할 수 있습니다.

### 4.2 음소 수준 평가
- 발음 평가에서는 각 음소의 정확성 점수를 제공합니다.
- 학습자는 음소 단위의 발음 세부 정보를 분석하여 더 나은 발음 학습을 할 수 있습니다.

