#!/bin/bash
# build_admin_docker.sh
# Docker 컨테이너를 이용한 '격리 빌드' 스크립트
# 호스트 시스템을 오염시키지 않고, 일관된 환경에서 빌드합니다.

set -e

# --- Configuration ---
PROJECT_ROOT=$(pwd)
ADMIN_DIR="$PROJECT_ROOT/admin"
BUILD_CONFIG_DIR="$PROJECT_ROOT/service/docker/admin_build"
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
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo -e "${CYAN}>>> Builder 이미지가 없습니다. 새로 생성합니다... ($IMAGE_NAME)${NC}"
  docker build -t $IMAGE_NAME -f "$BUILD_CONFIG_DIR/Dockerfile.build" "$BUILD_CONFIG_DIR"
else
  echo -e "${CYAN}>>> 기존 Builder 이미지를 사용합니다. ($IMAGE_NAME)${NC}"
fi

# 2. 결과물 디렉토리 준비
mkdir -p "$DEST_DIR"

# 3. Argument Parsing
CLEAN_BUILD=false
for arg in "$@"; do
  if [ "$arg" == "--clean" ]; then
    CLEAN_BUILD=true
  fi
done

# 4. Docker Run (일회용 컨테이너)
echo -e "${CYAN}>>> Container 실행 및 빌드 시작... (Incremental mode)${NC}"

# Define the build command
BUILD_CMD=""
if [ "$CLEAN_BUILD" = true ]; then
  echo -e "${RED}>>> [Full Build] cleaning project...${NC}"
  BUILD_CMD="flutter clean && "
fi

BUILD_CMD="${BUILD_CMD}echo '>>> [Container] Getting Packages...' && \
    flutter pub get && \
    echo '>>> [Container] Building Web (Release)...' && \
    flutter build web --release --target lib/main.dart --base-href '/greenbee_beyond_space/'"

docker run --rm \
  --name "$CONTAINER_NAME" \
  -v "$ADMIN_DIR:/app" \
  "$IMAGE_NAME" \
  /bin/bash -c "$BUILD_CMD"

# 4. 결과 확인
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker Build Success!${NC}"
    echo -e "${CYAN}    Files available at: $DEST_DIR${NC}"
    
    GATEWAY_DIR="../greenbee_gateway/html/greenbee_greenbee_beyond_space_admin"
    if [ -d "$GATEWAY_DIR" ]; then
        echo -e "${CYAN}>>> 게이트웨이로 파일 배포 중...${NC}"
        # Copy built files to gateway directory
        rsync -av --delete "$DEST_DIR/" "$GATEWAY_DIR/"
        echo -e "${GREEN}✅ 배포 완료!${NC}"
    else
        echo -e "${RED}⚠️  게이트웨이 디렉토리를 찾을 수 없습니다: $GATEWAY_DIR${NC}"
    fi
else
    echo -e "${RED}❌ Docker Build Failed!${NC}"
    exit 1
fi
