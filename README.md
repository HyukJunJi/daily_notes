# 📜 Daily Note 사용법

Windows 작업 스켈준러를 활용한 개인 메모 자동화 시스템입니다. 아래 설정을 통해 매일 자동으로 노트를 생성하고 열 수 있습니다.

---

## 📁 1. `daily_note.conf` 설정

먼저 `daily_note.conf` 파일을 아래와 같은 형식으로 작성합니다:

```
ROOT_DIR=D:\MyNotes\Daily
NOTEPAD_PATH=C:\Program Files\Notepad++\notepad++
LOG_PATH=D:\MyNotes\Daily\log
CREATE_XML_PATH=D:\MyNotes\Scripts\CreateDailyNote.xml
OPEN_XML_PATH=D:\MyNotes\Scripts\OpenDailyNote.xml
```

| 항목                | 설명                            |
| ----------------- | ----------------------------- |
| `ROOT_DIR`        | 메모 파일을 저장할 루트 디렉터리            |
| `NOTEPAD_PATH`    | 메모 파일을 열 엔딩 프리정 (Notepad++ 등) |
| `LOG_PATH`        | 로그 파일이 저장될 디렉터리               |
| `CREATE_XML_PATH` | Create 타스크용 XML 경로            |
| `OPEN_XML_PATH`   | Open 타스크용 XML 경로              |

---

## ⚙️ 2. XML 설정

각 XML 파일에는 실행할 `.bat` 파일의 경로를 `<Command>` 태그로 지정해야 합니다:

### ✅ CreateDailyNote.xml

```xml
<Command>D:\MyNotes\Scripts\create_daily_note.bat</Command>
```

### ✅ OpenDailyNote.xml

```xml
<Command>D:\MyNotes\Scripts\open_daily_note.bat</Command>
```

> ⚠️ XML 태그의 `<Name>` 등은 실제 타스크 이름인 `CreateDailyNote`, `OpenDailyNote`와 일치해야 정산적으로 등록됩니다.

---

## 🧹 3. 실행 순서

1. `.conf` 파일을 설정합니다.
2. `.xml` 파일을 설정하고 `<Command>` 태그에 `.bat` 경로를 입력합니다.
3. `register_tasks.bat`을 실행해 타스크를 Windows 작업 스켈준러에 등록합니다.

---

## 🖳️ 4. 타스크 해제

작업 스켈준러에서 타스크를 제거하려면 다음을 실행합니다:

```bat
unregister_tasks.bat
```

> 등록 및 해제 결과는 `LOG_PATH` 하위의 `scheduler_log.txt`에 기록됩니다.

---

이 문서는 GitHub 홈페이지에 `README.md`로 추가하여 사용법을 사용자에게 직관적으로 안내할 수 있습니다.
