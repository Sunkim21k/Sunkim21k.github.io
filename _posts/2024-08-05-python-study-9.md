---
#layout: post
title: Python study 9 - 모듈
date: 2024-08-05
description: Python 모듈과 관련된 내용을 학습합니다. # 검색어 및 글요약
categories: [Data_analysis, Python]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Python
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

> Python에서 사용되는 개념의 일부 혹은 전체를 정리하여 반복학습에 사용합니다.
  - 모듈을 읽어 들이는 방법에 대해 학습합니다.      
  - 기본 내장 모듈을 학습합니다.       
  - 모듈을 만드는 방법을 학습합니다.   
  - 외부모듈에 대해 학습합니다.        
  

<br>


## 모듈을 읽어 들이는 방법
---
> 모듈(module)이란 특정 관심사를 기반으로 변수와 함수, 클래스 등을 모아놓는 방법을 말합니다.   
> 예를들어 수학과 관련된 모듈은 math 모듈이 있구요,   
> 시스템과 관련된 모듈은 sys 모듈이 있습니다.   

<br>

> 파이썬에서 모듈은 공통적으로 뒤에있는 부분을 식별자로 읽는 방식입니다.   

1. import 모듈 : `모듈`을 식별자로 읽는 방식     


```python
import math
print(math.sin(1))
print(math.cos(1))
print(math.tan(0))
print(math.ceil(3.5))
print(math.floor(3.5))
```   


2. import 모듈 as 모 : 모듈을 `모`라는 식별자로 읽는 방식    

```python
import math as m
print(m.sin(1))
print(m.cos(1))
print(m.tan(0))
print(m.ceil(3.5))
print(m.floor(3.5))
```   


3. from 모듈 import 변수, 함수, 클래스 : `변수, 함수, 클래스`를 식별자로 읽어들임   

```python
from math import sin, cos, tan, ceil, floor
print(sin(1))
print(cos(1))
print(tan(0))
print(ceil(3.5))
print(floor(3.5))
```   


> 이처럼 3가지의 모듈 접근방식이 있는데요,   
> 어떤방식으로 사용할지는 사용하는 모듈의 대세방식(공식문서 등)을 따라하는것을 권장합니다.     

## 기본 내장 모듈
---
> 기본적인 모듈의 활용 방식은 다음과 같습니다.   


<a href="https://docs.python.org/ko/3/library/index.html" target="_blank">파이썬 표준 라이브러리</a>에 기본 내장 모듈이 상세히 설명되어 있습니다.   


1. **"내가 무엇을 해야겠다"라고 인지**   
  - 시간을 구해야하는 상황   
2. 구글 혹은 CHAT GPT 등을 이용하여 "무엇을 하려면 어떻게 해야하는지" 검색   
  - '파이썬 시간 구하기' 등 검색   
3. 검색한 코드를 복사하여 사용   
  - datetime 모듈 등   
4. 자주 사용되는 함수가 있다면 외워서 활용   
5. **모듈의 "함수 이름"보다는 "함수의 기능"을 기억하기**   

- random 모듈   

```python
import random

# 특정 범위의 랜덤한 float값 구하는 함수
print(random.uniform(10,20))
# 특정 범위의 랜덤한 int값 구하는 함수
print(random.randrange(10,20))
# 정해진 범위에서 랜덤하게 하나 선택
print(random.choice([1,2,3,4,5]))
```   


- sys 모듈

```python
import sys

# 명령문 아규먼트
print(sys.argv)
```   

- os 모듈

```python
import os

print(os.name)
print(os.listdir("."))
```   

- time 모듈

```python
import time

# 코드를 5초동안 정지
time.sleep(5)
```   


<br>



## 모듈 만들기
---
> 모듈은 파일 또는 폴더를 활용해서 구성됩니다.    
> 예를들어, `import 모듈이름`코드를 사용하면,   
> 현재 실행하고 있는 파일이 있는 위치에서   
> "모듈이름"이라는 파일 또는 폴더가 있는지 확인합니다.   
> 만약 존재하지않는다면 환경 변수에 등록되어 있는 위치에서 확인합니다.   
> 참고로, 모듈이름과 같은이름의 파일을 만들어서 사용하시면 오류가 발생합니다.   

- main.py에 hellomodule.py 모듈을 불러오는 예시   

```python
import hellomodule

print(hellomodule.a)
print(hellomodule.b())
print(hellomodule.c)

from hellomodule import Circle

c = Circle(10)
print(c.넓이())
print(c.둘레())
```   


- `__name__`변수 : 현재 파일 자신이 메인인지 모듈인지 확인   
    - 메인일 경우 `__main__` 출력, 모듈일 경우 모듈명 출력   


- `if __name__ == "__main__":` : 모듈내 코드 점검      

<br>



## 외부 모듈(라이브러리) 사용해보기
---

- 내장 모듈(built-in module)과 외부 모듈(external module)   
  - 내장 모듈 : math, sys, time 등의 기본 내장 모듈   
  - 외부 모듈 : 터미널에서 `pip install 모듈이름`으로 설치   


- 필요한 외부 모듈 찾는 방법   
  - 책에서 모듈 찾기   
    - 파이썬 웹 프로그래밍 : Django, Flask ...
    - 머신러닝 : scikit-learn, tensorflow ...
    - 스크레이핑 : requests, beautifulsoup ...
    - 영상 분석 : cv2, pillow ...
  - 파이썬 커뮤니티에 가입하여 트렌드 파악   
  - 구글링(with Chat GPT)   

- beautifulsoup4 모듈 사용해보기 : HTML/XML 데이터를 분석할 때 활용하는 모듈   

```python
# 기상철 날씨 정보 가져오기
from urllib import request
from bs4 import BeautifulSoup

기상청주소 = "https://www.kma.go.kr/weather/forecast/mid-term-rss3.jsp?stnId=108"
데이터 = request.urlopen(기상청주소)

soup = BeautifulSoup(데이터, "html.parser")

# soup.select()       # 특정 이름을 가진 태그를 모두 찾기
# soup.select_one()   # 특정 이름을 가진 태그를 하나만 찾기

# 각 지역의 시간별 날씨 파악
for location in soup.select("location"):
    city = location.select_one("city").string
    for data in location.select("data"):
        print(data.select_one("tmEf").string)
        print(data.select_one("wf").string)
        print(data.select_one("tmn").string)
        print(data.select_one("tmx").string)
```   


<br>

