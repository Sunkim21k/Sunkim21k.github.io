---
#layout: post
title: 서울시 대중교통 개선 팀프로젝트2 - 주제선정
date: 2024-08-28
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

### 오늘 할 일

- [x]  팀프로젝트 분석 주제 선정
- [x]  팀프로젝트 역할 분배

### 오늘 한 일

1. **주제선정 :** 팀원들의 주제공유 중 내가 제안한 ‘고령화로 인한 노인들의 지하철 이용 편의 개선’이 후보로 선정되었고, 후보군중에서 여러 요인(데이터가 풍부한지, 인사이트를 도출할게 많은지, 이슈가있는지 등)을 종합적으로 고려하여 주제를 선정하기로 결정. 이를위해 주제와 관련된 데이터를 수집하여 정리 → 주제 채택
2. **역할 분배 :** 채택된 프로젝트 주제 **‘고령화로 인한 노인들의 지하철 이용 편의 개선’** 역할 분담

### 내일 할 일

- [ ]  EDA 및 세부 분석 : 주어진 데이터 및 수집한 외부데이터에 대한 EDA 진행 및 결과 공유

---

### Issues & Challenges

- **후보주제 :** 인구고령화 대비 노인을위한 서울시 지하철 교통사고 안전방안과 이용편의 개선
    - 배경
        - **인구고령화** : 65세 이상의 인구 비율이 급격하게 증가하고있다
            - ‘23년 65세 이상 고령인구는 우리나라 인구의 18.4%로, 향후 계속 증가하여 [**’25년에는 20.6%로 우리나라가 초고령사회로 진입할 것으로 전망**됨’(통계청)](https://kostat.go.kr/board.es?mid=a10301010000&bid=10820&act=view&list_no=427252)
        - **무임승차 증가** : 노인층의 지하철 이용 비율이 높아지면서 무임승차 비율도 증가
            - [‘노인 대중교통 이용 82%가 지하철… 65세 이상 지하철이 버스 4.5배’](https://www.karnews.or.kr/news/articleView.html?idxno=15944)
        - **노인 교통사고 위험 증가** : 노인층은 신체적 제약이 많아 사고 위험이 크다(ex 걸음이 느려 발끼임 사고나 넘어질 위험)
            - [‘노인 지하철 안전사고 46%(2019년 기준으로 추가자료 필요)’](https://www.newsis.com/view/NISX20190419_0000625758)
        - **노인 편의성 문제 증가** : 노인층은 지하철 이용시 계단 이용의 어려움, 복잡한 환승 통로, 빠른 승하차, 엘리베이터 부재, 청력 및 시력 저하로 인해 지하철을 원활하게 이용하지 못할수 있다
        
          **→ 노인을위한 지하철 안전장치와 이용편의를 개선할 필요가 있다**
        
    - **목적 : 무임승차 비율이 높은 지하철역을 중점적으로 안전시설과 이용편의 개선 (+점진적확대)**
    - 관련 데이터 :
        - [연령별 인구 통계](https://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1IN1503&conn_path=I2)
            - [서울시 구별 고령자현황](https://data.seoul.go.kr/dataList/10730/S/2/datasetView.do)
        - [인구고령화 예측 (지역별 주요 인구지표)](https://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1BPB002&conn_path=I2) (2050년도에는 65세이상 40%?!)
        - [서울 생활이동 인구](https://data.seoul.go.kr/dataVisual/seoul/seoulLivingMigration.do)
        - [최근 5년 서울시 지하철 사고 현황](https://www.data.go.kr/data/15112860/fileData.do)
            - [노인 지하철 사고 유형](https://www.newsis.com/view/NISX20190419_0000625758) : 출입문 끼임, 넘어짐, 승강장 발빠짐 등
        - [서울시 지하철 호선별 역별 유/무임 승하차 인원 정보](https://data.seoul.go.kr/dataList/OA-12251/S/1/datasetView.do)
            - [서울교통공사 역주소 및 전화번호](https://data.seoul.go.kr/dataList/OA-12035/A/1/datasetView.do) (무임승차 높은곳 맵 시각화 가능할듯)
        - [서울교통공사 지하철혼잡도 정보](https://www.data.go.kr/data/15071311/fileData.do)
        - 무임승차인원 지하철 이용 패턴(무임승차 인원의 시간대별, 노선별 특징)
        - [서울교통공사 역별 일별 시간대별 노인 승하차인원 정보](https://www.data.go.kr/data/15101985/fileData.do)
        - [서울교통공사 교통약자 이용시설(승강기) 가동현황](https://data.seoul.go.kr/dataList/OA-15994/S/1/datasetView.do)
        - [서울교통공사 엘리베이터 설치현황](https://www.data.go.kr/data/15044261/fileData.do#tab-layer-recommend-data)
        - [서울교통공사 에스컬레이터 설치현황](https://www.data.go.kr/data/15044260/fileData.do?recommendDataYn=Y)
        - [서울교통공사 승강장 이격거리](https://www.data.go.kr/data/15041805/fileData.do)
        - [서울시 지하철 역사 노약자 장애인 편의시설 현황](https://data.seoul.go.kr/dataList/OA-11573/S/1/datasetView.do)
            - [서울교통공사 휠체어경사로 설치 현황](https://data.seoul.go.kr/dataList/OA-13116/S/1/datasetView.do)
            - [서울시 지하철 역사 편의시설 현황](https://data.seoul.go.kr/dataList/OA-13321/S/1/datasetView.do)
            - [서울교통공사 서울도시철도 역사별 세부 정보](https://www.data.go.kr/data/15107020/fileData.do)
            - [서울교통공사 소화기설치현황](https://www.data.go.kr/data/15044446/fileData.do#tab-layer-file)
            - [서울시 소방서, 안전센터, 구조대 위치정보](https://data.seoul.go.kr/dataList/OA-21072/S/1/datasetView.do)
    - 개선방안 :
        - 교통사고 예방 및 안전 강화 : 소방장치, 발끼임방지장치, 안전인력배치 등 안전조치를 강화하여 사고 예방
        - 노인 이용 편의 개선 : 경사로 설치, 역 내 좌석 확대, 안내 시스템 개선(시각 및 청각 보조 개선 등), 역 내 노인 친화적 디자인 도입, 노인 친화적 앱 개발, 안내요원 충원 등 노인의 지하철 이용 편의성 개선

- 역할분배 : 채택된 프로젝트 주제 **‘고령화로 인한 노인들의 지하철 이용 편의 개선’** 역할 분담
    - 1차적으로는 배경조사부터 데이터수집, 데이터전처리, EDA, 시각화, 보고서 작성을 겹치지않는 선에서 각자 진행하고 취합하는 방향으로 결정. 상황에따라 자신이 좀더 하고싶거나 강점있는 분야로 업무분배를 진행할예정.

### Reflection

- 오늘하루종일 어느주제가 프로젝트에 적합한지 커뮤니케이션하는 시간이 많이 소요되었고, 이과정에서 다양한 인사이트가 발생되고있다. 채택된 주제도 팀원들의 아이디어들을 바탕으로 괜찮은 주제가 떠올라 제안할수있었다. 꾸준히 의견을 공유해서 유의미한 프로젝트로 마무리되었으면한다.