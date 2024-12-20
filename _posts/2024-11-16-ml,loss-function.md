---
#layout: post
title: 데이터 위클리 페이퍼 11 - 지도학습과 비지도학습, 손실 함수
date: 2024-11-16
description: # 검색어 및 글요약
categories: [Data_analysis, Weekly]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- ML
- loss function
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---

### Q1) 지도 학습과 비지도 학습의 차이는 무엇인가요?

- 지도 학습은 입력 데이터와 해당 정답 레이블을 함께 사용하여 모델을 학습시키는 방식입니다. 이를 통해 모델은 주어진 입력에 대해 올바른 출력을 예측할 수 있도록 학습합니다.
    - 예를 들어, 사진에 있는 물체를 분류하는 것이 지도 학습의 예입니다.
- 비지도 학습은 레이블이 없는 데이터를 사용하여 모델이 데이터 내 숨겨진 패턴이나 구조를 스스로 파악하도록 합니다. 이 방식은 데이터의 그룹화, 연관성 발견 등에 주로 사용됩니다.
    - 예를 들어, 고객 데이터를 분석하여 비슷한 소비 성향을 가진 그룹을 찾는 것이 비지도 학습의 예가 될 수 있습니다.

### Q2) 손실 함수(loss function)란 무엇이며, 왜 중요한가요?

- 손실함수는 머신러닝 모델의 예측값과 실제값 사이의 차이를 수치적으로 나타내는 함수입니다. 이 함수의 값(손실)을 최소화하는 것이 모델 학습의 주요 목표입니다.
- 손실함수를 통해 모델의 성능을 평가하고, 이를 통해 모델이 데이터를 얼마나 잘 예측하는지 파악할 수 있습니다. 따라서, 손실함수는 모델의 학습 방향을 결정짓는 중요한 역할을 합니다.