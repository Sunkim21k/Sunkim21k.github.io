---
#layout: post
title: Python study 5 - 함수 2
date: 2024-07-18
description: Python 조기리턴과 리스트 평탄화, 튜플, 콜백함수에 대해 학습합니다.  # 검색어 및 글요약
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
  - 조기리턴과 리스트 평탄화에 대해 학습합니다.   
  - 튜플과 이뮤터블 자료, 뮤터블 자료에 대해 학습합니다.   
  - 콜백함수와 map/filter 함수에 대해 학습합니다.     

<br>


## 조기리턴과 리스트 평탄화
---

### 조기리턴(early return)   

> `조기리턴`은 함수나 메서드에서 특정 조건을 만족하면 즉시 함수를 종료하고 값을 반환하는 프로그그래밍 기법입니다.   
> 조기리턴을 사용하면 코드의 가독성을 높이고 불필요한 연산을 줄일 수 있습니다.   

 - 조기 리턴의 장점   
    1. 코드 가독성 향상 : 조건을 먼저 확인하고, 조건이 만족되면 바로 반환하기때문에 코드가 더 명확해집니다.   
    2. 불필요한 연산 방지 : 조건을 만족하지 않는 경우 바로 종료하여 불필요한 연산을 줄일 수 있습니다.   
    3. 중첩된 구조 감소 : 여러 조건문을 중첩시키지 않고, 간결한 코드를 작성할 수 있습니다.   
  
 - 조기 리턴 예시

 예시1) 재귀 함수에서 기저조건을 만나면 함수를 종료하는 조기리턴 사용   

```python
def factorial(n):
    if n == 0:
        return 1  # 조기 리턴
    return n * factorial(n - 1)

result = factorial(5)
print(result)  # 결과: 120
```   
  
  예시2) 피보나치수열 재귀함수에서 else 조건 제거   

```python
memo = {1 : 1, 2: 1}

def f(n):
    if n in memo:
        return memo[n]
                            # else:
    temp = f(n - 1) + f(n - 2)
    memo[n] = temp
    return temp

print(f(10))
```   



### 리스트 평탄화

> `리스트 평탄화`는 중첩된 리스트가 있을 때 중첩을 모두 제거하여 1차원 리스트로 만드는 작업입니다.   
> 재귀함수를 이용하여 리스트 평탄화 작업을 해봅시다.   


```python
def flatten(data):
    output = []
    for i in data:
        if type(i) == list:
            output.extend(flatten(i))   # 재귀 함수
        else:
            output.append(i)
    return output


data = [[1, 2, 3],
        [4, [5, 6]],
        7, [8, 9],
        [5, [[[5,6], [[6, 8,[[[7, 9]]]]]]]]]
print(flatten(data))  
```   

출력값 : [1, 2, 3, 4, 5, 6, 7, 8, 9, 5, 5, 6, 6, 8, 7, 9]   
  


<br>

## 튜플, 이뮤터블 자료, 뮤터블 자료
---

### 튜플   

> `튜플(tuple)`은 **순서가 있는 변경 불가능한 자료형** 중 하나입니다.   
> 튜플은 여러개의 값을 하나의 변수에 저장할 수 있으며, 각 값은 `,`쉼표로 구분됩니다.   
> 튜플을 한 개의 요소만 가질때는 쉼표를 포함해야 합니다.   
> 튜플의 요소는 변경, 추가, 삭제할 수 없습니다.   
> 이를 이용하여 불변성을 유지해야하는 데이터를 그룹화하여 처리할 때 유용합니다.   

튜플 생성 예시)   

```python
# 예제 1: 여러 요소가 있는 튜플
my_tuple = (1, 2, 3, 4, 5)

# 예제 2: 혼합된 데이터 타입을 가지는 튜플
mixed_tuple = (1, "hello", 3.14, True)

# 예제 3: 한 개의 요소만 가지는 튜플 (쉼표를 포함해야 함)
single_element_tuple = (42,)
```   

 - **튜플의 특징**   
     - 튜플의 요소는 변경, 추가, 삭제할 수 없다. (리스트와 차이점)   
     - 인덱스를 사용하여 튜플의 요소 접근이 가능하다. (리스트와 동일)   
     - 다중 할당 구문이 가능하다.   

      ```python
      def get_person_info():
          name = "Alice"
          age = 30
          city = "Wonderland"
          return name, age, city

      person_info = get_person_info()
      print(person_info)  # 출력: ('Alice', 30, 'Wonderland')

      name, age, city = person_info
      print(name)  # 출력: Alice
      print(age)   # 출력: 30
      print(city)  # 출력: Wonderland
      ```   



 - 튜플과 함수 리턴

```python
def f():
    return 10, 20, 30  # == (10, 20, 30)

b, c, d = f()   # == (b, c, d) = f()
# (b, c, d) = (10, 20, 30)
print(b, c, d)
```   

현재 인덱스를 위치를 확인하는 enumerate 사용 예시   

```python
dogs = ["푸들", "말티즈", "치와와"]

for num, name in enumerate(dogs):
    print(num, name)
```   

<details>
<summary>출력값</summary>

0 푸들  <br>
1 말티즈  <br>
2 치와와  <br>

</details>   


딕셔너리 items() 사용 예시   

```python
dogs = {"푸들" : 1,
        "말티즈" : 3,
        "치와와" : 2
        }

for key, value in dogs.items():
    print(key, value)
```   

<details>
<summary>출력값</summary>

푸들 1  <br>
말티즈 3  <br>
치와와 2  <br>

</details>    

### 뮤터블과 이뮤터블

> 일반적으로 자료를 구분할때 기본자료형(숫자, bool, 문자열 등)과 복합자료형(리스트, 딕셔너리)으로 구분합니다.   
> 위와 상관없이 자료를 구분할때 뮤터블자료와 이뮤터블자료로 구분할수도 있습니다.   

 - 이뮤터블 자료 : 변수에 넣었을 때, 스택에 있는 값을 변경해야만 값을 변경할 수 있는 자료를 말합니다.   
    - 숫자, 문자열, bool, 튜플   

 - 뮤터블 자료 : 변수에 넣었을 때, 스택에 있는 값을 변경하지 않아도 값을 변경 할 수 있는 자료를 말합니다.     
    - 리스트, 딕셔너리   

 - 뮤터블 자료 + 이뮤터블 자료 사용예시   
    - 튜플과 딕셔너리 `메모화`   

 ```python
days = {
    (1, 1) : "새해",
    (5, 5): "어린이날",
    (12, 25): "크리스마스"
        }

print(days)
```   


<br>


## 콜백함수와 map/filter 함수
---

### 콜백함수   
 - 함수는 변수에 저장할 수 있습니다.   
 - `콜백함수`는 다른 함수에 인수로 전달되어 호출되는 함수입니다.   
 - 콜백함수의 기본구조는 다음과 같습니다.   
     - 함수정의 : 호출될 함수를 정의합니다.   
     - 함수전달 : 다른 함수에 인수로 전달합니다.   
     - 함수호출 : 조건이 만족되면 전달된 함수를 호출합니다.   


```python
def call_back():
    print("함수가 호출되었습니다")

a = call_back
print(a)  # 함수 위치 : <function call_back at 0x000001B6CADD4AE0>
a()       # 함수 호출 : 함수가 호출되었습니다

```  



### map/filter 함수

 - map()함수 : 각각의 요소에 함수를 적용하여 새로운 이터레이터(리스트)를 리턴하는 함수   
   - map(함수, 리스트) → 이터레이터 return   

    ```python
    def power(number):
        return number ** 2

    a = [1, 2, 3, 4, 5]
    result = map(power, a)
    print(list(result))
    ```   

    출력값 : [1, 4, 9, 16, 25]   

    map()함수 구현해보기   

    ```python
    def my_map(callback, list_):
        output = []
        item = [output.append(callback(i)) for i in list_]
        return output
    def power(number):
        return number ** 2

    a = [1, 2, 3, 4, 5]
    print(my_map(power, a))
    ```   


 - filter()함수 : 리스트의 요소를 함수에 전달했을때, True 결과만 모아서 새로운 이터레이터(리스트)를 만드는 함수    
   - filter(함수, 리스트)   

    ```python
    def num_check(number):
        if number % 2 == 1:
            return True
        else:
            return False

    a = [1, 2, 3, 4, 5]
    result = filter(num_check, a)
    print(list(result))
    ```   

    출력값 : [1, 3, 5]   


    filter()함수 구현해보기   

    ```python
    def my_filter(callback, list_):
        output = []
        for i in list_:
            if callback(i):
                output.append(i)
        return output
    def is_odd(number):
        return number % 2 == 1

    a = [1, 2, 3, 4, 5]
    print(my_filter(is_odd, a))
    ```   

<br>
