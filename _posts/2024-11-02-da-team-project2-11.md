---
#layout: post
title: 채용플랫폼 이용패턴 분석 팀프로젝트11 - 가설 검증
date: 2024-11-02
description: # 검색어 및 글요약
categories: [Data_analysis, Team_project2]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Data_analysis
- 
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---

> **최종 분석 주제 : 채용 플랫폼 구직자 이탈 감소를 위한 검색 필터 A/B 테스트 제안**  

### 오늘 할 일

- [x]  가설 검증 및 인사이트 도출 : 구직자의 필터별 지원서 제출 전환율이 다를것이다
    - [x]  코드 구축후 분석결과를 통해 인사이트 도출
- [ ]  퍼널 외 분석 진행
    - [ ]  획득 관점 분석 아이디어 수립후 인사이트 도출
    - [ ]  리텐션 관점 분석 아이디어 수립후 인사이트 도출
    - [ ]  수익 관점 분석 아이디어 수립후 인사이트 도출

### 오늘 한 일

1. 가설 검증 및 인사이트 도출 : 구직자의 필터별 지원서 제출 전환율이 다를것이다
    - 분석결과를 팀원 각자 해석후 공유 → 제안 도출

### 내일 할 일

- [ ]  가설 인사이트 도출 마무리 : 시각화 가능한 부분 만들어보기
- [ ]  퍼널 외 분석 진행
    - [ ]  획득 관점 분석 아이디어 수립후 인사이트 도출
    - [ ]  리텐션 관점 분석 아이디어 수립후 인사이트 도출
    - [ ]  수익 관점 분석 아이디어 수립후 인사이트 도출

---

### Issues & Challenges

### 가설 검증 및 인사이트 도출

- 수립한 가설 : **구직자의 필터별 지원서 제출 전환율이 다를것이다**
- 분석 결과   

| 필터 조건 | 설명 | 채용공고조회 고유 유저수 **(C)** | 필터링 유저수 (필터 O) **(B)** | 전환율 **(B/C) 필터링 선호도** | 순위 | 필터 조건 | 순위 | 지원서 제출한 고유 유저수 (필터O) **(A)** | 최종 전환율 | (필터 O) **(A/B)** |
| ------------------ | --------------- | ------ | ----- | ------ | --- | ------------ | --- | ---- | ------ |
| job                | 업무 분야(1~10) | 15,687 | 12204 | 77.80% | 1   | job          | 11  | 8234 | 67.47% |
| specialty          | 활동 분야       | 15,687 | 5670  | 36.14% | 4   | specialty    | 5   | 4313 | 76.07% |
| career_type        | 경력(0&1&2)     | 15,687 | 7892  | 50.31% | 2   | career_type  | 4   | 6132 | 77.70% |
| location           | 지역            | 15,687 | 5882  | 37.50% | 3   | location     | 6   | 4442 | 75.52% |
| remote             | 근무 조건(0&1)  | 15,687 | 1031  | 6.57%  | 10  | remote       | 9   | 727  | 70.51% |
| language           | 언어            | 15,687 | 534   | 3.40%  | 11  | language     | 1   | 452  | 84.64% |
| salary             | 연봉            | 15,687 | 1458  | 9.29%  | 7   | salary       | 10  | 1004 | 68.86% |
| stock              | 스톡 옵션       | 15,687 | 1071  | 6.83%  | 9   | stock        | 8   | 763  | 71.24% |
| hiring_types       | 고용 형태       | 15,687 | 1453  | 9.26%  | 8   | hiring_types | 7   | 1069 | 73.57% |
| tag                | 산업            | 15,687 | 4283  | 27.30% | 6   | tag          | 3   | 3350 | 78.22% |
| sort               | 정렬 기준       | 15,687 | 4988  | 31.80% | 5   | sort         | 2   | 3904 | 78.27% |

![image.png](/assets/img/team_project2/2-11/1.png)

- **분석 결과 팀원별 해석**
    - 나의 해석 및 제안
        - 채용공고조회를 이용하는 유저 10명 중 9명은 `(원격)근무 조건`, `언어`, `연봉`, `스톡 옵션`, `고용 형태` 필터를 사용하지 않는다.
            - 다만, 유저 10명 중 6명은 원하는 필터링을 사용하면 지원서 제출까지 도달하는것으로 관찰됨
        - 언어 필터(language)를 사용하는 유저수는 적지만, 해당필터를 사용하는 유저는 지원서 제출까지 전환율이 제일 높게 관찰됨
            - 특정 언어능력을 가진 구직자들이 지원서 제출에 더 적극적인 경향을 나타냄
            - 언어필터가 인기없다고 삭제하는것보다, 채용기관에게 채용공고 분류를 좀 더 명확하게 사용하도록 유도(필터를 자주사용하도록)
                - ex) 외국어 능력자가 필요한 채용기관에게 “채용 공고 등록시 필터를 사용하면 원하는 구직자를 만날 확률이 올라간다”
            - 그래도 언어필터를 사용하는 유저 자체가 적은데 필터를 넣는게 맞을까?
        - 업무 분야(job) 필터를 사용하는 유저수는 가장 많지만, 해당필터를 사용하는 유저는 지원서 제출까지 전환율이 가장 낮게 관찰됨
            - 유저가 제일 많이사용하는 필터링이기 때문에 이탈율또한 가장 높게나올것이다?
            - 업무 분야 필터를 구직시 가장 중요한 필터로 판단하고 사용했으나, 업무 분야가 구직자가 원하는 세분화가 이루어지지 않아 이탈했을 것이다
            - 업무 분야별 채용공고 수 자체가 적어서 필터링이 의미가 없어져 이탈했을 것이다
        - 산업(tag) 필터를 사용하는 유저들은 지원서 제출까지 전환율이 높은 것으로 관찰됨
        - **제안**
            - 채용페이지에서 필터 조건 사용시, 필터링 선호도(채용공고조회를 이용하는 유저 중 자주사용하는 필터) 기준으로 순서를 바꾸는 A/B 테스트 제안
                
                ![image.png](/assets/img/team_project2/2-11/2.png)
                
            - 필터 제거(간소화) 검토(11개 → n개) : 10명 중 9명이 사용안하는 필터 `(원격)근무 조건`, `언어`, `연봉`, `스톡 옵션`, `고용 형태` 중 제거 검토
                - 다만 필터를 사용했다면(10명 중 1명에 속하는 유저), 사용한 유저 중에서는 10명 중 약 7명은 지원서 제출로 도달함
                - `언어(language)`를 제외하고는 해당 필터를 사용하는 유저들의 지원서 제출 전환율은 낮게 관찰됨 (하지만 상대적으로 낮을뿐 10명 중 7명은 지원서 제출 함)
                    
                    ![image.png](/assets/img/team_project2/2-11/3.png)
                    
            - 업무 분야(job) 세부 조건 검토 : 구직자가 자주 사용하지 않거나, 채용공고가 없는 세부 업무 분야를 통합or제거 검토(ex : job=3, job=4 통합 or 제거)
            
- **가설 검증에 따른 제안**
1. 개인화된 필터링 채용 공고 추천
2. 필터링 순서 변경
3. 필터링 세부분류 변경 : 필터링, sort 변경

---

1) **개인화된 필터링 채용 공고 추천 : 인적성 검사 서비스 제공 등 구직자 정보를 수집할 수 있는 서비스를 제공하여 개인화된 필터링 채용 공고 추천 제안**
    - 인적성 검사 서비스 자체 개발 대신, 전문기관과 제휴를 통한 양질의 구직자 정보 수집

---

- **필터링 관련 제안**
    
    ![image.png](/assets/img/team_project2/2-11/4.png)
    
    - **전제조건 : sort 제외 모든 필터는 리스트형태를 나타낼것이다**    

2) **필터링 순서 변경 : 선호도 + 구직자 심리(채용플랫폼 이용시 필터사용흐름) + 구직자 강점**    
 - 필터별 중복선택 가능하도록 개선    
 - 필터 제거(간소화) 검토(10개 → 8개) : 10명 중 9명이 사용안하는 필터 `(원격)근무 조건`, `언어`, `연봉`, `스톡 옵션`, `고용 형태` 중 제거 검토   
   - remote(원격근무) → hiring_types 통합   
   - stock(스톡옵션) → sort로 이동(체크박스 형식)   
 - 논의된 순서 **채용페이지 필터링순서(개선안)**        

    | **최종 순위** | **필터 조건** | **선호도 순위** | **최종 전환율 순위** | **순위 평균** |
    | ------------- | ------------- | --------------- | -------------------- | ------------- |
    | 1             | job           | 1               | 8                    | 5             |
    | 2             | career_type   | 2               | 3                    | 3             |
    | 3             | tag           | 5               | 2                    | 4             |
    | 5             | location      | 3               | 5                    | 4             |
    | 4             | specialty     | 4               | 4                    | 4             |
    | 8             | salary        | 6               | 7                    | 7             |
    | 7             | hiring_types  | 7               | 6                    | 7             |
    | 6             | language      | 8               | 1                    | 5             |   

    - 최종 순위 : (선호도 순위 + 최종전환율 순위)/2
        - 단, 선호도 순위 1위는 최우선 순서로 결정함
        - 평균 순위가 동일할 경우, 최종 전환율 순위가 높은 순서대로 순위를 결정함
    - 제거 된 필터 : remote, stock
        - remote : hiring_types 세부분류로 이동
        - stock : sort 체크박스로 이동
    - sort는 필터 순서 외 분류(stock 필터 포함)

- **최종 순위**
    
    
    | **개선전**   | **개선후**   | **개선후(순위)** |
    | ------------ | ------------ | ---------------- |
    | job          | job          | 1                |
    | specialty    | career_type  | 2                |
    | career_type  | tag          | 3                |
    | location     | specialty    | 4                |
    | remote       | location     | 5                |
    | language     | language     | 6                |
    | salary       | hiring_types | 7                |
    | stock        | salary       | 8                |
    | hiring_types |              |                  |
    | tag          |              |                  |
    | sort         |              |                  |
    |              |              |                  |
    
    ---
    
3) **필터링 세부분류 변경** : 예를들어, 업무 분야(job)에서 구직자가 자주 사용하지않거나, 채용공고가 없는 세부 업무 분야를 통합or제거 검토(ex : job=3, job=4 통합 or 제거) 
 - 데이터상 필터링 별 세부분류 확인 : 채용공고 job 데이터 테이블에서 job_field 컬럼 확인
 
 1. Job(업무분야) 세부분류 변경 (4개 조정)
     - Job 의 필터 선호도는 높지만(1등), 최종 전환율은 낮다(꼴찌) → Job 세부분류 변경
         - SW 개발
         - HW 개발
         - 게임 개발 → 이미 상위 업무 분야인 `SW개발`과 `HW개발` 이 존재함 → tag(산업) 필터 이동이 더 적절해보임
         - 디자인
         - 기획/PM
         - 마케팅
         - 운영 → CS (좀 더 명확한 분야명 표기)
         - 경영지원
         - 비즈니스 → 영업 (좀 더 명확한 분야명 표기)
         - 투자 → 제거
             - 필터를 사용한 유저는 74명으로 전체 필터링 이용 유저수의 0.005% 밖에 안됨 (74/15687)
             - job(채용공고) + application(지원서) 마스터 테이블 상으로도 0.0025% 유저만 투자 채용공고 지원한것으로 관찰됨
 
 
 2. career_type(경력) 필터 세부분류 변경 : 경력 세분화
     - 채용공고의 경우 필요경력을 년도로 기재하지 않아 검색시 구직자가 원하는 경력년도를 반영해서 검색할 수가 없어 개선이 필요해 보임
     - 기존 : 인턴, 신입, 경력
         - 경력의 범위가 너무 넓음 → 세분화 필요
         - 경력 채용 공고의 수가 압도적으로 많음(92.4%) - 세분화 필요
         - 경력1년차와 10년차의 업무경험과 연봉이 너무나도 차이나는데 묶여져있음
     - 개선안 : 인턴, 신입, 1년이상경력, 3년이상경력, 5년이상경력, 7년이상경력 세부분류 추가
 3. remote필터 → hiring_types 필터로 결합 : 
     - remote 구직자의 필터 사용 빈도가 낮고(6.5%) 선택옵션이 여/부 1개밖에 없고, hiring_type(고용형태) 세부분류에 속하는게 더 적합하다 판단하여 이동
         1. remote 필터 제거
         2. 고용 형태 hiring_type에 remote(원격 근무) 추가
 4. stock 필터를 sort로 이동 : 
     1. 구직자 채용플랫폼 이용시 스톡옵션 필터링 사용을 잘안하고(7%), 타 채용플랫폼에서도 스톡옵션이 검색옵션에 없음
     2. 구직자 입장에선 스톡옵션을 몇% 제공하는지보다 제공여부를 먼저 파악하고 싶을 것
     3. 제공 여부(이진 선택) 옵션이므로 sort 옆으로 이동하여 체크박스 옵션으로 제공

### 앞으로 해야할 일

- 가설 인사이트 도출 마무리 : 시각화 가능한 부분 만들어보기
- 퍼널 외 분석 진행
    - 획득 관점 분석 아이디어 수립후 인사이트 도출
    - 리텐션 관점 분석 아이디어 수립후 인사이트 도출
    - 수익 관점 분석 아이디어 수립후 인사이트 도출

### Reflection

- 이번주에 많은 회의들이 있었고, 사실상 하루에 마이크를 키지않은 시간이 1시간을 넘긴날이 없었다. 여러의견들이 오가면서 진행이 더딘부분도 있었지만 한 주를 마감해보니 가설을 수립하고 검증까지 완료한 후 제안까지 도출하였다. 이런저런 일들이 있었지만 항상 결과는 좋았다로 마무리 될 수 있어 다행이면서도 팀원들이 적극적으로 참여해줘서 얻은 결과라 더 기쁘다. 지금의 흐름대로라면 남은기간동안 팀프로젝트를 성공적으로 마무리 할 것으로 기대한다. 전반적으로 우리가 진행한 프로젝트가 지금까지 배운 분석기법들(AARRR, 퍼널, A/B테스트 등)과 프로젝트 과정중에서 배운 지식들(로그분석)이 적절하게 섞여서 결과물을 창출하고있어 뿌듯하다. 하루종일 떠들다보니 얻어가는 것들이 상당하고, 팀원들이 항상 열심히 따라오고 있는게 느껴져서 생각보다 지치지도 않는다. 남은 일정들도 팀원들이 바라는 결과가 나올 수 있게 일단 최선을 다해보자.