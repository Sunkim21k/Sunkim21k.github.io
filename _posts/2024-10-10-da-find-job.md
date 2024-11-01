---
#layout: post
title: 데이터분석 직업탐구 - 관심산업 이슈찾기&문제정의
date: 2024-10-10
description: # 검색어 및 글요약
categories: [Data_analysis, Data_find]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Data_find
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


## 이슈찾기

[경제 키워드 트렌드](https://eiec.kdi.re.kr/bigdata/issueTrend.do?cat=금융)

![image.png](/assets/img/find1/1.png)

- 주요키워드
    - 금리인하 :
        - 24년 초부터 미국과 유로존은 금리인상으로 인한 경기 둔화가 가시화된 상황에서 올해 금리를 인하할 가능성이 높아질것으로 전망.
        - 24년 2분기 미국 금리인하 가능성이 높아졌지만 아직까지 변동없음. 하지만 금리인하 가능성 매우높음. 24년 6월 유럽 금리인하 발표
        - 금리인하가 이루어지면 경제의 연착륙(나빠진 경제가 서서히 안정적으로 성장하는것) 가능성이 높아져 대출이 용이해지고, 기업과 소비자에게 투자와 지출을 촉진하는 긍정적인 영향을 끼쳐 2024년 금융관련 최대 관심사로 선정됨.
    - 내부통제(+홍콩H지수) :
        - 잦은 대형 금융사고 : 펀드 불완전 판매, 금융회사 직원횡령 등 금융권 신뢰도 하락. 2023년 금융감독당국 ‘금융회사 내부통제 제도 개선 방안’ 발표 및 관련 가이드라인 배포하여 금융회사들의 내부 시스템을 근본적으로 변경하도록 요구
        - 홍콩ELS불완전판매 : 홍콩H지수 하락으로 판매당시 대비 2024년 1~2월 만기도래 투자손실 1조원 이상 발생. 남은기간 포함하면 올해 총 6조원 규모 손실 예상. 금감원은 은행권의 ELS판매 관련 내부통제에 심각한 문제가 있다고 판단. 5대 금융지주가 공시한 리스크관리위원회 내용에 따르면, 홍콩ELS 관련 언급은 2차례에 불과하였고 특이사항이 없다고 보고하였으나 실제로는 막대한 피해가 발생됨. 약 40만 계좌에서 피해가 발생된것으로 파악됐으며, 금감원은 금융회사들이 고령자나 금융지식이 없는 투자자들에게 무리하게 상품을 판 사실등을 확인하고 이번사태에 금융회사와 경영진을 징계하고 엄정한 대응 방안을 마련함. 이로인해 금융회사들의 내부통제 강화필요성이 주목됨.
            - ELS? 특정 주식의 가격이나 주가지수 수치에 연계된 금융 상품. 만기 시점에 기초자산의 가격이 설정된 기준 이상일 경우 확정수익을 얻는다. (풋옵션과 같다) 그러나 기초자산의 가격이 크게 떨어질 경우 막대한 손실이 발생한다. (풋옵션과 달리 풋행사를 포기할수없다)

[3대 디지털 금융 트렌드와 활용 전략](https://www.samsungsds.com/kr/insights/trends-in-digital-finance.html)

![image.png](/assets/img/find1/2.png)

## 디지털 금융의 3대 트렌드

- **생성형 AI(Generative AI)**: 금융 서비스에 AI 기술을 활용하여 고객 맞춤형 서비스를 제공하고, 운영 효율성을 높이는 방안이 강조되는중. AI는 데이터 분석 및 예측 모델링에 활용되어 고객의 요구를 더 잘 이해하고 대응할 수 있게됨. (대출/보상 심사, 광고/안내장 생성, 포트폴리오 추천, 투자 운용 정보 생성, AI 휴먼 지점 텔러 등)
    - 금융 전문 통역 Agent : 외국인 대상 모바일 기반 실시간 통역 지원, ‘금융 표준 스크립트’에 대한 RAG(검색 증강 생성) 기술 적용을 통해 불완전 판매 최소화
    - 실시간 투자 정보 검색 Agent : 해외 변동 공시 정보, 뉴스, 주요 리포트를 수집해 번역 및 요약한 후 리포트를 작성. 메뉴, 광고 등을 정제하고 전처리한 콘텐츠로 투자 관리 담당자의 업무시간 단축과 더 넓은 정보제공(기존에는 시간관계상 중소형 종목은 확인을 잘안했지만 AI도입을 통해 전체 정보를 파악)
- **디지털 자산, 토큰의 제도권 편입**: 블록체인 기술을 기반으로 한 토큰화(STO)가 금융 시스템에 통합되고 있음. 이는 자산의 디지털화와 거래의 투명성을 높이고, 새로운 투자 기회를 창출함 (미술품이나 고가품과 같은 실물 자산이나 영화, 음악 등의 저작권에 투자하고, 증권화되어 유통 발행되는 시장) 2023년 디지털자산 법률 강화 제정후 2024년 7월 시행 → 규제 준수 시 디지털 자산 거래는 빠르게 활성화될 것.
    - STO 투자앱 : 뮤직카우(음악저작권), 테사(미술품), 뱅카우(한우), 트레져러(명품)
    - Web2.0에서 Web3.0으로 변화됨에따라 개인화된 인터넷 환경이 구성되고있고 탈중앙화되고있어 까다로운 국내 법률이 적응기간을 거치면 이런유형의 상품들이 활성화될것
- **금융 채널의 변화와 확장**: 디지털 플랫폼의 발전으로 인해 소비자가 금융 서비스를 이용하는 방식이 변화하고있음. 방문형이아닌 모바일 앱과 온라인 플랫폼을 통해 언제 어디서나 금융 거래가 가능함.
    - 임베디드 파이낸스 : 비금융회사가 금융회사의 금융 상품을 중개 및 재판매하는 것을 넘어 자사 플랫폼에 핀테크 기능을 내장하는 ‘은행대리업’ (네이버파이낸셜이 미래에셋캐피탈과 손잡고 네이버 스마트스토어 입점 사업자를 대상으로 신용대출 상품 출시)
    - 인카페이먼트 : 운전자가 차 안에서 등록 카드를 이용해 편의점, 카페, 주유소, 주차장 등 방문하기 전 미리 주문 및 결제하는 방식(현대, 기아, 르노삼성자동차 등이 서비스 제공)
    - 슈퍼앱 : 여러 가지 서비스를 하나의 플랫폼에서 제공하는 모바일 앱
        - 토스, 위챗 등 사용자 친화적인 인터페이스와 높은 편의성, 불편했던 금융서비스를 쉽고 간편하게 제공

## 활용 전략

- 고객 경험 개선: 디지털 금융 서비스는 고객의 편의성을 높이고, 사용자 경험을 개선하는 방향으로 발전해야함. 데이터 분석을 통해 고객의 행동을 이해하고, 맞춤형 서비스를 제공하는 것이 중요.
- 보안 강화: 디지털 금융의 확산에 따라 사이버 보안의 중요성이 주목됨. 금융 기관은 고객의 데이터를 안전하게 보호하기 위한 다양한 보안 기술을 도입해야 함. 특히 올해 홍콩ELS불완전판매 이슈와 잦은 금융직원 횡령 등 내부통제가 주요키워드로 언급되고있어 소비자가 신뢰할 수 있는 금융서비스를 제공하는것이 중요해지고 있음.
- 규제 준수: 새로운 기술이 도입됨에 따라 관련 법규와 규제를 준수하는 것이 수익과 직결되기에 반드시 필요함. 금융 기관은 변화하는 규제 환경에 적응하고, 이를 준수하는 시스템을 구축해야함.

## **IT 산업**

https://www.globalict.kr/upload_file/kms/202407/9639165941528006.pdf

![image.png](/assets/img/find1/3.png)

### 최신 이슈 및 트렌드

- **생성형 AI의 대중화:** 생성형 AI 기술이 더욱 보편화되면서, 데이터 분석가들은 AI를 활용하여 데이터 분석의 효율성을 높이고 있음. 생성형 AI기술은 비즈니스 인사이트 도출에 영향력을 줄것.
- **AI 보안과 윤리:** AI의 활용이 증가함에 따라 AI 보안과 윤리가 중요해지고 있음. 데이터 분석가는 데이터의 윤리적 사용과 AI의 안전성을 고려해야 함.
- **빅데이터와 클라우드 컴퓨팅의 통합:** 데이터 센터에 대한 투자가 증가하고 있으며, 클라우드 기반의 데이터 분석 솔루션이 더욱 보편화되고 있음. 데이터 분석 기술이 발전함에따라 실시간으로 빅데이터 분석도 가능해지면서 확장성과 유연성, 비용 절감 등의 이유로 클라우드로의 마이그레이션이 증가하는 추세임. 특히 서비스형 데이터(Data as a Service, DaaS) 시장에 대한 관심도는 지난 5년간 약 300% 증가함.
    - **서비스형 데이터(Data as a Service, DaaS)** : 클라우드 기반으로 데이터를 제공하고 관리하는 모델로, 사용자에게 온디맨드 접근성과 비용 효율성을 제공함. 다양한 소스의 데이터를 통합하여 활용할 수 있음.
        - 온디맨드 접근성 : 사용자가 필요할 때 즉시 데이터나 서비스를 요청하고 사용하는 기능
- **엣지 인텔리전스와 디지털 트윈:** 엣지 컴퓨팅과 디지털 트윈 기술이 데이터 분석에 통합되고 있음. 이는 실시간 데이터 분석과 예측을 가능하게 하여 비즈니스 운영의 효율성을 높이고 있음.
    - 엣지 컴퓨팅 : 데이터가 생성되는 장소에서 데이터를 처리하고 분석하는 기술. 로컬에서 실시간으로 데이터를 처리하여 빠른 의사결정이 가능하고 데이터 전송 비용 절감, 보안 강화 효과.
        - 교통 관리 시스템 : 실시간으로 교통 데이터를 분석하여 신호등을 조정하거나 교통 흐름을 최적화
        - 산업 자동화 : 제조업에서는 기계들을 실시간 데이터 분석하여 고장이나 오류를 예측하고 유지보수 수행
- **비즈니스 인텔리전스(BI) 도구의 발전**: 데이터 분석가들은 BI 도구를 활용하여 실시간 데이터 분석과 시각화를 통해 비즈니스 의사결정을 지원하고 있음. BI 도구를 활용해 데이터의 가시성을 높이고, 의사결정 과정을 간소화함. (power bi → tableau 대세 변화)

### 데이터 분석가의 역할 변화

- **AI와 머신러닝의 활용:** 데이터 분석가는 AI와 머신러닝 기술을 활용하여 데이터에서 패턴을 발견하고 예측 모델을 구축하는 역할이 중요해지고 있음. 앞으로도 기업의 전략적 의사결정에 영향력을 줄듯.
- **데이터 거버넌스:** 데이터의 품질과 보안을 관리하는 데이터 거버넌스의 중요성이 증가하고 있음. 데이터 분석가는 데이터의 정확성과 신뢰성을 보장하기 위해 데이터 거버넌스 정책을 준수해야 함. 데이터분석가는 사내규정과 계약서 등을 면밀히 검토해야하며, 국내/국외 법률 규정등을 주기적으로 확인하여 보완해야함.
- **협업과 커뮤니케이션 능력**: 데이터 분석가는 다양한 부서와 협업하여 데이터 기반의 인사이트를 제공해야 하므로, 커뮤니케이션 능력이 더욱 중요해지고 있음. 다른부서에서 데이터 분석 결과를 이해하기 쉽게 전달하는 능력이 필요함.

### 데이터 시각화의 중요성

- **데이터 시각화의 발전**: 데이터 시각화는 데이터 분석의 결과를 이해하기 쉽게 전달하는 데 필수적인 요소임. 최신 BI 도구들은 시각화 기능이 강화되고 있어, 데이터 분석가는 복잡한 데이터를 쉽게 해석하고 전달할 수 있다. 아직까지는 데이터 시각화 전문가가 수요보다 공급이 앞서는 상황임.
- **사용자 경험(UX)과 데이터 시각화**: 데이터 시각화는 사용자 경험을 향상시키는 중요한 요소임. 데이터 분석가는 시각적 요소를 통해 데이터를 효과적으로 전달하고, 사용자들이 쉽게 이해할 수 있도록 구성해야함.

## 제조업

- 스마트 제조: IoT와 AI를 활용한 스마트 제조가 주목받고 있으며, 이는 생산성을 높이고 비용을 절감하는 데 기여하고 있습니다
- 지속 가능성: 환경 문제에 대한 관심이 높아지면서, 제조업체들은 지속 가능한 생산 방식을 채택하고 있습니다
- 자동화: 자동화 기술이 발전하면서, 인력의 필요성이 줄어들고 있으며, 이는 인력 관리에 새로운 도전을 제기하고 있습니다

## 공기업

- 디지털 전환: 공기업들도 디지털 전환을 추진하고 있으며, 이는 서비스의 효율성을 높이고 있습니다
- 투명성 강화: 공기업의 투명성을 높이기 위한 노력이 계속되고 있으며, 이는 공공의 신뢰를 구축하는 데 중요한 역할을 하고 있습니다
- 사회적 책임: 공기업은 사회적 책임을 다하기 위해 다양한 사회 공헌 활동을 강화하고 있습니다