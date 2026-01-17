# 입주민 앱 UI/UX 긴급 보완 계획 (Fix Plan)

## 🚨 문제점 진단 (Diagnosis)
1. **폰트 불일치**: 새로 추가된 페이지들(`GridMenu`로 연결된 기능)이 전사 표준 폰트인 **'Paperlogy'**를 사용하지 않고 시스템 기본 폰트로 렌더링되고 있음.
2. **반응형 스케일링 미적용**: `ScreenUtil` (`.w`, `.h`, `.sp`, `.r`)이 제대로 적용되지 않아, 해상도에 따라 UI 요소들의 크기가 부자연스럽거나 너무 작게 표시됨.
3. **API 연결 오류 (404 Not Found)**: 일부 신규 기능(특히 그린 쉐어) 요청 시 404 에러 발생. API 엔드포인트 경로 불일치 추정.

## 🛠️ 작업 계획 (Action Plan)

### 1단계: 디자인 시스템 및 폰트 강제 적용 (Design System & Typography)
*   **목표**: 모든 신규 페이지에 'Paperlogy' 폰트와 올바른 반응형 단위를 적용.
*   **작업 내용**:
    *   `AppTheme` 테마 설정 재검토 및 `fontFamily: 'Paperlogy'`가 전역적으로, 그리고 개별 위젯 `Style`에 명시적으로 적용되었는지 확인.
    *   새로 생성한 5개 페이지(`EnergyChallengePage`, `EVCarePage`, `DoorstepManagerPage`, `CommunityLiveHubPage`, `GreenSharePage`)의 모든 `Text` 스타일과 컨테이너 사이즈를 `ScreenUtil` 단위로 전면 교체.
        *   `fontSize: 16` -> `fontSize: 16.sp`
        *   `height: 50` -> `height: 50.h`
        *   `radius: 8` -> `radius: 8.r`

### 2단계: API 경로 정합성 검증 (API Connectivity)
*   **목표**: 404 에러 해결.
*   **작업 내용**:
    *   `LivingService` 및 `DioClient`의 엔드포인트 경로 재확인.
    *   백엔드(`living.py`) 실제 라우트 경로와 프론트엔드 호출 경로(`dio.get('/living/share-items')`)가 일치하는지 대조.

### 3단계: 최종 검증 (Validation)
*   **목표**: 일관된 UI와 기능 작동 확인.
*   **작업 내용**:
    *   로컬 빌드 후 브라우저 개발자 도구로 폰트 로딩 확인.
    *   다양한 해상도 시뮬레이션으로 UI 깨짐 없는지 확인.
    *   API 호출 정상 응답(200 OK) 확인.

## 📝 우선순위 작업 순서
1.  **UI/UX 코드 수정**: 5개 신규 페이지 코드 전면 수정 (폰트 및 반응형 단위 적용).
2.  **API 경로 수정**: 404 에러 원인 파악 및 수정.
3.  **재배포**: 수정 사항 반영하여 빌드 및 배포.
