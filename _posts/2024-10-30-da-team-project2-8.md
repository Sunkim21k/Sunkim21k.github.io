---
#layout: post
title: 채용플랫폼 이용패턴 분석 팀프로젝트8 - 데이터 이슈 발생
date: 2024-10-30
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

- [x]  가설 수립 및 검증 : 전환율을 개선하고싶은 퍼널 선택 후 가설 설정해보기

### 오늘 한 일

1. 가설 수립 및 검증 : 전환율을 개선하고싶은 퍼널 선택 후 가설 설정해보기
    - 설정한 가설을 팀원이 나눠서 EDA 진행후 내용 공유
    - 가설 검증과정에서 이슈 사항들 공유

### 내일 할 일

- [ ]  가설 수립 및 검증 : 전환율을 개선하고싶은 퍼널 선택 후 가설 설정해보기 (계속)
    - [ ]  사용할 데이터 범위 정하기
        - [ ]  퍼널 설정 재검토 (필요시)
        - [ ]  가설 설정해보기

---

### Issues & Challenges

### 가설 수립 및 검증

- **지금까지 진행 상황 점검**
    - **팀 연구 주제 선정 : 채용플랫폼의 구직자 이용 패턴 분석을 통해 이탈요인 파악 및 개선점 제안**
        - 분석 흐름
            - **문제 정의: 트랙픽 수 감소는 유저 이탈로 판단 → 이탈 유저의 행동 패턴 또는 이탈 요인을 파악하여 개선점 제안** → **퍼널 분석**
            - 퍼널 정의 → 퍼널 분석 → 전환율 개선 대상 퍼널 선택 → 가설 수립 및 검증 → 액션 도출
        - 퍼널 분석 **:**  **방문 → 채용 공고 조회 → 지원서 입력 → 지원서 제출**
            - **데이터 수집 기간:** 2022.01.01 ~ 2023.12.31
            - **고객 정의**: 데이터 수집 기간 내 회원가입을 완료한 유저
            - **필터링** : `response_code` 컬럼 값 200 (정상 데이터만 집계)
            - **퍼널 여정**     
            1) 방문 → 데이터 수집 기간 내 기록된 고유 유저 id 수 → 21,333명     
            2) 채용 공고 조회 → `jobs/id/id_title` + `get` → 16,411명
                - 채용 공고 조회 path는 아래 첨부 사진과 같이 `jobs/id/id_title` 이 `other_jobs` 보다 먼저 호출 되는 것을 확인하였고 채용 공고가 랜딩되는 path라고 판단하여 선정
                    
                    ![1.png](/assets/img/team_project2/2-8/1.png)    
                       
               3) 지원서 입력 → `jobs/id/apply/step1` + `get` → 11,376명     
               4) 첫 지원서 제출 → `jobs/id/apply/step4` + `post` → 10,120명     
        
        ![image.png](/assets/img/team_project2/2-8/2.png)
        
    
- **가설 수립**
    - 가설 설정 - **퍼널 단계 별 전환율을 개선하기위해 어떤 가설을 검증해야 할까?**
        1. 전환율을 개선하고싶은 퍼널 선택 
            - 채용 공고 조회 → 지원서 입력 단계 (69.3% 잔류)
        2. 가설 설정해보기 → EDA
            - 내가 설정한 가설 :
                - 기업의 정보(회사정보, 주소, 투자, 인지도 등)가 많을수록 지원서 입력 비율이 높을 것이다. → 분석이 불가능한 가설로 판단됨
            - 분석이 불가능한 판단 근거
                - 해당 가설은 기업 정보수 별 지원서 입력 비율을 분석해야 함
                - 예를들어 아래와 같은 분석결과가 나올 수 있음
                    - 기업 정보수 2개 집단의 지원서 입력 비율 : 0.2
                    - 기업 정보수 5개 집단의 지원서 입력 비율 : 0.5
                    - → 기업의 정보수가 많을수록 지원서 입력 비율이 높아짐
                - 하지만, 로그데이터 외 데이터 테이블에서 지원서 입력한 기업 정보를 알수없었음
                    - 로그데이터 외 데이터 지원서 제출 정보만 추적이 가능했음
            - 그밖에 팀에서 설정한 가설들
                - 구직자가 채용 공고 조회를 많이 할수록 지원서 입력 비율이 높을 것이다.
                - 구직자가 채용 공고 북마크를 많이 할수록 지원서 입력 비율이 높을 것이다.
                - 월별 ‘신입’ 채용 공고가 많을수록 지원서 입력 비율이 높을 것이다
                - 기본 이력서 작성 완료한 유저일수록 지원서 입력 비율이 올라갈 것이다.
                - 기업의 투자 유치금이 많을수록 지원서 입력 비율이 높을 것이다.
                - 월별 채용 공고 수가 많을수록 지원서 입력 비율이 높을 것이다.
                - 채용 공고 수가 많은 직군의 지원서 입력 비율이 가장 높을 것이다.
                - 관심도와 지원서 입력 비율에 상관관계가 있을 것이다.
                - 관심도에 따른 지원서 입력 빈도는 정규분포를 따르지 않을 것이다.
                - 구직자의 성향에따라 지원서 입력에 도달하는 시간이 유의미한 차이가 있을것이다.
                - 시스템 에러를 1번 이상 마주친 유저일수록 지원서 입력 비율이 낮을 것이다.

### 가설 검증과정에서 데이터 이슈 발생

1. `지원서 입력` 관련 가설 설정 폭이 생각보다 넓지 않음 
    - 로그데이터 외 데이터 테이블에서 `지원서 입력` 추적이 불가능 함
        - 지원서 관련된 정보는 `지원서 제출` 데이터만 추적 가능함
        - 따라서, 우리가 설정한 지원서 입력 단계의 분석은 로그데이터에서만 수행가능함
2. `지원서 제출` 관련 가설 설정 폭도 생각보다 넓지 않음
    - 로그데이터 테이블과 로그데이터 외 테이블의 싱크가 일치하지 않음
        - 로그데이터와 지원서 마스터 테이블의 데이터가 불일치함 : 일부 추측이 가능한 정도
        - 지원서 마스터 테이블 데이터 점검
            - 팀회의에서는 `cdate` 지원서 제출시간이 결측치가 32만건이 발견되었으나, 수업끝나고 다시확인해보니 결측치가 없는것으로 관찰됐고 이부분을 내일 다시 공유해야함
            
            ![image.png](/assets/img/team_project2/2-8/3.png)
            
            - 34만건의 지원서 중 2022년 ~ 2023년 제출된 지원서 수 : 92,439건
            - 2022년 1월 1일 ~ 2023년 12월 31일에 지원서 제출한 고유 유저 id 수 : 10,281명
                - 로그데이터와 비슷 : 첫 지원서 제출 → `jobs/id/apply/step4` + `post` → 10,120명
                - 퍼널 설정을 방문 → 지원서 제출 시 : 10,219명
                    - 채용 공고 조회, 지원서 입력 없이 지원서 제출이 가능?? 99명 발견
            
            ![image.png](/assets/img/team_project2/2-8/4.png)
            
            ![image.png](/assets/img/team_project2/2-8/5.png)
            

⇒ 로그데이터와 로그데이터 외 데이터 테이블을 연결해서 분석하는데 제약이 많아 따로 분석해야함

- 가설 설정시 데이터 범위를 어디까지 설정할지 논의 필요

### Reflection

- 로그데이터를 어느정도 분석을 완료했고, 분석한 자료를 기업정보 등 다른 데이터 테이블과 결합하여 가설을 설정하고 분석하는 시간을 가졌다. 그 과정에서 로그데이터 정보를 로그데이터 외 데이터 테이블에서 추적하는데 제약이 많았다. 그래서 우리가 설정한 전환하고싶은 퍼널 단계 기준에서 설정할 수 있는 가설 데이터 범위가 한계가 많았고, 사실상 로그데이터로 분석을하면 로그데이터 내에서만 분석을 끝내야하는 데이터를 제공받은 느낌을 받았다. 1차적으로는 왜 로그데이터와 나머지 데이터 셋이 싱크가 불일치 하는지 의문이 들었고, 이부분이 우리의 실수가 아니라면 분석 데이터를 제대로 제공받지 못했다는 아쉬움이 생길수밖에 없다. 지금 당장 해야할일은 주어진 상황을 인지하고 할 수 있는 범위내에서 분석을 설정하는 일이다.