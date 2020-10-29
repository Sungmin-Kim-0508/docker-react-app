# as는 2번째 줄의 FROM 부터 다음 FROM 까지는 모두 Builder stage라는 것을 명시
FROM node:alpine as builder
WORKDIR '/usr/src/app'
COPY package.json .
RUN npm install
COPY ./ ./
# 생성된 빌드 파일과 폴더는 Working Directory에서 build 폴더로 들어간다.
# 즉 /usr/src/app/build로 들어간다.
RUN npm run build

FROM nginx
## --from=   --> 다른 Stage에 있는 파일을 복사할 때 다른 Stage 이름을 명시.
# --from=builder에서 builder는 위의 as builder에서 가져온 것
## /usr/src/app/build /usr/share/nginx/html
# builder stage에서 생성된 빌드 파일을(/usr/src/app/build) 이 장소에다가(/usr/share/nginx/html) 복사 시켜줌.
# 빌드파일들을 /usr/share/nginx/html에 복사시켜주는 이유는 이 장소로 파일을 넣어 두면 Nginx가 알아서 Client 요청이 드러올때 알맞은 정적 파일들을 제공.
# nginx의 경로 /usr/share/nginx/html 는 Dockerhub 공식 문서에 나와있음.
COPY --from=builder /usr/src/app/build /usr/share/nginx/html