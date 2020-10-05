# Biz-able Backend
## Biz-able?
- 모바일 배치 관리 시스템
- 업무시간 외, 외부망을 통해 조회 가능한 장점
- 필터를 통한 배치 내역 조회 및 비상연락망 기능 수행
</br>

## 아키텍처
![architecture](https://github.com/daysiee/kb-biz-able-backend/blob/master/%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98.jpg)
</br>

## 담당 업무
- EC2, RDS 연동 및 Node.js 기반 API 서버 개발
</br>

## API 레퍼런스
- [레퍼런스 링크](https://documenter.getpostman.com/view/10284982/T1LV9Phh)
- 로그인 API 샘플</br>
![req](https://github.com/daysiee/kb-biz-able-backend/blob/master/login_req.jpg)
![res](https://github.com/daysiee/kb-biz-able-backend/blob/master/login_res.png)

## 구현 기술
### Authorization
- client에서 로그인 API 호출 시 jwt 발급&리턴
- 이후 모든 서비스 API 호출 시 auth 미들웨어를 통해 jwt 검증
### Paging
- 앱 UI 고려, 매 요청 마다 10개의 레코드 반환
### Data Binding
- sql 인젝션 방지를 위해 prepared statements&data binding으로 보안성 강화
</br>
