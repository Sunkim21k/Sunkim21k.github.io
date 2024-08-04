---
#layout: post
title: Python study 8 - 클래스
date: 2024-08-04
description: Python 클래스와 관련된 내용을 학습합니다.  # 검색어 및 글요약
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
  - 특수한 메소드에 대해 학습합니다.   
  - 캡슐화에 대해 학습합니다.    
  - 상속에 대해 학습합니다.     
  

<br>



## 특수한 메소드  
---

- 비교 연산자 구현    

```python
def __eq__(self, value): # self == value
def __ne__(self, value): # self != value
def __gt__(self, value): # self > value
def __ge__(self, value): # self >= value
def __lt__(self, value): # self < value
def __le__(self, value): # self <= value
```   

- 사칙 연산자 구현   

```python
def __add__(self, value):  # 더하기 +
def __sub__(self, value):  # 빼기 - 
def __mul__(self, value):  # 곱하기 * 
def __truediv__(self, value):  # 나누기 /
def __floordiv__(self, value):  # 정수 나누기 //
```   

- 문자열 출력   

```python
def __str__(self):
    return "문자열"
```   

- 값 객체   
> 특정 길이를 기본자료형으로 cm로 파악하여 숫자를 적다가 다른사람 혹은 나중에 inch로 착각하여 길이가 꼬이는 경우가 발생될 수 있습니다.   
> 그래서 프로그램의 규모가 커지게되면 기본자료형의 사용을 막아버리고 클래스로 구현하게 됩니다.   
> 값을 하나들고있는 객체를 값 객체라고하며, 이를통해 값을 안전하게 만들고 보호할 수 있습니다.   
> 참고로 NASA에서 단위실수로 막대한 금액의 손실이 일어난 적이 있습니다.    

```python
class CmLength:
    def __init__(self, cm):
        if cm < 0:
            raise "길이는 0 이상으로 지정해야 합니다."
        self.__length = cm
    def get(self):
        return self.__length
    def __add__(self, other):
        if type(other) != CmLength:
            raise "길이 단위를 통일해주세요!"
        return CmLength(self.get() + other.get())

CmLength(3) + CmLength(5)
```   


<br>



## 캡슐화
---
> 캡슐화는 객체를 사용할 때 객체의 변수와 함수를 숨기는 작업을 말합니다.   
> 인스턴스 변수와 인스턴스 함수 앞에 `__`를 붙이면 외부에서 접근이 불가능해집니다.  
> 이를통해 외부로부터 잘못된 객체가 들어오는 것을 차단할 수 있어 유지보수성이 좋아집니다.      

아래와 같이 반지름을 통해 둘레와 넓이를 구하는 코드를 살펴보겠습니다.   

```python
class Circle:
    def __init__(self, r):
        if r < 0:
            raise TypeError("반지름은 0 이상이어야 합니다.")
        self.r = r
        self.pi = 3.14
    def 둘레(self):
        return  2 * self.pi * self.r
    def 넓이(self):
        return self.pi * (self.r ** 2)


circle = Circle(10)
# circle = Circle(-10) # 음수일 경우 예외 오류 발생
circle.r = -10
print(circle.둘레()) # 둘레를 구함
print(circle.넓이()) # 넓이를 구함
```   

`circle`객체를 생성할 때 매개변수를 음수로 생성하면 상기와 같이 raise를 사용하여 오류를 발생하게 할 수 있습니다.   
그런데 인스턴스 변수를 음수로 바꿔버리면 오류가 발생하지않고 음수가 출력되는 상황이 발생합니다.   
이러한 접근을 차단하기위해 인스턴스 변수와 인스턴스 함수 앞에 `__`를 붙여 외부에 접근을 차단하는 캡슐화 작업을 합니다.   

```python
class Circle:
    def __init__(self, r):
        if r < 0:
            raise TypeError("반지름은 0 이상이어야 합니다.")
        self.__r = r
        self.__pi = 3.14
    def 둘레(self):
        return  2 * self.__pi * self.__r
    def 넓이(self):
        return self.__pi * (self.__r ** 2)


circle = Circle(10)
# circle = Circle(-10) # 음수일 경우 예외 오류 발생
print(circle.둘레()) # 둘레를 구함
print(circle.넓이()) # 넓이를 구함
```   

캡슐화로 접근이 차단된 변수의 값을 추출하거나 할당할때는 get함수와 set함수를 만들어서 사용합니다.   

```python
class Circle:
    def __init__(self, r):
        if r < 0:
            raise TypeError("반지름은 0 이상이어야 합니다.")
        self.__r = r
        self.__pi = 3.14
    def get_r(self):
        return self.__r
    def set_r(self, value):
        if value < 0:
            raise TypeError("반지름은 0 이상이어야 합니다.")
        self.__r = value
    def 둘레(self):
        return  2 * self.__pi * self.__r
    def 넓이(self):
        return self.__pi * (self.__r ** 2)


circle = Circle(10)
print(circle.get_r())  # 반지름 출력
circle.set_r(20)  # 반지름을 20으로 변경
print(circle.둘레()) # 둘레를 구함
print(circle.넓이()) # 넓이를 구함
```   



<br>



## 상속
---
> 상속은 `class A(B):` 처럼 표현할 수 있으며,  
> 특정 메소드가 A 클래스에 없다면 B 클래스에서 메소드를 찾아 반영합니다.   
> 만약 B 클래스도 `class B(C):` 형식이라면 B 클래스에서도 찾는 메소드가 없으면 C 클래스에서 메소드를 찾습니다.   
> A는 자식클래스(서브클래스), B는 부모클래스(슈퍼클래스)라고 칭합니다.   
> 상속을 이용하면 중복되는 메소드를 간편하게 만들 수 있습니다.   
> 또한, 부모클래스에 예외 오류를 생성하여 자식클래스의 필요한 부분을 찾아 입력할 수 있습니다.    

> 만약 `class A(B):`에서 특정메소드가 A(자식클래스)에 있다면,  
> B(부모클래스)에 있는 동일한 메소드를 호출하지 않게됩니다. 이를 `오버라이드`(재정의)라고 합니다.   
> 위와같이 특정메소드가 자식클래스에 있을때,   
> 부모클래스에 있는 메소드를 사용하고싶다면 `super()`함수를 사용하여 호출할 수 있습니다.     
> `super().메소드()`형식으로 코드를 구현하면 부모클래스(슈퍼클래스)의 메소드를 호출할 수 있습니다.   


<br>

