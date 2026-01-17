# 입주민 앱 IoT 등록 페이지 UI/UX 개선 계획

## 🚨 문제점 진단 (Diagnosis)
1. **네비게이션 구조 이탈**: `IoTRegistrationPage` (`/iot-registration`)가 현재 `ResidentShellPage` (하단 네비게이션 바 포함)의 **외부**에 별도의 독립 라우트로 설정되어 있습니다.
    *   이로 인해 페이지 진입 시 하단 바가 사라지고, 전체 화면을 덮는 '모달(Modal)'처럼 동작합니다.
2. **뒤로가기/닫기 UX 불편**: 시스템 뒤로가기 제스처나 버튼이 예상대로 동작하지 않으며, 앱의 통일된 네비게이션 경험을 해치고 있습니다.

## 🛠️ 작업 계획 (Action Plan)

### 1단계: 라우팅 구조 변경 (Router Refactoring)
*   **목표**: IoT 등록 페이지에서도 하단 탭바(Bottom Navigation)가 유지되어야 함.
*   **작업 내용**:
    *   `/lib/core/router/resident_router.dart` 수정.
    *   `GoRoute(path: '/iot-registration', ...)` 항목을 `ShellRoute`의 `routes` 리스트 내부로 이동시킵니다.

### 2단계: 페이지 UI 튜닝 (UI Adjustment)
*   **목표**: `Shell` 내부로 들어왔을 때, 이중 헤더(App Bar)가 생기거나 레이아웃이 깨지지 않도록 조정.
*   **작업 내용**:
    *   `IotRegistrationPage`에서 자체적으로 사용 중인 `Scaffold` 및 `AppBar`(상단 'X' 버튼 포함)를 확인하고, 입주민 앱 표준 헤더 스타일과 어울리도록 조정합니다.
    *   필요시 최상단 'X' 닫기 버튼 대신, 페이지 타이틀과 백 버튼을 사용하는 구조로 변경을 고려합니다.

## 📝 예상 결과 (Expected Outcome)
*   IoT 기기 등록 화면에서도 **하단 메뉴바**가 항상 표시됩니다.
*   다른 탭(홈, 센터, MY)으로 언제든지 자유롭게 이동 가능해집니다.
*   "뒤로가기" 동작이 앱의 기본 네비게이션 스택을 따르게 됩니다.

## 📅 진행 순서
1.  **라우터 코드 수정** (즉시 적용 가능)
2.  **페이지 UI 다듬기** (라우터 변경 후 어색한 부분 수정)
3.  **빌드 및 배포**
