# rpg_game

# 🎮 Dart 콘솔 RPG 게임

전투 기능이 포함된 텍스트 기반 콘솔 RPG 게임입니다.  
`Dart` 언어로 작성되었으며, 유저가 캐릭터 이름을 입력하고, 여러 몬스터와 전투를 벌이는 구조입니다.

---

## 📦 기능 요약

### ✅ 기본 기능
- 캐릭터 클래스 (`Character`), 몬스터 클래스 (`Monster`)
- 전투 시스템: 공격, 방어
- 게임 승패에 따라 결과 저장
- 캐릭터/몬스터 정보 파일에서 불러오기

### 🚀 도전 기능
- 아이템 1회 사용 (공격력 2배)
- 몬스터가 3턴마다 방어력 증가
- 30% 확률로 보너스 체력 부여

---

## 📁 프로젝트 구조

```
rpg_game/
├── main.dart         # 게임 메인 코드
├── characters.txt    # 캐릭터 초기 능력치 (HP, ATK, DEF)
├── monsters.txt      # 몬스터 정보 목록
├── result.txt        # 게임 결과 저장 파일
└── README.md         # 프로젝트 설명 파일
```
</code></pre>


---

## 🕹 실행 방법

1. Dart 설치 (https://dart.dev/get-dart)
2. 프로젝트 폴더로 이동
3. 터미널에서 실행:

```bash
dart main.dart
```

🧪 캐릭터/몬스터 파일 예시

characters.txt
```
50,10,5
```

monsters.txt
```
Batman,30,20
Spiderman,20,30
Superman,30,10
```

💾 결과 저장

게임 종료 시, 결과 저장 여부를 묻습니다.
예를 선택하면 result.txt에 아래 형식으로 저장됩니다:
```
이름: 홍길동, 남은 체력: 25, 결과: 승리
```
