# 수식과 자동화

> **이 장에서 배우는 것:** Notion 데이터베이스가 자동으로 계산하고, 필터링하고, 연결되게 만드는 방법 — 세 가지 기본 요소부터 Formula 2.0 패턴, 관계 자동화까지.
>
> - 세 가지 기본 요소: `empty()`, `not`, `and`
> - Formula 2.0 기능: `let`, `lets`, `filter`, `match`, `ifs`, `dateRange`
> - 관계 자동화 패턴 (플랫폼 비의존적)
> - 유지보수 가능한 수식을 위한 실전 팁

**함께 읽기:** [설계 방법론](./design-methodology.md) — 이 수식들이 작동하는 데이터베이스 아키텍처. · [원칙](./principles-and-antipatterns.md) — 자동화를 이끄는 "일이 되지 않게" 원칙.

---

## 목차

- [Formula 2.0 — 무엇이 바뀌었나](#formula-20--무엇이-바뀌었나)
- [세 가지 기본 요소](#세-가지-기본-요소)
- [주요 함수](#주요-함수)
- [관계 자동화](#관계-자동화)
- [팁](#팁)

---

Notion 데이터베이스는 자동으로 계산하고, 필터링하고, 연결될 때 강력해집니다. 대부분의 사람들은 "행을 저장하고 정렬하기"에서 시작하지만, 진짜 레버리지는 수식이 반복적인 판단을 제거하고 관계가 수동 작업이 아니게 될 때 나타납니다.

핵심 마인드셋은 심플합니다:

1. **로직을 작고 테스트 가능한 조각으로 작성하십시오** (하나의 거대한 표현식이 아니라).
2. **Formula 2.0 기능으로 반복을 줄이십시오** (`let`, `lets`, 리스트 연산).
3. **프로세스 수준에서 관계 연결을 자동화하십시오** — 수식이 항상 연결된 데이터를 갖도록.

이 세 가지가 갖춰지면, 데이터베이스는 정적 테이블처럼 행동하는 것을 멈추고 경량 로직 엔진처럼 작동하기 시작합니다.

---

## Formula 2.0 — 무엇이 바뀌었나

Formula 2.0은 **표현력**과 **유지보수성** 모두를 개선했습니다. 가독성을 잃지 않고 더 긴 수식을 작성할 수 있고, 관련 데이터를 더 직접적으로 쿼리할 수 있습니다.

| 영역 | Formula 1.0 | Formula 2.0 | 왜 중요한가 |
|---|---|---|---|
| 작성 방향 | 수평, 스프레드시트형 | 수직, 코드형 | 스캔, 들여쓰기, 디버깅이 쉬움 |
| 주석 | 불가 | 가능 | 복잡한 로직 안에 의도를 기록 |
| 변수 | 불가 | `let()` / `lets()` | 중간 값 재사용 |
| Rollup 의존도 | 높음 | 낮음 (관계 리스트 직접 접근) | 헬퍼 속성 감소, 스키마 간결화 |
| 타입 혼합 | 엄격하고 불편 | 더 유연 | 라벨 + 숫자 조합이 깔끔 |
| 배열 / 리스트 | 제한적 | 일급 지원 (`filter`, `map` 등) | 수식 내 강력한 관계 분석 |

> [!TIP]
> **빠른 자가 점검:** 수식이 같은 관계 탐색을 3번 이상 반복한다면 → `let` 변수로 옮기십시오. 헬퍼 속성이 필요했다면 → Formula 2.0으로 통합할 수 있을 겁니다. 팀이 수식을 읽지 못한다면 → 주석 + 수직 포맷팅으로 해결하십시오.

---

## 세 가지 기본 요소

고급 함수 전에, 이 세 가지 원시 요소를 마스터하십시오. 대부분의 검증 및 분류 로직을 처리하기에 충분합니다.

### 1) `empty(value)` — 누락된 입력 감지

```javascript
empty(prop("Credit"))  // true when no value is present
```

> [!NOTE]
> 숫자: `0`은 empty로 취급됩니다. 텍스트: `""`은 empty로 취급됩니다.

### 2) `not(boolean)` — 조건 반전

"값이 있다" 패턴:

```javascript
not(empty(prop("Credit")))  // "Credit field is not empty"
```

불리언 값에만 작동합니다 — 숫자, 텍스트, 날짜에 직접 `not`을 사용할 수 없습니다.

### 3) `and(conditionA, conditionB)` — 엄격한 조건 결합

> [!WARNING]
> **`and()`는 정확히 2개의 인자만 받습니다.** 이것이 초보자가 가장 많이 겪는 오류입니다. 3개 이상의 조건은 중첩하십시오:
> ```javascript
> and(cond1, and(cond2, cond3))  // ✅ 올바름
> and(cond1, cond2, cond3)       // ❌ "Too many arguments" 오류
> ```

---

### 실전 예제: 결제 수단 자동 감지

세 가지 속성: `Cash` (체크박스), `Credit` (텍스트), `Bank` (텍스트).

목표: 어떤 결제 수단이 사용되었는지 자동 감지하고, 충돌을 잡아냅니다.

<details>
<summary>전체 수식 (클릭하여 펼치기)</summary>

```javascript
ifs(
  and(prop("Cash"), and(empty(prop("Credit")), empty(prop("Bank")))),
    "💵 Cash",
  and(not(prop("Cash")), and(not(empty(prop("Credit"))), empty(prop("Bank")))),
    "💳 Credit Card",
  and(not(prop("Cash")), and(empty(prop("Credit")), not(empty(prop("Bank"))))),
    "🏦 Bank Transfer",
  and(not(prop("Cash")), and(empty(prop("Credit")), empty(prop("Bank")))),
    "",
  "❌ Error"
)
```

</details>

이 패턴은 두 가지 습관을 가르칩니다:
1. **명시적 배타성** — 각 유효한 케이스가 다른 입력을 차단합니다.
2. **최종 캐치올** (`"❌ Error"`) — 모순된 입력이 조용히 무시되지 않고 잡힙니다.

> [!NOTE]
> **핵심 포인트:** 모든 조건부 수식에는 캐치올 분기가 있어야 합니다. 조용한 실패가 최악의 실패입니다.

---

## 주요 함수

Formula 2.0은 반복 로직을 극적으로 줄이는 함수들을 추가합니다.

### `let` / `lets` — 명명된 변수

한 번 계산하고, 어디서든 재사용:

```javascript
let(doneCount,
  prop("Tasks").filter(current.prop("Status") == "Done").length,
  "Done: " + doneCount
)
```

`lets`로 여러 변수 사용:

```javascript
lets(
  total, prop("Tasks").length,
  done, prop("Tasks").filter(current.prop("Status") == "Done").length,
  if(total == 0, "No tasks", format(round(done / total * 100)) + "% complete")
)
```

### `filter(list, condition)` — 관련 리스트 부분집합 추출

```javascript
prop("Tasks").filter(current.prop("Status") == "Done").length
// → Count completed items from a related tasks list

prop("Tasks").filter(current.prop("Priority") == "High").map(current.prop("Title"))
// → Return only high-priority task names
```

### `match(array, pattern)` — 일치하는 항목 찾기

```javascript
match(prop("Tags"), "bug").length
// → Count tags containing "bug"

if(match(prop("Keywords"), "urgent").length > 0, "🔥 Action now", "")
// → Trigger warning label if urgency keyword appears
```

### `ifs(c1, v1, c2, v2, ..., default)` — 깔끔한 다중 조건문

깊게 중첩된 `if()` 체인을 대체합니다:

```javascript
ifs(
  prop("Score") >= 90, "A",
  prop("Score") >= 80, "B",
  prop("Score") >= 70, "C",
  "Needs Review"
)
```

### `dateRange(start, end)` — 날짜 범위 생성

```javascript
dateRange(prop("Start Date"), prop("End Date"))
// → Single timeline-ready period from two dates

let(endDate, dateAdd(prop("Start Date"), 6, "days"),
  dateRange(prop("Start Date"), endDate)
)
// → Auto-generate one-week windows from a start date
```

---

## 관계 자동화

대부분의 팀이 같은 병목에 부딪힙니다: 관계 필드는 강력하지만, 수동으로 레코드를 연결하는 것은 확장되지 않습니다.

> [!WARNING]
> 데이터 볼륨이 커지면 사용자가 행을 연결하는 것을 잊고, 수식이 맥락을 잃고, 리포팅이 일관성을 잃습니다. 수동 관계는 확장성 함정입니다.

### 패턴 (플랫폼 비의존적)

```text
제출 이벤트
    ↓
고유 키로 대상 DB 검색
    ↓
┌─────────────────────┐
│ 대상이 존재하는가?    │
├─── YES → 재사용     │
├─── NO  → 생성       │
└─────────────────────┘
    ↓
메인 레코드에서 확인된 대상으로 관계 연결
    ↓
관련 차원마다 반복 (사람, 회사, 카테고리...)
```

### 설계 원칙

- **안정적인 키를 사용**하여 조회 (slug, 이메일, ID, 정규화된 이름)
- **조회와 생성을 분리**하여 흐름을 감사 가능하게
- **누락/모호한 키를 명시적으로 처리** (폴백 큐 또는 리뷰 상태)
- **관계 쓰기를 멱등적으로 유지** (재실행해도 중복이 생기지 않도록)

> [!NOTE]
> 구현 도구가 바뀌더라도 이 패턴은 동일하게 유지됩니다. 중요한 것은 의사결정 로직이지, 플랫폼이 아닙니다.

---

## 팁

> [!TIP]
> **조각으로 만드십시오.** 20줄짜리 수식을 한 번에 쓰지 마십시오. 작은 덩어리를 만들고 테스트하십시오: 원시 조건 → 하나의 분기 → 추가 분기 → 오류/기본값.

| 팁 | 이유 |
|-----|-----|
| 조각으로 만들기 | 구문 오류를 줄이고 리뷰를 빠르게 함 |
| "완료 버튼" 테스트 사용 | 완료 흐름이 깨지면 가장 최근 수식 변경을 먼저 점검 |
| 출력 라벨에 이모지 (`✅`, `⏳`, `❌`) | 밀도 높은 테이블에서 인지 부하를 줄이는 작은 시각적 단서 |
| 3개 이상 조건은 `and()` 중첩 | 우회가 아닌 구조적 규칙 — `and(c1, and(c2, c3))` |
| 반복 패턴에 `lets()` 사용 | 표현식 감소, 편집 용이, 의도 명확 |

---

> [!NOTE]
> **진행 순서:** `empty/not/and` 마스터 → Formula 2.0 패턴 도입 (`let`, `lets`, 리스트 함수) → 관계 자동화 적용. 이 조각들이 갖춰지면, 데이터베이스는 수동적인 기록 저장소가 아니라 신뢰할 수 있는 운영 시스템이 됩니다.
>
> **함께 읽기:** [설계 방법론](./design-methodology.md) — 이 수식들이 구동하는 데이터베이스 패턴. · [원칙](./principles-and-antipatterns.md) — 이 모든 것을 이끄는 "일이 되지 않게" 원칙.
