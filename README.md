# Biz-able Backend
## Biz-able?
- 모바일 배치 관리 시스템
- 필터를 통한 배치 내역 조회 및 비상연락망 기능 수행
</br>

## 담당 업무
- EC2, RDS 연동 및 Node.js 기반 API 서버 개발
</br>

## API 레퍼런스
- postman 링크 
- 로그인 API 샘플(res&req)

## 구현 기술
### Authorization
- client에서 로그인 API 호출 시 jwt 발급&리턴
- 이후 모든 서비스 API 호출 시 auth 미들웨어를 통해 jwt 검증
### Paging
- 앱 UI 고려, 매 요청 마다 10개의 레코드 반환
### Data Binding
- sql 인젝션 방지를 위해 prepared statements&data binding으로 보안성 강화
