---
#layout: post
title: Python study 4 - 함수 1
date: 2024-07-17
description: Python 함수의 기본 구조와 가변 매개변수 함수 등에 대해 학습합니다. # 검색어 및 글요약
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
  - 함수의 기본 구조와 가변 매개변수 함수, 기본 매개변수에 대해 학습합니다.   
  - 함수의 리턴과 재귀 함수에 대해 학습합니다.   

<br>


## 함수의 기본 구조   
---

```python
def 이름():
  코드

이름() # 함수 호출
```   

 - `매개변수` : 함수의 `()`안에 넣는 변수   
 - `파라미터`parameter : 함수 정의 때 넣은 변수   
 - `아규먼트`argument : 함수 호출때 넣은 값   
 - 최근에는 딱히 구분없이 매개변수, 파라미터, 아규먼트 혼용해서 사용하는 추세입니다.   
 - 매개변수는 여러개 넣을 수 있습니다. 이때 아큐먼트 값이 파라미터보다 적거나 많으면 오류가 발생됩니다.   

```python
def 이름(문자):  # parameter
  print(문자)

이름("Hello")  # argument
```   

출력값 : Hello   

 - 함수 설계시 검토사항   
    1. 함수의 설명을 문서화(혹은 주석)   
    2. 예외 처리   

<br>

## 가변 매개변수 함수
---

> 함수의 기본 구조는 파라미터 갯수와 아규먼트 갯수가 동일하지않으면 오류가 발생합니다.   
> 그런데 `print()`함수는 아규먼트를 몇개를 넣어도 갯수와 상관없이 함수가 정상적으로 실행됩니다.   
> 이처럼 **아규먼트가 가변적으로 변하는 함수**를 `가변 매개변수 함수`라고합니다.   

 - 가변 매개변수는 매개변수 앞에 `*`을 넣어서 만듭니다.   
 - 다른 함수 사용시 함수에 가변 매개변수가 있다면 `*abc` 또는 `abc, ...` 처럼 표현되어 있다면,   
 - 해당 함수는 가변 매개변수 함수라는 의미입니다.   
 - **리스트를 가변 매개변수 함수의 매개변수로 전달할 때**는 `전개연산자 *`를 사용합니다.   
 - ***가변 매개변수 뒤에는 일반 매개변수가 올 수 없습니다.*** 이는 아규먼트 값이 전부 가변 매개변수에 들어가기 때문입니다.   
 - 만약, 가변 매개변수 뒤에 일반 매개변수를 사용하고 싶을때는 해당 매개변수를 키워드로 지정해줘야 합니다. 이를 `키워드 매개변수`라고 합니다.   
   - `def 함수(*리스트, 이름):` 일때, 함수 호출시 `함수([리스트], 이름="홍길동")` 키워드 지정       

```python
# 문자열 여러개 받기 print_n_times(count, [list_])
def print_n_times(count, list_):
    for i in range(count):
        for list_index in list_:
            print(list_index)

print_n_times(2, ["Hello", "Bye"])

print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")

# 가변 매개변수 사용하기 print_n_times(count, *리스트)
def print_n_times2(count, *list_):
    print("list_는 어떤식으로 받아질까?")
    print(list_)
    print("***********************")
    for i in range(count):
        for list_index in list_:
            print(list_index)

print_n_times2(2, "Hello", "Bye")

print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")

# 리스트를 가변 매개변수에 전달 print_n_times(count, *리스트)
def print_n_times3(count, *list_):
    print("list_는 어떤식으로 받아질까?")
    print(list_)
    print("***********************")
    for i in range(count):
        for list_index in list_:
            print(list_index)

test_name = ["Hello", "Bye"]
print_n_times3(2, *test_name)

print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")

# 가변 매개변수 뒤에 일반 매개변수가 있을때 키워드 지정
def print_n_times4(*list_, count):
    print("list_는 어떤식으로 받아질까?")
    print(list_)
    print("***********************")
    for i in range(count):
        for list_index in list_:
            print(list_index)

test_name = ["Hello", "Bye"]
print_n_times4(*test_name, count = 2)
```  


<details>
<summary>출력값</summary>

Hello   <br>
Bye   <br>
Hello   <br>
Bye   <br>
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
list_는 어떤식으로 받아질까?   <br>
('Hello', 'Bye')   <br>
***********************   <br>
Hello   <br>
Bye   <br>
Hello   <br>
Bye   <br>
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
list_는 어떤식으로 받아질까?   <br>
('Hello', 'Bye')   <br>
***********************   <br>
Hello   <br>
Bye   <br>
Hello   <br>
Bye   <br>
ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   <br>
list_는 어떤식으로 받아질까?   <br>
('Hello', 'Bye')   <br>
***********************   <br>
Hello   <br>
Bye   <br>
Hello   <br>
Bye   <br>

</details>

<br>


## 기본 매개변수
---

 - 기본 매개변수(디폴트 매개변수) : 매개변수에 아무것도 입력하지 않았을때 특정한 값이 들어가는 매개변수   
 - 키워드 매개변수 : 내가 변경하고싶은 매개변수에 값을 지정  
 - 기본 매개변수는 다른 매개변수보다 뒤에 나와야합니다.    

```python
def test_num(i = 10, j = 20):  # 기본 매개변수(디폴트 매개변수)
    print(i, j)

test_num()       # 기본 매개변수 출력
test_num(50)     # i는 변동된 값, j는 기본 매개변수 출력
test_num(j = 30) # 키워드 매개변수 : i 매개변수는 그대로 두면서 j 매개변수만 바꾸고싶을때
```   

출력값   
10 20   
50 20   
10 30   
   
> print()함수의 매개변수인 **sep와 end**는 `키워드 매개변수` 인데요,     
> 가변 매개변수인 `*values`에 값을 입력하면,   
> `sep`매개변수는 `sep=" "`이 기본값으로 values값을 띄어쓰기로 구분해서 출력하고,     
> `end`매개변수는 `end="\n"`이 기본값으로 values값을 모두 출력하면 줄바꿈 처리합니다.   
> 해당 키워드 매개변수를 바꾸면 print()함수를 다른 결과값으로 출력하는것을 볼 수 있습니다.       
{: .prompt-tip }   

```python
print("H", "e", "l", "l", "o")
print("H", "e", "l", "l", "o", sep = "?!")  # sep 매개변수 수정
print("H", "e", "l", "l", "o", end = "...") # end 매개변수 수정
```   

출력값   
H e l l o   
H?!e?!l?!l?!o   
H e l l o...   
   
 - 딕셔너리 매개변수 : `**딕셔너리` 형식   

```python
# 딕셔너리 매개변수
def names(*name, **dict):
    print(name, dict)

names("H", "e", "l", "l", "o",
      hong = 10, gil = 12, dong = 14)
```   

출력값   
('H', 'e', 'l', 'l', 'o') {'hong': 10, 'gil': 12, 'dong': 14}   


<br>


## 함수 리턴
---
> 함수를 호출했을때 return을 통해 값을 돌려받습니다.   
> 이때, return값이 없으면 `None` 값을 돌려받습니다.

```python
def math1(x):
    return x + 1

def no_return(i):
    return

print(math1(5))
print(no_return(5))
```   

출력값   
6   
None   

```python
# 1부터 50까지 더해주는 함수 만들기
def sum_f(first, end):
    num = 0
    for i in range(first, end + 1):
        num += i
    return num

print(sum_f(1, 50))
```   

출력값 : 1275    

   
<br>


## 재귀함수
---

> `재귀함수`는 **자기 자신을 다시 호출하는 함수*입니다.   
> 조금 더 쉽게 표현하자면, 함수가 자기 자신을 계속해서 호출해서 큰 문제를 작은 문제로 쪼개서 풀어나가는 것입니다.   


 - 재귀함수 예시 : 1부터 n까지의 합을 구하는 문제는 `n + (n - 1) + (n - 2) + ... + 1`로써, `n + (1부터 n-1까지의 합)`으로 표현할 수 있습니다.   
 - 이를이용하여 1부터 5까지의 합을 재귀함수로 풀어본다면,   
    1. 1부터 5까지의 합을 구하는 문제를 `5 + (1부터 4까지의 합)` 으로 표현할 수 있습니다.
    2. 1부터 4까지의 합을 구하는 문제를 `4 + (1부터 3까지의 합)` 으로 표현할 수 있습니다.
    3. 1부터 3까지의 합을 구하는 문제를 `3 + (1부터 2까지의 합)` 으로 표현할 수 있습니다.
    4. 1부터 2까지의 합을 구하는 문제를 `2 + (1부터 1까지의 합)` 으로 표현할 수 있습니다.
    5. `1부터 1까지의 합`은 답이 1이라는 것을 알 수 있습니다. 이를 통해, `1부터 n-1까지의 합` 결과값을 리턴해서 역순으로 올라가 `1 + (1부터 4까지의 합)`을 해결할 수 있습니다.   
  
 - 재귀함수의 구조 : 재귀함수는 주요 부분은 두가지로 나뉠수 있습니다.   
   - **기저 조건(Base Case)** : 재귀 호출을 멈추는 조건입니다. 위의 예시 기준으로 `1부터 1까지의 합`이 기저 조건입니다.    
      만약 기저 조건이 없다면 함수가 무한히 자기 자신을 다시 호출하게 되어 문제가 발생합니다.   
   - **재귀 호출(Recursive Call)** : 함수가 자기 자신을 다시 호출하는 부분입니다. 함수를 호출할때마다 문제의 크기를 줄여나가 문제를 해결합니다.   

위의 예시를 아래와 같이 파이썬으로 구현할 수 있습니다.   

```python
def sum_recursive(n):
    # 기저 조건
    if n == 1:
        return 1
    # 재귀 호출
    else:
        return n + sum_recursive(n - 1)

# 1부터 5까지의 합 구하기
result = sum_recursive(5)
print(result)  # 결과: 15
```   

### 메모화

> 아래와 같이 피보나치수열을 리턴하는 재귀함수를 만들어 봅시다.   

```python
def f(n):
    if n == 1:
        return 1
    elif n == 2:
        return 1
    else:
        return f(n - 1) + f(n - 2)
```   

> 해당 코드를 입력하면 `print(f(숫자))`를 사용하면 피보나치수열을 출력하는데요,   
> 숫자가 커지면(예를들면 15) 프로그래밍 처리속도가 굉장히 느린 것을 알 수 있습니다.   
> 이는 해당 재귀함수가 재귀호출을 2번씩 하고있고, 숫자가 클수록 그 과정이 배로 늘어나기 때문입니다.   
> 여기서 우리는 재귀호출을 2번씩 하면서 그과정에서 중복되는 함수(a7 = a6 + a5, a6 = a5 + a4... a5 2번 호출)를 확인할 수 있습니다.   
> 이렇듯 **한번계산했던 함수 결과를 미리 메모해두고, 다음에 이 결과를 요청할때 메모해둔 결과를 리턴해주는 과정**을 `메모화`라고 합니다.  

```python
memo = {}
def f(n):
    if n in memo:        # n번째 수열이 이미 메모에 저장됐다면
        return memo[n]   # n번째 수열값을 리턴해라
    if n == 1:
        return 1
    elif n == 2:
        return 1
    else:
        temp = f(n - 1) + f(n - 2)
        memo[n] = temp    # n번째 수열을 저장
        return temp

print(f(50))
print(memo)
```   

<br>

