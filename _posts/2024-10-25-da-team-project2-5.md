---
#layout: post
title: 채용플랫폼 이용패턴 분석 팀프로젝트5 - 유저 이용 패턴 파악
date: 2024-10-25
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


### 오늘 할 일

- [x]  log URL(이벤트) 분류 및 분석방향 설정
    - [x]  2022년 ~ 2023년 log 데이터 취합후, 중복값 없이 method와 URL 기준으로 분류해보기
    - [x]  로그데이터를 전체로 볼지, funnel관점에서 관련있는 것만 볼지 진행사항 점검해보기
    - [x]  로그데이터 분류후 어떤 데이터들을 활용해볼지 논의해보기
    - [x]  분석 대상 및 타겟 선정

### 오늘 한 일

1. **로그데이터 분류해보기:** 자주 사용되는 상위 20개 `path` 해석 및 공유
2. **funnel 관점에서 로그데이터 분류해보기 :** funnel 설정 후 여정 별 각자 로그데이터 해석 및 공유

### 내일 할 일

- [ ]  funnel 관점에서 로그데이터 해석 후 활용방안 논의해보기

---

### Issues & Challenges

### 로그데이터 분류해보기

- 2022년 ~ 2023년 로그데이터 취합후, 중복값 없이 method와 URL 기준으로 분류해보기
- 로그데이터 분류 방안 : 분류 기준으로 상위 path 로그데이터 20개 각자 해석해보고 공유
    - 1차) `/`로 구분된 path 여부  or 특수문자 여부
    - 2차) path를 다시 `/` 단위로 나눠서 해석
        - 예시 URL : **`api/search/language**?name=한국어&_=1655915651225`
            - path : `api/search/language`
            - query : `name=한국어&_=1655915651225`
    - URL 분류까지 해놓고 각자 해석 공유 vs 분류도 각자 해놓고 해석 공유
    - 분류 코드
        
        ```python
        import pandas as pd
        
        df_log2022 = pd.read_csv('/content/drive/MyDrive/코드잇_DA_2기/팀프로젝트/중급1/hrdata/log_2022.csv')
        df_log2022 = df_log2022.iloc[:, 1:]
        
        df_log2023 = pd.read_csv('/content/drive/MyDrive/코드잇_DA_2기/팀프로젝트/중급1/hrdata/log_2023.csv')
        df_log2023 = df_log2023.iloc[:, 1:]
        
        def concat_logs(log2022, log2023):
            logs = pd.concat([log2022, log2023], ignore_index=True)
            logs = logs.dropna(subset=['URL'])
            logs = logs.drop_duplicates()
            return logs
        
        logs = concat_logs(df_log2022, df_log2023)
        
        logs = logs.drop_duplicates(subset=['method', 'URL'])
        
        from urllib.parse import urlparse
        
        # 경로와 쿼리 파라미터를 벡터화하여 한 번에 추출하는 방법
        def vectorized_url_split(df):
            # 전체 URL에 대해 urlparse 결과를 분리
            parsed_urls = df['URL'].map(urlparse)
        
        # 경로(path) 및 쿼리(query)를 각각 추출
            df['path'] = [parsed.path for parsed in parsed_urls]
            df['query'] = [parsed.query for parsed in parsed_urls]
        
            return df
        
        # 벡터화된 URL 분리
        log = vectorized_url_split(logs)
        
        # 결과 출력
        log.head()
        ```
        
- 분류 내용   


| method | path                              | 설명                                                                  |
| ------ | --------------------------------- | --------------------------------------------------------------------- |
| GET    | api/search/people/job_title       | 특정 직무에 해당하는 사람들을 검색하는 API                            |
| GET    | api/users/notifications/mark_read | 사용자가 알림을 읽은 것으로 표시하는 API                              |
| GET    | api/search/companies              | 회사를 검색하는 API                                                   |
| GET    | api/search/product                | 제품을 검색하는 API                                                   |
| GET    | api/jobs/job_title                | 특정 직무에 대한 채용 공고를 조회하는 API                             |
| GET    | api/timeline                      | 사용자의 활동 타임라인을 조회하는 API(활동내역, 뉴스피드 등)          |
| GET    | api/apply_progress                | 사용자가 지원 현황(상황)을 조회하는 API                               |
| GET    | api/companies/id/ad_stat/progress | 특정 회사의 광고 상태 및 진행 상황을 조회하는 API                     |
| GET    | suggest                           | 사용자가 검색어 자동 완성 기능을 사용(호출), 추천 기능을 제공하는 API |
| GET    | api/users/id/career/template      | 사용자의 경력 템플릿을 조회하는 API                                   |
| GET    | api/users/id/project/template     | 사용자의 프로젝트 템플릿을 조회하는 API                               |
| GET    | continue                          | 사용자가 이전에 중단했던 작업을 재개                                  |
| GET    | api/search/specialty              | 사용자가 전문 분야를 검색하는 API                                     |
| GET    | api/users/id/career/id/form       | 특정 경력 ID에 대한 정보를 조회 또는 수정하거나 제출하는 API          |
| GET    | api/search/people/schools         | 사용자가 학교별로 사람을 검색                                         |
| GET    | api/job_offer/id/modal            | 특정 채용 제안에 대한 모달 창을 조회                                  |
| GET    | api/search/template               | 검색 템플릿을 조회하거나 사용하는 API                                 |
| GET    | api/people/template               | 사람 관련 템플릿을 조회하는 API                                       |
| GET    | api/jobs/id/stat/progress         | 특정 채용 공고의 통계 및 진행 상황을 조회하는 API                     |
| GET    | api/users/id/project/id/form      | 특정 프로젝트 ID에 대한 정보를 수정하거나 제출하는 API                |   

- 소감 : 로그데이터 분석하는 방법을 알았고, 해석을 어느정도는 할 수 있었음
    - 하지만, 상위 20개만 분류하고 해석하는데 너무 많은 시간이 소요됐고, 전체 로그데이터를 해석할 자신이 없음 ⇒ Funnel 관점에서 여정을 만들어보고 로그데이터 분석해보기

### **Funnel 관점에서 로그데이터 분류해보기**

- 첫 번째 Funnel 설정 : 회원 가입 클릭 → 회원 가입 완료 → 채용 공고 조회 → 지원서 입력 → 지원서 작성 완료 → 첫 지원서 제출
    - 여정을 팀원 각각 나눠서 관련있는 로그데이터 URL만 해석해보고 공유하기
    - ex) 지원서 제출 : `apply/complete`
- 문제점 발생
    1. Funnel 여정을 정리하고 각자 분류한 기준이 통일되지 않았고, 아래 2번의 여정을 각각 다르게 이해하고 로그데이터를 분류하고 있었음
        1. ~ 지원서 입력 → 지원서 작성 완료 ~
        2. ~ 기본 이력서 작성 → 기본 이력서 작성 완료 ~
    2. `기본 이력서 작성`이 Funnel 여정에 적합한지 논의가 필요했음
        1. 구직자가 채용공고 지원시 작성된 기본 이력서로 지원 or 지원서 새로 작성 선택 가능
        2. 기본 이력서 작성을 추가하면 Funnel 여정이 모두 옮겨지지 않을 문제가 있었음
- 1차 해결 방안 : 분석 대상(유저) 타겟을 설정하고 Funnel을 만들어보기
    - 핵심가치 : 기본 이력서를 작성하고 첫 지원한 구직자
    - Funnel : 회원 가입 클릭 → 회원 가입 완료 → 기본 이력서 작성 → 채용 공고 조회 → 지원서 입력 → 지원서 작성 완료 → 첫 지원서 제출
    - Funnel 2단계 약 4,500명 → 3단계 약 2,500명 데이터 보유(기본 이력서 작성 완료된 유저)
- 2차 문제점 발생
    - 우리가 설정한 Funnel 대상이 전체 로그데이터 유저의 21%라면, 비즈니스 관점에서 적절한가?
    - 21%의 표본이 전체 유저의 행동 패턴이나 특성을 충분히 반영할 수 있다면, 적절하다고 볼 수 있지 않을까?

### Reflection

- 로그데이터를 분석하는 시간을 가졌고, 처음배우고 생소하지만 어떤식으로 접근하는지는 파악할 수 있었다. 다만, 문제는 작업속도가 빠르지 않았고 분석해야할 로그데이터가 너무 많았다. 근본적인 원인은 로그데이터를 명확하게 설명한 데이터를 제공받지 못한점이지만, 우리는 이 로그데이터를 해결하면 다른팀과 차별화된 분석을 진행했다고 자신있게 말할 수 있기 때문에 반드시 해결하고 싶었다. 그래서 전체 로그데이터 기준이 아닌 Funnel 관점에서 여정별 로그데이터를 분석하는 방향을 설정했지만, 원활하게 진행되지 못했다. 1차적으로는 팀원모두 배우지못한 로그분석과 aarrr과 funnel 등 지표 이해도 차이로인한 의견조율 문제가 있었고, 근본적으로는 팀장으로써 명확하게 가이드라인을 주지도 못했고, 확실하지도않은 내용을 진행하려고 한것이 문제로 판단된다. 서로가 명확하게 알지못하는 지식을 본인도 정리가안된 상태에서 이야기를 나누다보니 어느곳으로 방향을 나아갈지 갈피를 잡지 못하고 있었다. 모두가 답답해하는 시간이 발생해서 잠깐 쉬는타임을 가졌어야했는데, 오후타임에는 관리자의 역할을 제대로 수행하지 못했던 것 같다. 그렇게까지 급박하게 할 필요가 없었는데, 전체 로그데이터를 일정안에 해야한다는 부담감이 팀전체로 전달된것 같아 아쉽다. 오랜만에 내가일했었던 직장의 관리자급의 행동들을 떠올려보는 시간을 가졌던것같다. 신기한것은 대화를 자주하다보니 어떻게든 진행되고있다는 점이다. 어려움속에서도 대화를 참여하려고 노력하는 팀원들을 고맙게 생각한다.