# 입주민 앱(Resident App) 5대 핵심 기능 구현 계획서

## 1. 개요 (Overview)
현재 "껍데기(Shell)" 상태인 입주민 앱의 5대 핵심 기능을 활성화하여, 실제 백엔드 API와 연동된 완성형 앱으로 전환하기 위한 단계별 작업 계획입니다.

## 2. 현황 분석 (Current Status)
- **Frontend**: 메인 홈 화면(`ResidentHomePage`)에 아이콘만 존재하며, 클릭 이벤트(`onTap`)가 연결되지 않음.
- **Backend API**: `living.py` 등을 통해 핵심 기능에 대한 데이터 조회 API(`/challenges`, `/ev-chargers`, `/facilities`, `/deliveries` 등)는 이미 구현되어 있음.
- **결론**: 프론트엔드 UI 페이지 생성 및 API 바인딩 작업이 주된 과제임.

## 3. 단계별 상세 계획 (Phased Plan)

### 🚀 Phase 1: 연결 및 골격 완성 (Structure & Routing)
**목표**: 모든 홈 화면 아이콘 클릭 시, 해당 기능 페이지로 이동하도록 "길"을 뚫는 작업.
- [ ] **라우터 설정 (`resident_router.dart`)**: 
  - 미구현된 5개 기능에 대한 라우트 경로(`/energy`, `/ev`, `/doorstep`, `/share` 등) 정의.
- [ ] **빈 페이지(Scaffold) 생성**: 
  - `EnergyPage`, `EVCarePage`, `DoorstepManagerPage`, `GreenSharePage` 파일 생성 및 기본 UI 골격 작성.
- [ ] **홈 화면 연결**: 
  - `resident_home_page.dart`의 `onTap` 이벤트에 `context.push()` 연결.
- **기대 효과**: 사용자가 앱의 모든 기능을 탐색할 수 있게 됨 (빈 화면이라도 이동 가능).

### ⚡ Phase 2: 친환경 & 모빌리티 (Eco & Mobility)
**목표**: GreenBee의 핵심 가치인 "에너지 절약"과 "전기차" 기능 우선 구현.
- [ ] **에너지 절약 챌린지 (`EnergyPage`)**:
  - API: `GET /api/living/challenges`
  - UI: 나의 챌린지 달성 현황 그래프, 포인트 보상 내역 표시.
- [ ] **EV 스마트 케어 (`EVCarePage`)**:
  - API: `GET /api/living/ev-chargers`
  - UI: 실시간 충전소 점유 상태(사용중/대기중) 시각화, 충전 완료 알림 카드.

### 🏠 Phase 3: 생활 편의 (Living Convenience)
**목표**: 일상 생활의 편리함을 제공하는 "도어스텝" 및 "커뮤니티" 기능 구현.
- [ ] **도어스텝 매니저 (`DoorstepManagerPage`)**:
  - API: `GET /api/living/deliveries`, `GET /api/living/home-care`
  - UI: 탭(Tab) 구조로 택배, 세탁, 홈케어 요청 내역 통합 조회.
- [ ] **Live Hub 커뮤니티 (`CommunityFacilityPage`)**:
  - API: `GET /api/living/facilities`
  - UI: 커뮤니티 시설 목록(헬스장, 골프장 등) 및 실시간 혼잡도/예약 상태 표시.

### 🤝 Phase 4: 소셜 & 공유 (Social & Share)
**목표**: 입주민 간의 교류를 활성화하는 "그린 쉐어" 구현.
- [ ] **그린 쉐어 (`GreenSharePage`)**:
  - API: `GET /api/living/green-share` (또는 `talent-exchanges`)
  - UI: 물품 무료 나눔 및 재능 기부 게시글 리스트 (Card View), 채팅/신청 버튼.

## 4. 제안 작업 순서
가장 시각적 임팩트가 크고 시스템의 정체성을 보여주는 **Phase 1 (연결) -> Phase 2 (에너지/EV)** 순으로 진행하는 것을 추천합니다.
