---
#layout: post
title: 공유오피스 출입데이터 분석 팀프로젝트3 - EDA
date: 2024-12-06
description: # 검색어 및 글요약
categories: [Data_analysis, Team_project3]        # 메인 카테고리, 하위 카테고리(생략가능)
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

> **최종 분석 주제 : 공유오피스 무료 체험 유저의 유료 결제 전환 예측 및 데이터 수집 전략 제안**

### 오늘 할 일

- [x]  EDA 및 주제 선정(계속)

### 오늘 한 일

1. **EDA 및 주제 선정(계속)** 
    1. 대주제 : 무료체험 유저 중 유료 전환 유저 수 예측
    2. 데이터결합 및 전처리 : `trial_payment` 기준으로 결합 및 전처리

### 내일 할 일

- [ ]  EDA와 전처리를 거쳐 모델링 적용해보기

---

### Issues & Challenges

### 주제 선정

- 대주제 : 무료체험 유저 중 유료 전환 수 예측을 통한 ㅇㅇㅇ제안
    - 선정사유 : 지점관련 분석을 해보고싶었으나, 데이터 불일치 및 한계로 외부데이터 사용시 프로젝트 분석이 너무 추상적인 결과로 산출될 수 밖에 없음. 따라서, 가장 무난한 예측 변수를 선택하여 주제를 결정함
- 외부데이터 활용
    - 추상적이지 않은 외부데이터를 모델링에 사용해볼지 고민해보기 : 날씨라던지, 코로나 분위기 등

### 데이터 결합 및 전처리

1. 데이터 전처리 : 생각보다 전처리해야할 요소가 EDA하면서 계속 발견되고 있음
    1. 중복값 제거 : 테이블 마다 중복값이 존재하였고 제거함
        
        ![image.png](/assets/img/team_project3/3-3/1.png)
        
2. 데이터 결합 : `trial_payment`(3일체험 신청자 결제 여부) 테이블 기준으로 나머지 테이블 결합(`trial_visit_info` 제외)
    1. trial_visit_info(3일체험 신청자 일자별 방문기록) 테이블 결합 제외 사유
        1. trial_access_log(3일체험 신청자 출입기록) 테이블과 싱크가 안맞음(log데이터가 좀 더 범용성이 넓다)
        2. 결측치가 존재함 : 출입 기록이 누락됐는데 재실시간은 기록됨
            
            ![image.png](/assets/img/team_project3/3-3/2.png)
            
        3. 지점 정보가 좀 더 명확해짐 : visit_info 테이블에서만 존재하는&존재하지않는 지점정보가 있으며, 해당 테이블을 사용하지않으면 지점 정보를 따로 제거할 필요가 없게됨
            
            ![image.png](/assets/img/team_project3/3-3/3.png)
            
    2. 결합상태
        
        ![image.png](/assets/img/team_project3/3-3/4.png)
        

### 차 주 할일

1. 데이터 전처리 추가 고민 
    1. 파생변수생성
        1. 날짜와 시간 쪼개기
        2. access_log 활용하여 visit_info 변수들 만들기(재실시간 등)
        3. 이것저것 쪼개보기 : 입실/퇴실 카운트, 고유 유저의 지점 방문수
        4. 외부데이터 찾아보기 : 분석이 추상적이지 않고 합리적인 외부데이터 찾아보기(날씨 등) 
    2. 범주형 데이터 인코딩
        1. 최종적으로 결제한 고유 유저 수 기준으로 변수들을 생성해야하며 현재는 결합으로 중복된 상황
        2. 고유 유저 수 기준으로 열을 길게 늘어지게 만들기
        3. 데이터 불균형 여부를 고려하여 SMOTE 사용 고려
2. 데이터 전처리 및 결합 후 모델링 해보기
    1. 기존 학습한 모델링을 해볼지, AutoML, Bayesian Optimization, MLflow를 사용해볼지 고민해보기

### Reflection

- 기업의 데이터라 그런지 작은 데이터셋에 전처리 해야할 부분이 몇가지 발견되었다. 테이블이 5개뿐인데 테이블 간 연계도 좋지않다. ERP조차 구축되지않은 소규모 기업으로 판단된다. 작은 데이터라 내가 아직 익숙치 않은 모델링 기법을 이것저것 넣어보면서 학습하는데 의의를 두고자 한다. 일단 작은 데이터를 풍부하게 여러가지 쪼개봐야겠다. 다른팀은 전반적으로 외부데이터를 메인으로 쓰는 느낌을 받았다. 다들 고생이 많다.