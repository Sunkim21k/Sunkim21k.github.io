---
#layout: post
title: 채용플랫폼 이용패턴 분석 팀프로젝트6 - Funnel 관점에서 로그분석
date: 2024-10-26
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

- [x]  funnel 관점에서 로그데이터 해석 후 활용방안 논의해보기 (계속)

### 오늘 한 일 (필수)

1. **퍼널 대상 설정에 대한 논의 :** 비즈니스 관점에서 적합한지에 대한 논의
2. **퍼널 관점에서 여정별 로그데이터 설정 :** 여정별 도달로그이벤트 설정 및 분류 코드 점검

### 내일 할 일

- [ ]  중간발표 검토
- [ ]  funnel 관점에서 로그데이터 해석 후 활용방안 논의해보기 (계속)
    - 여정 별 고유 유저 id 확인
    - 가입시점별 코호트분석(일자/주간/월/분기 별 여정 고유 유저 id 확인)
- [ ]  Acquisition : 채널별 유입 유저 파악해보기
- [ ]  A/B 테스트 검토 :
    - 동일한 이벤트인데 2023년과 2022년의 로그이벤트명이 다른 것들을 A/B 테스트로 가정하고 분석해보기

---

### Issues & Challenges (필수)

### **퍼널 대상 설정에 대한 논의**

- 1,700만개 중 **4,500명 유저(2022-2023 가입 유저)**가 몇 개의 로그 데이터를 가지고 있는지? (**전체 유저는 21,383명이고, 전체 유저의 21%**)
- 21%의 표본이 전체 유저의 행동 패턴이나 특성을 충분히 반영할 수 있다면(입증할 수 있다면) 적절하다고 볼 수 있지 않을까?
- 논의 결과
    - 100%중 우리가 추적할 수 있는 로그 유저가 21% 밖에 없었다. (데이터 한계점)
    - 전체 로그데이터에서 추적할 수 있는 표본을 설정했고, 표본이 충분하다고 판단된다.
    - 데이터 분석을 통해 예측 모델링을 하는게 아니라 서비스 흐름이 제대로 이루어지고 있는지 검증하는 목적이기 때문에 전체 데이터를 사용할 필요는 없다.
    - 우리가 선정한 표본(전체의 21%)은 모집단을 충분히 대표할 수 있는 크기다
        - 표본 추출의 랜덤성이 없는데 대표한다는 표현이 명확한지는 의문

### **퍼널 관점에서 여정별 로그데이터 설정**

- **데이터 수집 기간:** 2022.01.01 ~ 2023.12.31
- **고객 정의**: 데이터 수집 기간 내 회원가입을 완료한 유저
- **Aha-moment**: 첫 지원서 제출
- 퍼널 여정 별 로그데이터 분석을 좀 더 효율적이게 해보는 방안 논의해보기
    - **2023년 기준 퍼널 여정 별 로그데이터 분류 후 → 2022년 동일 기능 추적 후 변동 부분 체크**
    - 여정에 해당되는 유저들을 기준으로 로그데이터를 분석하기
- **퍼널 단계 (여정, 도달 로그)**
    1. 회원 가입 클릭(1단계 고유 유저 대상) → `signup/detail` 
    2. 회원 가입 완료 → `signup/step3/done` 
    3. 기본 이력서 작성 완료 → `api/users/id/resume/step2` 
    4. 채용 공고 조회 → jobs + company + people 진입 로그 
    5. 지원서 입력 → `jobs/id/apply/step1` 
    6. 첫 지원서 제출 → `apply/complete` 
- 분류 코드
    - 로그데이터 전처리 코드
        
        ```python
        import pandas as pd
        import re
        
        # 팀 내 log 데이터 전처리 과정 통일화를 위한 class
        class LogProcessing:
            def __init__(self, log2022=None, log2023=None):
        
                self.log2022 = log2022
                self.log2023 = log2023
                self.logs = None
        
            # log data concat
            def concat_logs(self):
                print("start concat...")
                # 로그 병합
                self.logs = pd.concat([self.log2022, self.log2023], ignore_index=True)
                
                # URL 결측값 제거
                self.logs = self.logs.dropna(subset=['URL'])
                
                # 'Unnamed: 0' 열이 있는지 확인하고, 존재하면 제거
                if 'Unnamed: 0' in self.logs.columns:
                    self.logs = self.logs.drop('Unnamed: 0', axis=1)
                
                # 중복 제거 (필요하면 사용)
                # self.logs = self.logs.drop_duplicates()
                # self.logs = self.logs.drop_duplicates(subset=['method', 'URL'])
                print("data concat done...")
                return self.logs
        
            # 'URL' 컬럼을 분해하여 'path'와 'query' 추출
            def vectorized_url_split(self):
                print("start url split...")
                parsed_urls = self.logs['URL'].map(urlparse)
                
                # 'path'와 'query' 분리 후 추가
                self.logs['path'] = [parsed.path for parsed in parsed_urls]
                self.logs['query'] = [parsed.query for parsed in parsed_urls]
                
                print("url split done...")
                return self.logs
        
            # 'timestamp'컬럼 datetime으로 변환
            def sort_by_timestamp_with_timezone(self, timestamp_column='timestamp'):
                print("start timestamp column inverter...")
                # 'timestamp' 컬럼이 object 타입이면 datetime으로 변환 (타임존 없이)
                if self.logs[timestamp_column].dtype == 'object':
                
                    # 조건 추가 - 마이크로초가 없는 데이터에 .000000 추가해서 동일한 형식으로 변경 (re 라이브러리 불러와야함)
                    self.logs[timestamp_column] = self.logs[timestamp_column].apply(
                        lambda x: re.sub(r'(\d{2}:\d{2}:\d{2}) UTC$', r'\1.000000 UTC', x)
                    )
                    
                    # UTC 텍스트 제거 후 datetime으로 변환 (타임존 없이)
                    self.logs[timestamp_column] = pd.to_datetime(self.logs[timestamp_column].str.replace(' UTC', ''), errors='coerce')
            
                # 타임스탬프를 기준으로 시간대 순서대로 정렬 (오름차순)
                self.logs = self.logs.sort_values(by=timestamp_column)
        
                # 인덱스 초기화
                self.logs = self.logs.reset_index(drop=True)
        
                print("timestamp column inverter done...")
                return self.logs
        
            # 타임스탬프 추출
            def timestamp_extraction(self, path_column='path', timestamp_column='timestamp'):
        
                # 'path'별로 그룹화하여 호출 횟수, 첫 번째 및 마지막 타임스탬프 추출
                path_group = self.logs.groupby(path_column)[timestamp_column].agg(['count', 'min', 'max']).reset_index()
        
                # 'first_used', 'last_called', 'path count' 컬럼 추가
                path_group.columns = [path_column, 'path count', 'first_used', 'last_called']
        
                # 'last_called' 기준으로 내림차순 정렬
                sorted_path_group = path_group.sort_values(by='last_called', ascending=True)
        
                # sorted_path_group의 인덱스 초기화
                sorted_path_group = sorted_path_group.reset_index(drop=True)
        
                return sorted_path_group
        
            # 전처리 한 번에 진행
            def log_processing(self):
        
                # 로그 병합
                self.concat_logs()
                
                # URL 분해
                self.vectorized_url_split()
                
                # 타임스탬프 정렬
                return self.sort_by_timestamp_with_timezone()
                
        # 사용법
        
        # 데이터 불러오기
        path = "본인 데이터 path"
        log_2022 = pd.read_csv(path + 'log_2022.csv')
        log_2023 = pd.read_csv(path + 'log_2023.csv')
        
        # 클래스 인스턴스 생성
        logs = LogProcessing(log2022=log_2022, log2023=log_2023)
        
        # 로그 데이터 병합, URL 분해, 타임스탬프 정렬 전처리 수행
        cleaned_logs_df = logs.log_processing()
        
        # 전처리 후 데이터로 path와 timestamp 정보에서 최초 호출 시간과 마지막 호출 시간 타임스탬프 추출
        log_timestamp = logs.timestamp_extraction() # 필요시!!!
        ```
        
    - 회원가입 완료한 고객 중 이력서 작성 고객 퍼널 전환 분석
        1. 회원 가입 클릭(1단계 고유 유저 대상) → `signup/detail` → signup_click_log (6,365명)
            
            ```python
            cond = cleaned_logs_df['path'] == 'signup/detail'
            signup_click_id = cleaned_logs_df[cond]['user_uuid'].unique()
            print('회원 가입 클릭 고유 유저 수:', len(signup_click_id))
            
            # cleaned_logs_df에서 회원가입 클릭한 유저 로그 필터링
            signup_click_log = cleaned_logs_df[cleaned_logs_df['user_uuid'].isin(signup_click_id)]
            ```
            
        2. 회원 가입 완료 → `signup/step3/done` → signup_log (4,622명)
            
            ```python
            cond = signup_click_log['path'] == 'signup/step3/done'
            signup_id = signup_click_log[cond]['user_uuid'].unique()
            print('회원 가입 클릭 고유 유저 수:', len(signup_id))
            
            #signup_click_log에서 회원가입 완료한 유저 로그 필터링
            signup_log = signup_click_log[signup_click_log['user_uuid'].isin(signup_id)]
            ```
            
        3. 기본 이력서 작성 완료 → `api/users/id/resume/step2` → resume_log (2,449명)
            
            ```python
            cond = signup_log['path'] == 'api/users/id/resume/step2'
            resume_id = signup_log[cond]['user_uuid'].unique()
            print('기본 이력서 작성 완료 고유 유저 수:', len(resume_id))
            
            #signup_log에서 기본 이력서 작성 완료한 유저 로그 필터링
            resume_log = signup_log[signup_log['user_uuid'].isin(resume_id)]
            ```
            
        4. 채용 공고 조회 → jobs + company + people 진입 로그 →  job_click_log (2,384명)
            
            ```python
            cond = resume_log['path'] == 'api/jobs/job_title'
            job_click_id = resume_log[cond]['user_uuid'].unique()
            print('채용 공고 클릭 고유 유저 수:', len(job_click_id))
            
            # 회원가입 완료한 유저 중 채용탭 클릭 로그 필터링
            job_click_log = cleaned_logs_df[cleaned_logs_df['user_uuid'].isin(job_click_id)]
            ```
            
        5. 지원서 입력 → `jobs/id/apply/step1` →  진행중
        6. 첫 지원서 제출 → `apply/complete` → 진행중
        
    

### Notes & Ideas

- 코드나 다른 작업물들을 협업할 때, 각자의 환경설정이 다르기때문에 같은 파일이라도 다르게 출력되는 상황이 발생됨 (라이브러리 버전이 다르다거나, 폰트나 소프트웨어 버전이 다르다거나 등)
    - 같은 코드를 실행했는데 결과값이 달라 확인해보니 라이브러리 버전차이로 인한 문제로 확인됨
    - `Git`을 공부할때 느꼈던 개발세팅의 중요성을 이번 프로젝트를 진행하면서 느낌

### Reflection

- 어제 로그분석을 진행하면서 팀원들의 1주간 피로도가 한계치만큼 쌓여있다고 판단하여, 오늘은 조금 가벼운 마음으로 협업을 진행했다. 적절한 판단이였다고 생각하고, 팀원들과 한 주 동안 상당히 많은 커뮤니케이션과 업무를 진행했기때문에 첫주차 일정은 만족스럽다. 아직 해야할 일도 넘어야할 로그데이터라는 산이 남아있지만, 팀원들의 도메인지식이 다양해서 시너지가 발생하고있다. 코드경험이 풍부한 팀원, 문서정리와 보고서작성을 잘하는 팀원, 디자인 재능이 있는 팀원, 생각지도 못한 아이디어를 많이 알고있는 팀원 등 각자 잘하는 부분들이 있었고 논의를 하면서 더 좋은 결과물들이 계속해서 발생하고 있었다. 그리고, 팀원들이 서로 협업하려는 자세가 느껴졌고 팀원들끼리도 어느정도 인지하고 있는 느낌이 들었다. 서로 배려하고 이해하는 모습들이 앞으로의 프로젝트 결과에도 나와서 팀원들이 성취감을 느꼈으면한다.