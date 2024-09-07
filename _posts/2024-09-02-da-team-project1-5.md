---
#layout: post
title: 서울시 대중교통 개선 팀프로젝트5 - 방향정리
date: 2024-09-02
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

- [x]  데이터 수집 및 정리
- [x]  EDA 및 세부 분석 : 주어진 데이터 및 수집한 외부데이터에 대한 EDA 진행 및 결과 공유

### 오늘 한 일

1. **데이터 수집 및 정리 :** 팀회의후 논의된 내용을 바탕으로 데이터수집 및 정리
2. **방향정리** : 팀원 개별적으로 작성된 자료를 모아서 하나의 방향 설정

### 내일 할 일

- [ ]  EDA 및 세부 분석 : 주어진 데이터 및 수집한 외부데이터에 대한 EDA 진행 및 결과 공유

---

### Issues & Challenges

1. **무임승차 변동시 노인들의 대중교통 이용패턴 예측** : 버스를 선호하는 노인들, 하지만 노인들의 서울 대중교통 이용은 지하철이용이 5명중 4명
- 65세 이상 고령자는 서울시에서 지하철 비율이 80%에 달하지만, 정작 선호하는 교통수단은 도보와 버스로 나타났음, 대중교통 이용시 계단이나 경사로 등이 주요 불편사항으로 나타남
- 전체 지역 기준 ‘2020년 보건복지부 노인실태조사’에 따르면, 노인이 외출할 때 이용하는 교통수단은 버스 52.8%, 지하철 11.8%, 택시 6.6% 등 **대중교통 71.2%**, 자가용 25.6%

![2023년 서울시 대중교통 이용건수](/assets/img/team_project1/11.png)

![65세 이상 주 통행목적과 선호수단](/assets/img/team_project1/12.png)

![2020 노인실태조사 - 노인의 교통수단과 불편사항 / 보건복지부](/assets/img/team_project1/13.png)

![2020 노인실태조사 - 외출 시 노인이 주로 이용하는 교통수단](/assets/img/team_project1/14.png)

- 고령자 통행은 10시~17시에 집중되는 경향을 보임

![고령자 통행시간대](/assets/img/team_project1/15.png)

- 서울시 지하철 무임승차제도를 이용하는 약 400여명의 노인들에게 설문조사한 결과, **노인 지하철 무임수송 변동시 외부활동 감소 43.8% 응답** (2013년 노인 교통이용 요금제고 개선방안 연구 : 지하철 무임승차를 중심으로 / 보건복지부)
    - 지하철 이용 목적은 경제활동보다는 종교활동, 여가, 개인생활 등 다른 활동 목적이 90%
    - 무임승차 개선방안에 대해 ‘노인 소득계층별 이용요금 할인율 차등적용’이 가장 긍정적

![무임승차 변동시 노인의 지하철 이용패턴 예상](/assets/img/team_project1/16.png)

![노인의 지하철 주된 이용목적](/assets/img/team_project1/17.png)

![노인의 지하철 무임승차제도 개선방안에 대한 의견](/assets/img/team_project1/18.png)

- 무임승차와 관련된 연구자료에 무임승차 변동(연령대, 할인율, 폐지)에 따른 이탈하는 가중치가 없는것같음… 무임승차 변동시 노인의 활동 위축을 측정하는 (최근 5년이내)자료가 안보임..

1. **방향정리 :** 팀원이 수집한 내용들을 바탕으로 주제 축소, 방향설정
- 다양한 아이디어들이 나왔지만, 아이디어의 공통 주제에 사용되는 ‘무임승차 변화에 따른 노인들의 대중교통 이용패턴’을 확인할 수 있는 자료가 마땅치 않았다. 데이터가 없기에 방향을 조금 우회할 필요가 있다. 혹은 무임승차 변화시 노인의 대중교통이동이 5%, 10% 변할것이다 가정하고 하는방법도 고민중이다. 하지만 계속 의견을 나누어본 결과, 무임승차 변동에 따른 대중교통 이용변화를 파악하기에는 한두가지부분에서 물음표가 해결되지 않고있다.
- → 결국 다른방안으로 주제를 선회하였고, ‘지하철 무임 승/하차 데이터 분석을 통해 노인관련 지표관리(자치구별 복지시설, 의료시설, 대중교통, 위험요인 등) 방안’을 선정할 예정이다. 내일 팀원들과 최종논의후 주제를 확정할 예정이고, 비록 우리팀이 주제를 선정하는 과정에서 오래걸렸지만 그 과정에서 이미 대다수의 데이터와 EDA를 진행했기때문에 진도가 느리지 않다고 생각한다.

### Reflection

- 다른팀보다 우리팀이 진도가 많이느려진것처럼 보이고있다. 다만, 그 과정이 손을놓고 아무것도 하지않은것이 아니라 팀원마다 각자의 아이디어를 자유롭게 공유하고, 그 아이디어가 너무나도 다양하고 가치가 있어서 고르는데 어려움이 있었다. 업체에 메일보내는 팀원도 있고, 지인에게 연락하는 팀원도 있었다. 그만큼 열정가득한 우리팀이 잘하고 있다고 생각한다!