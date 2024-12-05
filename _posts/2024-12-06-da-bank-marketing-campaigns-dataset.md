---
#layout: post
title: 고객의 정기예금 가입 여부 예측을 위한 은행 마케팅 분류 모델 구축
date: 2024-12-06
description: # 검색어 및 글요약
categories: [Data_analysis, Python_DA_Library]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Data_analysis
- Python
- ML
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---


## 1. 분석 목적 및 목표   
--- 

- 분석 목적 : 포르투갈 A은행의 마케팅 담당자로서 **고객이 정기 예금을 가입할 가능성을 예측**하고자 정기 예금과 관련이 있는 요소들을 파악하여 마케팅 캠페인의 효율성 제고
- 분석 목표 : 결정 트리와 앙상블 기법을 사용하여 고객이 정기 예금을 가입할지 여부를 예측하는 분류 모델을 구축하여 인사이트를 바탕으로 비즈니스 전략 제시