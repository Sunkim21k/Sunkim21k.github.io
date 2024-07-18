---
#layout: post
title: Python study 6 - 함수 3
date: 2024-07-18
description: Python 람다, key 키워드 매개변수, 기본 파일 처리, 이터러블과 제너레이터 함수에 대해 학습합니다.  # 검색어 및 글요약
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
  - 람다와 key 키워드 매개변수에 대해 학습합니다.   
  - 기본 파일 처리와 CSV 사용법에 대해 학습합니다.   
  - 이터러블, 이터레이터, 제너레이터 함수와 제너레이터 표현식에 대해 학습합니다.   
  

<br>


## 람다
---
> `람다`는 이름이 없는 한 줄로 간결하게 함수를 만들고 싶을때 사용합니다.   

 - 람다 함수는 `lambda`키워드를 사용하여 정의하며,    
 - 기본 구문은 `lambda 매개변수들: 표현식` 입니다.   
 - 아래와 같이 두 숫자의 합을 계산하는 람다 함수를 예시로 들어보겠습니다.   

```python
# 두 숫자의 합을 계산하는 람다 함수
add = lambda x, y: x + y

# 람다 함수 호출
print(add(3, 5))  # 출력: 8
```   

### 람다 활용 : map 함수와 filter 함수   

 - map 함수 람다 활용   

```python
numbers = [1, 2, 3, 4, 5]
squared_numbers = list(map(lambda x: x ** 2, numbers))
print(squared_numbers)  # 출력: [1, 4, 9, 16, 25]
```   

 - filter 함수 람다 활용   

```python
numbers = [1, 2, 3, 4, 5]
even_numbers = list(filter(lambda x: x % 2 == 0, numbers))
print(even_numbers)  # 출력: [2, 4]
```   


<br>



## 리스트 함수의 key 키워드 매개변수
---

> 요소가 숫자인 리스트에서 최소값 또는 최대값을 구하려면 `min`함수와 `max`함수를 사용하여 구할 수 있습니다.   
> 그러나, 요소가 딕셔너리인 리스트에서 작동하려면 `min`함수와 `max`함수에 있는 `key 키워드 매개변수`를 사용해야 합니다.   
> 여기서 key 키워드 매개변수는 무엇을 비교할지 return 해주는 함수를 넣습니다.   
> return 해주는 함수는 간단한 경우 `lambda`를 활용할 수 있습니다.   


```python
# 요소가 숫자인 리스트에서 최소값 최대값 구하기
numbers = [10, 20, 50, 100, 30, 70]
print(min(numbers))
print(max(numbers))

# 요소가 딕셔너리인 리스트에서 최소값 최대값 구하기
names = [{
    "품종" : "푸들",
    "나이" : 1
}, {
    "품종" : "말티즈",
    "나이" : 3
}, {
    "품종" : "치와와",
    "나이" : 2
}]

# min/max 함수의 key 키워드 매개변수 사용
# key 키워드 매개변수 : 무엇을 비교할지 return 해주는 함수
def age(dict):
    return dict["나이"]

print(min(names, key=age))
# 람다식 표현
print(min(names, key=lambda name: name["나이"]))
print(max(names, key=age))
# 람다식 표현
print(max(names, key=lambda name: name["나이"]))
```   


<details>
<summary>출력값</summary>

10  <br>
100  <br>
{'품종': '푸들', '나이': 1}  <br>
{'품종': '푸들', '나이': 1}  <br>
{'품종': '말티즈', '나이': 3}  <br>
{'품종': '말티즈', '나이': 3}  <br>

</details>   



<br>




## 기본 파일 처리
---

 - 읽기 처리(r모드) 단계   
    1. 파일 열기 (스트림stream 연결) : `open("경로", "모드")` 함수 사용   
        - 경로 : 파일경로
        - 모드 : `w`쓰기, `a`추가해서 쓰기, `r`읽기   
        - ex) files = open("test.txt", "r")
    2. 스트림을 통해 데이터 통신 : 
        - 전체 읽기 : `read`함수 사용.   
        - 한 줄씩 읽기 : `readline`함수 사용    
        - 모든 줄을 읽어 리스트로 반환 : `readlines`함수 사용    
        - ex) text = files.read()     

    3. 스트림 해제 (파일 닫기) : `close`함수 사용   
        - ex) files.close()   # 파일을 닫지 않으면 추가적일 스트림 연결을 할 수 없습니다.   
    4. **with 문** 사용 : 파일 처리를 할때, **파일을 열고 닫는 과정을 자동으로 처리**하여 안전하고 편리합니다.       

```python
with open("test.txt", "r") as files:
    text = files.read()
    print(text)
```   

 - 쓰기 처리 `"w"`모드 : `"w"`모드와 `write`함수를 사용합니다. 파일이 이미 존재하면 내용을 덮어쓰기합니다.            
     - `writelines`메서드 : 문자열 리스트를 쓸때 사용합니다.   

```python
# 쓰기모드는 "w", 경로에 파일이 없으면 새로 생성
with open("abc.txt", "w") as files:
    files.write("Hello")   # "abc.txt"파일에 "Hello" 입력
```   

 - 쓰기 처리 `"a"`모드 : 파일이 이미 존재하면 내용 끝에 덧붙입니다.      

<br>

### CSV(Comma Separated Values)   

> 데이터가 `,`콤마로 구분되어 있는것을 csv라고 합니다.   
> 데이터분석시 CSV의 간단한 사용방법을 알아보겠습니다.   

 - BMI 데이터 랜덤하게 10명 CSV형식으로 만들기     

```python
# BMI 데이터 만들기
# Case 1: 랜덤하게 10명의 키와 몸무게를 CSV로 만들기
import random

text = list("가나다라마바사아자차카타파하")

with open("BMI.txt", "w") as files:
    files.write("이름,몸무게,키\n")   # CSV 헤더부분 (생략가능)
    for i in range(10):
        name = random.choice(text) + random.choice(text)
        body_weight = random.randrange(50, 150)
        height = random.randrange(130, 190)
        files.write(f"{name},{body_weight},{height}\n")
```   

 - CSV 데이터 한 줄씩 읽기   

```python
# BMI 분석하기
# Case 2: CSV 데이터 한 줄씩 읽기
with open("BMI.txt", "r") as files:
    for oneline in files:  # 파일을 한 줄씩 읽기
        # 다중 할당 구문 활용
        name,body_weight,height = oneline.strip().split(",")

        # 몸무게가 숫자가 아니면 넘어감
        if not body_weight.isdigit():
            continue

        body_weight = int(body_weight)
        height = int(height)

        bmi = body_weight / (height / 100) ** 2

        result = ""
        if 25 <= bmi:
            result = "과체중"
        elif 18.5 <= bmi:
            result = "정상체중"
        else:
            result = "저체중"

        # 한 줄씩 출력
        print("\n".join([
            f"이름: {name}",
            f"몸무게: {body_weight}",
            f"키: {height}",
            f"BMI: {bmi}",
            f"결과: {result}", ""
        ]))
```  



## 이터러블, 이터레이터, 제너레이터 함수
---

> **이터러블**은 반복문 형태에서 (for 요소 in 반복할수있는것) `반복할수있는것`을 말합니다.   
> Iterate반복한다 + able = 반복할수있는것    
> 이터러블의 예시로는 리스트, 튜플, 딕셔너리 등이 있습니다.   
> 이터러블을 만드는 방법중에서는 이터레이터(Iterate + or)를 만드는 방식이 있습니다.   

 - 이터레이터 만드는 방법
     - 제너레이터 표현식 사용 
     - 제너레이터 함수 사용
     - 이터레이터 클래스 사용

> 정리하면,
> 제너레이터 표현식, 제너레이터 함수, 이터레이터 클래스는 이터레이터를 만들고,   
> 이터레이터는 이터러블을 만듭니다.   
> 각각 이터레이터를 만드는 방식을 살펴보겠습니다.   

### 제너레이터 표현식   

> 리스트 내포 구조를 먼저 살펴보겠습니다.   

```python
[
  표현식
  for 요소 in 반복할수있는것
  if 조건식
]
```  

> 리스트 내포 형식으로 숫자 1부터 100까지의 범위를 만들어보면 아래와 같습니다.      

```python
# 제곱 리스트 내포 만들기
리스트내포 = [
  i * i
  for i in range(1, 100 + 1)
]
print(리스트내포)
```  

> **제너레이터 표현식**은 리스트 내포의 `[]`괄호를 `()`괄호로 바꾸면 됩니다.     

```python
제너레이터표현식 = (
  i * i
  for i in range(1, 100 + 1)
)
print(제너레이터표현식)
```  


#### 이터레이터와 next() 함수   

> 제너레이터 표현식을 사용해서 만든 이터레이터를 `next`함수의 매개변수에 넣어서 내부의 요소를 꺼낼 수 있습니다.   

```python
제너레이터표현식 = (
  i * i
  for i in range(1, 100 + 1)
)
print(next(제너레이터표현식))
print(next(제너레이터표현식))
print(next(제너레이터표현식))
```  

<details>
<summary>출력값</summary>

1  <br>
4  <br>
9  <br>

</details>   


### 제너레이터 함수   

> 제너레이터 함수를 사용하려면 return 대신 `yield`를 사용하여 값을 반환합니다.    

 - 제너레이터 함수 특징   
     - 함수를 호출했을때, 내부의 코드가 즉시 실행되지않고 제너레이터를 리턴합니다.   
     - 제너레이터는 이터레이터를 만드는 방법 중 하나이기 때문에 `next`함수를 사용하여 내부의 요소를 꺼낼 수 있습니다.   

```python
def f():
  for i in range(1, 100 + 1):
    yield i * i

generator_ = f()
print(next(generator_))
print(next(generator_))
print(next(generator_))
```  

<details>
<summary>출력값</summary>

1  <br>
4  <br>
9  <br>

</details>   


### 리스트 내포와 제너레이터 함수의 차이   

 - 리스트 내포 : 코드 실행시 자원(CPU와 메모리 등) 소모가 제너레이터보다 큼   
     - 코드 실행시 새로운 리스트 생성   
     - 새로운 요소를 만들어내기위해 표현식 연산을 즉시 실행   

 - 제너레이터 표현식과 함수 : 메모리를 적게 사용하며 연산이 분산됨   
     - 기존의 데이터를 사용   
     - 특정 요소를 사용할 때, 표현식 연산을 진행함   

> 만약, 10000개의 데이터 연산을 10000초에 걸쳐 수행한다면,   
> 리스트 내포 코드는 10000초후 한꺼번에 출력됩니다.   
> 하지만 제너레이터 표현식 또는 함수는 1초마다 하나씩 출력해서 보여주는 차이가 있습니다.   
> 즉, 리스트 내포는 데이터가 클수록 자원소모가 큽니다.   
> 리스트 내포는 데이터를 미리 만들어두고 빠르게 출력할 떄 사용합니다.   

<br>



