---
#layout: post
title: Python study 7 - 예외처리
date: 2024-08-04
description: Python 예외처리에 대해 학습합니다.   # 검색어 및 글요약
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
  - 예외처리와 관련된 내용을 학습합니다.    
  

<br>


## 구문오류(Syntax Error)와 예외(Exception)
---

> 오류는 2가지로 분류할 수 있습니다.    

- **구문오류 Syntax Error(Compile Error)** : 프로그램 실행 전에 발생하는 오류   

```python
# 구문 오류 (Syntax Error)
print("# 프로그램이 시작되었습니다!")
print("# 구문 오류를 강제로 발생시킵니다!"
```   

위와 같이 괄호를 누락하여 작성하고 실행하면,   
첫번째 print함수가 실행되지않고 Syntax Error가 발생되는 것을 알 수 있습니다.   
Syntax Error가 발생되면 코드가 한 줄도 실행되지 않고 오류를 가리킵니다.    

- **Runtime Error(Exception)** : 프로그램 실행 중에 발생하는 오류

```python
# 예외(Exception)
print("# 프로그램이 시작되었습니다!")
numbers[1]
```   

위와 같이 리스트가 선언이 되지 않고 코드를 실행하면,   
첫번째 print함수는 실행되고 예외 오류 NameError가 발생되는 것을 알 수 있습니다.   
예외가 발생되면 기존 코드는 실행된 후 오류를 가리킵니다.   

<br>


## 기본적인 예외처리 방법
---

> 반지름을 입력하면 둘레와 넓이를 구하는 코드를 만들어봅시다.   

```python
# 원의 둘레, 넓이 구하기
r = int(input("정수 입력: "))

print(f"원의 반지름: {r}")
print(f"원의 둘레: {2 * 3.14 * r}")
print(f"원의 넓이: {3.14 * r * r}")
```   

> 위와 같은 코드에서 반지름을 입력하면 원의 둘레와 넓이가 출력되는 것을 알 수 있습니다.   
> 그런데 만약, 코드를 입력하는사람이 부동소수점이나 정수가 아닌 문자열을 입력한다면 오류가 발생합니다.   
> 이런 예외적인 상황을 막고 정수일때만 입력이 가능하게 예외처리를 다음과 같이 할 수 있습니다.   


- 조건문으로 예외처리 하기   

```python
# 원의 둘레, 넓이 구하기
r = input("정수 입력: ")

if r.isdigit():  # r이 숫자라면 원의 둘레와 넓이 구하기
    num_r = int(r)
    print(f"원의 반지름: {num_r}")
    print(f"원의 둘레: {2 * 3.14 * num_r}")
    print(f"원의 넓이: {3.14 * num_r * num_r}")
else:   # r이 숫자가 아니라면
    print("정수를 입력하지 않았습니다.")
```   

- try except 구문을 사용하여 예외처리 하기   
    - 현대에서는 조건문이아닌 try except처럼 별도 예외구문을 활용하여 진행합니다.   
    - try except구문에는 try와 except를 반드시 동시에 사용해야 합니다.    
      - try는 예외가 발생할 수 있는 코드를 작성하고   
      - except는 예외가 발생했을 때 실행할 코드를 작성합니다.   



```python
# 원의 둘레, 넓이 구하기
r = input("정수 입력: ")

try:
    num_r = int(r)
    print(f"원의 반지름: {num_r}")
    print(f"원의 둘레: {2 * 3.14 * num_r}")
    print(f"원의 넓이: {3.14 * num_r * num_r}")
except:
    print("정수를 입력하지 않았습니다.")
```   


<br>


## else finally 예외 처리 구문
---

> try except구문에서 else와 finally구문을 추가로 사용할 수 있습니다.   


- try : 예외가 발생할 가능성이 있는 코드
- except : 예외가 발생했을 때 실행할 코드
- else : 예외가 발생하지 않았을 때 실행할 코드
- finally : 무조건 실행하는 코드   

상기 구문을 조합해서 쓸수있는 구문은 아래와 같습니다.   

- try + except
- try + except + else
- try + except + finally
- try + except + else + finally
- try + finally

> 상기와 같은 조합이 있지만, 주로 사용되는 조합은 try except와 try except finally 조합입니다.   
> else구문을 사용하지 않는이유는 굳이 else구문에 만들지 않더라도 try 구문에서 예외가 없으면 이어서 실행하기 때문입니다.   
> 추가적으로 else구문은 파이썬과 루비 외 일반적인 프로그래밍 언어에서는 (필요가없기 때문에) 구현되지 않은 기능입니다.   

- try + except + finally 조합   


```python
def f():
    print("함수()에 진입했습니다.")
    try:
        print("try 구문에 진입했습니다.")
        return
        print("try 구문이 끝났습니다.")
    except:
        print("except 구문에 진입했습니다.")
    finally:
        print("finally 구문에 진입했습니다.")
    print("함수()가 끝났습니다.")

f()
```   

상기와 같이 코드를 작성하면 try구문이 끝났다는 출력은 나오지않지만,   
finally 구문 진입은 출력됩니다.   
그리고 return에 따라 마지막에 `함수()가 끝났습니다`가 출력되지 않음을 알 수 있습니다.   

- finally 몇가지 사용 예시   
  - 파일을 일시적으로 만들어서 활용하고 코드 종료시 파일을 제거해야 할 때  
  - 파일을 다른 프로그램에서 쓰지 못하게 잠그고, 코드 종료시 잠금을 해제해야 할 때
  - 특정 함수를 실행하는 시간을 예외상황 상관없이 출력하고 싶을때   


<br>


## 예외 객체
---

- 예외 객체란 예외와 관련된 정보를 담고 있는 객체로 try except 구문에 활용할 수 있습니다.   
  - `except 예외의 종류 as 예외 객체의 변수 이름:` 형식으로 지정하여 사용합니다.   
    - 예외의 종류 : NameError, IndexError, ValueError, Exception 등
    - 참고로 `Exception`은 모든 예외를 포함합니다.   
    - 예외 객체의 변수 이름 : exception 혹은 줄여서 e로 주로 사용합니다.   
  - except는 여러번 사용할 수 있으며, 먼저 입력된 순서대로 예외를 처리합니다.    
    - 따라서 여러번 사용할 경우 Exception은 가장 마지막에 위치해야 합니다.   

```python
try:
    name[0]
except Exception as e:
    print(type(e))
    print(e)
```   

출력값)    
<class 'NameError'>   
name 'name' is not defined   


<br>


## 예외 강제 발생 raise 구문
---

> raise 예외객체, raise 예외객체(), raise 예외객체(메세지) 형태로 예외를 강제로 발생시킬 수 있습니다.   


```python
raise Exception("예외를 강제로 발생시킵니다.")
```   

> 예외를 강제로 발생시키는 이유는 다른 개발자에게 정보를 전달하기 위함입니다.   
> 예외 오류중 하나인 미구현 상태라는 정보를 전달하는 예시를 만들어보겠습니다.   
> 참고로 미구현 상태 예외는 `NotImplementedError`를 사용할 수 있습니다.   


```python
number = input("정수를 입력해주세요: ")
number = int(number)

if number > 0:
    print("양수입니다.")
elif number == 0:
    # pass
    raise Exception("아직 구현되지 않았습니다.")  # 미구현 pass를 강제 예외로
else:
    # pass
    raise NotImplementedError("아직 구현되지 않았습니다.") 
```   