# 1. 사용할 기본 이미지 설정
FROM nginx:latest

# 2. 작업 디렉토리 설정 (선택 사항)
WORKDIR /usr/share/nginx/html

# 3. 로컬 파일을 컨테이너 내로 복사
COPY index.html /usr/share/nginx/html/index.html

# 4. 기본 포트 설정 (선택 사항)
EXPOSE 80

# 5. 컨테이너 시작 시 실행될 명령어 (기본 설정으로 Nginx 실행)
CMD ["nginx", "-g", "daemon off;"]

