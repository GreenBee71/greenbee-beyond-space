#!/bin/bash
# build_admin_docker.sh
# Docker 컨테이너를 이용한 '격리 빌드' 스크립트
# 호스트 시스템을 오염시키지 않고, 일관된 환경에서 빌드합니다.

set -e

# --- Configuration ---
PROJECT_ROOT=$(pwd)
# We map 'web' logic to our source directory.
ADMIN_DIR="$PROJECT_ROOT/web"
BUILD_CONFIG_DIR="$PROJECT_ROOT/web"
DEST_DIR="$ADMIN_DIR/build/web"
IMAGE_NAME="greenbee_flutter_builder:stable"
CONTAINER_NAME="greenbee_ads_build_runner"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🐳 [Docker Build] Starting Isolated Build for GreenBee Beyond Space...${NC}"

# 1. Builder Image 확인 및 생성
if [[ "$(sudo docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo -e "${CYAN}>>> Builder 이미지가 없습니다. 새로 생성합니다... ($IMAGE_NAME)${NC}"
  sudo docker build -t $IMAGE_NAME -f "$BUILD_CONFIG_DIR/Dockerfile.build" "$BUILD_CONFIG_DIR"
else
  echo -e "${CYAN}>>> 기존 Builder 이미지를 사용합니다. ($IMAGE_NAME)${NC}"
fi

# 2. 결과물 디렉토리 준비
mkdir -p "$DEST_DIR"

echo -e "${CYAN}>>> Container 실행 및 빌드 시작...${NC}"
echo -e "${CYAN}    (호스트 소스 코드를 마운트합니다)${NC}"

# 3. Docker Run (일회용 컨테이너)
# --rm: 끝나면 자동 삭제
sudo docker run --rm \
  --name "$CONTAINER_NAME" \
  -v "$ADMIN_DIR:/app" \
  "$IMAGE_NAME" \
  /bin/bash -c "
    echo '>>> [Container] Flutter Clean...' && \
    flutter clean && \
    echo '>>> [Container] Getting Packages...' && \
    flutter pub get && \
    echo '>>> [Container] Building Web (Release)...' && \
    flutter build web --release --base-href '/greenbee_beyond_space/'
  "

# 4. 결과 확인
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker Build Success!${NC}"
    echo -e "${CYAN}    Files available at: $DEST_DIR${NC}"
    # 권한 보정 (Docker가 root로 생성했으므로 현재 사용자로 변경)
    sudo chown -R $(id -u):$(id -g) "$ADMIN_DIR/build" 2>/dev/null || true
else
    echo -e "${RED}❌ Docker Build Failed!${NC}"
    exit 1
fi
