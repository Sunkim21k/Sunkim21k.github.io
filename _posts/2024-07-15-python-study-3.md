---
#layout: post
title: Python study 3 - 조건문, 반복문, 리스트관련 함수
date: 2024-07-15
description: Python 조건문, 반복문, 리스트 관련 함수에 대해 학습합니다. # 검색어 및 글요약
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

<br>

> Python에서 사용되는 개념의 일부 혹은 전체를 정리하여 반복학습에 사용합니다.
  - 조건문에 대해 학습합니다.
  - 반복문과 관련된 리스트, for 반복문과 while 반복문에 대해 학습합니다.
  - 리스트, 딕셔너리와 관련된 함수를 학습합니다.   

<br>


## 조건문
---
> 조건문에 응용할 Python 날짜/시간 구하는 방법    

```python
# 날짜/시간 구하는 방법
import datetime
import pytz  # 미설치시 shell에서 설치

seoul = pytz.timezone("Asia/Seoul")
now = datetime.datetime.now(seoul)
```   

 - if문 이용 상기 소스로 오전/오후 구분하는 프로그램 생성   
  
```python
print(f"{now.hour}시입니다!")

if now.hour < 12:
    print("오전입니다!")
else:
    print("오후입니다!")
```     
 - IndentationError : Python에서 들여쓰기를 잘못사용할 경우 해당 에러가 발생하여 들여쓰기가 잘못된곳을 찾아야합니다.   
   - 예시1   
  
    ```python
    print("A")
    if False:
      print("B")
      print("C")
        print("Error") # 들여쓰기 잘못된곳
    print("D")
    ```     
   - 예시2   
  
    ```python
    print("A")
    if False:
      print("B")
    print("C")
      print("Error") # 들여쓰기 잘못된곳
    ```     

 - bool() 자료형 변환 활용   
    - None, 숫자 0(0.0), 빈 컨테이너, 빈 문자열을 `bool()`자료형 변환시 `False`를 반환합니다.   
    - 그 외 `bool()`변환시 `True`를 반환합니다.   
    - 예시   
      ```python
      name = "홍길동"
      if name: 
        print(f"{name}")
      ```       
    여기서 `name`에 `bool()`자료형이 `True`값을 반환하므로 `"홍길동"`이 출력됩니다.   

 - raise와 pass   
     - raise NotImplNotImplementedError : 작성한 코드줄에 오류를 생성. 향후 코드를 작성하기위해 임시로 코드입력시 사용   
     - pass : 특정 코드를 아무것도 입력안했을시, 에러방지용으로 넘어가는 코드처리   

<br>  

## 반복문
---

### 리스트와 배열
- 배열 : 길이가 고정된 형태   
- 리스트 : 배열에 요소를 추가/제거 등의 기능을 추가한 것   
  - 리스트 길이 : len() 함수 사용   
  - 리스트 거꾸로 뒤집기 : 문자열[숫자A:숫자B:스탭] 형태이용하여 `[::-1]` 뒤집기 스탭사용   
  - 리스트는 중첩이 가능합니다.   
    ```python
    num1 = [1, 3]
    num2 = [num1, num1]  # 2차원 리스트
    print(num2)
    print(num2[0][1])
    ```       

    > 출력값 :   
    > [[1,3], [1,3]]    
    > 3   

### 리스트의 함수
 - 요소 추가(**파괴적 연산**) : append(), insert(), extend()   
   - append(요소) : 가장 마지막에 요소를 추가하는 함수
   - insert(index, 요소) : 원하는 위치에 요소를 하나 추가 a.append(10) == a.insert(-1, 10)
   - extend([요소, 요소, 요소]) : 가장 마지막에 요소를 여러개 추가 a.extend([5, 6]) == a += [5, 6]
 - 요소 제거(**파괴적 연산**) : del, pop(), remove(), clear()   
   - del a[index] : 선택한 인덱스 제거
   - pop(index) : 선택한 인덱스 제거(미입력시 -1)
   - remove(요소) : 입력한 요소 제거
   - clear() : 모든 요소 제거
 - 요소 정렬(**파괴적 연산**) : sort()   
   - sort() : 오름차순으로 출력  
   - sort(reverse=True) : 내림차순으로 출력
 - 요소 확인(**비파괴적 연산**) : in, not in   
   - A in B : `A`가 `B`에 있는지 True/False 반환   
   - A not in B : `A`가 `B`에 없는지 True/False 반환   

### for 반복문
  - for 반복문 형식   
    for 반복변수 in 리스트:   
    　　복합구문
  - for 반복문 예시 : 총합과 총곱 계산   
    ```python
    num = [1, 3, 5]
    
    sum = 0
    prod = 1
    for i in num:
      sum += i
      prod *= i
    print(sum)
    print(prod)
    ```       

### 중첩반복분

```python
num = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

for i in num:
    print(i)
    for j in i:  # 중첩 반복문
        print(j)
```  

<details>
<summary>출력값</summary>

[1, 2, 3]   <br>
1    <br>
2   <br>
3   <br>
[4, 5, 6]   <br>
4   <br>
5   <br>
6   <br>
[7, 8, 9]   <br>
7   <br>
8   <br>
9   <br>

</details>

### 전개연산자
 - 리스트앞에 `*`를 붙여서 해당리스트 목록을 가져올 수 있습니다. 리스트 요소를 복사하고 싶을때 주로 사용합니다.   

```python
num = [1, 2, 3]
num_new = [*num, num, 4]

print(num_new)
print(num_new[0])
```  

<details>
<summary>출력값</summary>

[1, 2, 3, [1, 2, 3], 4]   <br>
1    

</details>

 - 전개연산자를 매개변수를 풀어서 출력할 수 있습니다.    
  
```python
watch = [14, 22, 34]

print("{}시 {}분 {}초".format(watch[0], watch[1], watch[2]))
```   

위 아래 코드는 동일한 값을 출력합니다.  

```python
watch = [14, 22, 34]

print("{}시 {}분 {}초".format(*watch))
```  

### 딕셔너리

 - 생성 : a = {키:값}   
  `{키:값}` → "이름":"홍길동", "나이":00, "사는곳":"서울"   
  a["이름"] = "홍길동"   
  a["나이"] = 00   
  a["사는곳"] = "서울"  
   - 키 : 숫자, 문자열, 불, 튜플 입력가능   
   - 값 : 모두 입력가능   

 - for 반복문에서 사용   
    ```python
    a = {
        "이름" : "홍길동",
        "나이" : 90,
        "사는곳" : "서울"
    }

    for key in a:
        print(key)
        print(a[key])
        print("ㅡ" * 10)
    ```   

<details>
<summary>출력값</summary>

이름   <br>
홍길동   <br>
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
나이   <br>
90   <br>
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
사는곳   <br>
서울   <br>
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>

</details>

    ```python
    a = [{
        "이름" : "홍길동",
        "나이" : 90,
        "사는곳" : "서울"
    }, {
        "이름" : "홍길순",
        "나이" : 40,
        "사는곳" : "제주"
    }]
    for i in a:
        for key in i:
            print(key)
            print(i[key])
        print("ㅡ" * 10)
    ```   

<details>
<summary>출력값</summary>

이름   <br>
홍길동   <br>
나이   <br>
90   <br>
사는곳   <br>
서울   <br>
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
이름   <br>
홍길순   <br>
나이    <br>
40   <br>
사는곳   <br>
제주   <br>
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>

</details>

 - 딕셔너리 요소 추가/수정/제거   
    - 딕셔너리 예시 test1 = {"이름" : "홍길동", "나이" : 40}  
    - 요소의 값 변경 : test1["이름"] = "홍길순"   
    - 요소 추가 : test1["사는곳"] = "서울"
    - 요소 제거 : `del` test1["사는곳"]
    - 키의 존재 유무 확인 방법 : `in 사용` "성별" in test1 → True/False 반환    
    - get() 함수 : test1.get(key) 형식이며, 키가 존재하지않는경우 `None` 반환   
      test1.get("이름") → "홍길동"   

### 범위
> 특정한 범위 내부의 정수들을 나열하는 자료형으로서, `range()`함수를 사용합니다.   
> range()함수는 인덱싱 문자열[]과 슬라이싱 문자열[:], [::] 기능과 비슷하게 작동합니다.   

 - range(숫자A) : `0`부터 `숫자A-1`까지의 정수를 범위로 나열   
 - range(숫자A, 숫자B) : `숫자A`부터 `숫자B-1`까지의 정수를 범위로 나열   
 - range(숫자A, 숫자B, 숫자C) : `숫자A`부터 `숫자B-1`까지의 정수를 `숫자C`만큼씩 스탭하면서 나열   
 - 예시
    ```python
    print(list(range(10)))
    print(list(range(2, 10)))
    print(list(range(2, 10, 3)))
    ```   

<details>
<summary>출력값</summary>

[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]   <br>
[2, 3, 4, 5, 6, 7, 8, 9]   <br>
[2, 5, 8]   <br>

</details>

### reversed()함수
> reversed()함수는 반복 가능한 매개변수를 넣으면 뒤집은 결과를 리턴해줍니다.   
> 리턴해주는 자료형은 `이터레이터`라는 특수 자료형입니다.   

예시) list(reversed([1, 2, 3])) → [3, 2, 1]   

 - reversed()함수 활용
   - range() 범위 함수 : `list(reversed(0, 5))`
   - 반복문 뒤집기 : `for i reversed(range(0, 5)):`


<br>  

### while 반복문
> while 반복문은 조건이 참이라면 무한 반복하는 형태입니다.   
> 파이썬에서는 while 반복문이 for 반복문보다 범용성이 좋습니다.   
> for 반복문에서 구현한 코드를 while 반복문으로 구현할 수 있지만,   
> 반대의 경우 코드구성이 난해하거나 불가할 수 있습니다.   

 - 시간 기반 예시 : 현재시간이 시작시간 + 5초 보다 커지면 멈추는 반복문   

  ```python
  import time

  start_time = time.time()
  current_time = time.time()

  while current_time < start_time + 5:
      print(current_time, start_time + 5)
      current_time = time.time()
  ```   

 - break와 continue 키워드   
   - `break`키워드는 반복문 전체를 벗어날 때 사용하는 구문입니다.   

    ```python
    i = 0
    while True:
        print(f"{i}번째 반복입니다.")
        i += 1

        test = input("종료 하시겠습니까?(y/n): ")
        if test in ["y", "Y"]:
            break
    ```   

   - `continue`키워드는 현재 반복을 넘어갈 때 사용하는 구문입니다.   

    ```python
    # 5이상의 숫자만 출력
    numbers = [1, 3, 5, 7 ,9]
    for i in numbers:
        if i < 5:
            continue
        print(i)
    ```   

<br>


## 리스트와 딕셔너리 관련 함수
---

 - 리스트에 적용할 수 있는 기본 함수 : min(), max(), sum()   

    ```python
    numbers = [1, 5, 10, 15, 20]

    print(max(numbers))
    print(min(numbers))
    print(sum(numbers))  # numbers 리스트에 숫자가 아닌 요소가 있다면 오류발생

    # print(max(1, 5, 10, 15, 20))
    print(max(*numbers))
    # print(min(1, 5, 10, 15, 20))
    print(min(*numbers))
    # sum 함수는 가변인자를 받지 않기 때문에 *numbers 불가
    ```   

    <details>
    <summary>출력값</summary>

    20   <br>
    1   <br>
    51   <br>
    20   <br>
    1   <br>

    </details>

 - 리스트 뒤집는 함수 : reversed()
   - > reversed() 함수는 동일한 할당을 할경우 제일 처음만 실행되며, 이후 할당된 것은 무시됩니다.    

    ```python
    numbers = [1, 3, 5, 7, 9]

    for number in reversed(numbers):
        print(number)
    ```   

    <details>
    <summary>출력값</summary>

    9   <br>
    7   <br>
    5   <br>
    3   <br>
    1    <br>

    </details>


 - 현재 인덱스 위치를 확인하는 함수 : enumerate()   
   - > enumerate() 함수도 하나의 할당만 실행되며, 이후 할당된 것은 무시됩니다.   

    ```python
    dogs = ["푸들", "말티즈", "웰키코기"]

    for dog in enumerate(dogs):
        print(dog[0], dog[1])
    ```   

    <details>
    <summary>출력값</summary>

    0 푸들   <br>
    1 말티즈   <br>
    2 웰키코기   <br>

    </details>


 - 딕셔너리로 반복문 활용함수 : items(), keys(), values()   

    ```python
    dog = {
        "종류": "푸들",
        "나이": 2,
        "사는곳": "한국"
    }
    print(dog.items())
    for info in dog.items():
        print(info[0], info[1])

    print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")

    print(dog.keys())
    for info in dog.keys():
        print(info)

    print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")

    print(dog.values())
    for info in dog.values():
        print(info)

    print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
    ```   

    <details>
    <summary>출력값</summary>

    dict_items([('종류', '푸들'), ('나이', 2), ('사는곳', '한국')])   <br>
    종류 푸들   <br>
    나이 2   <br>
    사는곳 한국   <br>
    ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
    dict_keys(['종류', '나이', '사는곳'])   <br>
    종류   <br>
    나이   <br>
    사는곳   <br>
    ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
    dict_values(['푸들', 2, '한국'])   <br>
    푸들   <br>
    2    <br>
    한국   <br>
    ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>

    </details>

 - 리스트 내포(List comprehension) : 반복가능한 것을 새로운 리스트로 만들어내는 문법   
   - `[표현식 for 반복문]` 형태    

    ```python
    # An = 2n + 1 (0 <= n < 10)
    # A = {1, 3, 5, 7, 9, ..., 19}
    A = []
    for i in range(0, 10):    # 반복문
        A.append(2 * i + 1)   # 표현식 2 * i + 1
    print(A)

    print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
    # 리스트 내포 식
    # [표현식 for 반복문]
    B = [2 * i + 1 for i in range(0, 10)]
    print(B)
    ```   

    <details>
    <summary>출력값</summary>

    [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]   <br>
    ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
    [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]   <br>

    </details>   

   - 리스트 내포와 조건 : `[표현식 for 반복문 조건문]` 형태   

    ```python
    # 리스트 내포 식
    # [표현식 for 반복문]
    C = [
        2 * i + 1              # 표현식
        for i in range(0, 10)  # 반복문
        if i % 2 == 0          # 조건문
    ]
    print(C)
    ```   

    <details>
    <summary>출력값</summary>

    [1, 5, 9, 13, 17]   

    </details>   

 - join() 함수 : `"".join([list])` 리스트에 있는 **문자열**들을 앞에있는 문자열로 연결해주는 함수     
    ```python
    print("\n".join([
        f"join() 함수를 통해",
        f"깔끔한 코드와",
        f"줄바꿈을 할 수 있어요."
    ]))
    ```   

    <details>
    <summary>출력값</summary>

    join() 함수를 통해   <br>
    깔끔한 코드와   <br>
    줄바꿈을 할 수 있어요.    <br>

    </details>   

