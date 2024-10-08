---
#layout: post
title: 서울시 대중교통 개선 팀프로젝트6 - 주제확정 및 데이터전처리
date: 2024-09-03
description: # 검색어 및 글요약
categories: [Data_analysis, Team_project1]        # 메인 카테고리, 하위 카테고리(생략가능)
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
> **최종 분석 주제 : 서울교통공사가 운영하는 지하철역들의 노인 이용 패턴과 접근성, 위험도 분석 후 지표화 및 개선사항 도출**

### 오늘 할 일

- [x]  주제 재논의
- [x]  데이터 수집 및 선정
- [x]  데이터 전처리

### 오늘 한 일

1. **방향정리(마무리):** 어제 팀회의에 참여하지못한 동료들과 의견 공유하고 방향확정하기
2. **데이터 수집 및 가공:** 필요한 데이터들 모아서 데이터 별 지하철 호선/역명 통일, 팀원 가공데이터 점검

### 내일 할 일

- [ ]  여러 데이터 합치기
- [ ]  EDA 시작
- [ ]  지표 점수화

---

### Issues & Challenges

1. **방향정리(마무리):** 어제 팀회의에 참여하지못한 동료들과 의견 공유하고 방향확정하기 → ‘지하철역 무임 승/하차 데이터 분석을 통해 노인관련 지표관리’

1. **데이터 수집 및 가공:** 필요한 데이터들 모아서 데이터 별 지하철 호선/역명 통일
- 지하철 무임 승/하차 데이터
- 지하철 역 별 안전 및 접근성 지표
    - 안전관련(승강장 이격거리, 지하철 혼잡도, 사고현황, 안전시설수 등)
    - 접근성관련(노인 여가+복지시설, 의료시설 등)
    - (사이드) 자치구 - 지하철역 매칭 : 일정을봐서 지하철역 → 자치구별 고려
- 데이터 별 가공 작업 진행
    - 데이터분류 : ‘서울교통공사 역주소.csv’ 호선/역명 기준
        - 호선 : 숫자로 (ex : 1호선 → 1)
        - 역명 : 서울역 → 서울, 괄호 제거(ex : 교대(법원.검찰청) → 교대)
    - 용어 통일
        - 자치구, 구 → 행정구
    - csv 인코딩
        - encoding = ‘utf-8-sig’
- 지하철 역별 매핑 통일 데이터(서울교통공사 역주소-괄호제거ver)

![역별 매핑 통일](/assets/img/team_project1/1-6/1.png)

![가공 데이터 점검](/assets/img/team_project1/1-6/2.png)

- 역 별 엘리베이터_에스컬레이터_휠체어리프트_무빙워크 설치수 매칭

![역 별 승강기 관련 설치 분류](/assets/img/team_project1/1-6/3.png)

- 데이터 가공 팀 결과물

![오늘자 데이터 가공 팀 결과물](/assets/img/team_project1/1-6/4.png)

### Reflection

- 3번만에 주제를 확정지었다. 우리가 주제를 3번이나 바꾼이유는 ‘욕심’이라고 볼수있다. 처음에는 팀워크에 중점을 두고 조금은 가벼운 분석주제를 골랐지만, 여러피드백을거쳐 팀워크를 유지하면서 좀 더 도전적인 주제를 선정하고 싶었고, ‘우리가 보유한 데이터에서 이 주제를(무임승차 변화에 따른 대중교통 이용량과 경제적수치) 해결할 수 있을까’에대한 고민에서 시간이 많이 소요되었다. 팀원들이 피로감이 들수도있겠지만 그럼에도 불구하고 (아마도)갈등이 없었던 이유는 각자 어느정도 팀에 녹아드려고 노력하는 부분과 매일매일 다같이 회의에 참여하는 열정이 주요했다. 모두가 모인곳에서 누구하나 소외되지않고 각자의 의견을 서슴없이 공유했고, 단순히 좋다/나쁘다, 좋아보이네요/별로네요가아니라 나름대로 근거를 가지고 이야기를 나눴다. 회의가 지속될수록 팀원들이 이 프로젝트를 진행할 의지가 상당한게 서로 느껴졌기때문에 주제를 몇차례 바꾸면서도 끊임없는 피드백을 서로 공유하며 개선하지않았나싶다. 이제 주제도 정하고 데이터 수집부터 가공까지 이미 팀원들이 이번주제에 보유한 지식이 어느정도 쌓였기때문에 빠르게 진행될 수 있었다. 이제 이 데이터를 기반으로 유의미한 분석을 진행할 예정이고, 지금까지의 팀원들의 열정을 본다면 EDA과정에서 유의미한 인사이트가 도출될 것이라고 기대한다.