# GreenBee Web/App separation and Independent Auth implementation plan

## 1. 개요 (Overview)
본 문서는 greenbee_beyond_space 프로젝트의 Master Admin Web과 Resident Mobile App을 완전히 분리하고, 각각 독립적인 로그인 시스템을 구축하기 위한 계획서입니다.

## 2. 분리 현황 (Current Status)
현재 다음과 같이 물리적 프로젝트 분리가 완료되었습니다.
- **Web Project**: `/web` (Project Name: `greenbee_web`)
  - Target: Web (Master Admin)
  - Entry: `web/lib/main.dart`
  - Router: `AdminRouter`
- **App Project**: `/app` (Project Name: `greenbee_app`)
  - Target: Mobile (iOS/Android)
  - Entry: `app/lib/main.dart`
  - Router: `ResidentRouter`

## 3. 핵심 구현 계획 (Core Implementation Plan)

### A. 독립 로그인 시스템 (Independent Authentication)
1. **Master Admin Web (`greenbee_admin`)**
   - **Login Logic**: 본사 관리자 전용 API(`/api/v1/auth/admin/login`) 연동 계획.
   - **Role**: `MASTER_ADMIN` 역할만 접근 가능하도록 필터링.
   - **Session**: Web 환경에 최적화된 토큰 관리 (Secure Storage/Session).
   
2. **Resident App (`greenbee_app`)**
   - **Login Logic**: 기존 입주민 로그인 체계 유지.
   - **Clean up**: Admin 관련 코드 및 UI 요소를 제거하여 앱 크기 최적화 및 빌드 속도 향상.

### B. UI/UX 보존 (Preserving Experience)
- **Resident App**: `Paperlogy` 폰트(Weight 500 이하) 및 기존 디자인 테마를 절대 변경하지 않음.
- **Admin Web**: 1440x900 기준의 데스크탑 최적화 UI 적용 (ScreenUtil 활용).

### C. 빌드 및 배포 프로세스 (Build & Deployment)
- **Web Build**: `flutter build web --target=lib/main.dart` (admin 디렉토리 기준)
- **App Build**: `flutter build apk/ipa --target=lib/main.dart` (app 디렉토리 기준)

## 4. 향후 작업 순서 (Next Steps)
1. [ ] 각 프로젝트별 `pubspec.yaml` 의존성 정리 (불필요한 패키지 제거)
2. [ ] `greenbee_admin` 전용 로그인 UI 및 API 연동 로직 구현
3. [ ] `greenbee_app` 내 Admin 관련 Router 및 Screen 제거
4. [ ] 독립 로그인 테스트 및 빌드 검증

---
**보고자: Antigravity (AI)**
**날짜: 2026-01-14**
