---
#layout: post
title: 실용적인 유닉스 커맨드 활용
date: 2024-07-31
description: 유닉스를 배우는 이유와 활용방안에 대해 정리합니다.  # 검색어 및 글요약
categories: [Data_analysis, Unix]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Unix
- Command
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---

> 커맨드를 통해 컴퓨터를 사용하는 방식인 CLI(Command Line Interface)


## 유닉스 커맨드
---

<br>

### CLI(Command Line Interface)
---

- **CLI(Command Line Interface)** : 커맨드를 통해 컴퓨터를 사용하는 방식   
  - 개발환경에서 주로사용
  - 필요한 라이브러리를 다운받고 설치할때
  - 협업시 코드 관리
  - 웹 개발시 환경 설정과 서버 실행   
  - 커맨드로 작업을 명확하고 간결하게 수행 가능 
- **GUI(Graphical User Interface)** : 화면과 마우스를 통해 컴퓨터를 사용하는 방식   

<br>


### 유닉스(Unix)   
---

- **유닉스(Unix)** : 1970년대 초반에 개발된 운영체제   
  - 소프트웨어를 개발하고 실행할 수 있는 편리한 플랫폼
  - 쉽게 수정해서 다른 컴퓨터에 적용가능
  - 보편화되어 유닉스를 기반으로 하는 다양한운영체제(유닉스운영체제) 탄생(maxOS, Linux, Ubuntu 등)   
- **유닉스 커맨드** : 유닉스 운영체제에서 사용되는 커맨드로 큰 틀에서 사용하는 커맨드는 거의 비슷함   
  - 개발환경에서 윈도우 운영체제(윈도우 커맨드)보다 보편적으로 사용   
      1. 대규모 데이터를 효율적이고 빠르게 처리하고 관리하는 도구 제공
      2. 반복적인 작업을 자동화하기 위해 셀 스크립트 작성(Bot)
      3. 웹사이트 배포 시
      4. 인공지능 프로그램 개발 등 서버컴퓨터 사용시   

- **터미널(Terminal)** : 커맨드를 입력받고(input) 출력해주는(output) 프로그램   
- **shell** : 커맨드를 컴퓨터가 이해할 수 있는 형태로 바꿔주는 역할   
    - bash, Ubuntu, zsh 등   

<br>



### 커맨드 기본   
---

- **아큐먼트(argument)** : 어느 대상에 대해 커맨드를 실행할지 정함. 인자 라고도 함   
    - `cal`커맨드(달려출력)에 2024년 5월 달력을 출력하기위한 아규먼트 `5 2024` 설정   

```bash
  cal 5 2024
```   

- **옵션(option)** : 대시`-`를 사용해 커맨드가 실행되는 방식 설정   
    - `cal`커맨드에 특정날(2024년 10월)이 1월 1일부터 몇 번째 날인지 옵션 `-j` 설정    

```bash
  cal -j 10 2024
```   

- **매뉴얼 커맨드** : `man` `커맨드`를 사용해 특정 커맨드의 매뉴얼을 호출   
    - `cal` 커맨드의 매뉴얼을 확인   
  
```bash
  man cal
```   

<br>


### 커맨드 사용 팁   
---

- `↑↓방향키` : `↑`방향키를 통해 이전에 사용한 커맨드 명령어를 가져옴  
- **커서 이동 단축키** : 커맨드 입력도중 수정을 하고싶은데 너무 길어진 경우   
    - `←`, `→` : 한칸씩 커서 이동   
    - `Ctrl + A` : 줄 가장 앞부분으로 커서 이동   
    - `Ctrl + E` : 줄 가장 뒷부분으로 커서 이동   
      - `Ctrl + ←`, `Alt + ←` : 단어 간격으로 커서 앞부분으로 이동   
      - `Ctrl + →`, `Alt + →` : 단어 간격으로 커서 뒷부분으로 이동    
- `Ctrl + C` : 커맨드 입력도중 혹은 실행중 강제로 작업 종료   
- `clear` : 터미널 화면을 지우기   
- `Tab키` : 자동완성기능 혹은 특정 커맨드 일부 입력후 해당 단어가 사용가능한 커맨드 나열   

<br>


## 디렉토리(폴더)와 파일 다루기  
---

- **유닉스 디렉토리 구조** : 최상위 디렉토리 혹은 루트에서 밑으로 디렉토리와 파일이 뻗어나가는 구조   

**[예시]**   
  - root디렉토리 📁   
    - info.txt파일 📓   
    - bin디렉토리 📁  
    - home디렉토리 📁   
      - Sun디렉토리 📁   
        - price.txt파일 📓   
        - house.py파일 📓         
        - animal디렉토리 📁    
          - dog디렉토리 📁   
          - cat디렉토리 📁     
        - market디렉토리 📁   
          - fruit디렉토리 📁  
            - fruit_info.txt파일 📓   
            - summer디렉토리 📁   
              - watermelon파일 📓   
            - winter디렉토리 📁   
          - meat디렉토리 📁   

- 하위(자식) 디렉토리 : 디렉토리 안에 디렉토리가 있을 때 `안에 있는 디렉토리`   
- 상위(부모) 디렉토리 : 디렉토리 안에 디렉토리가 있을 때 `밖에 있는 디렉토리`   
- **홈(사용자) 디렉토리** : 컴퓨터 사용자마다 주어지는 디렉토리   
    - 사용자의 각종 문서나 파일들   
    - 컴퓨터에 일반적으로 필요한 파일들은 홈 디렉토리 밖   

- **파일 경로** :   
  - 루트에서부터 특정 파일이나 디렉토리까지의 경로를 사용할 때 디렉토리 안으로 들어갈 때 `/`를 사용   
  - 루트는 아무 문자 없이 `/`만 사용   
    - root디렉토리 : `/`   
    - dog디렉토리 : `/home/Sun/animal/dog`   
    - fruit_info.txt파일 : `/home/Sun/market/fruit/fruit_info.txt`   
- **홈 디렉토리**는 `~`로 표시할 수 있음 (`~` = `/home/Sun`)   
  - house.py파일(사용자가 Sun인경우) : `~/house.py`   
- 작업 디렉토리(working directory) : 현재 작업중인 경로   


<br>


### 디렉토리와 파일 둘러보기 : pwd, cd, ls
---
> 경로예시는 상기에 기재된 예시 기준입니다.   

0. 공통 : `커맨드` `옵션` `경로` 형식으로 사용(옵션 생략 가능)     
1. `pwd` : 현재 작업중인 작업 디렉토리(working directory) 확인   
2. `cd` : 디렉토리 이동   
    - 루트 디렉토리 이동 : `cd /`
    - 홈 디렉토리 이동 : `cd /home/Sun` 또는 `cd ~` 또는 `cd `(아무것도 입력 안함)   
    - 이전 디렉토리 이동 : `cd -`   
3. `ls` : 디렉토리의 내용물을 목록화    
    - ls -a : 숨긴 파일과 디렉토리를 보여줌   
    - ls -l : 파일과 디렉토리에 대한 상세 정보를 보여줌           


### 절대경로와 상대경로   
---

- **절대경로** : **루트(최상위) 디렉토리** 부터 시작하는 전체경로    
    - `/` 로 시작하여 파일이나 디렉토리 경로를 명확하게 표시할 수 있음     
    - 스크립트 내에서 항상 고정된 파일이나 디렉토리를 참조해야 할 때 활용   
      - 시스템 로그 파일이나 환경 설정 파일 등을 접근할때 명확하게 경로 지정   
    - 여러번 하위 디렉토리로 이동하는 등 경로가 길어질수록 불편함 → 상대경로 고려   
      - 예시) summer디렉토리 이동 : `cd /home/Sun/market/fruit/summer`   
- **상대경로** : **현재 자신이 위치해 있는 디렉토리**(작업 디렉토리) 부터 시작하는 경로   
    - 파일이나 디렉토리 이동이 빈번할 때 활용    
    - 현재 디렉토리를 `.`으로 표시        
      - 예시) 현재 디렉토리 `/home/Sun/market/fruit`에서 summer디렉토리 이동 : `cd ./summer`   
      - 현재 디렉토리를 표시하는 `./` 생략 가능 `cd ./summer` = `cd summer`   
    - 현재 디렉토리에서 상위(부모) 디렉토리를 `..`으로 표시   
      - 예시) 현재 디렉토리 `/home/Sun/market/fruit/summer`에서 상위 디렉토리 market으로 이동 : `cd ../..`   
      - 예시) summer 디렉토리에서 winter 디렉토리로 이동 : `cd ../winter`   
    - 여러번 상위 디렉토리로 이동해야하는 경우 → 절대경로 또는 홈 디렉토리 고려   
      - 예시) winter 디렉토리에서 animal 디렉토리로 이동   
        - 상대경로 사용 : `cd ../../../animal`    
        - 절대경로 사용 : `cd /home/Sun/animal` 
        - 홈 디렉토리 사용 : `cd ~/animal`    

- **정리** : 개발작업시 파일과 디렉토리를 지정할 때 절대경로와 상대경로 그리고 홈 디렉토리를 적절하게 경로지정하여 사용   



### 디렉토리와 파일 만들기 : mkdir, touch   
---

- `커맨드` `옵션` `경로` 형식으로 사용하고 경로 형식은 절대경로/상대경로/홈 자유롭게 가능     
- `mkdir` : 해당 경로에 디렉토리 생성
  - 예시) 홈 디렉토리에 하위디렉토리 abc 생성 : `mkdir ~/abc`      
  - mkdir `디렉토리명` `디렉토리명2` : 여러개 동시에 생성가능  
- `touch` : 해당 경로에 파일 생성
  - 예시) 홈 디렉토리에서 하위디렉토리 abc에 test.txt 생성 : `touch ~/abc/test.txt`      
  - touch `파일명` `파일명2` : 여러개 동시에 생성가능   
  - touch `디렉토리/파일1` `디렉토리/파일2` : 여러 디렉토리에 파일 생성가능   



### 텍스트 에디터 Vim   
---
> `Vim`은 CLI에서 파일 편집이 가능한 에디터입니다.   


- Vim 에디터 실행   
  - 새로운 파일 생성 시 : `vim`   
  - 파일 수정 시 : `vim [파일경로]`   

- Vim 에디터 편집 : 초기에는 일반모드로 진입후 다른모드로 이동하고 다시 `esc`키를 통해 일반모드를 거쳐 이동    
  - 일반모드 : 커서이동, 텍스트 붙여넣기, 작업취소   
  - 입력모드 `i`: 텍스트 입력   
  - 비주얼모드 `v`: 텍스트 지정, 복사 붙여넣기 잘라내기 
    - 텍스트 복사 : 줄단위복사 `V`, 글자단위복사 `v`로 지정후 `y`키로 복사(`d` 잘라내기)    
    - 텍스트 붙여넣기 : 붙여넣고 싶은곳에 커서 이동후 `p`키 사용     
    - 줄단위 복사 또는 잘라내기는 `yy`나 `dd`로도 가능함   
  - 명령모드 `:`: 내용 저장, Vim 종료   
    - 파일 저장 및 종료 : `:` `w` `q` (w는 파일 저장, q는 파일 종료)   
    - 새파일 저장 시 : `: w 파일경로` 입력후 `q`입력   
    - 파일수정후 저장없이 종료 : `:q!`사용   



### 파일 내용 살펴보기 : cat, less, head, tail   
---   
- 공통 : `커맨드` `옵션` `파일경로` `파일경로2` (옵션생략가능, 파일 여러개 가능  )
- `cat` : 파일 조회    
- `less` : 파일 내용을 페이지 단위로 조회   
- `head` : 파일 시작부분 조회(기본값 10줄)   
- `tail` : 파일 마지막부분 조회(기본값 10줄)   



### 파일과 디렉토리 옮기거나 변경하기, 복사 붙여넣기, 삭제하기 : mv, cp, rm   
---   

- 공통 : `커맨드` `옵션` `경로1` `경로2`    
- `mv`: 파일이나 디렉토리를 옮기거나 덮어쓰기 혹은 이름변경하는 커맨드 (move의 줄임말)   
  - 경로1은 작업할 대상의 경로, 경로2는 이동할 목적지 또는 변경할 이름   
  - 경로2가 존재할 경우 : 경로2 안으로 이동   
  - 경로2가 없는 경우 : 경로2로 이름 변경   
  - 즉, 경로1을 경로2안으로 넣거나, 경로2로 이름을 변경하는 커맨드   
- `cp`: 파일이나 디렉토리를 복사 붙여넣기   
  - 경로1은 복사할 대상의 경로, 경로2는 복사할 위치   
  - 경로2가 존재할 경우 경로2 안으로 복사, 없는 경우 경로2 디렉토리 생성    
  - **디렉토리를 복사할 때**는 `-r`옵션을 사용해야 함   
- `rm`: 파일이나 디렉토리를 삭제하기   
  - 경로1은 삭제할 파일 또는 디렉토리 경로   
  - 경로2는 추가로 삭제할 파일 또는 디렉토리 경로로 경로3, 경로4 ... 여러개 가능   
  - **디렉토리를 삭제할 때**는 `-r`옵션을 사용해야 함   
  - 삭제된 파일이나 디렉토리는 휴지통이 아닌 **영구적으로 삭제**됨   

> `mv`와 `cp` 커맨드는 아규먼트로 파일이나 디렉토리 경로를 두개 받는데,    
> 만약 경로2(이동할 목적지)에 똑같은 이름의 파일이 있는경우,     
> 별도 확인 없이 파일을 덮어버립니다.   
> 파일을 덮어쓰기전에 확인하는 과정을 만들고 싶다면 `-i`옵션을 사용합니다.     
{: .prompt-warning }   

