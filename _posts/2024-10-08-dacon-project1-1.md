---
#layout: post
title: 데이콘 프로젝트 - 농산물 가격예측 1-1 데이터 살펴보기
date: 2024-10-08
description: # 검색어 및 글요약
categories: [Data_analysis, Team_project2]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Data_analysis
- Dacon
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---

> 데이터분석가로 공부를 하면서, 데이터에 흥미를 갖기위해 관심있는 수강생들과함께 데이콘에 참여해보기로 했습니다. 처음으로 대회를 참여해보는데요, 흥미와 경험목적으로 참여하는만큼, 부담없이 최대한 즐기는 느낌으로 프로젝트를 진행하고자 합니다. 저희가 참여하는 대회는 `국민생활과 밀접한 10가지 농산물 품목의 가격을 예측`해야하는데요, 첫번째로 대회에서 제공하는 **데이터들을 살펴보는 시간**을 가졌고, 제가 정리한 내용을 기록으로 남기고자합니다.


## 데이터 설명
- **대회명 : 데이터·AI를 활용한 물가 예측 경진대회 : 농산물 가격을 중심으로**
- 데이터 출처 : [데이콘](https://dacon.io/competitions/official/236381/overview/description)
- [주제]
  - 국민생활과 밀접한 10개 농산물 품목의 가격 예측
  - (배추, 무, 양파, 사과, 배, 건고추, 깐마늘, 감자, 대파, 상추)

- [문제 상세 설명]
  - 학습 데이터는 2018년 ~ 2021년의 순 단위(10일)의 데이터가 주어지며,
  - 평가 데이터는 추론 시점 T가 비식별화된 2022년의 순 단위의 데이터가 주어집니다.
  - 평가 데이터 추론은 추론 시점 T 기준으로 최대 3개월의 순 단위의 입력 데이터를 바탕으로 T+1순, T+2순, T+3순의 평균가격을 예측해야합니다.
  - 예측해야할 Target은 (배추, 무, 양파, 사과, 배, 건고추, 깐마늘, 감자, 대파, 상추)의 10개의 품목 중 아래의 특정 품종, 등급에 대해서만 예측을 진행합니다.



- train [폴더] :
   - train.csv [파일] : 2018년 ~ 2021년의 모든 농산물의 상세 정보 및 가격
   - meta [폴더]
      - TRAIN_산지공판장_2018-2021.csv : 전국도매 경락정보
      - TRAIN_전국도매_2018-2021.csv : 산지공판장 경락정보

- test [폴더] :
   - 2022년의 특정 시점 T가 비식별화된 평가 데이터
   - 예측의 입력으로 사용될 예측 시점 T를 포함한 최대 3개월의 9개의 시점에 대한 데이터 (총 25개의 평가 데이터셋 샘플 구성)
   - **TEST_00.csv ~ TEST_24.csv [파일]**
   - **meta [폴더]**
       - TEST_전국도매_00.csv ~ TEST_전국도매_24.csv [파일]
       - TEST_산지공판장_00.csv ~ TEST_산지공판장_24.csv [파일]
   - 예시) `TEST_00` 추론 시에는 `TEST_00.csv.` 필요시에는 `TEST_전국도매_00.csv`와 `TEST_산지공판장_00.csv`만 추론에 사용 가능

 - sample_submission.csv [ 파일 ] :
     - 각 품목의 TEST 파일별 +1순, +2순, +3순의 평균가격(원) 예측 결과
     - 시점 : TEST_00+1순, TEST_00+2순, TEST_00+3순 ... TEST_24+1순, TEST_24+2순, TEST_24+3순  

| 품목명       | 품종명       | 거래단위   | 등급 |
| ------------ | ------------ | ---------- | ---- |
| 건고추       | 화건         | 30 kg      | 상품 |
| 사과         | 홍로, 후지   | 10 개      | 상품 |
| 감자         | 감자 수미    | 20키로상자 | 상   |
| 배           | 신고         | 10 개      | 상품 |
| 깐마늘(국산) | 깐마늘(국산) | 20 kg      | 상품 |
| 무           | 무           | 20키로상자 | 상   |
| 상추         | 청           | 100 g      | 상품 |
| 배추         | 배추         | 10키로망대 | 상   |
| 양파         | 양파         | 1키로      | 상   |
| 대파         | 대파(일반)   | 1키로단    | 상   |



```python
### 개발환경 세팅하기

# ▶ 한글 폰트 다운로드
!sudo apt-get install -y fonts-nanum
!sudo fc-cache -fv
!rm ~/.cache/matplotlib -rf
```

    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    The following NEW packages will be installed:
      fonts-nanum
    0 upgraded, 1 newly installed, 0 to remove and 49 not upgraded.
    Need to get 10.3 MB of archives.
    After this operation, 34.1 MB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu jammy/universe amd64 fonts-nanum all 20200506-1 [10.3 MB]
    Fetched 10.3 MB in 1s (9,777 kB/s)
    debconf: unable to initialize frontend: Dialog
    debconf: (No usable dialog-like program is installed, so the dialog based frontend cannot be used. at /usr/share/perl5/Debconf/FrontEnd/Dialog.pm line 78, <> line 1.)
    debconf: falling back to frontend: Readline
    debconf: unable to initialize frontend: Readline
    debconf: (This frontend requires a controlling tty.)
    debconf: falling back to frontend: Teletype
    dpkg-preconfigure: unable to re-open stdin: 
    Selecting previously unselected package fonts-nanum.
    (Reading database ... 123620 files and directories currently installed.)
    Preparing to unpack .../fonts-nanum_20200506-1_all.deb ...
    Unpacking fonts-nanum (20200506-1) ...
    Setting up fonts-nanum (20200506-1) ...
    Processing triggers for fontconfig (2.13.1-4.2ubuntu5) ...
    /usr/share/fonts: caching, new cache contents: 0 fonts, 1 dirs
    /usr/share/fonts/truetype: caching, new cache contents: 0 fonts, 3 dirs
    /usr/share/fonts/truetype/humor-sans: caching, new cache contents: 1 fonts, 0 dirs
    /usr/share/fonts/truetype/liberation: caching, new cache contents: 16 fonts, 0 dirs
    /usr/share/fonts/truetype/nanum: caching, new cache contents: 12 fonts, 0 dirs
    /usr/local/share/fonts: caching, new cache contents: 0 fonts, 0 dirs
    /root/.local/share/fonts: skipping, no such directory
    /root/.fonts: skipping, no such directory
    /usr/share/fonts/truetype: skipping, looped directory detected
    /usr/share/fonts/truetype/humor-sans: skipping, looped directory detected
    /usr/share/fonts/truetype/liberation: skipping, looped directory detected
    /usr/share/fonts/truetype/nanum: skipping, looped directory detected
    /var/cache/fontconfig: cleaning cache directory
    /root/.cache/fontconfig: not cleaning non-existent cache directory
    /root/.fontconfig: not cleaning non-existent cache directory
    fc-cache: succeeded
    


```python
# ▶ 한글 폰트 설정하기
import matplotlib.pyplot as plt
plt.rc('font', family='NanumBarunGothic')
plt.rcParams['axes.unicode_minus'] =False

# ▶ Warnings 제거
import warnings
warnings.filterwarnings('ignore')
```


```python
import matplotlib.pyplot as plt
import matplotlib.font_manager as fm

# 나눔고딕 폰트를 설치합니다.
!apt-get install -y fonts-nanum
!fc-cache -fv

# 설치된 나눔고딕 폰트를 matplotlib에 등록합니다.
font_path = '/usr/share/fonts/truetype/nanum/NanumGothic.ttf'
fm.fontManager.addfont(font_path)
plt.rcParams['font.family'] = 'NanumGothic'
```

    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    fonts-nanum is already the newest version (20200506-1).
    0 upgraded, 0 newly installed, 0 to remove and 49 not upgraded.
    /usr/share/fonts: caching, new cache contents: 0 fonts, 1 dirs
    /usr/share/fonts/truetype: caching, new cache contents: 0 fonts, 3 dirs
    /usr/share/fonts/truetype/humor-sans: caching, new cache contents: 1 fonts, 0 dirs
    /usr/share/fonts/truetype/liberation: caching, new cache contents: 16 fonts, 0 dirs
    /usr/share/fonts/truetype/nanum: caching, new cache contents: 12 fonts, 0 dirs
    /usr/local/share/fonts: caching, new cache contents: 0 fonts, 0 dirs
    /root/.local/share/fonts: skipping, no such directory
    /root/.fonts: skipping, no such directory
    /usr/share/fonts/truetype: skipping, looped directory detected
    /usr/share/fonts/truetype/humor-sans: skipping, looped directory detected
    /usr/share/fonts/truetype/liberation: skipping, looped directory detected
    /usr/share/fonts/truetype/nanum: skipping, looped directory detected
    /var/cache/fontconfig: cleaning cache directory
    /root/.cache/fontconfig: not cleaning non-existent cache directory
    /root/.fontconfig: not cleaning non-existent cache directory
    fc-cache: succeeded
    

## train 폴더 살펴보기

### train 파일


```python
import pandas as pd

# train.csv 파일 읽기
train_file_path = '/content/drive/MyDrive/데이콘/농산물/train/train.csv'
train_data = pd.read_csv(train_file_path)
```


```python
# 어떤 데이터인가요?
train_data
```





  <div id="df-7171928d-d21e-4028-b286-cee2056cd94a" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>품목명</th>
      <th>품종명</th>
      <th>거래단위</th>
      <th>등급</th>
      <th>평년 평균가격(원)</th>
      <th>평균가격(원)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201801상순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>381666.666667</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201801중순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380809.666667</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201801하순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380000.000000</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201802상순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380000.000000</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201802중순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>376666.666667</td>
      <td>590000.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>29371</th>
      <td>202111중순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>29372</th>
      <td>202111하순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>29373</th>
      <td>202112상순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>29374</th>
      <td>202112중순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>29375</th>
      <td>202112하순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.000000</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
<p>29376 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-7171928d-d21e-4028-b286-cee2056cd94a')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-7171928d-d21e-4028-b286-cee2056cd94a button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-7171928d-d21e-4028-b286-cee2056cd94a');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-f929c1a0-19bc-4e98-aece-fe012c9c513b">
  <button class="colab-df-quickchart" onclick="quickchart('df-f929c1a0-19bc-4e98-aece-fe012c9c513b')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-f929c1a0-19bc-4e98-aece-fe012c9c513b button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_abdc346d-dcca-4c26-af5b-1c41258b46e6">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('train_data')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_abdc346d-dcca-4c26-af5b-1c41258b46e6 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('train_data');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 데이터 정보 확인
train_data.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 29376 entries, 0 to 29375
    Data columns (total 7 columns):
     #   Column      Non-Null Count  Dtype  
    ---  ------      --------------  -----  
     0   시점          29376 non-null  object 
     1   품목명         29376 non-null  object 
     2   품종명         29376 non-null  object 
     3   거래단위        29376 non-null  object 
     4   등급          29376 non-null  object 
     5   평년 평균가격(원)  29376 non-null  float64
     6   평균가격(원)     29376 non-null  float64
    dtypes: float64(2), object(5)
    memory usage: 1.6+ MB
    


```python
train_data.isnull().sum()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>시점</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품목명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품종명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>거래단위</th>
      <td>0</td>
    </tr>
    <tr>
      <th>등급</th>
      <td>0</td>
    </tr>
    <tr>
      <th>평년 평균가격(원)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>평균가격(원)</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
train_data.duplicated().sum()
```




    0




```python
train_data['시점'].unique()
```




    array(['201801상순', '201801중순', '201801하순', '201802상순', '201802중순',
           '201802하순', '201803상순', '201803중순', '201803하순', '201804상순',
           '201804중순', '201804하순', '201805상순', '201805중순', '201805하순',
           '201806상순', '201806중순', '201806하순', '201807상순', '201807중순',
           '201807하순', '201808상순', '201808중순', '201808하순', '201809상순',
           '201809중순', '201809하순', '201810상순', '201810중순', '201810하순',
           '201811상순', '201811중순', '201811하순', '201812상순', '201812중순',
           '201812하순', '201901상순', '201901중순', '201901하순', '201902상순',
           '201902중순', '201902하순', '201903상순', '201903중순', '201903하순',
           '201904상순', '201904중순', '201904하순', '201905상순', '201905중순',
           '201905하순', '201906상순', '201906중순', '201906하순', '201907상순',
           '201907중순', '201907하순', '201908상순', '201908중순', '201908하순',
           '201909상순', '201909중순', '201909하순', '201910상순', '201910중순',
           '201910하순', '201911상순', '201911중순', '201911하순', '201912상순',
           '201912중순', '201912하순', '202001상순', '202001중순', '202001하순',
           '202002상순', '202002중순', '202002하순', '202003상순', '202003중순',
           '202003하순', '202004상순', '202004중순', '202004하순', '202005상순',
           '202005중순', '202005하순', '202006상순', '202006중순', '202006하순',
           '202007상순', '202007중순', '202007하순', '202008상순', '202008중순',
           '202008하순', '202009상순', '202009중순', '202009하순', '202010상순',
           '202010중순', '202010하순', '202011상순', '202011중순', '202011하순',
           '202012상순', '202012중순', '202012하순', '202101상순', '202101중순',
           '202101하순', '202102상순', '202102중순', '202102하순', '202103상순',
           '202103중순', '202103하순', '202104상순', '202104중순', '202104하순',
           '202105상순', '202105중순', '202105하순', '202106상순', '202106중순',
           '202106하순', '202107상순', '202107중순', '202107하순', '202108상순',
           '202108중순', '202108하순', '202109상순', '202109중순', '202109하순',
           '202110상순', '202110중순', '202110하순', '202111상순', '202111중순',
           '202111하순', '202112상순', '202112중순', '202112하순'], dtype=object)




```python
train_data['품목명'].unique()
```




    array(['건고추', '사과', '감자', '배', '깐마늘(국산)', '무', '상추', '배추', '양파', '대파'],
          dtype=object)




```python
train_data['품종명'].unique()
```




    array(['화건', '햇산양건', '햇산화건', '양건', '후지', '홍로', '쓰가루', '감자 수미', '감자 수미(햇)',
           '감자', '감자 조풍', '감자 대지', '감자 두백', '감자 수미(저장)', '홍감자', '감자 수입', '신고',
           '원황', '깐마늘(국산)', '무', '다발무', '열무', '청', '적', '배추', '쌈배추', '알배기배추',
           '얼갈이배추', '봄동배추', '절임배추', '양파', '저장양파', '조생양파', '양파(햇)', '자주양파',
           '양파 수입', '대파(일반)', '실파', '깐쪽파', '쪽파', '대파 수입'], dtype=object)




```python
train_data['거래단위'].unique()
```




    array(['30 kg', '10 개', '20키로상자', '10키로상자', '23키로상자', '20 kg', '10키로',
           '18키로상자(비닐포)', '5000키로', '5톤트럭', '1000키로', '4키로상자', '1.5키로단',
           '8톤트럭', '100 g', '10키로망대', '1키로상자', '8키로상자', '15키로상자', '1키로',
           '15키로', '12키로', '20키로', '1키로단', '10키로묶음'], dtype=object)




```python
train_data['등급'].unique()
```




    array(['상품', '중품', '상', '특', '하', '중'], dtype=object)




```python
# target에 해당되지않는 데이터들을 확인해보자

# target 데이터 정의
target_values = {
    '품목명': ['건고추', '사과', '감자', '배', '깐마늘(국산)', '무', '상추', '배추', '양파', '대파'],
    '품종명': ['화건', '홍로', '후지', '감자 수미', '신고', '깐마늘(국산)', '무', '청', '배추', '양파', '대파(일반)'],
    '거래단위': ['30 kg', '10 개', '20키로상자', '10 개', '20 kg', '100 g', '10키로망대', '1키로', '1키로단'],
    '등급': ['상품', '상']
}

# target 값과 일치하지 않는 데이터
non_target_data = train_data[
    ~(
        (train_data['품목명'].isin(target_values['품목명'])) &
        (train_data['품종명'].isin(target_values['품종명'])) &
        (train_data['거래단위'].isin(target_values['거래단위'])) &
        (train_data['등급'].isin(target_values['등급']))
    )
]

# 결과 확인
non_target_data
```





  <div id="df-a7595711-a00c-4636-bb42-f5ba79f85b07" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>품목명</th>
      <th>품종명</th>
      <th>거래단위</th>
      <th>등급</th>
      <th>평년 평균가격(원)</th>
      <th>평균가격(원)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>144</th>
      <td>201801상순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>145</th>
      <td>201801중순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>146</th>
      <td>201801하순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>147</th>
      <td>201802상순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>148</th>
      <td>201802중순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>29371</th>
      <td>202111중순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>29372</th>
      <td>202111하순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>29373</th>
      <td>202112상순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>29374</th>
      <td>202112중순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>29375</th>
      <td>202112하순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>10키로묶음</td>
      <td>상</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
<p>27936 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-a7595711-a00c-4636-bb42-f5ba79f85b07')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-a7595711-a00c-4636-bb42-f5ba79f85b07 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-a7595711-a00c-4636-bb42-f5ba79f85b07');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-9e6affea-6dc9-451d-8ca0-b7755b14f2c5">
  <button class="colab-df-quickchart" onclick="quickchart('df-9e6affea-6dc9-451d-8ca0-b7755b14f2c5')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-9e6affea-6dc9-451d-8ca0-b7755b14f2c5 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_6ecd5438-220f-4c50-8a12-80b3b70b93a9">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('non_target_data')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_6ecd5438-220f-4c50-8a12-80b3b70b93a9 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('non_target_data');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
non_target_data[non_target_data['평년 평균가격(원)'] > 0]
```





  <div id="df-620ff034-1463-4658-b3d2-df13bcff4bc1" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>품목명</th>
      <th>품종명</th>
      <th>거래단위</th>
      <th>등급</th>
      <th>평년 평균가격(원)</th>
      <th>평균가격(원)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>167</th>
      <td>201808하순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>484324.000000</td>
      <td>9.157000e+05</td>
    </tr>
    <tr>
      <th>203</th>
      <td>201908하순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>530301.666667</td>
      <td>5.925000e+05</td>
    </tr>
    <tr>
      <th>239</th>
      <td>202008하순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>559039.666667</td>
      <td>1.063400e+06</td>
    </tr>
    <tr>
      <th>311</th>
      <td>201808하순</td>
      <td>건고추</td>
      <td>햇산화건</td>
      <td>30 kg</td>
      <td>중품</td>
      <td>359800.000000</td>
      <td>7.407110e+05</td>
    </tr>
    <tr>
      <th>347</th>
      <td>201908하순</td>
      <td>건고추</td>
      <td>햇산화건</td>
      <td>30 kg</td>
      <td>중품</td>
      <td>404000.000000</td>
      <td>4.420310e+05</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>29083</th>
      <td>202111중순</td>
      <td>대파</td>
      <td>깐쪽파</td>
      <td>10키로상자</td>
      <td>하</td>
      <td>31883.564815</td>
      <td>4.916489e+04</td>
    </tr>
    <tr>
      <th>29084</th>
      <td>202111하순</td>
      <td>대파</td>
      <td>깐쪽파</td>
      <td>10키로상자</td>
      <td>하</td>
      <td>25615.375000</td>
      <td>3.022850e+04</td>
    </tr>
    <tr>
      <th>29085</th>
      <td>202112상순</td>
      <td>대파</td>
      <td>깐쪽파</td>
      <td>10키로상자</td>
      <td>하</td>
      <td>27183.268519</td>
      <td>2.813400e+04</td>
    </tr>
    <tr>
      <th>29086</th>
      <td>202112중순</td>
      <td>대파</td>
      <td>깐쪽파</td>
      <td>10키로상자</td>
      <td>하</td>
      <td>36559.796296</td>
      <td>2.732662e+04</td>
    </tr>
    <tr>
      <th>29087</th>
      <td>202112하순</td>
      <td>대파</td>
      <td>깐쪽파</td>
      <td>10키로상자</td>
      <td>하</td>
      <td>33635.992593</td>
      <td>2.507640e+04</td>
    </tr>
  </tbody>
</table>
<p>6371 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-620ff034-1463-4658-b3d2-df13bcff4bc1')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-620ff034-1463-4658-b3d2-df13bcff4bc1 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-620ff034-1463-4658-b3d2-df13bcff4bc1');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-6368d010-58f3-486b-8de1-c39a153dd1a8">
  <button class="colab-df-quickchart" onclick="quickchart('df-6368d010-58f3-486b-8de1-c39a153dd1a8')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-6368d010-58f3-486b-8de1-c39a153dd1a8 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
non_target_data[non_target_data['평균가격(원)'] > 0]
```





  <div id="df-b972733d-6adc-4ed3-854d-7b4c01c655a1" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>품목명</th>
      <th>품종명</th>
      <th>거래단위</th>
      <th>등급</th>
      <th>평년 평균가격(원)</th>
      <th>평균가격(원)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>167</th>
      <td>201808하순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>484324.000000</td>
      <td>915700.0</td>
    </tr>
    <tr>
      <th>203</th>
      <td>201908하순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>530301.666667</td>
      <td>592500.0</td>
    </tr>
    <tr>
      <th>239</th>
      <td>202008하순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>559039.666667</td>
      <td>1063400.0</td>
    </tr>
    <tr>
      <th>272</th>
      <td>202107하순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>0.000000</td>
      <td>800000.0</td>
    </tr>
    <tr>
      <th>273</th>
      <td>202108상순</td>
      <td>건고추</td>
      <td>햇산양건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>0.000000</td>
      <td>799571.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>29105</th>
      <td>201806하순</td>
      <td>대파</td>
      <td>대파 수입</td>
      <td>10키로상자</td>
      <td>상</td>
      <td>0.000000</td>
      <td>3630.0</td>
    </tr>
    <tr>
      <th>29106</th>
      <td>201807상순</td>
      <td>대파</td>
      <td>대파 수입</td>
      <td>10키로상자</td>
      <td>상</td>
      <td>0.000000</td>
      <td>3630.0</td>
    </tr>
    <tr>
      <th>29107</th>
      <td>201807중순</td>
      <td>대파</td>
      <td>대파 수입</td>
      <td>10키로상자</td>
      <td>상</td>
      <td>0.000000</td>
      <td>3630.0</td>
    </tr>
    <tr>
      <th>29108</th>
      <td>201807하순</td>
      <td>대파</td>
      <td>대파 수입</td>
      <td>10키로상자</td>
      <td>상</td>
      <td>0.000000</td>
      <td>3630.0</td>
    </tr>
    <tr>
      <th>29109</th>
      <td>201808상순</td>
      <td>대파</td>
      <td>대파 수입</td>
      <td>10키로상자</td>
      <td>상</td>
      <td>0.000000</td>
      <td>3630.0</td>
    </tr>
  </tbody>
</table>
<p>15223 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-b972733d-6adc-4ed3-854d-7b4c01c655a1')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-b972733d-6adc-4ed3-854d-7b4c01c655a1 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-b972733d-6adc-4ed3-854d-7b4c01c655a1');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-ccda003a-3677-461d-92a6-f67e15c7df07">
  <button class="colab-df-quickchart" onclick="quickchart('df-ccda003a-3677-461d-92a6-f67e15c7df07')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-ccda003a-3677-461d-92a6-f67e15c7df07 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
train_data[
    (
        (train_data['품목명'].isin(target_values['품목명'])) &
        (train_data['품종명'].isin(target_values['품종명'])) &
        (train_data['거래단위'].isin(target_values['거래단위'])) &
        (train_data['등급'].isin(target_values['등급']))
    )
]
```





  <div id="df-abd24109-2dae-4aeb-8634-aed14847dcbd" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>품목명</th>
      <th>품종명</th>
      <th>거래단위</th>
      <th>등급</th>
      <th>평년 평균가격(원)</th>
      <th>평균가격(원)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201801상순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>381666.666667</td>
      <td>590000.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201801중순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380809.666667</td>
      <td>590000.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201801하순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380000.000000</td>
      <td>590000.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201802상순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>380000.000000</td>
      <td>590000.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201802중순</td>
      <td>건고추</td>
      <td>화건</td>
      <td>30 kg</td>
      <td>상품</td>
      <td>376666.666667</td>
      <td>590000.000000</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>26491</th>
      <td>202111중순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>1키로단</td>
      <td>상</td>
      <td>1934.819444</td>
      <td>1754.222222</td>
    </tr>
    <tr>
      <th>26492</th>
      <td>202111하순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>1키로단</td>
      <td>상</td>
      <td>1774.898148</td>
      <td>1460.250000</td>
    </tr>
    <tr>
      <th>26493</th>
      <td>202112상순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>1키로단</td>
      <td>상</td>
      <td>1728.379630</td>
      <td>1619.000000</td>
    </tr>
    <tr>
      <th>26494</th>
      <td>202112중순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>1키로단</td>
      <td>상</td>
      <td>1677.643519</td>
      <td>1217.125000</td>
    </tr>
    <tr>
      <th>26495</th>
      <td>202112하순</td>
      <td>대파</td>
      <td>대파(일반)</td>
      <td>1키로단</td>
      <td>상</td>
      <td>1581.411111</td>
      <td>1322.200000</td>
    </tr>
  </tbody>
</table>
<p>1440 rows × 7 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-abd24109-2dae-4aeb-8634-aed14847dcbd')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-abd24109-2dae-4aeb-8634-aed14847dcbd button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-abd24109-2dae-4aeb-8634-aed14847dcbd');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-6a9a2fe1-cacf-4500-8c78-105f1937ee39">
  <button class="colab-df-quickchart" onclick="quickchart('df-6a9a2fe1-cacf-4500-8c78-105f1937ee39')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-6a9a2fe1-cacf-4500-8c78-105f1937ee39 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# 기초 통계량 확인
train_data.describe()
```





  <div id="df-fa450cb1-95ad-440f-973d-bf55d67b7d3a" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>평년 평균가격(원)</th>
      <th>평균가격(원)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>2.937600e+04</td>
      <td>2.937600e+04</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1.772730e+04</td>
      <td>5.224625e+04</td>
    </tr>
    <tr>
      <th>std</th>
      <td>1.521004e+05</td>
      <td>4.545482e+05</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000e+00</td>
      <td>0.000000e+00</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.000000e+00</td>
      <td>0.000000e+00</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>0.000000e+00</td>
      <td>1.055214e+03</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>5.203333e+02</td>
      <td>1.289481e+04</td>
    </tr>
    <tr>
      <th>max</th>
      <td>5.213802e+06</td>
      <td>1.335000e+07</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-fa450cb1-95ad-440f-973d-bf55d67b7d3a')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-fa450cb1-95ad-440f-973d-bf55d67b7d3a button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-fa450cb1-95ad-440f-973d-bf55d67b7d3a');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-260bb62b-b50a-4245-bc49-d6e06d038e4e">
  <button class="colab-df-quickchart" onclick="quickchart('df-260bb62b-b50a-4245-bc49-d6e06d038e4e')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-260bb62b-b50a-4245-bc49-d6e06d038e4e button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# 시점별 평균가격 변화를 살펴볼까요?
import matplotlib.pyplot as plt

# 시점 열을 날짜 형식으로 변환
def convert_to_date(row):
    year_month = row['시점'][:-2]  # '201801' 부분 추출
    day_indicator = row['시점'][-2:]  # '상순', '중순', '하순' 부분 추출

    if day_indicator == '상순':
        day = '01'
    elif day_indicator == '중순':
        day = '15'
    elif day_indicator == '하순':
        day = '28'

    return pd.to_datetime(f"{year_month}{day}")

train_data['시점'] = train_data.apply(convert_to_date, axis=1)

# 시점별 평균가격 시각화
monthly_avg_price = train_data.groupby('시점')['평균가격(원)'].mean()

plt.figure(figsize=(12, 6))
plt.plot(monthly_avg_price.index, monthly_avg_price.values)
plt.title('Monthly Average Price Over Time')
plt.xlabel('Date')
plt.ylabel('Average Price (won)')
plt.xticks(rotation=45)
plt.grid()
plt.show()
```


    
![png](/assets/img/py7_files/py7_22_0.png)
    


- 전박적으로 여름에 가격이 소폭 증가하는 경향이 있고, 11월과 12월에 농산물 가격이 폭증하고있다
- 특이사항으로는 2019년 10월 하순부터 2020년 5월 상순까지 가격이 폭증한 기간이 다소 길게 관찰되었다. 이부분을 어떻게 해석할지도 주목할 필요가 있다


```python
pd.set_option('display.max_rows', 150)
```


```python
# target 대상만 시각화

train_data_target = train_data[
    (
        (train_data['품목명'].isin(target_values['품목명'])) &
        (train_data['품종명'].isin(target_values['품종명'])) &
        (train_data['거래단위'].isin(target_values['거래단위'])) &
        (train_data['등급'].isin(target_values['등급']))
    )
]

monthly_avg_price2 = train_data_target.groupby('시점')['평균가격(원)'].mean()

plt.figure(figsize=(12, 6))
plt.plot(monthly_avg_price2.index, monthly_avg_price2.values)
plt.title('Monthly Average Price Over Time')
plt.xlabel('Date')
plt.ylabel('Average Price (won)')
plt.xticks(rotation=45)
plt.grid()
plt.show()
```


    
![png](/assets/img/py7_files/py7_25_0.png)
    


- target 데이터 기준으로만 시각화를 했을때는 평균가격이 다른양상을 띄고 있었다
- 아무래도 저렴한 농산물들이 더많이있는 전체데이터랑 차이가있다
- 품목별로 비교를 해볼 필요가있다


```python
import seaborn as sns
# 시점별 품목별 평균가격 계산
monthly_avg_price_by_item = train_data.groupby(['시점', '품목명'])['평균가격(원)'].mean().reset_index()

# 시각화
plt.figure(figsize=(14, 8))
sns.lineplot(data=monthly_avg_price_by_item, x='시점', y='평균가격(원)', hue='품목명')
plt.title('Average Price by Item Over Time')
plt.xlabel('Date')
plt.ylabel('Average Price (원)')
plt.xticks(rotation=45)
plt.legend(title='품목명')
plt.grid()
plt.show()
```


    
![png](/assets/img/py7_files/py7_27_0.png)
    



```python
pivot_table = monthly_avg_price_by_item.pivot(index='시점', columns='품목명', values='평균가격(원)')
pivot_table = pivot_table.round(0).astype(int)
pivot_table
```





  <div id="df-52055fca-4251-42ab-8372-f56bb1df1674" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>품목명</th>
      <th>감자</th>
      <th>건고추</th>
      <th>깐마늘(국산)</th>
      <th>대파</th>
      <th>무</th>
      <th>배</th>
      <th>배추</th>
      <th>사과</th>
      <th>상추</th>
      <th>양파</th>
    </tr>
    <tr>
      <th>시점</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2018-01-01</th>
      <td>9605</td>
      <td>315000</td>
      <td>125667</td>
      <td>16980</td>
      <td>2815</td>
      <td>11459</td>
      <td>6097</td>
      <td>7061</td>
      <td>792</td>
      <td>4682</td>
    </tr>
    <tr>
      <th>2018-01-15</th>
      <td>11094</td>
      <td>315000</td>
      <td>125600</td>
      <td>20689</td>
      <td>2901</td>
      <td>11520</td>
      <td>6146</td>
      <td>7038</td>
      <td>825</td>
      <td>4223</td>
    </tr>
    <tr>
      <th>2018-01-28</th>
      <td>11126</td>
      <td>315000</td>
      <td>125600</td>
      <td>14314</td>
      <td>3030</td>
      <td>11766</td>
      <td>7140</td>
      <td>7180</td>
      <td>815</td>
      <td>4168</td>
    </tr>
    <tr>
      <th>2018-02-01</th>
      <td>12120</td>
      <td>315000</td>
      <td>129614</td>
      <td>18372</td>
      <td>4562</td>
      <td>11685</td>
      <td>10939</td>
      <td>7216</td>
      <td>838</td>
      <td>4392</td>
    </tr>
    <tr>
      <th>2018-02-15</th>
      <td>12172</td>
      <td>315000</td>
      <td>132100</td>
      <td>17447</td>
      <td>4381</td>
      <td>11956</td>
      <td>7670</td>
      <td>7495</td>
      <td>841</td>
      <td>4512</td>
    </tr>
    <tr>
      <th>2018-02-28</th>
      <td>11661</td>
      <td>310416</td>
      <td>132100</td>
      <td>10219</td>
      <td>4121</td>
      <td>11884</td>
      <td>6944</td>
      <td>7353</td>
      <td>727</td>
      <td>4048</td>
    </tr>
    <tr>
      <th>2018-03-01</th>
      <td>12067</td>
      <td>300833</td>
      <td>132100</td>
      <td>7469</td>
      <td>5243</td>
      <td>11650</td>
      <td>7022</td>
      <td>7310</td>
      <td>566</td>
      <td>3332</td>
    </tr>
    <tr>
      <th>2018-03-15</th>
      <td>12819</td>
      <td>306250</td>
      <td>132100</td>
      <td>6052</td>
      <td>4692</td>
      <td>11633</td>
      <td>6734</td>
      <td>7223</td>
      <td>530</td>
      <td>2900</td>
    </tr>
    <tr>
      <th>2018-03-28</th>
      <td>15977</td>
      <td>306250</td>
      <td>131912</td>
      <td>5947</td>
      <td>5046</td>
      <td>11713</td>
      <td>7239</td>
      <td>7271</td>
      <td>539</td>
      <td>2437</td>
    </tr>
    <tr>
      <th>2018-04-01</th>
      <td>18570</td>
      <td>306250</td>
      <td>131428</td>
      <td>6778</td>
      <td>4417</td>
      <td>11809</td>
      <td>6338</td>
      <td>6942</td>
      <td>588</td>
      <td>2179</td>
    </tr>
    <tr>
      <th>2018-04-15</th>
      <td>18193</td>
      <td>306250</td>
      <td>135500</td>
      <td>7225</td>
      <td>5170</td>
      <td>11806</td>
      <td>6982</td>
      <td>6991</td>
      <td>568</td>
      <td>2538</td>
    </tr>
    <tr>
      <th>2018-04-28</th>
      <td>18997</td>
      <td>306250</td>
      <td>135500</td>
      <td>23639</td>
      <td>5663</td>
      <td>11684</td>
      <td>7372</td>
      <td>6922</td>
      <td>606</td>
      <td>3552</td>
    </tr>
    <tr>
      <th>2018-05-01</th>
      <td>15295</td>
      <td>306250</td>
      <td>135500</td>
      <td>23175</td>
      <td>5968</td>
      <td>11724</td>
      <td>6060</td>
      <td>6833</td>
      <td>585</td>
      <td>3495</td>
    </tr>
    <tr>
      <th>2018-05-15</th>
      <td>9649</td>
      <td>306250</td>
      <td>132583</td>
      <td>18201</td>
      <td>2851</td>
      <td>11786</td>
      <td>4226</td>
      <td>6916</td>
      <td>560</td>
      <td>3631</td>
    </tr>
    <tr>
      <th>2018-05-28</th>
      <td>8443</td>
      <td>306250</td>
      <td>132000</td>
      <td>21906</td>
      <td>2051</td>
      <td>11688</td>
      <td>4318</td>
      <td>6833</td>
      <td>586</td>
      <td>3262</td>
    </tr>
    <tr>
      <th>2018-06-01</th>
      <td>5139</td>
      <td>311910</td>
      <td>132000</td>
      <td>24559</td>
      <td>1922</td>
      <td>11677</td>
      <td>3487</td>
      <td>6904</td>
      <td>610</td>
      <td>3152</td>
    </tr>
    <tr>
      <th>2018-06-15</th>
      <td>4583</td>
      <td>315286</td>
      <td>131428</td>
      <td>28287</td>
      <td>1660</td>
      <td>11688</td>
      <td>3555</td>
      <td>7038</td>
      <td>562</td>
      <td>3549</td>
    </tr>
    <tr>
      <th>2018-06-28</th>
      <td>2389</td>
      <td>313325</td>
      <td>130600</td>
      <td>27492</td>
      <td>1827</td>
      <td>11975</td>
      <td>4191</td>
      <td>6943</td>
      <td>539</td>
      <td>3473</td>
    </tr>
    <tr>
      <th>2018-07-01</th>
      <td>2461</td>
      <td>313325</td>
      <td>117357</td>
      <td>36952</td>
      <td>1921</td>
      <td>12003</td>
      <td>6074</td>
      <td>6974</td>
      <td>593</td>
      <td>3385</td>
    </tr>
    <tr>
      <th>2018-07-15</th>
      <td>2397</td>
      <td>313012</td>
      <td>115838</td>
      <td>47717</td>
      <td>2319</td>
      <td>11955</td>
      <td>6956</td>
      <td>6983</td>
      <td>889</td>
      <td>3227</td>
    </tr>
    <tr>
      <th>2018-07-28</th>
      <td>2797</td>
      <td>308800</td>
      <td>113478</td>
      <td>41621</td>
      <td>2700</td>
      <td>11965</td>
      <td>8347</td>
      <td>6961</td>
      <td>813</td>
      <td>3367</td>
    </tr>
    <tr>
      <th>2018-08-01</th>
      <td>3636</td>
      <td>316890</td>
      <td>113050</td>
      <td>46051</td>
      <td>3293</td>
      <td>11986</td>
      <td>10092</td>
      <td>7092</td>
      <td>828</td>
      <td>3699</td>
    </tr>
    <tr>
      <th>2018-08-15</th>
      <td>3774</td>
      <td>322859</td>
      <td>112400</td>
      <td>46683</td>
      <td>3138</td>
      <td>12024</td>
      <td>11379</td>
      <td>7348</td>
      <td>1017</td>
      <td>3798</td>
    </tr>
    <tr>
      <th>2018-08-28</th>
      <td>4261</td>
      <td>732796</td>
      <td>109800</td>
      <td>41795</td>
      <td>3725</td>
      <td>23355</td>
      <td>12662</td>
      <td>14681</td>
      <td>1332</td>
      <td>3600</td>
    </tr>
    <tr>
      <th>2018-09-01</th>
      <td>4043</td>
      <td>393162</td>
      <td>109800</td>
      <td>36827</td>
      <td>3350</td>
      <td>23458</td>
      <td>10725</td>
      <td>17823</td>
      <td>1785</td>
      <td>3377</td>
    </tr>
    <tr>
      <th>2018-09-15</th>
      <td>4049</td>
      <td>346350</td>
      <td>109769</td>
      <td>29359</td>
      <td>2847</td>
      <td>28052</td>
      <td>7971</td>
      <td>8667</td>
      <td>1911</td>
      <td>3133</td>
    </tr>
    <tr>
      <th>2018-09-28</th>
      <td>4402</td>
      <td>337004</td>
      <td>109550</td>
      <td>21765</td>
      <td>2746</td>
      <td>28788</td>
      <td>6636</td>
      <td>8734</td>
      <td>1421</td>
      <td>3004</td>
    </tr>
    <tr>
      <th>2018-10-01</th>
      <td>4075</td>
      <td>324123</td>
      <td>109550</td>
      <td>16461</td>
      <td>1906</td>
      <td>14926</td>
      <td>4634</td>
      <td>8438</td>
      <td>1160</td>
      <td>3485</td>
    </tr>
    <tr>
      <th>2018-10-15</th>
      <td>3964</td>
      <td>312225</td>
      <td>112407</td>
      <td>18881</td>
      <td>1750</td>
      <td>13824</td>
      <td>6639</td>
      <td>10233</td>
      <td>873</td>
      <td>3048</td>
    </tr>
    <tr>
      <th>2018-10-28</th>
      <td>3960</td>
      <td>311162</td>
      <td>114419</td>
      <td>13204</td>
      <td>450608</td>
      <td>13552</td>
      <td>6802</td>
      <td>10621</td>
      <td>780</td>
      <td>3003</td>
    </tr>
    <tr>
      <th>2018-11-01</th>
      <td>4558</td>
      <td>307368</td>
      <td>115357</td>
      <td>14433</td>
      <td>474127</td>
      <td>13747</td>
      <td>8276</td>
      <td>7312</td>
      <td>683</td>
      <td>2905</td>
    </tr>
    <tr>
      <th>2018-11-15</th>
      <td>8841</td>
      <td>305850</td>
      <td>115500</td>
      <td>11654</td>
      <td>1304564</td>
      <td>13694</td>
      <td>6590</td>
      <td>7542</td>
      <td>624</td>
      <td>2599</td>
    </tr>
    <tr>
      <th>2018-11-28</th>
      <td>8297</td>
      <td>306216</td>
      <td>116375</td>
      <td>10385</td>
      <td>902688</td>
      <td>14032</td>
      <td>6945</td>
      <td>7772</td>
      <td>604</td>
      <td>2601</td>
    </tr>
    <tr>
      <th>2018-12-01</th>
      <td>9166</td>
      <td>307775</td>
      <td>116100</td>
      <td>12073</td>
      <td>848519</td>
      <td>14224</td>
      <td>6755</td>
      <td>7854</td>
      <td>587</td>
      <td>2673</td>
    </tr>
    <tr>
      <th>2018-12-15</th>
      <td>15545</td>
      <td>308775</td>
      <td>115188</td>
      <td>11726</td>
      <td>856283</td>
      <td>14564</td>
      <td>6922</td>
      <td>7729</td>
      <td>587</td>
      <td>2672</td>
    </tr>
    <tr>
      <th>2018-12-28</th>
      <td>15003</td>
      <td>308775</td>
      <td>111717</td>
      <td>13784</td>
      <td>291958</td>
      <td>14986</td>
      <td>4829</td>
      <td>7714</td>
      <td>619</td>
      <td>2062</td>
    </tr>
    <tr>
      <th>2019-01-01</th>
      <td>15134</td>
      <td>307230</td>
      <td>109300</td>
      <td>14768</td>
      <td>1423</td>
      <td>14861</td>
      <td>5541</td>
      <td>7751</td>
      <td>646</td>
      <td>2765</td>
    </tr>
    <tr>
      <th>2019-01-15</th>
      <td>13804</td>
      <td>304438</td>
      <td>109350</td>
      <td>15265</td>
      <td>1237</td>
      <td>15098</td>
      <td>5092</td>
      <td>7950</td>
      <td>653</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>2019-01-28</th>
      <td>13742</td>
      <td>298189</td>
      <td>109400</td>
      <td>14079</td>
      <td>1257</td>
      <td>15932</td>
      <td>4828</td>
      <td>8261</td>
      <td>637</td>
      <td>2153</td>
    </tr>
    <tr>
      <th>2019-02-01</th>
      <td>14074</td>
      <td>296800</td>
      <td>109400</td>
      <td>17959</td>
      <td>1297</td>
      <td>16426</td>
      <td>5118</td>
      <td>8697</td>
      <td>638</td>
      <td>1918</td>
    </tr>
    <tr>
      <th>2019-02-15</th>
      <td>13488</td>
      <td>297347</td>
      <td>109400</td>
      <td>12496</td>
      <td>1325</td>
      <td>16152</td>
      <td>5004</td>
      <td>8403</td>
      <td>608</td>
      <td>2174</td>
    </tr>
    <tr>
      <th>2019-02-28</th>
      <td>12477</td>
      <td>299300</td>
      <td>109400</td>
      <td>12856</td>
      <td>1425</td>
      <td>16048</td>
      <td>4967</td>
      <td>8238</td>
      <td>574</td>
      <td>2095</td>
    </tr>
    <tr>
      <th>2019-03-01</th>
      <td>13623</td>
      <td>299300</td>
      <td>109400</td>
      <td>8721</td>
      <td>1386</td>
      <td>16034</td>
      <td>4595</td>
      <td>7999</td>
      <td>572</td>
      <td>2212</td>
    </tr>
    <tr>
      <th>2019-03-15</th>
      <td>12562</td>
      <td>299300</td>
      <td>111244</td>
      <td>7795</td>
      <td>1378</td>
      <td>16166</td>
      <td>4945</td>
      <td>8099</td>
      <td>574</td>
      <td>2277</td>
    </tr>
    <tr>
      <th>2019-03-28</th>
      <td>14856</td>
      <td>298586</td>
      <td>112400</td>
      <td>8008</td>
      <td>1451</td>
      <td>16179</td>
      <td>4651</td>
      <td>8273</td>
      <td>572</td>
      <td>2492</td>
    </tr>
    <tr>
      <th>2019-04-01</th>
      <td>14680</td>
      <td>296800</td>
      <td>111962</td>
      <td>7330</td>
      <td>1471</td>
      <td>16260</td>
      <td>4892</td>
      <td>8265</td>
      <td>581</td>
      <td>2908</td>
    </tr>
    <tr>
      <th>2019-04-15</th>
      <td>13830</td>
      <td>296621</td>
      <td>111543</td>
      <td>7310</td>
      <td>1396</td>
      <td>16390</td>
      <td>4722</td>
      <td>8259</td>
      <td>584</td>
      <td>3664</td>
    </tr>
    <tr>
      <th>2019-04-28</th>
      <td>12234</td>
      <td>296175</td>
      <td>111400</td>
      <td>16856</td>
      <td>1331</td>
      <td>16414</td>
      <td>3520</td>
      <td>8323</td>
      <td>558</td>
      <td>3210</td>
    </tr>
    <tr>
      <th>2019-05-01</th>
      <td>12763</td>
      <td>296175</td>
      <td>111400</td>
      <td>17809</td>
      <td>1612</td>
      <td>16930</td>
      <td>4312</td>
      <td>8356</td>
      <td>634</td>
      <td>3677</td>
    </tr>
    <tr>
      <th>2019-05-15</th>
      <td>12729</td>
      <td>296175</td>
      <td>111400</td>
      <td>27514</td>
      <td>1458</td>
      <td>17434</td>
      <td>3768</td>
      <td>8304</td>
      <td>711</td>
      <td>2471</td>
    </tr>
    <tr>
      <th>2019-05-28</th>
      <td>10327</td>
      <td>295897</td>
      <td>107866</td>
      <td>29909</td>
      <td>1387</td>
      <td>17267</td>
      <td>4553</td>
      <td>8218</td>
      <td>615</td>
      <td>2100</td>
    </tr>
    <tr>
      <th>2019-06-01</th>
      <td>8117</td>
      <td>293675</td>
      <td>104630</td>
      <td>31624</td>
      <td>1566</td>
      <td>16988</td>
      <td>5388</td>
      <td>8342</td>
      <td>595</td>
      <td>2091</td>
    </tr>
    <tr>
      <th>2019-06-15</th>
      <td>6931</td>
      <td>293362</td>
      <td>97075</td>
      <td>46389</td>
      <td>1600</td>
      <td>17693</td>
      <td>5510</td>
      <td>8433</td>
      <td>571</td>
      <td>1979</td>
    </tr>
    <tr>
      <th>2019-06-28</th>
      <td>6582</td>
      <td>291175</td>
      <td>89750</td>
      <td>34359</td>
      <td>1602</td>
      <td>18254</td>
      <td>6540</td>
      <td>8484</td>
      <td>590</td>
      <td>2135</td>
    </tr>
    <tr>
      <th>2019-07-01</th>
      <td>5977</td>
      <td>290144</td>
      <td>87250</td>
      <td>31441</td>
      <td>1540</td>
      <td>18955</td>
      <td>5865</td>
      <td>8539</td>
      <td>672</td>
      <td>1952</td>
    </tr>
    <tr>
      <th>2019-07-15</th>
      <td>6597</td>
      <td>289800</td>
      <td>81257</td>
      <td>27887</td>
      <td>1523</td>
      <td>19366</td>
      <td>5329</td>
      <td>8619</td>
      <td>751</td>
      <td>2002</td>
    </tr>
    <tr>
      <th>2019-07-28</th>
      <td>6513</td>
      <td>289331</td>
      <td>80425</td>
      <td>18643</td>
      <td>1482</td>
      <td>19715</td>
      <td>5092</td>
      <td>14834</td>
      <td>756</td>
      <td>2022</td>
    </tr>
    <tr>
      <th>2019-08-01</th>
      <td>6286</td>
      <td>280050</td>
      <td>79357</td>
      <td>24848</td>
      <td>1986</td>
      <td>20352</td>
      <td>7858</td>
      <td>14440</td>
      <td>1350</td>
      <td>2240</td>
    </tr>
    <tr>
      <th>2019-08-15</th>
      <td>6563</td>
      <td>268117</td>
      <td>78700</td>
      <td>29241</td>
      <td>1670</td>
      <td>35244</td>
      <td>7089</td>
      <td>14448</td>
      <td>1326</td>
      <td>2071</td>
    </tr>
    <tr>
      <th>2019-08-28</th>
      <td>6223</td>
      <td>317315</td>
      <td>78650</td>
      <td>26941</td>
      <td>1656</td>
      <td>31650</td>
      <td>6489</td>
      <td>17778</td>
      <td>1033</td>
      <td>2262</td>
    </tr>
    <tr>
      <th>2019-09-01</th>
      <td>6288</td>
      <td>252500</td>
      <td>78600</td>
      <td>30900</td>
      <td>1949</td>
      <td>29161</td>
      <td>8526</td>
      <td>12057</td>
      <td>940</td>
      <td>2298</td>
    </tr>
    <tr>
      <th>2019-09-15</th>
      <td>6258</td>
      <td>252500</td>
      <td>78600</td>
      <td>39994</td>
      <td>2089</td>
      <td>27702</td>
      <td>10204</td>
      <td>7423</td>
      <td>1134</td>
      <td>2076</td>
    </tr>
    <tr>
      <th>2019-09-28</th>
      <td>6055</td>
      <td>247500</td>
      <td>78266</td>
      <td>33687</td>
      <td>2029</td>
      <td>14105</td>
      <td>11462</td>
      <td>6534</td>
      <td>1268</td>
      <td>2221</td>
    </tr>
    <tr>
      <th>2019-10-01</th>
      <td>6153</td>
      <td>236250</td>
      <td>78100</td>
      <td>30459</td>
      <td>3066</td>
      <td>13227</td>
      <td>11988</td>
      <td>6055</td>
      <td>1178</td>
      <td>1926</td>
    </tr>
    <tr>
      <th>2019-10-15</th>
      <td>6432</td>
      <td>235833</td>
      <td>78100</td>
      <td>34681</td>
      <td>3386</td>
      <td>13000</td>
      <td>15019</td>
      <td>5971</td>
      <td>1417</td>
      <td>2217</td>
    </tr>
    <tr>
      <th>2019-10-28</th>
      <td>6092</td>
      <td>235278</td>
      <td>79456</td>
      <td>33414</td>
      <td>703809</td>
      <td>13067</td>
      <td>12803</td>
      <td>9178</td>
      <td>1270</td>
      <td>2121</td>
    </tr>
    <tr>
      <th>2019-11-01</th>
      <td>6450</td>
      <td>235500</td>
      <td>80200</td>
      <td>28121</td>
      <td>719056</td>
      <td>12887</td>
      <td>11515</td>
      <td>6549</td>
      <td>974</td>
      <td>2400</td>
    </tr>
    <tr>
      <th>2019-11-15</th>
      <td>6479</td>
      <td>235500</td>
      <td>80400</td>
      <td>11688</td>
      <td>1556263</td>
      <td>12528</td>
      <td>10683</td>
      <td>6504</td>
      <td>825</td>
      <td>2251</td>
    </tr>
    <tr>
      <th>2019-11-28</th>
      <td>6801</td>
      <td>236643</td>
      <td>80172</td>
      <td>11510</td>
      <td>1823850</td>
      <td>12598</td>
      <td>9523</td>
      <td>6386</td>
      <td>781</td>
      <td>2416</td>
    </tr>
    <tr>
      <th>2019-12-01</th>
      <td>6813</td>
      <td>237500</td>
      <td>80000</td>
      <td>12400</td>
      <td>1734489</td>
      <td>12767</td>
      <td>10483</td>
      <td>6137</td>
      <td>780</td>
      <td>2756</td>
    </tr>
    <tr>
      <th>2019-12-15</th>
      <td>3931</td>
      <td>237500</td>
      <td>80000</td>
      <td>15920</td>
      <td>1838784</td>
      <td>12834</td>
      <td>9546</td>
      <td>6219</td>
      <td>765</td>
      <td>2667</td>
    </tr>
    <tr>
      <th>2019-12-28</th>
      <td>5525</td>
      <td>235083</td>
      <td>79584</td>
      <td>14514</td>
      <td>1567160</td>
      <td>12833</td>
      <td>9878</td>
      <td>6247</td>
      <td>781</td>
      <td>2834</td>
    </tr>
    <tr>
      <th>2020-01-01</th>
      <td>6215</td>
      <td>221072</td>
      <td>79500</td>
      <td>13914</td>
      <td>680509</td>
      <td>13143</td>
      <td>11031</td>
      <td>6274</td>
      <td>945</td>
      <td>3357</td>
    </tr>
    <tr>
      <th>2020-01-15</th>
      <td>6880</td>
      <td>220000</td>
      <td>78666</td>
      <td>15497</td>
      <td>679894</td>
      <td>13116</td>
      <td>10155</td>
      <td>6454</td>
      <td>1082</td>
      <td>3843</td>
    </tr>
    <tr>
      <th>2020-01-28</th>
      <td>6111</td>
      <td>219000</td>
      <td>72696</td>
      <td>16385</td>
      <td>679404</td>
      <td>13104</td>
      <td>8527</td>
      <td>6955</td>
      <td>1117</td>
      <td>3705</td>
    </tr>
    <tr>
      <th>2020-02-01</th>
      <td>8998</td>
      <td>216500</td>
      <td>72100</td>
      <td>11288</td>
      <td>678951</td>
      <td>12794</td>
      <td>9138</td>
      <td>6836</td>
      <td>872</td>
      <td>3360</td>
    </tr>
    <tr>
      <th>2020-02-15</th>
      <td>8609</td>
      <td>213875</td>
      <td>72300</td>
      <td>14780</td>
      <td>679126</td>
      <td>13204</td>
      <td>10335</td>
      <td>6913</td>
      <td>722</td>
      <td>4052</td>
    </tr>
    <tr>
      <th>2020-02-28</th>
      <td>10840</td>
      <td>217344</td>
      <td>71875</td>
      <td>10032</td>
      <td>678947</td>
      <td>13536</td>
      <td>10999</td>
      <td>6961</td>
      <td>674</td>
      <td>5270</td>
    </tr>
    <tr>
      <th>2020-03-01</th>
      <td>10029</td>
      <td>216353</td>
      <td>71910</td>
      <td>8923</td>
      <td>679244</td>
      <td>13437</td>
      <td>12444</td>
      <td>6759</td>
      <td>656</td>
      <td>4329</td>
    </tr>
    <tr>
      <th>2020-03-15</th>
      <td>10746</td>
      <td>214734</td>
      <td>69812</td>
      <td>9672</td>
      <td>679055</td>
      <td>13387</td>
      <td>14737</td>
      <td>6856</td>
      <td>647</td>
      <td>4270</td>
    </tr>
    <tr>
      <th>2020-03-28</th>
      <td>11156</td>
      <td>216321</td>
      <td>69500</td>
      <td>8409</td>
      <td>679112</td>
      <td>13133</td>
      <td>12803</td>
      <td>6910</td>
      <td>636</td>
      <td>4243</td>
    </tr>
    <tr>
      <th>2020-04-01</th>
      <td>9673</td>
      <td>217125</td>
      <td>69500</td>
      <td>8730</td>
      <td>678702</td>
      <td>13048</td>
      <td>11284</td>
      <td>6862</td>
      <td>590</td>
      <td>4293</td>
    </tr>
    <tr>
      <th>2020-04-15</th>
      <td>16412</td>
      <td>217125</td>
      <td>69800</td>
      <td>32514</td>
      <td>678865</td>
      <td>13189</td>
      <td>11010</td>
      <td>7073</td>
      <td>575</td>
      <td>4153</td>
    </tr>
    <tr>
      <th>2020-04-28</th>
      <td>18641</td>
      <td>217125</td>
      <td>70643</td>
      <td>29491</td>
      <td>678887</td>
      <td>13118</td>
      <td>9248</td>
      <td>7317</td>
      <td>558</td>
      <td>4169</td>
    </tr>
    <tr>
      <th>2020-05-01</th>
      <td>19337</td>
      <td>217125</td>
      <td>71250</td>
      <td>26113</td>
      <td>678813</td>
      <td>13310</td>
      <td>10678</td>
      <td>7512</td>
      <td>564</td>
      <td>3669</td>
    </tr>
    <tr>
      <th>2020-05-15</th>
      <td>17815</td>
      <td>217344</td>
      <td>75188</td>
      <td>25872</td>
      <td>1397</td>
      <td>13276</td>
      <td>8357</td>
      <td>7750</td>
      <td>560</td>
      <td>3885</td>
    </tr>
    <tr>
      <th>2020-05-28</th>
      <td>15007</td>
      <td>218018</td>
      <td>76200</td>
      <td>29355</td>
      <td>1625</td>
      <td>13093</td>
      <td>8370</td>
      <td>7779</td>
      <td>576</td>
      <td>3053</td>
    </tr>
    <tr>
      <th>2020-06-01</th>
      <td>14397</td>
      <td>225781</td>
      <td>76025</td>
      <td>34122</td>
      <td>1856</td>
      <td>13183</td>
      <td>6196</td>
      <td>7949</td>
      <td>599</td>
      <td>2534</td>
    </tr>
    <tr>
      <th>2020-06-15</th>
      <td>13180</td>
      <td>233964</td>
      <td>76672</td>
      <td>35851</td>
      <td>2029</td>
      <td>13995</td>
      <td>6630</td>
      <td>8163</td>
      <td>640</td>
      <td>3427</td>
    </tr>
    <tr>
      <th>2020-06-28</th>
      <td>12090</td>
      <td>236478</td>
      <td>81904</td>
      <td>38163</td>
      <td>2304</td>
      <td>14054</td>
      <td>9787</td>
      <td>8558</td>
      <td>868</td>
      <td>6409</td>
    </tr>
    <tr>
      <th>2020-07-01</th>
      <td>12054</td>
      <td>235550</td>
      <td>84266</td>
      <td>36811</td>
      <td>2039</td>
      <td>14214</td>
      <td>8560</td>
      <td>8770</td>
      <td>994</td>
      <td>5739</td>
    </tr>
    <tr>
      <th>2020-07-15</th>
      <td>12124</td>
      <td>235716</td>
      <td>101954</td>
      <td>30569</td>
      <td>1751</td>
      <td>14426</td>
      <td>9656</td>
      <td>9117</td>
      <td>1087</td>
      <td>6448</td>
    </tr>
    <tr>
      <th>2020-07-28</th>
      <td>10650</td>
      <td>236806</td>
      <td>122711</td>
      <td>30961</td>
      <td>1675</td>
      <td>14610</td>
      <td>9420</td>
      <td>9406</td>
      <td>1092</td>
      <td>7148</td>
    </tr>
    <tr>
      <th>2020-08-01</th>
      <td>12001</td>
      <td>247416</td>
      <td>130550</td>
      <td>47756</td>
      <td>2422</td>
      <td>14682</td>
      <td>13030</td>
      <td>17093</td>
      <td>1340</td>
      <td>8963</td>
    </tr>
    <tr>
      <th>2020-08-15</th>
      <td>8738</td>
      <td>524143</td>
      <td>130572</td>
      <td>63233</td>
      <td>2692</td>
      <td>14649</td>
      <td>15440</td>
      <td>17227</td>
      <td>1846</td>
      <td>9910</td>
    </tr>
    <tr>
      <th>2020-08-28</th>
      <td>9194</td>
      <td>814136</td>
      <td>131414</td>
      <td>71330</td>
      <td>3405</td>
      <td>26960</td>
      <td>14516</td>
      <td>20988</td>
      <td>1803</td>
      <td>9695</td>
    </tr>
    <tr>
      <th>2020-09-01</th>
      <td>9074</td>
      <td>474528</td>
      <td>131700</td>
      <td>69814</td>
      <td>3283</td>
      <td>26842</td>
      <td>16331</td>
      <td>17403</td>
      <td>1196</td>
      <td>10407</td>
    </tr>
    <tr>
      <th>2020-09-15</th>
      <td>9388</td>
      <td>469025</td>
      <td>131700</td>
      <td>65291</td>
      <td>3482</td>
      <td>20094</td>
      <td>19217</td>
      <td>10003</td>
      <td>1251</td>
      <td>10594</td>
    </tr>
    <tr>
      <th>2020-09-28</th>
      <td>9067</td>
      <td>442272</td>
      <td>131586</td>
      <td>57014</td>
      <td>3306</td>
      <td>24147</td>
      <td>16546</td>
      <td>10874</td>
      <td>1231</td>
      <td>10343</td>
    </tr>
    <tr>
      <th>2020-10-01</th>
      <td>8971</td>
      <td>438938</td>
      <td>131500</td>
      <td>30385</td>
      <td>2584</td>
      <td>16172</td>
      <td>12160</td>
      <td>10502</td>
      <td>1018</td>
      <td>11383</td>
    </tr>
    <tr>
      <th>2020-10-15</th>
      <td>7952</td>
      <td>439064</td>
      <td>131500</td>
      <td>25623</td>
      <td>2020</td>
      <td>16024</td>
      <td>10353</td>
      <td>10267</td>
      <td>756</td>
      <td>11128</td>
    </tr>
    <tr>
      <th>2020-10-28</th>
      <td>8320</td>
      <td>443312</td>
      <td>131500</td>
      <td>26261</td>
      <td>1576</td>
      <td>15511</td>
      <td>7584</td>
      <td>14451</td>
      <td>660</td>
      <td>10686</td>
    </tr>
    <tr>
      <th>2020-11-01</th>
      <td>8453</td>
      <td>448039</td>
      <td>131500</td>
      <td>27328</td>
      <td>407841</td>
      <td>15586</td>
      <td>8148</td>
      <td>10069</td>
      <td>630</td>
      <td>11125</td>
    </tr>
    <tr>
      <th>2020-11-15</th>
      <td>8172</td>
      <td>447066</td>
      <td>131500</td>
      <td>29092</td>
      <td>449013</td>
      <td>15700</td>
      <td>7286</td>
      <td>9435</td>
      <td>605</td>
      <td>11189</td>
    </tr>
    <tr>
      <th>2020-11-28</th>
      <td>10759</td>
      <td>444667</td>
      <td>131500</td>
      <td>24609</td>
      <td>454504</td>
      <td>15907</td>
      <td>6950</td>
      <td>9268</td>
      <td>583</td>
      <td>12580</td>
    </tr>
    <tr>
      <th>2020-12-01</th>
      <td>10996</td>
      <td>443143</td>
      <td>131500</td>
      <td>18835</td>
      <td>403338</td>
      <td>16300</td>
      <td>7288</td>
      <td>8965</td>
      <td>584</td>
      <td>12029</td>
    </tr>
    <tr>
      <th>2020-12-15</th>
      <td>16391</td>
      <td>439696</td>
      <td>131500</td>
      <td>26109</td>
      <td>403705</td>
      <td>16739</td>
      <td>6723</td>
      <td>9158</td>
      <td>669</td>
      <td>11631</td>
    </tr>
    <tr>
      <th>2020-12-28</th>
      <td>16845</td>
      <td>432912</td>
      <td>131500</td>
      <td>36840</td>
      <td>403840</td>
      <td>17231</td>
      <td>7988</td>
      <td>9557</td>
      <td>755</td>
      <td>11414</td>
    </tr>
    <tr>
      <th>2021-01-01</th>
      <td>20610</td>
      <td>430975</td>
      <td>131500</td>
      <td>47286</td>
      <td>2595</td>
      <td>17632</td>
      <td>8418</td>
      <td>9618</td>
      <td>922</td>
      <td>13086</td>
    </tr>
    <tr>
      <th>2021-01-15</th>
      <td>22195</td>
      <td>430975</td>
      <td>131500</td>
      <td>60539</td>
      <td>2689</td>
      <td>18410</td>
      <td>10181</td>
      <td>10121</td>
      <td>1042</td>
      <td>14330</td>
    </tr>
    <tr>
      <th>2021-01-28</th>
      <td>24156</td>
      <td>430975</td>
      <td>131500</td>
      <td>43940</td>
      <td>2221</td>
      <td>20002</td>
      <td>8266</td>
      <td>11251</td>
      <td>1039</td>
      <td>14183</td>
    </tr>
    <tr>
      <th>2021-02-01</th>
      <td>24912</td>
      <td>430975</td>
      <td>135350</td>
      <td>30753</td>
      <td>2072</td>
      <td>20986</td>
      <td>9193</td>
      <td>12116</td>
      <td>1004</td>
      <td>16002</td>
    </tr>
    <tr>
      <th>2021-02-15</th>
      <td>26167</td>
      <td>430455</td>
      <td>138300</td>
      <td>18859</td>
      <td>1596</td>
      <td>21269</td>
      <td>9109</td>
      <td>11803</td>
      <td>937</td>
      <td>17111</td>
    </tr>
    <tr>
      <th>2021-02-28</th>
      <td>26240</td>
      <td>428825</td>
      <td>138600</td>
      <td>20487</td>
      <td>1463</td>
      <td>21169</td>
      <td>7975</td>
      <td>11770</td>
      <td>850</td>
      <td>18713</td>
    </tr>
    <tr>
      <th>2021-03-01</th>
      <td>24939</td>
      <td>428104</td>
      <td>138400</td>
      <td>16193</td>
      <td>1597</td>
      <td>20586</td>
      <td>8548</td>
      <td>11420</td>
      <td>719</td>
      <td>16731</td>
    </tr>
    <tr>
      <th>2021-03-15</th>
      <td>25349</td>
      <td>424911</td>
      <td>139800</td>
      <td>14551</td>
      <td>1658</td>
      <td>20921</td>
      <td>10288</td>
      <td>11286</td>
      <td>720</td>
      <td>15533</td>
    </tr>
    <tr>
      <th>2021-03-28</th>
      <td>23006</td>
      <td>424791</td>
      <td>140738</td>
      <td>13623</td>
      <td>1590</td>
      <td>21823</td>
      <td>9917</td>
      <td>11561</td>
      <td>716</td>
      <td>12893</td>
    </tr>
    <tr>
      <th>2021-04-01</th>
      <td>19729</td>
      <td>428372</td>
      <td>141014</td>
      <td>26225</td>
      <td>1524</td>
      <td>21480</td>
      <td>7622</td>
      <td>11860</td>
      <td>698</td>
      <td>7999</td>
    </tr>
    <tr>
      <th>2021-04-15</th>
      <td>19479</td>
      <td>428550</td>
      <td>142114</td>
      <td>29735</td>
      <td>1635</td>
      <td>21378</td>
      <td>7626</td>
      <td>11905</td>
      <td>700</td>
      <td>6961</td>
    </tr>
    <tr>
      <th>2021-04-28</th>
      <td>17557</td>
      <td>428550</td>
      <td>150150</td>
      <td>29328</td>
      <td>1621</td>
      <td>21301</td>
      <td>6508</td>
      <td>11962</td>
      <td>709</td>
      <td>4060</td>
    </tr>
    <tr>
      <th>2021-05-01</th>
      <td>18033</td>
      <td>428550</td>
      <td>148200</td>
      <td>29345</td>
      <td>1657</td>
      <td>21408</td>
      <td>6463</td>
      <td>11990</td>
      <td>683</td>
      <td>5483</td>
    </tr>
    <tr>
      <th>2021-05-15</th>
      <td>14501</td>
      <td>428550</td>
      <td>145914</td>
      <td>29460</td>
      <td>1494</td>
      <td>20578</td>
      <td>5829</td>
      <td>11974</td>
      <td>685</td>
      <td>4436</td>
    </tr>
    <tr>
      <th>2021-05-28</th>
      <td>14075</td>
      <td>428550</td>
      <td>143836</td>
      <td>23604</td>
      <td>1561</td>
      <td>21309</td>
      <td>6004</td>
      <td>11643</td>
      <td>701</td>
      <td>4504</td>
    </tr>
    <tr>
      <th>2021-06-01</th>
      <td>8616</td>
      <td>428550</td>
      <td>143000</td>
      <td>25869</td>
      <td>1756</td>
      <td>21745</td>
      <td>5323</td>
      <td>11554</td>
      <td>825</td>
      <td>4409</td>
    </tr>
    <tr>
      <th>2021-06-15</th>
      <td>7789</td>
      <td>429383</td>
      <td>141250</td>
      <td>29885</td>
      <td>1715</td>
      <td>21837</td>
      <td>5445</td>
      <td>11746</td>
      <td>805</td>
      <td>5454</td>
    </tr>
    <tr>
      <th>2021-06-28</th>
      <td>9470</td>
      <td>429800</td>
      <td>140286</td>
      <td>31388</td>
      <td>1850</td>
      <td>22331</td>
      <td>6290</td>
      <td>11682</td>
      <td>818</td>
      <td>5025</td>
    </tr>
    <tr>
      <th>2021-07-01</th>
      <td>10931</td>
      <td>429800</td>
      <td>140511</td>
      <td>31726</td>
      <td>2433</td>
      <td>22876</td>
      <td>5669</td>
      <td>11612</td>
      <td>855</td>
      <td>5012</td>
    </tr>
    <tr>
      <th>2021-07-15</th>
      <td>7822</td>
      <td>425857</td>
      <td>157114</td>
      <td>30422</td>
      <td>1982</td>
      <td>23641</td>
      <td>6295</td>
      <td>11709</td>
      <td>970</td>
      <td>5108</td>
    </tr>
    <tr>
      <th>2021-07-28</th>
      <td>9307</td>
      <td>681860</td>
      <td>157350</td>
      <td>46005</td>
      <td>2080</td>
      <td>24210</td>
      <td>7592</td>
      <td>11587</td>
      <td>1236</td>
      <td>5944</td>
    </tr>
    <tr>
      <th>2021-08-01</th>
      <td>11273</td>
      <td>768657</td>
      <td>157886</td>
      <td>62117</td>
      <td>2355</td>
      <td>24748</td>
      <td>10695</td>
      <td>15408</td>
      <td>1238</td>
      <td>7477</td>
    </tr>
    <tr>
      <th>2021-08-15</th>
      <td>11970</td>
      <td>731371</td>
      <td>156358</td>
      <td>68709</td>
      <td>1935</td>
      <td>24302</td>
      <td>10309</td>
      <td>17611</td>
      <td>1320</td>
      <td>8324</td>
    </tr>
    <tr>
      <th>2021-08-28</th>
      <td>11994</td>
      <td>321917</td>
      <td>156000</td>
      <td>52377</td>
      <td>1880</td>
      <td>27381</td>
      <td>9809</td>
      <td>20729</td>
      <td>1381</td>
      <td>8467</td>
    </tr>
    <tr>
      <th>2021-09-01</th>
      <td>12381</td>
      <td>319197</td>
      <td>153650</td>
      <td>47336</td>
      <td>2300</td>
      <td>30134</td>
      <td>11555</td>
      <td>8385</td>
      <td>1842</td>
      <td>9139</td>
    </tr>
    <tr>
      <th>2021-09-15</th>
      <td>12314</td>
      <td>310806</td>
      <td>152900</td>
      <td>65237</td>
      <td>2006</td>
      <td>24134</td>
      <td>12051</td>
      <td>8339</td>
      <td>2018</td>
      <td>8431</td>
    </tr>
    <tr>
      <th>2021-09-28</th>
      <td>12266</td>
      <td>307452</td>
      <td>152900</td>
      <td>39638</td>
      <td>1300</td>
      <td>16693</td>
      <td>7299</td>
      <td>8631</td>
      <td>1614</td>
      <td>8398</td>
    </tr>
    <tr>
      <th>2021-10-01</th>
      <td>11247</td>
      <td>306470</td>
      <td>152900</td>
      <td>30134</td>
      <td>1429</td>
      <td>15809</td>
      <td>6780</td>
      <td>7671</td>
      <td>971</td>
      <td>9470</td>
    </tr>
    <tr>
      <th>2021-10-15</th>
      <td>11949</td>
      <td>302532</td>
      <td>152986</td>
      <td>40696</td>
      <td>2172</td>
      <td>14583</td>
      <td>8674</td>
      <td>7176</td>
      <td>1080</td>
      <td>8856</td>
    </tr>
    <tr>
      <th>2021-10-28</th>
      <td>11428</td>
      <td>300775</td>
      <td>153000</td>
      <td>31435</td>
      <td>3503</td>
      <td>14550</td>
      <td>13462</td>
      <td>4950</td>
      <td>1731</td>
      <td>8931</td>
    </tr>
    <tr>
      <th>2021-11-01</th>
      <td>11616</td>
      <td>300775</td>
      <td>154500</td>
      <td>25906</td>
      <td>2434</td>
      <td>14502</td>
      <td>12038</td>
      <td>8922</td>
      <td>1394</td>
      <td>8007</td>
    </tr>
    <tr>
      <th>2021-11-15</th>
      <td>13272</td>
      <td>300775</td>
      <td>162086</td>
      <td>23591</td>
      <td>2595</td>
      <td>13734</td>
      <td>13096</td>
      <td>8294</td>
      <td>967</td>
      <td>9487</td>
    </tr>
    <tr>
      <th>2021-11-28</th>
      <td>17634</td>
      <td>302382</td>
      <td>164000</td>
      <td>17168</td>
      <td>2130</td>
      <td>13940</td>
      <td>12113</td>
      <td>8300</td>
      <td>845</td>
      <td>8158</td>
    </tr>
    <tr>
      <th>2021-12-01</th>
      <td>18178</td>
      <td>303588</td>
      <td>164000</td>
      <td>17118</td>
      <td>2216</td>
      <td>14133</td>
      <td>11476</td>
      <td>8490</td>
      <td>753</td>
      <td>7300</td>
    </tr>
    <tr>
      <th>2021-12-15</th>
      <td>17322</td>
      <td>303588</td>
      <td>164000</td>
      <td>19419</td>
      <td>1882</td>
      <td>14324</td>
      <td>10966</td>
      <td>8448</td>
      <td>738</td>
      <td>6870</td>
    </tr>
    <tr>
      <th>2021-12-28</th>
      <td>26568</td>
      <td>301400</td>
      <td>162934</td>
      <td>18900</td>
      <td>1934</td>
      <td>15420</td>
      <td>11929</td>
      <td>8575</td>
      <td>777</td>
      <td>6792</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-52055fca-4251-42ab-8372-f56bb1df1674')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-52055fca-4251-42ab-8372-f56bb1df1674 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-52055fca-4251-42ab-8372-f56bb1df1674');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-34341929-73a7-4b8a-acfc-383d653fb819">
  <button class="colab-df-quickchart" onclick="quickchart('df-34341929-73a7-4b8a-acfc-383d653fb819')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-34341929-73a7-4b8a-acfc-383d653fb819 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_c7c54aab-ac98-4fe9-8d35-df67ce93378e">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('pivot_table')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_c7c54aab-ac98-4fe9-8d35-df67ce93378e button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('pivot_table');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# target 기준 시점별 품목별 평균가격
monthly_avg_price_by_item_target = train_data_target.groupby(['시점', '품목명'])['평균가격(원)'].mean().reset_index()

# 시각화
unique_items = monthly_avg_price_by_item_target['품목명'].unique()

# 각 품목별로 차트 생성
for item in unique_items:
    plt.figure(figsize=(14, 6))
    item_data = monthly_avg_price_by_item_target[monthly_avg_price_by_item_target['품목명'] == item]
    sns.lineplot(data=item_data, x='시점', y='평균가격(원)')
    plt.title(f'Average Price of {item} Over Time')
    plt.xlabel('Date')
    plt.ylabel('Average Price (원)')
    plt.xticks(rotation=45)
    plt.grid()
    plt.show()
```


    
![png](/assets/img/py7_files/py7_29_0.png)
    



    
![png](/assets/img/py7_files/py7_29_1.png)
    



    
![png](/assets/img/py7_files/py7_29_2.png)
    



    
![png](/assets/img/py7_files/py7_29_3.png)
    



    
![png](/assets/img/py7_files/py7_29_4.png)
    



    
![png](/assets/img/py7_files/py7_29_5.png)
    



    
![png](/assets/img/py7_files/py7_29_6.png)
    



    
![png](/assets/img/py7_files/py7_29_7.png)
    



    
![png](/assets/img/py7_files/py7_29_8.png)
    



    
![png](/assets/img/py7_files/py7_29_9.png)
    


- 나름 규칙적인 패턴이 있는가하면 가격이 불안정한 농산물도 상당수 있음


```python
monthly_avg_price_by_item_target = train_data_target.groupby(['시점', '품목명'])['평균가격(원)'].mean().reset_index()
pivot_table2 = monthly_avg_price_by_item_target.pivot(index='시점', columns='품목명', values='평균가격(원)')
pivot_table2 = pivot_table2.round(0).astype(int)
pivot_table2
```





  <div id="df-574b5929-05be-4e3c-b6ce-5cfec0a0d31d" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>품목명</th>
      <th>감자</th>
      <th>건고추</th>
      <th>깐마늘(국산)</th>
      <th>대파</th>
      <th>무</th>
      <th>배</th>
      <th>배추</th>
      <th>사과</th>
      <th>상추</th>
      <th>양파</th>
    </tr>
    <tr>
      <th>시점</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2018-01-01</th>
      <td>44170</td>
      <td>590000</td>
      <td>130667</td>
      <td>1685</td>
      <td>9284</td>
      <td>28312</td>
      <td>5420</td>
      <td>20361</td>
      <td>940</td>
      <td>1144</td>
    </tr>
    <tr>
      <th>2018-01-15</th>
      <td>48284</td>
      <td>590000</td>
      <td>130600</td>
      <td>1625</td>
      <td>9260</td>
      <td>28290</td>
      <td>5319</td>
      <td>20359</td>
      <td>981</td>
      <td>1041</td>
    </tr>
    <tr>
      <th>2018-01-28</th>
      <td>50243</td>
      <td>590000</td>
      <td>130600</td>
      <td>1834</td>
      <td>10576</td>
      <td>28324</td>
      <td>6735</td>
      <td>20653</td>
      <td>983</td>
      <td>1036</td>
    </tr>
    <tr>
      <th>2018-02-01</th>
      <td>55381</td>
      <td>590000</td>
      <td>134614</td>
      <td>2530</td>
      <td>18371</td>
      <td>28113</td>
      <td>8942</td>
      <td>20563</td>
      <td>1009</td>
      <td>1046</td>
    </tr>
    <tr>
      <th>2018-02-15</th>
      <td>59133</td>
      <td>590000</td>
      <td>137100</td>
      <td>1538</td>
      <td>19546</td>
      <td>28294</td>
      <td>7247</td>
      <td>21779</td>
      <td>1022</td>
      <td>1098</td>
    </tr>
    <tr>
      <th>2018-02-28</th>
      <td>60487</td>
      <td>580833</td>
      <td>137100</td>
      <td>1444</td>
      <td>19226</td>
      <td>28129</td>
      <td>7891</td>
      <td>21465</td>
      <td>918</td>
      <td>922</td>
    </tr>
    <tr>
      <th>2018-03-01</th>
      <td>64070</td>
      <td>563333</td>
      <td>137100</td>
      <td>1426</td>
      <td>23856</td>
      <td>27435</td>
      <td>8168</td>
      <td>21384</td>
      <td>670</td>
      <td>879</td>
    </tr>
    <tr>
      <th>2018-03-15</th>
      <td>70822</td>
      <td>575000</td>
      <td>137100</td>
      <td>1309</td>
      <td>19215</td>
      <td>27543</td>
      <td>7797</td>
      <td>20695</td>
      <td>627</td>
      <td>675</td>
    </tr>
    <tr>
      <th>2018-03-28</th>
      <td>92195</td>
      <td>575000</td>
      <td>136912</td>
      <td>1121</td>
      <td>19304</td>
      <td>27942</td>
      <td>7996</td>
      <td>20794</td>
      <td>623</td>
      <td>644</td>
    </tr>
    <tr>
      <th>2018-04-01</th>
      <td>115128</td>
      <td>575000</td>
      <td>136428</td>
      <td>914</td>
      <td>18611</td>
      <td>28129</td>
      <td>7503</td>
      <td>19019</td>
      <td>689</td>
      <td>647</td>
    </tr>
    <tr>
      <th>2018-04-15</th>
      <td>109037</td>
      <td>575000</td>
      <td>142000</td>
      <td>787</td>
      <td>20007</td>
      <td>28140</td>
      <td>7082</td>
      <td>19208</td>
      <td>676</td>
      <td>760</td>
    </tr>
    <tr>
      <th>2018-04-28</th>
      <td>98434</td>
      <td>575000</td>
      <td>142000</td>
      <td>1002</td>
      <td>23676</td>
      <td>27779</td>
      <td>6637</td>
      <td>19154</td>
      <td>711</td>
      <td>954</td>
    </tr>
    <tr>
      <th>2018-05-01</th>
      <td>74558</td>
      <td>575000</td>
      <td>142000</td>
      <td>1254</td>
      <td>25174</td>
      <td>28143</td>
      <td>5589</td>
      <td>19074</td>
      <td>707</td>
      <td>836</td>
    </tr>
    <tr>
      <th>2018-05-15</th>
      <td>50940</td>
      <td>575000</td>
      <td>139083</td>
      <td>884</td>
      <td>22678</td>
      <td>28288</td>
      <td>4657</td>
      <td>18943</td>
      <td>672</td>
      <td>592</td>
    </tr>
    <tr>
      <th>2018-05-28</th>
      <td>41498</td>
      <td>575000</td>
      <td>138500</td>
      <td>1385</td>
      <td>13201</td>
      <td>28179</td>
      <td>3771</td>
      <td>18681</td>
      <td>698</td>
      <td>553</td>
    </tr>
    <tr>
      <th>2018-06-01</th>
      <td>25062</td>
      <td>591320</td>
      <td>138500</td>
      <td>1237</td>
      <td>13106</td>
      <td>27790</td>
      <td>3345</td>
      <td>19018</td>
      <td>741</td>
      <td>679</td>
    </tr>
    <tr>
      <th>2018-06-15</th>
      <td>23765</td>
      <td>599514</td>
      <td>137928</td>
      <td>1149</td>
      <td>10809</td>
      <td>27844</td>
      <td>4073</td>
      <td>19762</td>
      <td>699</td>
      <td>742</td>
    </tr>
    <tr>
      <th>2018-06-28</th>
      <td>23870</td>
      <td>600000</td>
      <td>137100</td>
      <td>1289</td>
      <td>11432</td>
      <td>28322</td>
      <td>4684</td>
      <td>19393</td>
      <td>664</td>
      <td>659</td>
    </tr>
    <tr>
      <th>2018-07-01</th>
      <td>24742</td>
      <td>600000</td>
      <td>123914</td>
      <td>1324</td>
      <td>11280</td>
      <td>28555</td>
      <td>5479</td>
      <td>19508</td>
      <td>700</td>
      <td>697</td>
    </tr>
    <tr>
      <th>2018-07-15</th>
      <td>24152</td>
      <td>599375</td>
      <td>122350</td>
      <td>1203</td>
      <td>14501</td>
      <td>28595</td>
      <td>7957</td>
      <td>19496</td>
      <td>1046</td>
      <td>713</td>
    </tr>
    <tr>
      <th>2018-07-28</th>
      <td>28255</td>
      <td>590943</td>
      <td>119928</td>
      <td>1400</td>
      <td>20879</td>
      <td>28632</td>
      <td>11236</td>
      <td>19680</td>
      <td>977</td>
      <td>799</td>
    </tr>
    <tr>
      <th>2018-08-01</th>
      <td>37492</td>
      <td>601250</td>
      <td>119500</td>
      <td>1609</td>
      <td>23968</td>
      <td>28352</td>
      <td>10779</td>
      <td>20287</td>
      <td>969</td>
      <td>911</td>
    </tr>
    <tr>
      <th>2018-08-15</th>
      <td>37474</td>
      <td>605000</td>
      <td>118800</td>
      <td>1843</td>
      <td>20642</td>
      <td>28464</td>
      <td>16235</td>
      <td>20956</td>
      <td>1223</td>
      <td>804</td>
    </tr>
    <tr>
      <th>2018-08-28</th>
      <td>42554</td>
      <td>600000</td>
      <td>116000</td>
      <td>2981</td>
      <td>27821</td>
      <td>28192</td>
      <td>17583</td>
      <td>21807</td>
      <td>1556</td>
      <td>810</td>
    </tr>
    <tr>
      <th>2018-09-01</th>
      <td>40545</td>
      <td>771633</td>
      <td>116000</td>
      <td>2997</td>
      <td>22826</td>
      <td>26699</td>
      <td>10922</td>
      <td>21299</td>
      <td>1908</td>
      <td>790</td>
    </tr>
    <tr>
      <th>2018-09-15</th>
      <td>40888</td>
      <td>670800</td>
      <td>116000</td>
      <td>2671</td>
      <td>21873</td>
      <td>35206</td>
      <td>9810</td>
      <td>26228</td>
      <td>2071</td>
      <td>764</td>
    </tr>
    <tr>
      <th>2018-09-28</th>
      <td>43794</td>
      <td>651067</td>
      <td>116000</td>
      <td>2904</td>
      <td>21683</td>
      <td>36263</td>
      <td>7212</td>
      <td>26219</td>
      <td>1634</td>
      <td>718</td>
    </tr>
    <tr>
      <th>2018-10-01</th>
      <td>39751</td>
      <td>628017</td>
      <td>116000</td>
      <td>2809</td>
      <td>15611</td>
      <td>35528</td>
      <td>6275</td>
      <td>25411</td>
      <td>1410</td>
      <td>808</td>
    </tr>
    <tr>
      <th>2018-10-15</th>
      <td>38610</td>
      <td>616000</td>
      <td>119714</td>
      <td>1849</td>
      <td>12332</td>
      <td>33137</td>
      <td>5449</td>
      <td>22474</td>
      <td>1037</td>
      <td>708</td>
    </tr>
    <tr>
      <th>2018-10-28</th>
      <td>38499</td>
      <td>608500</td>
      <td>122375</td>
      <td>1908</td>
      <td>8466</td>
      <td>33051</td>
      <td>5500</td>
      <td>22336</td>
      <td>935</td>
      <td>714</td>
    </tr>
    <tr>
      <th>2018-11-01</th>
      <td>43583</td>
      <td>593857</td>
      <td>123357</td>
      <td>1852</td>
      <td>6862</td>
      <td>33505</td>
      <td>5469</td>
      <td>21791</td>
      <td>831</td>
      <td>724</td>
    </tr>
    <tr>
      <th>2018-11-15</th>
      <td>42668</td>
      <td>586000</td>
      <td>123500</td>
      <td>1828</td>
      <td>5770</td>
      <td>33602</td>
      <td>4931</td>
      <td>22815</td>
      <td>759</td>
      <td>720</td>
    </tr>
    <tr>
      <th>2018-11-28</th>
      <td>40473</td>
      <td>588500</td>
      <td>124375</td>
      <td>1606</td>
      <td>5724</td>
      <td>34202</td>
      <td>4795</td>
      <td>23070</td>
      <td>744</td>
      <td>677</td>
    </tr>
    <tr>
      <th>2018-12-01</th>
      <td>39454</td>
      <td>599000</td>
      <td>124100</td>
      <td>1827</td>
      <td>7230</td>
      <td>34577</td>
      <td>4314</td>
      <td>22840</td>
      <td>721</td>
      <td>649</td>
    </tr>
    <tr>
      <th>2018-12-15</th>
      <td>42736</td>
      <td>601000</td>
      <td>123188</td>
      <td>1531</td>
      <td>7809</td>
      <td>35128</td>
      <td>3553</td>
      <td>22237</td>
      <td>711</td>
      <td>696</td>
    </tr>
    <tr>
      <th>2018-12-28</th>
      <td>42905</td>
      <td>601000</td>
      <td>119917</td>
      <td>1412</td>
      <td>7535</td>
      <td>36299</td>
      <td>3268</td>
      <td>21908</td>
      <td>730</td>
      <td>650</td>
    </tr>
    <tr>
      <th>2019-01-01</th>
      <td>42426</td>
      <td>598357</td>
      <td>117500</td>
      <td>1501</td>
      <td>7729</td>
      <td>36310</td>
      <td>2927</td>
      <td>22487</td>
      <td>760</td>
      <td>722</td>
    </tr>
    <tr>
      <th>2019-01-15</th>
      <td>39411</td>
      <td>593950</td>
      <td>117550</td>
      <td>1188</td>
      <td>6801</td>
      <td>36997</td>
      <td>2823</td>
      <td>23655</td>
      <td>772</td>
      <td>583</td>
    </tr>
    <tr>
      <th>2019-01-28</th>
      <td>40487</td>
      <td>581378</td>
      <td>117600</td>
      <td>1171</td>
      <td>7741</td>
      <td>39020</td>
      <td>2783</td>
      <td>25155</td>
      <td>761</td>
      <td>575</td>
    </tr>
    <tr>
      <th>2019-02-01</th>
      <td>42760</td>
      <td>578600</td>
      <td>117600</td>
      <td>1156</td>
      <td>7895</td>
      <td>40269</td>
      <td>3235</td>
      <td>26059</td>
      <td>767</td>
      <td>610</td>
    </tr>
    <tr>
      <th>2019-02-15</th>
      <td>42351</td>
      <td>581725</td>
      <td>117600</td>
      <td>1170</td>
      <td>8620</td>
      <td>38450</td>
      <td>2775</td>
      <td>24721</td>
      <td>736</td>
      <td>645</td>
    </tr>
    <tr>
      <th>2019-02-28</th>
      <td>41386</td>
      <td>588600</td>
      <td>117600</td>
      <td>953</td>
      <td>8433</td>
      <td>38635</td>
      <td>2484</td>
      <td>24274</td>
      <td>709</td>
      <td>593</td>
    </tr>
    <tr>
      <th>2019-03-01</th>
      <td>49900</td>
      <td>588600</td>
      <td>117600</td>
      <td>914</td>
      <td>7994</td>
      <td>38477</td>
      <td>2480</td>
      <td>24027</td>
      <td>710</td>
      <td>668</td>
    </tr>
    <tr>
      <th>2019-03-15</th>
      <td>57439</td>
      <td>588600</td>
      <td>120850</td>
      <td>851</td>
      <td>7646</td>
      <td>38730</td>
      <td>2495</td>
      <td>24501</td>
      <td>716</td>
      <td>667</td>
    </tr>
    <tr>
      <th>2019-03-28</th>
      <td>64747</td>
      <td>585743</td>
      <td>123100</td>
      <td>698</td>
      <td>6670</td>
      <td>38835</td>
      <td>2483</td>
      <td>24797</td>
      <td>715</td>
      <td>762</td>
    </tr>
    <tr>
      <th>2019-04-01</th>
      <td>60224</td>
      <td>578600</td>
      <td>122662</td>
      <td>842</td>
      <td>7174</td>
      <td>38855</td>
      <td>2466</td>
      <td>24550</td>
      <td>723</td>
      <td>1006</td>
    </tr>
    <tr>
      <th>2019-04-15</th>
      <td>51644</td>
      <td>577171</td>
      <td>122243</td>
      <td>830</td>
      <td>8151</td>
      <td>38745</td>
      <td>2681</td>
      <td>24522</td>
      <td>739</td>
      <td>974</td>
    </tr>
    <tr>
      <th>2019-04-28</th>
      <td>41836</td>
      <td>573600</td>
      <td>122100</td>
      <td>895</td>
      <td>9277</td>
      <td>38809</td>
      <td>2643</td>
      <td>25049</td>
      <td>715</td>
      <td>729</td>
    </tr>
    <tr>
      <th>2019-05-01</th>
      <td>43263</td>
      <td>573600</td>
      <td>122100</td>
      <td>1187</td>
      <td>9762</td>
      <td>39511</td>
      <td>2894</td>
      <td>24884</td>
      <td>767</td>
      <td>726</td>
    </tr>
    <tr>
      <th>2019-05-15</th>
      <td>43275</td>
      <td>573600</td>
      <td>122100</td>
      <td>1414</td>
      <td>9051</td>
      <td>39963</td>
      <td>3420</td>
      <td>24801</td>
      <td>861</td>
      <td>489</td>
    </tr>
    <tr>
      <th>2019-05-28</th>
      <td>29787</td>
      <td>573044</td>
      <td>118544</td>
      <td>1719</td>
      <td>8342</td>
      <td>39913</td>
      <td>3744</td>
      <td>24563</td>
      <td>803</td>
      <td>498</td>
    </tr>
    <tr>
      <th>2019-06-01</th>
      <td>21312</td>
      <td>568600</td>
      <td>115280</td>
      <td>1756</td>
      <td>9132</td>
      <td>40033</td>
      <td>4880</td>
      <td>25007</td>
      <td>766</td>
      <td>464</td>
    </tr>
    <tr>
      <th>2019-06-15</th>
      <td>18377</td>
      <td>567975</td>
      <td>103525</td>
      <td>1440</td>
      <td>8805</td>
      <td>41507</td>
      <td>5758</td>
      <td>25248</td>
      <td>708</td>
      <td>398</td>
    </tr>
    <tr>
      <th>2019-06-28</th>
      <td>19100</td>
      <td>563600</td>
      <td>94750</td>
      <td>1371</td>
      <td>8364</td>
      <td>43013</td>
      <td>6128</td>
      <td>25287</td>
      <td>726</td>
      <td>450</td>
    </tr>
    <tr>
      <th>2019-07-01</th>
      <td>16364</td>
      <td>561350</td>
      <td>92250</td>
      <td>1562</td>
      <td>8151</td>
      <td>43830</td>
      <td>5524</td>
      <td>25319</td>
      <td>800</td>
      <td>390</td>
    </tr>
    <tr>
      <th>2019-07-15</th>
      <td>19713</td>
      <td>560600</td>
      <td>86257</td>
      <td>1564</td>
      <td>8930</td>
      <td>44998</td>
      <td>6094</td>
      <td>25760</td>
      <td>929</td>
      <td>413</td>
    </tr>
    <tr>
      <th>2019-07-28</th>
      <td>19782</td>
      <td>559350</td>
      <td>85425</td>
      <td>1583</td>
      <td>5795</td>
      <td>45877</td>
      <td>5912</td>
      <td>25340</td>
      <td>950</td>
      <td>427</td>
    </tr>
    <tr>
      <th>2019-08-01</th>
      <td>18479</td>
      <td>538743</td>
      <td>84357</td>
      <td>1909</td>
      <td>6929</td>
      <td>45823</td>
      <td>6700</td>
      <td>25279</td>
      <td>1549</td>
      <td>538</td>
    </tr>
    <tr>
      <th>2019-08-15</th>
      <td>18589</td>
      <td>516733</td>
      <td>83700</td>
      <td>1624</td>
      <td>8141</td>
      <td>45736</td>
      <td>6597</td>
      <td>25974</td>
      <td>1675</td>
      <td>502</td>
    </tr>
    <tr>
      <th>2019-08-28</th>
      <td>16750</td>
      <td>493366</td>
      <td>83650</td>
      <td>1335</td>
      <td>9616</td>
      <td>43486</td>
      <td>7692</td>
      <td>26672</td>
      <td>1339</td>
      <td>474</td>
    </tr>
    <tr>
      <th>2019-09-01</th>
      <td>17472</td>
      <td>470000</td>
      <td>83600</td>
      <td>1732</td>
      <td>12056</td>
      <td>36613</td>
      <td>11855</td>
      <td>25700</td>
      <td>1225</td>
      <td>496</td>
    </tr>
    <tr>
      <th>2019-09-15</th>
      <td>17827</td>
      <td>470000</td>
      <td>83600</td>
      <td>1701</td>
      <td>10907</td>
      <td>34958</td>
      <td>13132</td>
      <td>22939</td>
      <td>1339</td>
      <td>539</td>
    </tr>
    <tr>
      <th>2019-09-28</th>
      <td>16791</td>
      <td>460000</td>
      <td>83266</td>
      <td>1684</td>
      <td>12325</td>
      <td>34803</td>
      <td>18168</td>
      <td>20127</td>
      <td>1518</td>
      <td>494</td>
    </tr>
    <tr>
      <th>2019-10-01</th>
      <td>16972</td>
      <td>430000</td>
      <td>83100</td>
      <td>1734</td>
      <td>20288</td>
      <td>33689</td>
      <td>16388</td>
      <td>18516</td>
      <td>1469</td>
      <td>450</td>
    </tr>
    <tr>
      <th>2019-10-15</th>
      <td>18050</td>
      <td>430000</td>
      <td>83100</td>
      <td>1503</td>
      <td>18902</td>
      <td>32626</td>
      <td>13268</td>
      <td>17644</td>
      <td>1689</td>
      <td>510</td>
    </tr>
    <tr>
      <th>2019-10-28</th>
      <td>16344</td>
      <td>431111</td>
      <td>84456</td>
      <td>1577</td>
      <td>20094</td>
      <td>32074</td>
      <td>9547</td>
      <td>18986</td>
      <td>1530</td>
      <td>523</td>
    </tr>
    <tr>
      <th>2019-11-01</th>
      <td>19047</td>
      <td>432000</td>
      <td>85200</td>
      <td>1468</td>
      <td>18688</td>
      <td>31478</td>
      <td>8370</td>
      <td>19086</td>
      <td>1219</td>
      <td>530</td>
    </tr>
    <tr>
      <th>2019-11-15</th>
      <td>19557</td>
      <td>432000</td>
      <td>85400</td>
      <td>1571</td>
      <td>19211</td>
      <td>30789</td>
      <td>9176</td>
      <td>18829</td>
      <td>1047</td>
      <td>577</td>
    </tr>
    <tr>
      <th>2019-11-28</th>
      <td>20175</td>
      <td>433714</td>
      <td>85172</td>
      <td>1425</td>
      <td>18697</td>
      <td>30527</td>
      <td>9163</td>
      <td>18390</td>
      <td>965</td>
      <td>641</td>
    </tr>
    <tr>
      <th>2019-12-01</th>
      <td>20088</td>
      <td>435000</td>
      <td>85000</td>
      <td>1494</td>
      <td>22652</td>
      <td>31030</td>
      <td>8697</td>
      <td>17583</td>
      <td>974</td>
      <td>802</td>
    </tr>
    <tr>
      <th>2019-12-15</th>
      <td>18996</td>
      <td>435000</td>
      <td>85000</td>
      <td>1333</td>
      <td>25629</td>
      <td>31423</td>
      <td>8600</td>
      <td>17745</td>
      <td>947</td>
      <td>728</td>
    </tr>
    <tr>
      <th>2019-12-28</th>
      <td>23132</td>
      <td>429833</td>
      <td>84584</td>
      <td>1406</td>
      <td>24146</td>
      <td>31549</td>
      <td>8820</td>
      <td>18227</td>
      <td>970</td>
      <td>784</td>
    </tr>
    <tr>
      <th>2020-01-01</th>
      <td>25535</td>
      <td>401429</td>
      <td>84500</td>
      <td>1406</td>
      <td>25479</td>
      <td>32191</td>
      <td>9273</td>
      <td>18290</td>
      <td>1127</td>
      <td>933</td>
    </tr>
    <tr>
      <th>2020-01-15</th>
      <td>31223</td>
      <td>400000</td>
      <td>83666</td>
      <td>1085</td>
      <td>19378</td>
      <td>32249</td>
      <td>8702</td>
      <td>18508</td>
      <td>1316</td>
      <td>898</td>
    </tr>
    <tr>
      <th>2020-01-28</th>
      <td>25293</td>
      <td>398857</td>
      <td>77696</td>
      <td>926</td>
      <td>17106</td>
      <td>31685</td>
      <td>8522</td>
      <td>20625</td>
      <td>1377</td>
      <td>930</td>
    </tr>
    <tr>
      <th>2020-02-01</th>
      <td>32809</td>
      <td>396000</td>
      <td>77100</td>
      <td>1106</td>
      <td>10902</td>
      <td>30074</td>
      <td>8881</td>
      <td>20006</td>
      <td>1143</td>
      <td>929</td>
    </tr>
    <tr>
      <th>2020-02-15</th>
      <td>31611</td>
      <td>396000</td>
      <td>77300</td>
      <td>925</td>
      <td>11589</td>
      <td>31786</td>
      <td>9089</td>
      <td>20348</td>
      <td>932</td>
      <td>1015</td>
    </tr>
    <tr>
      <th>2020-02-28</th>
      <td>47157</td>
      <td>401250</td>
      <td>76875</td>
      <td>922</td>
      <td>9168</td>
      <td>32914</td>
      <td>9076</td>
      <td>20120</td>
      <td>851</td>
      <td>1490</td>
    </tr>
    <tr>
      <th>2020-03-01</th>
      <td>39014</td>
      <td>399750</td>
      <td>76910</td>
      <td>807</td>
      <td>10112</td>
      <td>32903</td>
      <td>8657</td>
      <td>19667</td>
      <td>811</td>
      <td>1132</td>
    </tr>
    <tr>
      <th>2020-03-15</th>
      <td>42722</td>
      <td>399125</td>
      <td>74812</td>
      <td>788</td>
      <td>8491</td>
      <td>33513</td>
      <td>8288</td>
      <td>19802</td>
      <td>796</td>
      <td>1090</td>
    </tr>
    <tr>
      <th>2020-03-28</th>
      <td>44674</td>
      <td>403857</td>
      <td>74500</td>
      <td>766</td>
      <td>10133</td>
      <td>32331</td>
      <td>8157</td>
      <td>19988</td>
      <td>786</td>
      <td>1124</td>
    </tr>
    <tr>
      <th>2020-04-01</th>
      <td>41647</td>
      <td>406000</td>
      <td>74500</td>
      <td>823</td>
      <td>8165</td>
      <td>32093</td>
      <td>7590</td>
      <td>20251</td>
      <td>713</td>
      <td>1082</td>
    </tr>
    <tr>
      <th>2020-04-15</th>
      <td>45117</td>
      <td>406000</td>
      <td>74800</td>
      <td>905</td>
      <td>9709</td>
      <td>32593</td>
      <td>8504</td>
      <td>20484</td>
      <td>695</td>
      <td>986</td>
    </tr>
    <tr>
      <th>2020-04-28</th>
      <td>49584</td>
      <td>406000</td>
      <td>75643</td>
      <td>1138</td>
      <td>10187</td>
      <td>32784</td>
      <td>11245</td>
      <td>20518</td>
      <td>693</td>
      <td>910</td>
    </tr>
    <tr>
      <th>2020-05-01</th>
      <td>48523</td>
      <td>406000</td>
      <td>76250</td>
      <td>1325</td>
      <td>9875</td>
      <td>33112</td>
      <td>10654</td>
      <td>20940</td>
      <td>689</td>
      <td>856</td>
    </tr>
    <tr>
      <th>2020-05-15</th>
      <td>43740</td>
      <td>406375</td>
      <td>80188</td>
      <td>1449</td>
      <td>8404</td>
      <td>32948</td>
      <td>9589</td>
      <td>21526</td>
      <td>691</td>
      <td>855</td>
    </tr>
    <tr>
      <th>2020-05-28</th>
      <td>28288</td>
      <td>409000</td>
      <td>81200</td>
      <td>1503</td>
      <td>8992</td>
      <td>32668</td>
      <td>9950</td>
      <td>21783</td>
      <td>726</td>
      <td>709</td>
    </tr>
    <tr>
      <th>2020-06-01</th>
      <td>27899</td>
      <td>428125</td>
      <td>81025</td>
      <td>1364</td>
      <td>11057</td>
      <td>32951</td>
      <td>7173</td>
      <td>22451</td>
      <td>754</td>
      <td>613</td>
    </tr>
    <tr>
      <th>2020-06-15</th>
      <td>25177</td>
      <td>446714</td>
      <td>81672</td>
      <td>1623</td>
      <td>11275</td>
      <td>33685</td>
      <td>7488</td>
      <td>22908</td>
      <td>799</td>
      <td>699</td>
    </tr>
    <tr>
      <th>2020-06-28</th>
      <td>20326</td>
      <td>453457</td>
      <td>85833</td>
      <td>1555</td>
      <td>12731</td>
      <td>33963</td>
      <td>7608</td>
      <td>23682</td>
      <td>1078</td>
      <td>774</td>
    </tr>
    <tr>
      <th>2020-07-01</th>
      <td>19618</td>
      <td>451600</td>
      <td>88140</td>
      <td>1448</td>
      <td>11514</td>
      <td>34443</td>
      <td>7897</td>
      <td>24879</td>
      <td>1209</td>
      <td>664</td>
    </tr>
    <tr>
      <th>2020-07-15</th>
      <td>20346</td>
      <td>451933</td>
      <td>106408</td>
      <td>1758</td>
      <td>11746</td>
      <td>34696</td>
      <td>11236</td>
      <td>26075</td>
      <td>1348</td>
      <td>797</td>
    </tr>
    <tr>
      <th>2020-07-28</th>
      <td>22675</td>
      <td>453933</td>
      <td>127622</td>
      <td>1718</td>
      <td>10809</td>
      <td>35224</td>
      <td>12040</td>
      <td>26973</td>
      <td>1360</td>
      <td>900</td>
    </tr>
    <tr>
      <th>2020-08-01</th>
      <td>27168</td>
      <td>472233</td>
      <td>135600</td>
      <td>2951</td>
      <td>12765</td>
      <td>35338</td>
      <td>12339</td>
      <td>27768</td>
      <td>1632</td>
      <td>978</td>
    </tr>
    <tr>
      <th>2020-08-15</th>
      <td>29195</td>
      <td>656571</td>
      <td>135614</td>
      <td>2572</td>
      <td>13421</td>
      <td>35367</td>
      <td>17104</td>
      <td>27649</td>
      <td>2203</td>
      <td>1002</td>
    </tr>
    <tr>
      <th>2020-08-28</th>
      <td>30143</td>
      <td>703571</td>
      <td>136486</td>
      <td>2312</td>
      <td>23336</td>
      <td>36155</td>
      <td>18618</td>
      <td>26514</td>
      <td>2164</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>2020-09-01</th>
      <td>29065</td>
      <td>905650</td>
      <td>136800</td>
      <td>2713</td>
      <td>23617</td>
      <td>37269</td>
      <td>19790</td>
      <td>30369</td>
      <td>1533</td>
      <td>1102</td>
    </tr>
    <tr>
      <th>2020-09-15</th>
      <td>30464</td>
      <td>890800</td>
      <td>136800</td>
      <td>2426</td>
      <td>22133</td>
      <td>29846</td>
      <td>25821</td>
      <td>29944</td>
      <td>1584</td>
      <td>1044</td>
    </tr>
    <tr>
      <th>2020-09-28</th>
      <td>32093</td>
      <td>815114</td>
      <td>136686</td>
      <td>2661</td>
      <td>24917</td>
      <td>36920</td>
      <td>24373</td>
      <td>32610</td>
      <td>1530</td>
      <td>1063</td>
    </tr>
    <tr>
      <th>2020-10-01</th>
      <td>30682</td>
      <td>806000</td>
      <td>136600</td>
      <td>2905</td>
      <td>20662</td>
      <td>37215</td>
      <td>16984</td>
      <td>30579</td>
      <td>1264</td>
      <td>1245</td>
    </tr>
    <tr>
      <th>2020-10-15</th>
      <td>27133</td>
      <td>807057</td>
      <td>136600</td>
      <td>2530</td>
      <td>14746</td>
      <td>36568</td>
      <td>8204</td>
      <td>29534</td>
      <td>965</td>
      <td>1169</td>
    </tr>
    <tr>
      <th>2020-10-28</th>
      <td>28129</td>
      <td>819750</td>
      <td>136600</td>
      <td>2777</td>
      <td>11304</td>
      <td>35732</td>
      <td>6000</td>
      <td>29715</td>
      <td>834</td>
      <td>1221</td>
    </tr>
    <tr>
      <th>2020-11-01</th>
      <td>28879</td>
      <td>830629</td>
      <td>136600</td>
      <td>2771</td>
      <td>11496</td>
      <td>36707</td>
      <td>5757</td>
      <td>29099</td>
      <td>760</td>
      <td>1283</td>
    </tr>
    <tr>
      <th>2020-11-15</th>
      <td>28705</td>
      <td>825750</td>
      <td>136600</td>
      <td>2804</td>
      <td>10245</td>
      <td>36354</td>
      <td>6674</td>
      <td>27159</td>
      <td>723</td>
      <td>1296</td>
    </tr>
    <tr>
      <th>2020-11-28</th>
      <td>28987</td>
      <td>816467</td>
      <td>136600</td>
      <td>2259</td>
      <td>8736</td>
      <td>36455</td>
      <td>5542</td>
      <td>26942</td>
      <td>690</td>
      <td>1334</td>
    </tr>
    <tr>
      <th>2020-12-01</th>
      <td>28334</td>
      <td>810371</td>
      <td>136600</td>
      <td>1783</td>
      <td>8982</td>
      <td>37346</td>
      <td>4002</td>
      <td>26543</td>
      <td>705</td>
      <td>1294</td>
    </tr>
    <tr>
      <th>2020-12-15</th>
      <td>27793</td>
      <td>797800</td>
      <td>136600</td>
      <td>1913</td>
      <td>12023</td>
      <td>38155</td>
      <td>3782</td>
      <td>27134</td>
      <td>835</td>
      <td>1290</td>
    </tr>
    <tr>
      <th>2020-12-28</th>
      <td>29702</td>
      <td>778150</td>
      <td>136600</td>
      <td>1783</td>
      <td>14112</td>
      <td>39443</td>
      <td>3373</td>
      <td>27935</td>
      <td>920</td>
      <td>1420</td>
    </tr>
    <tr>
      <th>2021-01-01</th>
      <td>40769</td>
      <td>770400</td>
      <td>136600</td>
      <td>2760</td>
      <td>15454</td>
      <td>40309</td>
      <td>3315</td>
      <td>28046</td>
      <td>1094</td>
      <td>1571</td>
    </tr>
    <tr>
      <th>2021-01-15</th>
      <td>42077</td>
      <td>770400</td>
      <td>136600</td>
      <td>3285</td>
      <td>14209</td>
      <td>41773</td>
      <td>4905</td>
      <td>29954</td>
      <td>1221</td>
      <td>1707</td>
    </tr>
    <tr>
      <th>2021-01-28</th>
      <td>38563</td>
      <td>770400</td>
      <td>136600</td>
      <td>3452</td>
      <td>11529</td>
      <td>46698</td>
      <td>5641</td>
      <td>32624</td>
      <td>1214</td>
      <td>1691</td>
    </tr>
    <tr>
      <th>2021-02-01</th>
      <td>44619</td>
      <td>770400</td>
      <td>140438</td>
      <td>4307</td>
      <td>9099</td>
      <td>48547</td>
      <td>6297</td>
      <td>35339</td>
      <td>1191</td>
      <td>1752</td>
    </tr>
    <tr>
      <th>2021-02-15</th>
      <td>37598</td>
      <td>770400</td>
      <td>143300</td>
      <td>4670</td>
      <td>8340</td>
      <td>47498</td>
      <td>8421</td>
      <td>34097</td>
      <td>1139</td>
      <td>2001</td>
    </tr>
    <tr>
      <th>2021-02-28</th>
      <td>46297</td>
      <td>770400</td>
      <td>143800</td>
      <td>5489</td>
      <td>7571</td>
      <td>46220</td>
      <td>8894</td>
      <td>33901</td>
      <td>1048</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>2021-03-01</th>
      <td>41993</td>
      <td>769686</td>
      <td>143600</td>
      <td>5176</td>
      <td>7826</td>
      <td>44800</td>
      <td>9311</td>
      <td>33066</td>
      <td>885</td>
      <td>1825</td>
    </tr>
    <tr>
      <th>2021-03-15</th>
      <td>44974</td>
      <td>764029</td>
      <td>145000</td>
      <td>4386</td>
      <td>8208</td>
      <td>46270</td>
      <td>9345</td>
      <td>32917</td>
      <td>887</td>
      <td>1973</td>
    </tr>
    <tr>
      <th>2021-03-28</th>
      <td>50239</td>
      <td>764000</td>
      <td>145938</td>
      <td>4441</td>
      <td>7182</td>
      <td>48163</td>
      <td>9393</td>
      <td>33668</td>
      <td>896</td>
      <td>1556</td>
    </tr>
    <tr>
      <th>2021-04-01</th>
      <td>52162</td>
      <td>767800</td>
      <td>146214</td>
      <td>4296</td>
      <td>7465</td>
      <td>47176</td>
      <td>9566</td>
      <td>34642</td>
      <td>869</td>
      <td>1349</td>
    </tr>
    <tr>
      <th>2021-04-15</th>
      <td>49736</td>
      <td>767800</td>
      <td>147314</td>
      <td>4370</td>
      <td>8291</td>
      <td>46831</td>
      <td>9218</td>
      <td>34038</td>
      <td>880</td>
      <td>945</td>
    </tr>
    <tr>
      <th>2021-04-28</th>
      <td>39850</td>
      <td>767800</td>
      <td>155350</td>
      <td>3715</td>
      <td>8946</td>
      <td>46783</td>
      <td>8997</td>
      <td>34235</td>
      <td>888</td>
      <td>715</td>
    </tr>
    <tr>
      <th>2021-05-01</th>
      <td>35688</td>
      <td>767800</td>
      <td>153400</td>
      <td>3749</td>
      <td>9052</td>
      <td>46856</td>
      <td>6507</td>
      <td>34263</td>
      <td>861</td>
      <td>661</td>
    </tr>
    <tr>
      <th>2021-05-15</th>
      <td>30355</td>
      <td>767800</td>
      <td>151143</td>
      <td>2249</td>
      <td>8165</td>
      <td>46516</td>
      <td>4591</td>
      <td>34386</td>
      <td>865</td>
      <td>523</td>
    </tr>
    <tr>
      <th>2021-05-28</th>
      <td>26345</td>
      <td>767800</td>
      <td>149086</td>
      <td>1446</td>
      <td>8497</td>
      <td>46978</td>
      <td>5713</td>
      <td>32823</td>
      <td>892</td>
      <td>549</td>
    </tr>
    <tr>
      <th>2021-06-01</th>
      <td>20956</td>
      <td>767800</td>
      <td>148250</td>
      <td>1183</td>
      <td>9258</td>
      <td>47711</td>
      <td>6226</td>
      <td>33013</td>
      <td>1010</td>
      <td>576</td>
    </tr>
    <tr>
      <th>2021-06-15</th>
      <td>18251</td>
      <td>771133</td>
      <td>146500</td>
      <td>1053</td>
      <td>8436</td>
      <td>48455</td>
      <td>5418</td>
      <td>34023</td>
      <td>1026</td>
      <td>695</td>
    </tr>
    <tr>
      <th>2021-06-28</th>
      <td>19178</td>
      <td>772800</td>
      <td>145396</td>
      <td>850</td>
      <td>9150</td>
      <td>49511</td>
      <td>5138</td>
      <td>33554</td>
      <td>1056</td>
      <td>688</td>
    </tr>
    <tr>
      <th>2021-07-01</th>
      <td>20931</td>
      <td>772800</td>
      <td>145618</td>
      <td>1022</td>
      <td>12564</td>
      <td>50696</td>
      <td>4672</td>
      <td>33200</td>
      <td>1092</td>
      <td>677</td>
    </tr>
    <tr>
      <th>2021-07-15</th>
      <td>20169</td>
      <td>772800</td>
      <td>162207</td>
      <td>884</td>
      <td>9013</td>
      <td>52031</td>
      <td>4782</td>
      <td>33300</td>
      <td>1214</td>
      <td>683</td>
    </tr>
    <tr>
      <th>2021-07-28</th>
      <td>23344</td>
      <td>772800</td>
      <td>162450</td>
      <td>844</td>
      <td>11067</td>
      <td>52473</td>
      <td>6819</td>
      <td>33472</td>
      <td>1573</td>
      <td>736</td>
    </tr>
    <tr>
      <th>2021-08-01</th>
      <td>28258</td>
      <td>759943</td>
      <td>162986</td>
      <td>1382</td>
      <td>13885</td>
      <td>53463</td>
      <td>10284</td>
      <td>32511</td>
      <td>1607</td>
      <td>912</td>
    </tr>
    <tr>
      <th>2021-08-15</th>
      <td>29960</td>
      <td>732243</td>
      <td>161458</td>
      <td>1165</td>
      <td>10581</td>
      <td>52707</td>
      <td>8025</td>
      <td>31031</td>
      <td>1714</td>
      <td>874</td>
    </tr>
    <tr>
      <th>2021-08-28</th>
      <td>28987</td>
      <td>602000</td>
      <td>161100</td>
      <td>1342</td>
      <td>10102</td>
      <td>50514</td>
      <td>9007</td>
      <td>30531</td>
      <td>1849</td>
      <td>874</td>
    </tr>
    <tr>
      <th>2021-09-01</th>
      <td>29590</td>
      <td>599813</td>
      <td>158750</td>
      <td>1490</td>
      <td>9531</td>
      <td>32101</td>
      <td>11554</td>
      <td>24907</td>
      <td>2204</td>
      <td>960</td>
    </tr>
    <tr>
      <th>2021-09-15</th>
      <td>31365</td>
      <td>587000</td>
      <td>158000</td>
      <td>1850</td>
      <td>10187</td>
      <td>32774</td>
      <td>13765</td>
      <td>26407</td>
      <td>2403</td>
      <td>908</td>
    </tr>
    <tr>
      <th>2021-09-28</th>
      <td>30398</td>
      <td>580750</td>
      <td>158000</td>
      <td>1274</td>
      <td>8076</td>
      <td>36734</td>
      <td>9142</td>
      <td>27970</td>
      <td>2043</td>
      <td>855</td>
    </tr>
    <tr>
      <th>2021-10-01</th>
      <td>28628</td>
      <td>578400</td>
      <td>158000</td>
      <td>1316</td>
      <td>7584</td>
      <td>35325</td>
      <td>6351</td>
      <td>25009</td>
      <td>1228</td>
      <td>893</td>
    </tr>
    <tr>
      <th>2021-10-15</th>
      <td>29442</td>
      <td>562714</td>
      <td>158086</td>
      <td>1428</td>
      <td>8730</td>
      <td>32757</td>
      <td>4706</td>
      <td>23608</td>
      <td>1365</td>
      <td>900</td>
    </tr>
    <tr>
      <th>2021-10-28</th>
      <td>28300</td>
      <td>558000</td>
      <td>158100</td>
      <td>1601</td>
      <td>10917</td>
      <td>31487</td>
      <td>6466</td>
      <td>24748</td>
      <td>2072</td>
      <td>937</td>
    </tr>
    <tr>
      <th>2021-11-01</th>
      <td>30181</td>
      <td>558000</td>
      <td>159600</td>
      <td>1583</td>
      <td>10744</td>
      <td>32666</td>
      <td>9495</td>
      <td>25889</td>
      <td>1734</td>
      <td>907</td>
    </tr>
    <tr>
      <th>2021-11-15</th>
      <td>33761</td>
      <td>558000</td>
      <td>167200</td>
      <td>1754</td>
      <td>12581</td>
      <td>30859</td>
      <td>10627</td>
      <td>26004</td>
      <td>1208</td>
      <td>909</td>
    </tr>
    <tr>
      <th>2021-11-28</th>
      <td>36024</td>
      <td>565143</td>
      <td>169100</td>
      <td>1460</td>
      <td>11107</td>
      <td>32239</td>
      <td>9273</td>
      <td>25494</td>
      <td>1062</td>
      <td>855</td>
    </tr>
    <tr>
      <th>2021-12-01</th>
      <td>35234</td>
      <td>570500</td>
      <td>169100</td>
      <td>1619</td>
      <td>11458</td>
      <td>33333</td>
      <td>8282</td>
      <td>26144</td>
      <td>946</td>
      <td>816</td>
    </tr>
    <tr>
      <th>2021-12-15</th>
      <td>32679</td>
      <td>570500</td>
      <td>169100</td>
      <td>1217</td>
      <td>10598</td>
      <td>33593</td>
      <td>7667</td>
      <td>26177</td>
      <td>931</td>
      <td>735</td>
    </tr>
    <tr>
      <th>2021-12-28</th>
      <td>42441</td>
      <td>560778</td>
      <td>168034</td>
      <td>1322</td>
      <td>10748</td>
      <td>35900</td>
      <td>7763</td>
      <td>25952</td>
      <td>988</td>
      <td>695</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-574b5929-05be-4e3c-b6ce-5cfec0a0d31d')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-574b5929-05be-4e3c-b6ce-5cfec0a0d31d button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-574b5929-05be-4e3c-b6ce-5cfec0a0d31d');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-663b825c-4adb-4697-9f4f-efe63ecd69a5">
  <button class="colab-df-quickchart" onclick="quickchart('df-663b825c-4adb-4697-9f4f-efe63ecd69a5')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-663b825c-4adb-4697-9f4f-efe63ecd69a5 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_ea37ca98-ba2b-4bbd-b637-74933b3fb1eb">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('pivot_table2')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_ea37ca98-ba2b-4bbd-b637-74933b3fb1eb button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('pivot_table2');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 품목별 평균가격 비교
plt.figure(figsize=(12, 6))
sns.boxplot(x='품목명', y='평균가격(원)', data=train_data)
plt.title('Average Price by Item')
plt.xticks(rotation=45)
plt.grid()
plt.show()

```


    
![png](/assets/img/py7_files/py7_32_0.png)
    


### 산지공판장


```python
# TRAIN_산지공판장_2018-2021.csv 파일 읽기
meta_sanji_file_path = '/content/drive/MyDrive/데이콘/농산물/train/meta/TRAIN_산지공판장_2018-2021.csv'
sanji_data = pd.read_csv(meta_sanji_file_path)
sanji_data.head(5)
```





  <div id="df-33a53711-65e2-46ca-bb45-7dffcc8b675b" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>공판장코드</th>
      <th>공판장명</th>
      <th>품목코드</th>
      <th>품목명</th>
      <th>품종코드</th>
      <th>품종명</th>
      <th>등급코드</th>
      <th>등급명</th>
      <th>총반입량(kg)</th>
      <th>...</th>
      <th>평균가(원/kg)</th>
      <th>중간가(원/kg)</th>
      <th>최저가(원/kg)</th>
      <th>최고가(원/kg)</th>
      <th>경매 건수</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
      <th>연도</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50101</td>
      <td>수미</td>
      <td>11</td>
      <td>특</td>
      <td>15470.0</td>
      <td>...</td>
      <td>1712.637363</td>
      <td>1723.961039</td>
      <td>1545.454545</td>
      <td>2320.666667</td>
      <td>7</td>
      <td>1947.350427</td>
      <td>1769.858320</td>
      <td>1023.982379</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50101</td>
      <td>수미</td>
      <td>12</td>
      <td>상</td>
      <td>2900.0</td>
      <td>...</td>
      <td>1198.655172</td>
      <td>1252.737207</td>
      <td>893.055556</td>
      <td>1417.857143</td>
      <td>4</td>
      <td>1301.239669</td>
      <td>1348.253676</td>
      <td>571.311475</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50199</td>
      <td>기타감자</td>
      <td>13</td>
      <td>보통</td>
      <td>1320.0</td>
      <td>...</td>
      <td>615.000000</td>
      <td>600.000000</td>
      <td>240.000000</td>
      <td>911.875000</td>
      <td>7</td>
      <td>630.851064</td>
      <td>449.166667</td>
      <td>473.032787</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50199</td>
      <td>기타감자</td>
      <td>12</td>
      <td>상</td>
      <td>460.0</td>
      <td>...</td>
      <td>544.130435</td>
      <td>365.000000</td>
      <td>200.000000</td>
      <td>1650.000000</td>
      <td>5</td>
      <td>1088.046875</td>
      <td>1129.600000</td>
      <td>734.024390</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50199</td>
      <td>기타감자</td>
      <td>11</td>
      <td>특</td>
      <td>30967.0</td>
      <td>...</td>
      <td>1876.454484</td>
      <td>2010.440477</td>
      <td>1598.327715</td>
      <td>2438.720588</td>
      <td>8</td>
      <td>2126.402457</td>
      <td>1779.262728</td>
      <td>1750.544700</td>
      <td>0.0</td>
      <td>2018</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 21 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-33a53711-65e2-46ca-bb45-7dffcc8b675b')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-33a53711-65e2-46ca-bb45-7dffcc8b675b button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-33a53711-65e2-46ca-bb45-7dffcc8b675b');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-853b2980-c64f-4281-84f9-5f7b98d351f1">
  <button class="colab-df-quickchart" onclick="quickchart('df-853b2980-c64f-4281-84f9-5f7b98d351f1')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-853b2980-c64f-4281-84f9-5f7b98d351f1 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
sanji_data.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 118628 entries, 0 to 118627
    Data columns (total 21 columns):
     #   Column                       Non-Null Count   Dtype  
    ---  ------                       --------------   -----  
     0   시점                           118628 non-null  object 
     1   공판장코드                        118628 non-null  int64  
     2   공판장명                         118628 non-null  object 
     3   품목코드                         118628 non-null  int64  
     4   품목명                          118628 non-null  object 
     5   품종코드                         118628 non-null  int64  
     6   품종명                          118628 non-null  object 
     7   등급코드                         118628 non-null  int64  
     8   등급명                          118628 non-null  object 
     9   총반입량(kg)                     118628 non-null  float64
     10  총거래금액(원)                     118628 non-null  int64  
     11  평균가(원/kg)                    118628 non-null  float64
     12  중간가(원/kg)                    118628 non-null  float64
     13  최저가(원/kg)                    118628 non-null  float64
     14  최고가(원/kg)                    118628 non-null  float64
     15  경매 건수                        118628 non-null  int64  
     16  전순 평균가격(원) PreVious SOON     118628 non-null  float64
     17  전달 평균가격(원) PreVious MMonth   118628 non-null  float64
     18  전년 평균가격(원) PreVious YeaR     118628 non-null  float64
     19  평년 평균가격(원) Common Year SOON  118628 non-null  float64
     20  연도                           118628 non-null  int64  
    dtypes: float64(9), int64(7), object(5)
    memory usage: 19.0+ MB
    


```python
sanji_data.isnull().sum()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>시점</th>
      <td>0</td>
    </tr>
    <tr>
      <th>공판장코드</th>
      <td>0</td>
    </tr>
    <tr>
      <th>공판장명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품목코드</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품목명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품종코드</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품종명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>등급코드</th>
      <td>0</td>
    </tr>
    <tr>
      <th>등급명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>총반입량(kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>총거래금액(원)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>평균가(원/kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>중간가(원/kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>최저가(원/kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>최고가(원/kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>경매 건수</th>
      <td>0</td>
    </tr>
    <tr>
      <th>전순 평균가격(원) PreVious SOON</th>
      <td>0</td>
    </tr>
    <tr>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <td>0</td>
    </tr>
    <tr>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <td>0</td>
    </tr>
    <tr>
      <th>평년 평균가격(원) Common Year SOON</th>
      <td>0</td>
    </tr>
    <tr>
      <th>연도</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
sanji_data.duplicated().sum()
```




    0




```python
sanji_data.columns
```




    Index(['시점', '공판장코드', '공판장명', '품목코드', '품목명', '품종코드', '품종명', '등급코드', '등급명',
           '총반입량(kg)', '총거래금액(원)', '평균가(원/kg)', '중간가(원/kg)', '최저가(원/kg)',
           '최고가(원/kg)', '경매 건수', '전순 평균가격(원) PreVious SOON',
           '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
           '평년 평균가격(원) Common Year SOON', '연도'],
          dtype='object')




```python
sanji_data['공판장명'].unique()
```




    array(['*전국농협공판장', '동두천농협공판장', '포천농협공판장', '제천농협공판장', '공주농협공판장',
           '논산계룡농협농산물공판장', '충서원협농산물공판장', '예산능금농협공판장', '군산원예농업협동조합', '전주농협공판장',
           '김제원예농업협동조합공판장', '남원원협공판장', '목포원예농업협동조합', '나주배농업협동조합', '대구공판장',
           '여수원예농협여천공판장', '여수원예농협농산물공판장', '왜관농협공판장', '경주농협 공판장',
           '영천농협농산물공판장간이지점', '대구경북능금농협영천공판장', '김천농협공판장', '상주농협공판장',
           '상주원예농협공판장', '점촌농협경제사업소', '풍기농협 백신<간>(판매)', '거창사과원예농협',
           '통영농협 농산물공판장', '동부농협 경매식집하장', '고성농협 공판장', '새통영농협 도산지점(공판)',
           '새남해농협경매식집하장', '새남해농협설천지점', '새남해농협남상지소', '새남해농협도마지점공판장(공판)',
           '새남해농협 중현지점', '창선농협(공판)', '동남해농협 남면지점(공판)', '동남해농협 삼동지점(공판)',
           '남해농협경매식집하장', '밀양농협공판장지점', '제주시농협농산물공판장', '서포농협(공판)',
           '삼천포농협농산물공판장', '의성농협농산물공판장(공판)', '동남해농협집하장(공판)', '남지농협공판장',
           '서생농협구동경매식집하장', '새남해농협서면지점경매식집하장', '동남해농협 미조지점(공판)',
           '동남해농협상주지점(공판)', '산청군농협 농산물산지유통센터(공판)', '새고성농협 하일지점(공판)',
           '동고성농협(공판)', '무안농업협동조합', '풍양농협 경매식집하장', '녹동농협농산물공판장', '대곡농협월아지점',
           '청도농협', '창녕농협공판장', '대관령원예농협공판사업소', '의성중부농협경매식집하장(공판)', '금성농협(공판)',
           '하양농협경매식집하장', '합천동부농협집하장(공판)', '이방농협', '경산농협공판장', '산서농협공판장',
           '의성중부농협 안평지점(공판)', '대동농협 공판장', '우포농협(공판)', '동안동농협(공판)',
           '용암농협농산물공판장'], dtype=object)




```python
sanji_data['품목명'].unique()
```




    array(['감자', '사과', '배', '배추', '상추', '무', '양파', '대파', '마늘', '순무'],
          dtype=object)




```python
sanji_data['품종명'].unique()
```




    array(['수미', '기타감자', '돼지감자', '자주감자', '대지', '미시마', '미얀마', '로얄부사', '착색후지',
           '후지', '기꾸8', '기타사과', '신고', '금촌추', '추황', '감천', '기타배', '월동배추',
           '기타배추', '우거지', '쌈배추', '저장배추', '기타상추', '쫑상추', '상추순', '포기찹', '청상추',
           '적포기', '적상추', '다발무', '단무지무', '무말랭이', '기타무', '가을무', '저장무', '저장양파',
           '깐양파', '기타양파', '양파(수입)', '기타대파', '깐대파', '중파', '대파(일반)', '저장형 난지',
           '마늘쫑(수입)', '마늘쫑', '깐마늘', '풋마늘', '기타마늘', '남작', '감홍', '양파(일반)',
           '깐마늘(수입)', '알프스오토메', '꽃적상추', '갈라', '수황', '순무(일반)', '육쪽마늘', '만수',
           '김장(가을)배추', '봄배추', '마늘(수입)', '조생양파', '청포기', '영산', '조풍', '생채용 배추',
           '여름배추', '흑적', '스타크림숀', '봄무', '햇마늘 난지', '저장형 한지', '햇마늘 한지', '대서',
           '여름무', '만생양파', '중생양파', '홍깨니백', '고냉지배추', '산사', '왕령', '행수', '선농',
           '미야비', '아오리', '시나노스위트', '시나노레드', '맨코이', '홍로', '하향', '원황', '장수',
           '두백', '태양', '모리스', '추향', '석정', '화산', '추광', '화홍', '풍수', '황금', '요까',
           '홍옥', '자홍', '장십랑', '조나골드', '천추', '홍월', '양광', '홍장군', '히로사끼', '예황',
           '야다까', '사이삼', '사과', '신흥', '단배', '홍감자', '신수', '한아름', '선홍', '만풍',
           '이십세기', '고냉지무', '아이카향', '서광', '세계일', '육오', '대홍', '소백3호', '햇마늘 대서',
           '햇마늘 남도', '깐마늘 남도', '깐마늘 한지', '저장형 대서', '저장형 남도', '만삼길', '절임배추',
           '깐마늘 대서'], dtype=object)




```python
sanji_data['등급명'].unique()
```




    array(['특', '상', '보통', '.', '등외', '4등', '5등', '6등', '7등', '8등'],
          dtype=object)




```python
sanji_data['연도'].unique()
```




    array([2018, 2019, 2020, 2021])



#### 무
- 베이스코드는 `기타무` 사용
- 가을무, 봄무, 여름무, 다발무 통합 고려


```python
sanji_data[sanji_data['품목명'] == '무'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-c8a40e08-132f-4a9b-9bf0-72a9db3e13ca" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>가을무</td>
      <td>364.496324</td>
      <td>274.655066</td>
      <td>242.190518</td>
      <td>31.957720</td>
    </tr>
    <tr>
      <th>1</th>
      <td>고냉지무</td>
      <td>264.650977</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>기타무</td>
      <td>521.595289</td>
      <td>480.538100</td>
      <td>493.062633</td>
      <td>61.633020</td>
    </tr>
    <tr>
      <th>3</th>
      <td>다발무</td>
      <td>471.451711</td>
      <td>406.059504</td>
      <td>410.614604</td>
      <td>57.488390</td>
    </tr>
    <tr>
      <th>4</th>
      <td>단무지무</td>
      <td>309.917956</td>
      <td>218.829911</td>
      <td>139.950914</td>
      <td>0.941931</td>
    </tr>
    <tr>
      <th>5</th>
      <td>무말랭이</td>
      <td>4900.287393</td>
      <td>4715.785434</td>
      <td>4911.765053</td>
      <td>686.727068</td>
    </tr>
    <tr>
      <th>6</th>
      <td>봄무</td>
      <td>395.756037</td>
      <td>322.147367</td>
      <td>373.670871</td>
      <td>50.657647</td>
    </tr>
    <tr>
      <th>7</th>
      <td>여름무</td>
      <td>389.546479</td>
      <td>280.379240</td>
      <td>388.051570</td>
      <td>50.507092</td>
    </tr>
    <tr>
      <th>8</th>
      <td>저장무</td>
      <td>151.465287</td>
      <td>114.053021</td>
      <td>141.616753</td>
      <td>8.661138</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-c8a40e08-132f-4a9b-9bf0-72a9db3e13ca')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-c8a40e08-132f-4a9b-9bf0-72a9db3e13ca button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-c8a40e08-132f-4a9b-9bf0-72a9db3e13ca');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-4d5e0aba-b1d0-4cc6-9b00-14a8579b3de2">
  <button class="colab-df-quickchart" onclick="quickchart('df-4d5e0aba-b1d0-4cc6-9b00-14a8579b3de2')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-4d5e0aba-b1d0-4cc6-9b00-14a8579b3de2 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### 사과
- 베이스코드는 `후지` 사용
- target에 홍로도 있고 공판장에도 홍로가있어서 포함할 필요가 있다
- 그밖에 품종들은 지식이없어서 넣어야할지 고민이 필요하다


```python
sanji_data[sanji_data['품목명'] == '사과'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-101e53fb-5395-4a35-943f-84f5bc0473f4" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>갈라</td>
      <td>569.678093</td>
      <td>263.004736</td>
      <td>869.679246</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>감홍</td>
      <td>1730.576598</td>
      <td>875.500095</td>
      <td>1445.164604</td>
      <td>167.070058</td>
    </tr>
    <tr>
      <th>2</th>
      <td>기꾸8</td>
      <td>954.873830</td>
      <td>339.413813</td>
      <td>310.775593</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>기타사과</td>
      <td>1492.372872</td>
      <td>1283.213815</td>
      <td>1268.129595</td>
      <td>173.348689</td>
    </tr>
    <tr>
      <th>4</th>
      <td>대홍</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>로얄부사</td>
      <td>1008.518617</td>
      <td>659.573187</td>
      <td>935.186667</td>
      <td>88.956486</td>
    </tr>
    <tr>
      <th>6</th>
      <td>맨코이</td>
      <td>273.232323</td>
      <td>49.735450</td>
      <td>635.919003</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>모리스</td>
      <td>260.870968</td>
      <td>0.000000</td>
      <td>169.171090</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>미시마</td>
      <td>1536.402974</td>
      <td>1292.333877</td>
      <td>1259.039874</td>
      <td>121.912301</td>
    </tr>
    <tr>
      <th>9</th>
      <td>미야비</td>
      <td>1456.013788</td>
      <td>931.744844</td>
      <td>801.860897</td>
      <td>10.217735</td>
    </tr>
    <tr>
      <th>10</th>
      <td>미얀마</td>
      <td>1573.668994</td>
      <td>1291.400864</td>
      <td>1204.713259</td>
      <td>145.481536</td>
    </tr>
    <tr>
      <th>11</th>
      <td>사과</td>
      <td>1399.631728</td>
      <td>842.684355</td>
      <td>960.700139</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>사이삼</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>산사</td>
      <td>632.686227</td>
      <td>85.295526</td>
      <td>1170.183659</td>
      <td>62.347713</td>
    </tr>
    <tr>
      <th>14</th>
      <td>서광</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>선홍</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>세계일</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>소백3호</td>
      <td>90.714286</td>
      <td>82.027778</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>스타크림숀</td>
      <td>873.958333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>시나노레드</td>
      <td>987.021283</td>
      <td>428.423642</td>
      <td>975.495420</td>
      <td>37.317702</td>
    </tr>
    <tr>
      <th>20</th>
      <td>시나노스위트</td>
      <td>1097.280536</td>
      <td>621.104189</td>
      <td>1148.696673</td>
      <td>151.421861</td>
    </tr>
    <tr>
      <th>21</th>
      <td>아오리</td>
      <td>1085.836575</td>
      <td>528.807416</td>
      <td>893.641009</td>
      <td>88.249611</td>
    </tr>
    <tr>
      <th>22</th>
      <td>아이카향</td>
      <td>548.058101</td>
      <td>126.154514</td>
      <td>379.605283</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>23</th>
      <td>알프스오토메</td>
      <td>1255.968427</td>
      <td>203.878106</td>
      <td>528.197040</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>24</th>
      <td>야다까</td>
      <td>619.378365</td>
      <td>163.313874</td>
      <td>861.398504</td>
      <td>49.213360</td>
    </tr>
    <tr>
      <th>25</th>
      <td>양광</td>
      <td>1631.535267</td>
      <td>778.842556</td>
      <td>1529.035052</td>
      <td>219.143259</td>
    </tr>
    <tr>
      <th>26</th>
      <td>왕령</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>27</th>
      <td>요까</td>
      <td>966.583885</td>
      <td>447.713981</td>
      <td>1043.005145</td>
      <td>144.976263</td>
    </tr>
    <tr>
      <th>28</th>
      <td>육오</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>29</th>
      <td>자홍</td>
      <td>1340.516699</td>
      <td>406.961399</td>
      <td>1080.497220</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>30</th>
      <td>조나골드</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>31</th>
      <td>착색후지</td>
      <td>652.728871</td>
      <td>486.832747</td>
      <td>618.762338</td>
      <td>35.674192</td>
    </tr>
    <tr>
      <th>32</th>
      <td>천추</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>33</th>
      <td>추광</td>
      <td>257.625890</td>
      <td>26.965116</td>
      <td>564.104437</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>34</th>
      <td>추향</td>
      <td>1184.833333</td>
      <td>308.333333</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>35</th>
      <td>태양</td>
      <td>293.983011</td>
      <td>23.529412</td>
      <td>59.505541</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>36</th>
      <td>하향</td>
      <td>692.172805</td>
      <td>154.598801</td>
      <td>542.652720</td>
      <td>36.171389</td>
    </tr>
    <tr>
      <th>37</th>
      <td>홍로</td>
      <td>1532.854744</td>
      <td>964.038302</td>
      <td>1529.363417</td>
      <td>216.348149</td>
    </tr>
    <tr>
      <th>38</th>
      <td>홍옥</td>
      <td>1158.549332</td>
      <td>504.692525</td>
      <td>1374.366649</td>
      <td>197.498201</td>
    </tr>
    <tr>
      <th>39</th>
      <td>홍월</td>
      <td>516.150745</td>
      <td>61.062553</td>
      <td>448.137705</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>40</th>
      <td>홍장군</td>
      <td>830.636433</td>
      <td>300.643245</td>
      <td>1053.822129</td>
      <td>109.504413</td>
    </tr>
    <tr>
      <th>41</th>
      <td>화홍</td>
      <td>439.646630</td>
      <td>19.545455</td>
      <td>568.328249</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>42</th>
      <td>후지</td>
      <td>1629.432211</td>
      <td>1476.453922</td>
      <td>1398.351233</td>
      <td>197.896520</td>
    </tr>
    <tr>
      <th>43</th>
      <td>히로사끼</td>
      <td>888.466765</td>
      <td>363.701710</td>
      <td>1013.950324</td>
      <td>128.438054</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-101e53fb-5395-4a35-943f-84f5bc0473f4')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-101e53fb-5395-4a35-943f-84f5bc0473f4 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-101e53fb-5395-4a35-943f-84f5bc0473f4');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-f5deba16-c755-46d2-ac2f-1fe9e2e5bc66">
  <button class="colab-df-quickchart" onclick="quickchart('df-f5deba16-c755-46d2-ac2f-1fe9e2e5bc66')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-f5deba16-c755-46d2-ac2f-1fe9e2e5bc66 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### 감자
- 베이스코드는 `수미` 사용



```python
sanji_data[sanji_data['품목명'] == '감자'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-72316665-2cc8-4e2b-88e1-fc81cd456b1f" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>기타감자</td>
      <td>755.145404</td>
      <td>693.869780</td>
      <td>687.860270</td>
      <td>94.925818</td>
    </tr>
    <tr>
      <th>1</th>
      <td>남작</td>
      <td>560.150205</td>
      <td>498.348088</td>
      <td>568.979836</td>
      <td>83.130762</td>
    </tr>
    <tr>
      <th>2</th>
      <td>대서</td>
      <td>31.306122</td>
      <td>34.693878</td>
      <td>170.660836</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>대지</td>
      <td>628.065914</td>
      <td>327.570561</td>
      <td>230.773129</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>돼지감자</td>
      <td>607.880485</td>
      <td>448.199625</td>
      <td>560.958474</td>
      <td>54.396822</td>
    </tr>
    <tr>
      <th>5</th>
      <td>두백</td>
      <td>554.171564</td>
      <td>508.894107</td>
      <td>377.266071</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>선농</td>
      <td>123.992553</td>
      <td>94.739011</td>
      <td>176.469780</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>수미</td>
      <td>831.473593</td>
      <td>768.579309</td>
      <td>756.332810</td>
      <td>100.398814</td>
    </tr>
    <tr>
      <th>8</th>
      <td>자주감자</td>
      <td>1016.011391</td>
      <td>752.886205</td>
      <td>845.317674</td>
      <td>50.766169</td>
    </tr>
    <tr>
      <th>9</th>
      <td>조풍</td>
      <td>472.468275</td>
      <td>387.280421</td>
      <td>457.017521</td>
      <td>42.304697</td>
    </tr>
    <tr>
      <th>10</th>
      <td>홍감자</td>
      <td>417.985111</td>
      <td>364.044977</td>
      <td>185.330309</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>홍깨니백</td>
      <td>343.218450</td>
      <td>175.853059</td>
      <td>396.176275</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-72316665-2cc8-4e2b-88e1-fc81cd456b1f')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-72316665-2cc8-4e2b-88e1-fc81cd456b1f button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-72316665-2cc8-4e2b-88e1-fc81cd456b1f');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-4015b572-5514-42e2-af48-a760e3ee0243">
  <button class="colab-df-quickchart" onclick="quickchart('df-4015b572-5514-42e2-af48-a760e3ee0243')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-4015b572-5514-42e2-af48-a760e3ee0243 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### 배
- 베이스코드는 `신고` 사용


```python
sanji_data[sanji_data['품목명'] == '배'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-927e2c4e-4cea-4463-82c4-b731fa9109b0" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>감천</td>
      <td>716.185423</td>
      <td>549.726862</td>
      <td>485.246382</td>
      <td>42.963859</td>
    </tr>
    <tr>
      <th>1</th>
      <td>금촌추</td>
      <td>804.144196</td>
      <td>677.757725</td>
      <td>414.913313</td>
      <td>27.469353</td>
    </tr>
    <tr>
      <th>2</th>
      <td>기타배</td>
      <td>1493.383107</td>
      <td>1279.096535</td>
      <td>922.977216</td>
      <td>75.824698</td>
    </tr>
    <tr>
      <th>3</th>
      <td>단배</td>
      <td>293.333333</td>
      <td>50.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>만삼길</td>
      <td>350.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>만수</td>
      <td>165.680272</td>
      <td>171.957939</td>
      <td>284.037096</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>만풍</td>
      <td>444.699776</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>석정</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>수황</td>
      <td>941.727865</td>
      <td>238.297621</td>
      <td>960.738668</td>
      <td>44.899032</td>
    </tr>
    <tr>
      <th>9</th>
      <td>신고</td>
      <td>1730.028725</td>
      <td>1619.513847</td>
      <td>1396.755925</td>
      <td>193.838871</td>
    </tr>
    <tr>
      <th>10</th>
      <td>신수</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>신흥</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>영산</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>예황</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>원황</td>
      <td>1397.269386</td>
      <td>766.178212</td>
      <td>1207.394486</td>
      <td>191.250208</td>
    </tr>
    <tr>
      <th>15</th>
      <td>이십세기</td>
      <td>721.545894</td>
      <td>0.000000</td>
      <td>521.149425</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>장수</td>
      <td>208.333333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>장십랑</td>
      <td>251.457238</td>
      <td>25.714286</td>
      <td>588.335054</td>
      <td>58.037189</td>
    </tr>
    <tr>
      <th>18</th>
      <td>추황</td>
      <td>996.263762</td>
      <td>779.599155</td>
      <td>798.796889</td>
      <td>78.297595</td>
    </tr>
    <tr>
      <th>19</th>
      <td>풍수</td>
      <td>804.547070</td>
      <td>209.809643</td>
      <td>875.784070</td>
      <td>109.519438</td>
    </tr>
    <tr>
      <th>20</th>
      <td>한아름</td>
      <td>754.090477</td>
      <td>0.000000</td>
      <td>574.356384</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>21</th>
      <td>행수</td>
      <td>940.415875</td>
      <td>287.048062</td>
      <td>867.340129</td>
      <td>64.067563</td>
    </tr>
    <tr>
      <th>22</th>
      <td>화산</td>
      <td>1156.334721</td>
      <td>576.847571</td>
      <td>1090.989661</td>
      <td>111.568495</td>
    </tr>
    <tr>
      <th>23</th>
      <td>황금</td>
      <td>1126.561505</td>
      <td>579.651897</td>
      <td>964.146319</td>
      <td>112.404139</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-927e2c4e-4cea-4463-82c4-b731fa9109b0')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-927e2c4e-4cea-4463-82c4-b731fa9109b0 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-927e2c4e-4cea-4463-82c4-b731fa9109b0');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-5fd99ec3-b864-4eba-a4bd-9a05cbf21b3a">
  <button class="colab-df-quickchart" onclick="quickchart('df-5fd99ec3-b864-4eba-a4bd-9a05cbf21b3a')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-5fd99ec3-b864-4eba-a4bd-9a05cbf21b3a button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### 마늘
- 베이스코드는 `깐마늘` 사용
- 깐마늘 남도가 수치가 비슷해보이지만, 일부가격정보가없어 통합하는데 문제가 발생할 수 있음


```python
sanji_data[sanji_data['품목명'] == '마늘'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-73155b74-65d8-4a89-bca2-025fc045cad8" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>기타마늘</td>
      <td>2273.307825</td>
      <td>2014.873050</td>
      <td>1718.696767</td>
      <td>220.564913</td>
    </tr>
    <tr>
      <th>1</th>
      <td>깐마늘</td>
      <td>6851.727882</td>
      <td>6707.628152</td>
      <td>3887.406098</td>
      <td>590.993279</td>
    </tr>
    <tr>
      <th>2</th>
      <td>깐마늘 남도</td>
      <td>6808.356073</td>
      <td>6069.679948</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>깐마늘 대서</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>깐마늘 한지</td>
      <td>3005.939858</td>
      <td>1790.655960</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>깐마늘(수입)</td>
      <td>0.000000</td>
      <td>603.080952</td>
      <td>1394.305952</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>6</th>
      <td>마늘(수입)</td>
      <td>361.940741</td>
      <td>160.288889</td>
      <td>1486.601852</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>7</th>
      <td>마늘쫑</td>
      <td>2598.021768</td>
      <td>2050.217622</td>
      <td>2297.485411</td>
      <td>354.816994</td>
    </tr>
    <tr>
      <th>8</th>
      <td>마늘쫑(수입)</td>
      <td>2873.691432</td>
      <td>2847.141632</td>
      <td>2575.108374</td>
      <td>423.663978</td>
    </tr>
    <tr>
      <th>9</th>
      <td>육쪽마늘</td>
      <td>1874.350744</td>
      <td>1495.796288</td>
      <td>1568.591502</td>
      <td>88.251788</td>
    </tr>
    <tr>
      <th>10</th>
      <td>저장형 난지</td>
      <td>2035.702372</td>
      <td>1516.583781</td>
      <td>2032.278421</td>
      <td>263.498433</td>
    </tr>
    <tr>
      <th>11</th>
      <td>저장형 남도</td>
      <td>4209.328713</td>
      <td>3327.537155</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>12</th>
      <td>저장형 대서</td>
      <td>3336.270921</td>
      <td>2852.423450</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>저장형 한지</td>
      <td>2733.700695</td>
      <td>2059.003452</td>
      <td>2404.896881</td>
      <td>261.597355</td>
    </tr>
    <tr>
      <th>14</th>
      <td>풋마늘</td>
      <td>1792.371925</td>
      <td>1592.476274</td>
      <td>1508.626327</td>
      <td>192.950485</td>
    </tr>
    <tr>
      <th>15</th>
      <td>햇마늘 난지</td>
      <td>4219.458029</td>
      <td>1465.343699</td>
      <td>1690.643817</td>
      <td>97.184833</td>
    </tr>
    <tr>
      <th>16</th>
      <td>햇마늘 남도</td>
      <td>2274.759862</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>햇마늘 대서</td>
      <td>1797.976046</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>18</th>
      <td>햇마늘 한지</td>
      <td>10212.988096</td>
      <td>9951.804685</td>
      <td>5957.053015</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-73155b74-65d8-4a89-bca2-025fc045cad8')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-73155b74-65d8-4a89-bca2-025fc045cad8 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-73155b74-65d8-4a89-bca2-025fc045cad8');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-c97ac698-002b-438c-8d25-9f1170a5cc3d">
  <button class="colab-df-quickchart" onclick="quickchart('df-c97ac698-002b-438c-8d25-9f1170a5cc3d')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-c97ac698-002b-438c-8d25-9f1170a5cc3d button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### 상추
- 베이스코드는 `청상추` 사용
- target에서 '품종명'을 '청'으로 표기했기에 별도 통합 필요 없어보임


```python
sanji_data[sanji_data['품목명'] == '상추'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-7adaae90-f343-4296-baa0-7479e1cf00fd" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>기타상추</td>
      <td>2063.511192</td>
      <td>1930.884575</td>
      <td>1562.900287</td>
      <td>191.887012</td>
    </tr>
    <tr>
      <th>1</th>
      <td>꽃적상추</td>
      <td>1391.938094</td>
      <td>457.795699</td>
      <td>191.666667</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>2</th>
      <td>상추순</td>
      <td>783.913324</td>
      <td>742.550723</td>
      <td>568.191007</td>
      <td>69.979328</td>
    </tr>
    <tr>
      <th>3</th>
      <td>적상추</td>
      <td>3058.355670</td>
      <td>3006.692039</td>
      <td>2690.612742</td>
      <td>441.116182</td>
    </tr>
    <tr>
      <th>4</th>
      <td>적포기</td>
      <td>1024.156627</td>
      <td>660.238552</td>
      <td>712.110199</td>
      <td>3.233451</td>
    </tr>
    <tr>
      <th>5</th>
      <td>쫑상추</td>
      <td>1329.080136</td>
      <td>1147.546696</td>
      <td>828.778053</td>
      <td>7.730644</td>
    </tr>
    <tr>
      <th>6</th>
      <td>청상추</td>
      <td>3377.312443</td>
      <td>3270.038761</td>
      <td>2723.517637</td>
      <td>505.513017</td>
    </tr>
    <tr>
      <th>7</th>
      <td>청포기</td>
      <td>205.841880</td>
      <td>101.880342</td>
      <td>92.163614</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>8</th>
      <td>포기찹</td>
      <td>3700.101261</td>
      <td>3625.832510</td>
      <td>3350.796448</td>
      <td>528.106543</td>
    </tr>
    <tr>
      <th>9</th>
      <td>흑적</td>
      <td>2351.410002</td>
      <td>1389.735238</td>
      <td>2535.857516</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-7adaae90-f343-4296-baa0-7479e1cf00fd')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-7adaae90-f343-4296-baa0-7479e1cf00fd button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-7adaae90-f343-4296-baa0-7479e1cf00fd');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-b0a775b2-b72a-440c-8c59-cf4a7d27c676">
  <button class="colab-df-quickchart" onclick="quickchart('df-b0a775b2-b72a-440c-8c59-cf4a7d27c676')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-b0a775b2-b72a-440c-8c59-cf4a7d27c676 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### 배추
- 베이스코드는 `쌈배추` 사용
- target에서는 명확한 배추 품종이 없기에 어떤것을 사용해야 할지 고민할 필요가 있으나, 쌈배추가 제일 흔해보임


```python
sanji_data[sanji_data['품목명'] == '배추'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-3e617f96-a75f-450c-970b-5ba6fd64c9cc" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>고냉지배추</td>
      <td>434.817259</td>
      <td>245.919432</td>
      <td>227.696707</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>기타배추</td>
      <td>902.679278</td>
      <td>822.868489</td>
      <td>854.085968</td>
      <td>89.189073</td>
    </tr>
    <tr>
      <th>2</th>
      <td>김장(가을)배추</td>
      <td>363.406296</td>
      <td>272.368420</td>
      <td>258.405736</td>
      <td>15.012064</td>
    </tr>
    <tr>
      <th>3</th>
      <td>봄배추</td>
      <td>292.659405</td>
      <td>201.895076</td>
      <td>252.706829</td>
      <td>32.732634</td>
    </tr>
    <tr>
      <th>4</th>
      <td>생채용 배추</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>5</th>
      <td>쌈배추</td>
      <td>1178.001447</td>
      <td>1111.557009</td>
      <td>1161.396834</td>
      <td>236.701700</td>
    </tr>
    <tr>
      <th>6</th>
      <td>여름배추</td>
      <td>565.441190</td>
      <td>367.385128</td>
      <td>490.983537</td>
      <td>74.483888</td>
    </tr>
    <tr>
      <th>7</th>
      <td>우거지</td>
      <td>1020.457105</td>
      <td>1016.813775</td>
      <td>985.234020</td>
      <td>99.890435</td>
    </tr>
    <tr>
      <th>8</th>
      <td>월동배추</td>
      <td>568.802533</td>
      <td>541.501727</td>
      <td>495.514618</td>
      <td>73.753218</td>
    </tr>
    <tr>
      <th>9</th>
      <td>저장배추</td>
      <td>247.154223</td>
      <td>177.595923</td>
      <td>299.056074</td>
      <td>19.751537</td>
    </tr>
    <tr>
      <th>10</th>
      <td>절임배추</td>
      <td>763.024345</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-3e617f96-a75f-450c-970b-5ba6fd64c9cc')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-3e617f96-a75f-450c-970b-5ba6fd64c9cc button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-3e617f96-a75f-450c-970b-5ba6fd64c9cc');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-475a844b-590b-4e79-a28e-7801e7d665bc">
  <button class="colab-df-quickchart" onclick="quickchart('df-475a844b-590b-4e79-a28e-7801e7d665bc')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-475a844b-590b-4e79-a28e-7801e7d665bc button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### 양파
- 베이스코드는 `기타양파` 사용
- target에서는 명확한 양파 품종이 없기에 어떤기준일지 고민이 필요. 예를들어 '양파(일반)'을 고려할 수도 있음


```python
sanji_data[sanji_data['품목명'] == '양파'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-05743c3d-9e1a-45ce-a906-1a2afb225b63" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>기타양파</td>
      <td>530.477631</td>
      <td>497.359374</td>
      <td>512.588861</td>
      <td>77.602752</td>
    </tr>
    <tr>
      <th>1</th>
      <td>깐양파</td>
      <td>807.705412</td>
      <td>770.527307</td>
      <td>656.314882</td>
      <td>87.884198</td>
    </tr>
    <tr>
      <th>2</th>
      <td>만생양파</td>
      <td>212.498495</td>
      <td>131.468701</td>
      <td>81.465571</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>3</th>
      <td>양파(수입)</td>
      <td>965.602218</td>
      <td>747.991851</td>
      <td>543.733776</td>
      <td>17.773838</td>
    </tr>
    <tr>
      <th>4</th>
      <td>양파(일반)</td>
      <td>437.944484</td>
      <td>382.429851</td>
      <td>426.556868</td>
      <td>56.629547</td>
    </tr>
    <tr>
      <th>5</th>
      <td>저장양파</td>
      <td>487.242214</td>
      <td>423.431548</td>
      <td>357.989474</td>
      <td>16.754170</td>
    </tr>
    <tr>
      <th>6</th>
      <td>조생양파</td>
      <td>793.435615</td>
      <td>585.810471</td>
      <td>610.687706</td>
      <td>49.123972</td>
    </tr>
    <tr>
      <th>7</th>
      <td>중생양파</td>
      <td>0.000000</td>
      <td>62.962963</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-05743c3d-9e1a-45ce-a906-1a2afb225b63')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-05743c3d-9e1a-45ce-a906-1a2afb225b63 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-05743c3d-9e1a-45ce-a906-1a2afb225b63');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-495fb576-860a-4a35-b2a9-330a42c31f18">
  <button class="colab-df-quickchart" onclick="quickchart('df-495fb576-860a-4a35-b2a9-330a42c31f18')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-495fb576-860a-4a35-b2a9-330a42c31f18 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### 대파
- 베이스코드는 `대파(일반)`을 사용했고, target도 동일하기에 특별한 통합은 필요없을듯


```python
sanji_data[sanji_data['품목명'] == '대파'].groupby(['품종명'])[['전순 평균가격(원) PreVious SOON',
       '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
       '평년 평균가격(원) Common Year SOON']].mean().reset_index()
```





  <div id="df-e7eaac2a-416b-4c54-a13f-a17a1807b2ce" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>품종명</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>기타대파</td>
      <td>1007.116192</td>
      <td>930.638454</td>
      <td>853.808361</td>
      <td>84.685006</td>
    </tr>
    <tr>
      <th>1</th>
      <td>깐대파</td>
      <td>1213.735580</td>
      <td>1111.199885</td>
      <td>955.285619</td>
      <td>100.574540</td>
    </tr>
    <tr>
      <th>2</th>
      <td>대파(일반)</td>
      <td>1258.464468</td>
      <td>1206.376216</td>
      <td>1004.420828</td>
      <td>161.390806</td>
    </tr>
    <tr>
      <th>3</th>
      <td>중파</td>
      <td>1120.266838</td>
      <td>1065.715810</td>
      <td>908.631415</td>
      <td>179.711495</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-e7eaac2a-416b-4c54-a13f-a17a1807b2ce')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-e7eaac2a-416b-4c54-a13f-a17a1807b2ce button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-e7eaac2a-416b-4c54-a13f-a17a1807b2ce');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-36b17a37-7006-45db-bef8-1c44ab91b421">
  <button class="colab-df-quickchart" onclick="quickchart('df-36b17a37-7006-45db-bef8-1c44ab91b421')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-36b17a37-7006-45db-bef8-1c44ab91b421 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




#### target 필터링
- 무 : '기타무', '가을무', '여름무', '봄무', '저장무', '다발무'를 포함하여 통합
- 사과 : '후지', '홍로'를 포함
- 감자 : '수미'만 포함
- 배 : '신고'만 포함
- 마늘 : '깐마늘'만 포함. '깐마늘 남도'는 일부 가격 정보가 없기 때문에 미포함
- 상추 : '청상추'만 포함
- 배추 : '쌈배추'를 포함. 배추 품종이 명확하지 않으므로 가장 일반적인 품종 사용
- 양파 : '기타양파'와 '양파(일반)'을 포함
- 대파 : '대파(일반)'만 포함


```python
# 타겟 품목 및 품종 정의
target_filters = {
    '무': ['기타무', '가을무', '여름무', '봄무', '저장무', '다발무'],
    '사과': ['후지', '홍로'],
    '감자': ['수미'],
    '배': ['신고'],
    '마늘': ['깐마늘'],
    '상추': ['청상추'],
    '배추': ['쌈배추'],
    '양파': ['기타양파', '양파(일반)'],
    '대파': ['대파(일반)']
}

# 등급 필터링 (상 등급 및 상품 등급만 포함)
grade_filter = ['상', '상품']

# 필터링 함수
def filter_sanji_data(row):
    if row['품목명'] in target_filters:
        if row['품종명'] in target_filters[row['품목명']] and row['등급명'] in grade_filter:
            return True
    return False

# 필터링 수행
filtered_sanji_data = sanji_data[sanji_data.apply(filter_sanji_data, axis=1)]

filtered_sanji_data
```





  <div id="df-fda2b8c2-5a2a-496c-af12-4d1261d7955c" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>공판장코드</th>
      <th>공판장명</th>
      <th>품목코드</th>
      <th>품목명</th>
      <th>품종코드</th>
      <th>품종명</th>
      <th>등급코드</th>
      <th>등급명</th>
      <th>총반입량(kg)</th>
      <th>...</th>
      <th>평균가(원/kg)</th>
      <th>중간가(원/kg)</th>
      <th>최저가(원/kg)</th>
      <th>최고가(원/kg)</th>
      <th>경매 건수</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
      <th>연도</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>501</td>
      <td>감자</td>
      <td>50101</td>
      <td>수미</td>
      <td>12</td>
      <td>상</td>
      <td>2900.0</td>
      <td>...</td>
      <td>1198.655172</td>
      <td>1252.737207</td>
      <td>893.055556</td>
      <td>1417.857143</td>
      <td>4</td>
      <td>1301.239669</td>
      <td>1348.253676</td>
      <td>571.311475</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>43</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>601</td>
      <td>사과</td>
      <td>60103</td>
      <td>후지</td>
      <td>12</td>
      <td>상</td>
      <td>30029.0</td>
      <td>...</td>
      <td>1298.341603</td>
      <td>1312.490667</td>
      <td>1175.258126</td>
      <td>1788.029079</td>
      <td>8</td>
      <td>1260.442271</td>
      <td>1186.346256</td>
      <td>1567.505601</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>54</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>602</td>
      <td>배</td>
      <td>60201</td>
      <td>신고</td>
      <td>12</td>
      <td>상</td>
      <td>25005.0</td>
      <td>...</td>
      <td>1133.797241</td>
      <td>1134.126195</td>
      <td>945.590062</td>
      <td>1241.435407</td>
      <td>8</td>
      <td>1119.173472</td>
      <td>1097.315866</td>
      <td>1010.577365</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>72</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>1001</td>
      <td>배추</td>
      <td>100108</td>
      <td>쌈배추</td>
      <td>12</td>
      <td>상</td>
      <td>1147.0</td>
      <td>...</td>
      <td>380.732345</td>
      <td>379.342723</td>
      <td>269.230769</td>
      <td>461.538462</td>
      <td>6</td>
      <td>421.717791</td>
      <td>296.701031</td>
      <td>732.530120</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>97</th>
      <td>201801상순</td>
      <td>1000000000</td>
      <td>*전국농협공판장</td>
      <td>1101</td>
      <td>무</td>
      <td>110199</td>
      <td>기타무</td>
      <td>12</td>
      <td>상</td>
      <td>51700.0</td>
      <td>...</td>
      <td>260.007737</td>
      <td>263.225186</td>
      <td>224.901099</td>
      <td>298.418367</td>
      <td>8</td>
      <td>322.803236</td>
      <td>361.371457</td>
      <td>856.636179</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>118540</th>
      <td>202112하순</td>
      <td>6128201171</td>
      <td>통영농협 농산물공판장</td>
      <td>1101</td>
      <td>무</td>
      <td>110199</td>
      <td>기타무</td>
      <td>12</td>
      <td>상</td>
      <td>16.0</td>
      <td>...</td>
      <td>800.000000</td>
      <td>800.000000</td>
      <td>800.000000</td>
      <td>800.000000</td>
      <td>1</td>
      <td>0.000000</td>
      <td>1422.727273</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>118544</th>
      <td>202112하순</td>
      <td>6128201171</td>
      <td>통영농협 농산물공판장</td>
      <td>1201</td>
      <td>양파</td>
      <td>120199</td>
      <td>기타양파</td>
      <td>12</td>
      <td>상</td>
      <td>680.0</td>
      <td>...</td>
      <td>650.000000</td>
      <td>650.000000</td>
      <td>650.000000</td>
      <td>650.000000</td>
      <td>3</td>
      <td>900.000000</td>
      <td>900.000000</td>
      <td>1101.162791</td>
      <td>0.000000</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>118578</th>
      <td>202112하순</td>
      <td>6168223255</td>
      <td>제주시농협농산물공판장</td>
      <td>601</td>
      <td>사과</td>
      <td>60103</td>
      <td>후지</td>
      <td>12</td>
      <td>상</td>
      <td>1850.0</td>
      <td>...</td>
      <td>1822.864865</td>
      <td>1770.892857</td>
      <td>1728.200000</td>
      <td>2060.000000</td>
      <td>57</td>
      <td>1844.975912</td>
      <td>1537.607362</td>
      <td>1686.000000</td>
      <td>1160.924118</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>118598</th>
      <td>202112하순</td>
      <td>6168223255</td>
      <td>제주시농협농산물공판장</td>
      <td>1101</td>
      <td>무</td>
      <td>110199</td>
      <td>기타무</td>
      <td>12</td>
      <td>상</td>
      <td>17460.0</td>
      <td>...</td>
      <td>236.901489</td>
      <td>236.440000</td>
      <td>67.500000</td>
      <td>475.211268</td>
      <td>23</td>
      <td>298.141844</td>
      <td>399.580243</td>
      <td>470.430878</td>
      <td>457.469488</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>118606</th>
      <td>202112하순</td>
      <td>6168223255</td>
      <td>제주시농협농산물공판장</td>
      <td>1201</td>
      <td>양파</td>
      <td>120199</td>
      <td>기타양파</td>
      <td>12</td>
      <td>상</td>
      <td>1815.0</td>
      <td>...</td>
      <td>389.256198</td>
      <td>360.000000</td>
      <td>270.000000</td>
      <td>727.941176</td>
      <td>4</td>
      <td>694.672489</td>
      <td>776.859504</td>
      <td>1317.556634</td>
      <td>669.357530</td>
      <td>2021</td>
    </tr>
  </tbody>
</table>
<p>9309 rows × 21 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-fda2b8c2-5a2a-496c-af12-4d1261d7955c')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-fda2b8c2-5a2a-496c-af12-4d1261d7955c button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-fda2b8c2-5a2a-496c-af12-4d1261d7955c');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-94e5e2f8-dfaa-459f-acd1-686ac1cb5abd">
  <button class="colab-df-quickchart" onclick="quickchart('df-94e5e2f8-dfaa-459f-acd1-686ac1cb5abd')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-94e5e2f8-dfaa-459f-acd1-686ac1cb5abd button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_807dc05e-4c55-40a4-b853-bc7ac06e8a7f">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('filtered_sanji_data')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_807dc05e-4c55-40a4-b853-bc7ac06e8a7f button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('filtered_sanji_data');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 1. 가격 관련 파생변수 생성
# 각 품목의 평균 가격을 기반으로 전순, 전달, 전년, 평년 가격 대비 현재 가격 변화율을 계산
filtered_sanji_data['가격 변화율(전순)'] = (filtered_sanji_data['평균가(원/kg)'] - filtered_sanji_data['전순 평균가격(원) PreVious SOON']) / filtered_sanji_data['전순 평균가격(원) PreVious SOON']
filtered_sanji_data['가격 변화율(전달)'] = (filtered_sanji_data['평균가(원/kg)'] - filtered_sanji_data['전달 평균가격(원) PreVious MMonth']) / filtered_sanji_data['전달 평균가격(원) PreVious MMonth']
filtered_sanji_data['가격 변화율(전년)'] = (filtered_sanji_data['평균가(원/kg)'] - filtered_sanji_data['전년 평균가격(원) PreVious YeaR']) / filtered_sanji_data['전년 평균가격(원) PreVious YeaR']
filtered_sanji_data['가격 변화율(평년)'] = (filtered_sanji_data['평균가(원/kg)'] - filtered_sanji_data['평년 평균가격(원) Common Year SOON']) / filtered_sanji_data['평년 평균가격(원) Common Year SOON']

# 2. 총반입량 및 경매 건수의 평균 계산
avg_volume = filtered_sanji_data.groupby('품목명')['총반입량(kg)'].mean().reset_index()
avg_auction_count = filtered_sanji_data.groupby('품목명')['경매 건수'].mean().reset_index()

# 3. 평균값을 원본 데이터에 병합
filtered_sanji_data = filtered_sanji_data.merge(avg_volume, on='품목명', suffixes=('', '_평균반입량'))
filtered_sanji_data = filtered_sanji_data.merge(avg_auction_count, on='품목명', suffixes=('', '_평균경매건수'))

# 4. 가격 변화율과 평균 반입량, 평균 경매 건수의 상관관계 분석
correlation_columns = ['가격 변화율(전순)', '가격 변화율(전달)', '가격 변화율(전년)', '가격 변화율(평년)', '총반입량(kg)', '경매 건수']
correlation_matrix = filtered_sanji_data[correlation_columns].corr()

# 결과 출력
print("필터링된 데이터의 상관관계 매트릭스:")
print(correlation_matrix)

# 필터링된 데이터의 일부를 출력
print("\n필터링된 데이터 샘플:")
print(filtered_sanji_data.head())
```

    필터링된 데이터의 상관관계 매트릭스:
                가격 변화율(전순)  가격 변화율(전달)  가격 변화율(전년)  가격 변화율(평년)  총반입량(kg)     경매 건수
    가격 변화율(전순)    1.000000    0.211875    0.218065    0.187848 -0.015081 -0.011421
    가격 변화율(전달)    0.211875    1.000000    0.217217    0.216816 -0.012900 -0.002991
    가격 변화율(전년)    0.218065    0.217217    1.000000    0.775282 -0.040436  0.008105
    가격 변화율(평년)    0.187848    0.216816    0.775282    1.000000 -0.003032  0.090661
    총반입량(kg)     -0.015081   -0.012900   -0.040436   -0.003032  1.000000  0.277587
    경매 건수        -0.011421   -0.002991    0.008105    0.090661  0.277587  1.000000
    
    필터링된 데이터 샘플:
             시점       공판장코드      공판장명  품목코드 품목명    품종코드  품종명  등급코드 등급명  총반입량(kg)  \
    0  201801상순  1000000000  *전국농협공판장   501  감자   50101   수미    12   상    2900.0   
    1  201801상순  1000000000  *전국농협공판장   601  사과   60103   후지    12   상   30029.0   
    2  201801상순  1000000000  *전국농협공판장   602   배   60201   신고    12   상   25005.0   
    3  201801상순  1000000000  *전국농협공판장  1001  배추  100108  쌈배추    12   상    1147.0   
    4  201801상순  1000000000  *전국농협공판장  1101   무  110199  기타무    12   상   51700.0   
    
       ...  전달 평균가격(원) PreVious MMonth  전년 평균가격(원) PreVious YeaR  \
    0  ...                 1348.253676                571.311475   
    1  ...                 1186.346256               1567.505601   
    2  ...                 1097.315866               1010.577365   
    3  ...                  296.701031                732.530120   
    4  ...                  361.371457                856.636179   
    
       평년 평균가격(원) Common Year SOON    연도  가격 변화율(전순)  가격 변화율(전달)  가격 변화율(전년)  \
    0                          0.0  2018   -0.078836   -0.110957    1.098076   
    1                          0.0  2018    0.030068    0.094404   -0.171715   
    2                          0.0  2018    0.013067    0.033246    0.121930   
    3                          0.0  2018   -0.097187    0.283219   -0.480250   
    4                          0.0  2018   -0.194532   -0.280497   -0.696478   
    
       가격 변화율(평년)  총반입량(kg)_평균반입량  경매 건수_평균경매건수  
    0         inf     1749.715395      7.182406  
    1         inf     4194.463299     29.750864  
    2         inf     5621.256362     23.698212  
    3         inf     1466.388309      5.528184  
    4         inf     6573.046959      7.874519  
    
    [5 rows x 27 columns]
    

### 전국도매


```python
# TRAIN_전국도매_2018-2021.csv 파일 읽기
meta_jeonguk_file_path = '/content/drive/MyDrive/데이콘/농산물/train/meta/TRAIN_전국도매_2018-2021.csv'
jeonguk_data = pd.read_csv(meta_jeonguk_file_path)
jeonguk_data
```





  <div id="df-bdeee1ee-8820-4cc9-aa93-34c4006d44e2" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>시장코드</th>
      <th>시장명</th>
      <th>품목코드</th>
      <th>품목명</th>
      <th>품종코드</th>
      <th>품종명</th>
      <th>총반입량(kg)</th>
      <th>총거래금액(원)</th>
      <th>평균가(원/kg)</th>
      <th>...</th>
      <th>저가(20%) 평균가</th>
      <th>중간가(원/kg)</th>
      <th>최저가(원/kg)</th>
      <th>최고가(원/kg)</th>
      <th>경매 건수</th>
      <th>전순 평균가격(원) PreVious SOON</th>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <th>평년 평균가격(원) Common Year SOON</th>
      <th>연도</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50124</td>
      <td>깐감자</td>
      <td>20.0</td>
      <td>86520</td>
      <td>4326.000000</td>
      <td>...</td>
      <td>4326.000000</td>
      <td>4326.000000</td>
      <td>4326.0</td>
      <td>4326.000000</td>
      <td>1</td>
      <td>0.000000</td>
      <td>4009.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>1</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50121</td>
      <td>돼지감자</td>
      <td>12380.0</td>
      <td>11650810</td>
      <td>941.099354</td>
      <td>...</td>
      <td>545.105717</td>
      <td>1010.000000</td>
      <td>200.0</td>
      <td>3000.000000</td>
      <td>117</td>
      <td>11213.358450</td>
      <td>9174.196723</td>
      <td>8167.895632</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>2</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50110</td>
      <td>자주감자</td>
      <td>240.0</td>
      <td>158400</td>
      <td>660.000000</td>
      <td>...</td>
      <td>500.000000</td>
      <td>550.000000</td>
      <td>500.0</td>
      <td>1000.000000</td>
      <td>7</td>
      <td>12553.279352</td>
      <td>12612.216445</td>
      <td>24990.324897</td>
      <td>18483.961304</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>3</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50111</td>
      <td>가을감자</td>
      <td>10.0</td>
      <td>37500</td>
      <td>3750.000000</td>
      <td>...</td>
      <td>3700.000000</td>
      <td>3750.000000</td>
      <td>3700.0</td>
      <td>3800.000000</td>
      <td>2</td>
      <td>24929.463415</td>
      <td>40365.081269</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>4</th>
      <td>201801상순</td>
      <td>100000</td>
      <td>*전국도매시장</td>
      <td>501</td>
      <td>감자</td>
      <td>50199</td>
      <td>기타감자</td>
      <td>1367301.3</td>
      <td>2403199462</td>
      <td>1757.622451</td>
      <td>...</td>
      <td>955.289668</td>
      <td>1360.453431</td>
      <td>0.0</td>
      <td>10581.081081</td>
      <td>872</td>
      <td>30806.779529</td>
      <td>27661.150770</td>
      <td>23741.953223</td>
      <td>19340.121989</td>
      <td>2018</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>176009</th>
      <td>202112하순</td>
      <td>380401</td>
      <td>진주</td>
      <td>1202</td>
      <td>대파</td>
      <td>120201</td>
      <td>대파(일반)</td>
      <td>21897.5</td>
      <td>33837005</td>
      <td>1545.245119</td>
      <td>...</td>
      <td>760.360360</td>
      <td>1450.000000</td>
      <td>500.0</td>
      <td>3879.125000</td>
      <td>39</td>
      <td>1348.646801</td>
      <td>1261.828668</td>
      <td>2400.044348</td>
      <td>2026.635189</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>176010</th>
      <td>202112하순</td>
      <td>380401</td>
      <td>진주</td>
      <td>1209</td>
      <td>마늘</td>
      <td>120942</td>
      <td>깐마늘 대서</td>
      <td>3250.0</td>
      <td>15000000</td>
      <td>4615.384615</td>
      <td>...</td>
      <td>4000.000000</td>
      <td>4500.000000</td>
      <td>4000.0</td>
      <td>5000.000000</td>
      <td>2</td>
      <td>0.000000</td>
      <td>4615.384615</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>176011</th>
      <td>202112하순</td>
      <td>380401</td>
      <td>진주</td>
      <td>1209</td>
      <td>마늘</td>
      <td>120943</td>
      <td>깐마늘 남도</td>
      <td>9250.0</td>
      <td>45000000</td>
      <td>4864.864865</td>
      <td>...</td>
      <td>4827.586207</td>
      <td>5000.000000</td>
      <td>4000.0</td>
      <td>5000.000000</td>
      <td>3</td>
      <td>0.000000</td>
      <td>4864.864865</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>176012</th>
      <td>202112하순</td>
      <td>380401</td>
      <td>진주</td>
      <td>1209</td>
      <td>마늘</td>
      <td>120999</td>
      <td>기타마늘</td>
      <td>130.0</td>
      <td>464000</td>
      <td>3569.230769</td>
      <td>...</td>
      <td>2400.000000</td>
      <td>3900.000000</td>
      <td>2400.0</td>
      <td>4000.000000</td>
      <td>4</td>
      <td>0.000000</td>
      <td>5823.076923</td>
      <td>2604.166667</td>
      <td>0.000000</td>
      <td>2021</td>
    </tr>
    <tr>
      <th>176013</th>
      <td>202112하순</td>
      <td>380401</td>
      <td>진주</td>
      <td>1209</td>
      <td>마늘</td>
      <td>120917</td>
      <td>마늘쫑(수입)</td>
      <td>16.0</td>
      <td>76400</td>
      <td>4775.000000</td>
      <td>...</td>
      <td>4775.000000</td>
      <td>4775.000000</td>
      <td>4775.0</td>
      <td>4775.000000</td>
      <td>2</td>
      <td>4637.500000</td>
      <td>4637.500000</td>
      <td>2900.000000</td>
      <td>0.000000</td>
      <td>2021</td>
    </tr>
  </tbody>
</table>
<p>176014 rows × 22 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-bdeee1ee-8820-4cc9-aa93-34c4006d44e2')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-bdeee1ee-8820-4cc9-aa93-34c4006d44e2 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-bdeee1ee-8820-4cc9-aa93-34c4006d44e2');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-372ccb82-5312-4874-be9b-e5485192f44e">
  <button class="colab-df-quickchart" onclick="quickchart('df-372ccb82-5312-4874-be9b-e5485192f44e')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-372ccb82-5312-4874-be9b-e5485192f44e button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_2052a22f-9adb-40e1-a213-099a4b3451f8">
    <style>
      .colab-df-generate {
        background-color: #E8F0FE;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: none;
        fill: #1967D2;
        height: 32px;
        padding: 0 0 0 0;
        width: 32px;
      }

      .colab-df-generate:hover {
        background-color: #E2EBFA;
        box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
        fill: #174EA6;
      }

      [theme=dark] .colab-df-generate {
        background-color: #3B4455;
        fill: #D2E3FC;
      }

      [theme=dark] .colab-df-generate:hover {
        background-color: #434B5C;
        box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
        filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
        fill: #FFFFFF;
      }
    </style>
    <button class="colab-df-generate" onclick="generateWithVariable('jeonguk_data')"
            title="Generate code using this dataframe."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
       width="24px">
    <path d="M7,19H8.4L18.45,9,17,7.55,7,17.6ZM5,21V16.75L18.45,3.32a2,2,0,0,1,2.83,0l1.4,1.43a1.91,1.91,0,0,1,.58,1.4,1.91,1.91,0,0,1-.58,1.4L9.25,21ZM18.45,9,17,7.55Zm-12,3A5.31,5.31,0,0,0,4.9,8.1,5.31,5.31,0,0,0,1,6.5,5.31,5.31,0,0,0,4.9,4.9,5.31,5.31,0,0,0,6.5,1,5.31,5.31,0,0,0,8.1,4.9,5.31,5.31,0,0,0,12,6.5,5.46,5.46,0,0,0,6.5,12Z"/>
  </svg>
    </button>
    <script>
      (() => {
      const buttonEl =
        document.querySelector('#id_2052a22f-9adb-40e1-a213-099a4b3451f8 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('jeonguk_data');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
jeonguk_data.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 176014 entries, 0 to 176013
    Data columns (total 22 columns):
     #   Column                       Non-Null Count   Dtype  
    ---  ------                       --------------   -----  
     0   시점                           176014 non-null  object 
     1   시장코드                         176014 non-null  int64  
     2   시장명                          176014 non-null  object 
     3   품목코드                         176014 non-null  int64  
     4   품목명                          176014 non-null  object 
     5   품종코드                         176014 non-null  int64  
     6   품종명                          176014 non-null  object 
     7   총반입량(kg)                     176014 non-null  float64
     8   총거래금액(원)                     176014 non-null  int64  
     9   평균가(원/kg)                    176014 non-null  float64
     10  고가(20%) 평균가                  176014 non-null  float64
     11  중가(60%) 평균가                  176014 non-null  float64
     12  저가(20%) 평균가                  176014 non-null  float64
     13  중간가(원/kg)                    176014 non-null  float64
     14  최저가(원/kg)                    176014 non-null  float64
     15  최고가(원/kg)                    176014 non-null  float64
     16  경매 건수                        176014 non-null  int64  
     17  전순 평균가격(원) PreVious SOON     176014 non-null  float64
     18  전달 평균가격(원) PreVious MMonth   176014 non-null  float64
     19  전년 평균가격(원) PreVious YeaR     176014 non-null  float64
     20  평년 평균가격(원) Common Year SOON  176014 non-null  float64
     21  연도                           176014 non-null  int64  
    dtypes: float64(12), int64(6), object(4)
    memory usage: 29.5+ MB
    


```python
jeonguk_data.isnull().sum()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>시점</th>
      <td>0</td>
    </tr>
    <tr>
      <th>시장코드</th>
      <td>0</td>
    </tr>
    <tr>
      <th>시장명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품목코드</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품목명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품종코드</th>
      <td>0</td>
    </tr>
    <tr>
      <th>품종명</th>
      <td>0</td>
    </tr>
    <tr>
      <th>총반입량(kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>총거래금액(원)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>평균가(원/kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>고가(20%) 평균가</th>
      <td>0</td>
    </tr>
    <tr>
      <th>중가(60%) 평균가</th>
      <td>0</td>
    </tr>
    <tr>
      <th>저가(20%) 평균가</th>
      <td>0</td>
    </tr>
    <tr>
      <th>중간가(원/kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>최저가(원/kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>최고가(원/kg)</th>
      <td>0</td>
    </tr>
    <tr>
      <th>경매 건수</th>
      <td>0</td>
    </tr>
    <tr>
      <th>전순 평균가격(원) PreVious SOON</th>
      <td>0</td>
    </tr>
    <tr>
      <th>전달 평균가격(원) PreVious MMonth</th>
      <td>0</td>
    </tr>
    <tr>
      <th>전년 평균가격(원) PreVious YeaR</th>
      <td>0</td>
    </tr>
    <tr>
      <th>평년 평균가격(원) Common Year SOON</th>
      <td>0</td>
    </tr>
    <tr>
      <th>연도</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
jeonguk_data.duplicated().sum()
```




    0




```python
jeonguk_data.columns
```




    Index(['시점', '시장코드', '시장명', '품목코드', '품목명', '품종코드', '품종명', '총반입량(kg)',
           '총거래금액(원)', '평균가(원/kg)', '고가(20%) 평균가', '중가(60%) 평균가 ', '저가(20%) 평균가',
           '중간가(원/kg)', '최저가(원/kg)', '최고가(원/kg)', '경매 건수',
           '전순 평균가격(원) PreVious SOON', '전달 평균가격(원) PreVious MMonth',
           '전년 평균가격(원) PreVious YeaR', '평년 평균가격(원) Common Year SOON', '연도'],
          dtype='object')




```python
jeonguk_data['시장명'].unique()
```




    array(['*전국도매시장', '서울가락', '서울강서', '부산엄궁', '부산반여', '대구북부', '인천남촌', '인천삼산',
           '광주각화', '광주서부', '대전오정', '대전노은', '수원', '안양', '안산', '구리', '춘천', '원주',
           '강릉', '청주', '충주', '천안', '전주', '익산', '정읍', '순천', '포항', '안동', '구미',
           '창원팔용', '울산', '창원내서', '진주'], dtype=object)




```python
jeonguk_data['품목명'].unique()
```




    array(['감자', '사과', '배', '배추', '상추', '순무', '무', '양파', '대파', '마늘'],
          dtype=object)




```python
jeonguk_data['품종명'].unique()
```




    array(['깐감자', '돼지감자', '자주감자', '가을감자', '기타감자', '봄감자', '조풍', '대지', '수미',
           '조림감자', '감자(수입)', '감자', '추백감자', '로얄부사', '미야비', '챔피온', '로얄후지',
           '스타칼라', '착색후지', '사과', '기꾸8', '알프스오토메', '산사', '후지', '미시마', '미얀마',
           '기타사과', '홍옥', '감홍', '금촌추', '추황', '감천', '배', '신고', '기타배', '우거지',
           '봄배추', '생채용 배추', '배추', '김장(가을)배추', '절임배추', '저장배추', '고냉지배추', '월동배추',
           '여름배추', '배추뿌리', '쌈배추', '기타배추', '상추순', '상추솎음', '청포기', '흑적', '쫑상추',
           '청상추', '꽃적상추', '적포기', '기타상추', '포기찹', '적상추', '상추', '순무(일반)', '여름무',
           '무솎음', '가을무', '고냉지무', '무말랭이(수입)', '단무지무', '건무(수입)', '월동무', '저장무',
           '소궁기무', '무', '기타무', '다발무', '세척무', '무말랭이', '달랑무', '봄무', '조생양파',
           '깐양파', '기타양파', '자주양파', '양파(일반)', '양파(수입)', '양파', '저장양파', '만생양파',
           '중파', '대파(일반)', '깐대파', '대파(수입)', '대파', '기타대파', '햇마늘 한지', '햇마늘 난지',
           '깐마늘', '저장형 한지', '깐마늘(수입)', '마늘(수입)', '냉동마늘(수입)', '육쪽마늘', '마늘',
           '마늘쫑(수입)', '저장형 난지', '풋마늘', '주대마늘', '기타마늘', '마늘쫑', '아이카향', '황금',
           '홍감자', '시나노스위트', '축', '스타크림숀', '히로사끼', '자색무', '홍로', '양광', '국광',
           '만수', '배추(수입)', '화홍', '우거지(수입)', '홍깨니백', '샬롯', '쪽마늘', '남작', '신흥',
           '단배', '만삼길', '중만생양파', '중생양파', '두백', '아오리', '답리작', '선농', '조나골드',
           '수황', '토말린', '서광', '대서', '선홍', '야다까', '고냉지', '맨코이', '홍월', '송본금',
           '시나노레드', '레드골드', '행수', '줄기상추(수입)', 'OBIR', '홍무', '장수', '태양', '추향',
           '추광', '하향', '하쯔쓰가루', '화산', '군총', '석정', '신천', '원황', '월향', '모리스',
           '채향', '자홍', '선황', '한아름', '신수', '풍수', '장십랑', '갈라', '홍장군', '요까',
           '대홍', '자주양파(수입)', '세계일', '천추', '만풍', '이십세기', '홍추', '북두', '골덴',
           '나리따', '호노까', '뉴히로사끼', '앙림', '육오', '금왕자', '만월', '사이삼', '사과(수입)',
           '얌빈(히카마)', '인도', '어리브레이스', '데리셔스', '노변', '호박감자', '명월', '애감수',
           '수경상추', '영산', '무(수입)', '치마상추', '메구미', '아리수', '시원', '시나노골드', '추홍',
           '배양채', '깐마늘 대서', '깐마늘 한지', '햇마늘 남도', '깐마늘 남도', '햇마늘 대서', '남서',
           '저장형 대서', '저장형 남도', '루비에스', '신화', '창조'], dtype=object)




```python
# 1. 가격 관련 파생변수 생성
# 각 품목의 평균 가격을 기반으로 전순, 전달, 전년, 평년 가격 대비 현재 가격 변화율을 계산
jeonguk_data2 = jeonguk_data.copy()
jeonguk_data2['가격 변화율(전순)'] = (jeonguk_data2['평균가(원/kg)'] - jeonguk_data2['전순 평균가격(원) PreVious SOON']) / jeonguk_data2['전순 평균가격(원) PreVious SOON']
jeonguk_data2['가격 변화율(전달)'] = (jeonguk_data2['평균가(원/kg)'] - jeonguk_data2['전달 평균가격(원) PreVious MMonth']) / jeonguk_data2['전달 평균가격(원) PreVious MMonth']
jeonguk_data2['가격 변화율(전년)'] = (jeonguk_data2['평균가(원/kg)'] - jeonguk_data2['전년 평균가격(원) PreVious YeaR']) / jeonguk_data2['전년 평균가격(원) PreVious YeaR']
jeonguk_data2['가격 변화율(평년)'] = (jeonguk_data2['평균가(원/kg)'] - jeonguk_data2['평년 평균가격(원) Common Year SOON']) / jeonguk_data2['평년 평균가격(원) Common Year SOON']

# 2. 총반입량 및 경매 건수의 평균 계산
avg_volume_jk = jeonguk_data2.groupby('품목명')['총반입량(kg)'].mean().reset_index()
avg_auction_count_jk = jeonguk_data2.groupby('품목명')['경매 건수'].mean().reset_index()

# 3. 평균값을 원본 데이터에 병합
jeonguk_data2 = jeonguk_data2.merge(avg_volume_jk, on='품목명', suffixes=('', '_평균반입량'))
jeonguk_data2 = jeonguk_data2.merge(avg_auction_count_jk, on='품목명', suffixes=('', '_평균경매건수'))

# 4. 가격 변화율과 평균 반입량, 평균 경매 건수의 상관관계 분석
correlation_columns_jk = ['가격 변화율(전순)', '가격 변화율(전달)', '가격 변화율(전년)', '가격 변화율(평년)', '총반입량(kg)', '경매 건수']
correlation_matrix_jk = jeonguk_data2[correlation_columns_jk].corr()

# 결과 출력
print("필터링된 데이터의 상관관계 매트릭스:")
print(correlation_matrix_jk)

# 필터링된 데이터의 일부를 출력
print("\n필터링된 데이터 샘플:")
print(jeonguk_data2.head())
```

    필터링된 데이터의 상관관계 매트릭스:
                가격 변화율(전순)  가격 변화율(전달)  가격 변화율(전년)  가격 변화율(평년)  총반입량(kg)     경매 건수
    가격 변화율(전순)    1.000000    0.846193    0.187391    0.187619 -0.007526 -0.006760
    가격 변화율(전달)    0.846193    1.000000    0.332185    0.259791 -0.008042 -0.005671
    가격 변화율(전년)    0.187391    0.332185    1.000000    0.391600 -0.016595 -0.012232
    가격 변화율(평년)    0.187619    0.259791    0.391600    1.000000 -0.085754 -0.039916
    총반입량(kg)     -0.007526   -0.008042   -0.016595   -0.085754  1.000000  0.661800
    경매 건수        -0.006760   -0.005671   -0.012232   -0.039916  0.661800  1.000000
    
    필터링된 데이터 샘플:
             시점    시장코드      시장명  품목코드 품목명   품종코드   품종명   총반입량(kg)    총거래금액(원)  \
    0  201801상순  100000  *전국도매시장   501  감자  50124   깐감자       20.0       86520   
    1  201801상순  100000  *전국도매시장   501  감자  50121  돼지감자    12380.0    11650810   
    2  201801상순  100000  *전국도매시장   501  감자  50110  자주감자      240.0      158400   
    3  201801상순  100000  *전국도매시장   501  감자  50111  가을감자       10.0       37500   
    4  201801상순  100000  *전국도매시장   501  감자  50199  기타감자  1367301.3  2403199462   
    
         평균가(원/kg)  ...  전달 평균가격(원) PreVious MMonth  전년 평균가격(원) PreVious YeaR  \
    0  4326.000000  ...                 4009.000000                  0.000000   
    1   941.099354  ...                 9174.196723               8167.895632   
    2   660.000000  ...                12612.216445              24990.324897   
    3  3750.000000  ...                40365.081269                  0.000000   
    4  1757.622451  ...                27661.150770              23741.953223   
    
       평년 평균가격(원) Common Year SOON    연도  가격 변화율(전순)  가격 변화율(전달)  가격 변화율(전년)  \
    0                     0.000000  2018         inf    0.079072         inf   
    1                     0.000000  2018   -0.916073   -0.897419   -0.884781   
    2                 18483.961304  2018   -0.947424   -0.947670   -0.973590   
    3                     0.000000  2018   -0.849576   -0.907098         inf   
    4                 19340.121989  2018   -0.942947   -0.936459   -0.925970   
    
       가격 변화율(평년)  총반입량(kg)_평균반입량  경매 건수_평균경매건수  
    0         inf    98459.192339      74.30387  
    1         inf    98459.192339      74.30387  
    2   -0.964293    98459.192339      74.30387  
    3         inf    98459.192339      74.30387  
    4   -0.909120    98459.192339      74.30387  
    
    [5 rows x 28 columns]
    


```python
# 전국도매 데이터에서 inf 값을 NaN으로 변환하고 평균으로 대체
jeonguk_data2.replace([float('inf'), -float('inf')], pd.NA, inplace=True)

# 가격 변화율의 NaN 값을 평균으로 대체
jeonguk_data2['가격 변화율(전순)'].fillna(jeonguk_data2['가격 변화율(전순)'].mean(), inplace=True)
jeonguk_data2['가격 변화율(전달)'].fillna(jeonguk_data2['가격 변화율(전달)'].mean(), inplace=True)
jeonguk_data2['가격 변화율(전년)'].fillna(jeonguk_data2['가격 변화율(전년)'].mean(), inplace=True)
jeonguk_data2['가격 변화율(평년)'].fillna(jeonguk_data2['가격 변화율(평년)'].mean(), inplace=True)

# 품목별 평균가, 총반입량, 경매 건수 등을 그룹화하여 새로운 데이터프레임 생성
grouped_data = jeonguk_data2.groupby('품목명').agg({
    '평균가(원/kg)': 'mean',
    '총반입량(kg)': 'mean',
    '경매 건수': 'mean'
}).reset_index()

# 결과 출력
print("품목별 평균가, 총반입량, 경매 건수:")
print(grouped_data)
```

    품목별 평균가, 총반입량, 경매 건수:
      품목명    평균가(원/kg)       총반입량(kg)       경매 건수
    0  감자  1314.934345   98459.192339   74.303870
    1  대파  1564.553918  168442.175014  105.601864
    2  마늘  3512.587850   15736.019170   35.946525
    3   무  1637.456777  198041.259141   37.253932
    4   배  2208.448162   71929.095068   57.707191
    5  배추  1133.312756  159356.791475   56.965319
    6  사과  2680.289318   80497.468027  107.137944
    7  상추  3140.843293   17690.675079   69.982016
    8  순무  1279.888071    6825.427354   11.674888
    9  양파   813.963477  280327.858769   60.127061
    

## test 폴더 살펴보기


```python
test_data_03 = pd.read_csv('/content/drive/MyDrive/데이콘/농산물/test/TEST_03.csv')
print(f"test_data_03 정보\n{test_data_03.head}")
print(f"{test_data_03.columns}")

test_data_21 = pd.read_csv('/content/drive/MyDrive/데이콘/농산물/test/TEST_21.csv')
print(f"test_data_21 정보\n{test_data_21.head}")

sanji_test_data_03 = pd.read_csv('/content/drive/MyDrive/데이콘/농산물/test/meta/TEST_산지공판장_03.csv')
print(f"sanji_test_data_03 정보\n{sanji_test_data_03.head}")
print(f"{sanji_test_data_03.columns}")

sanji_test_data_21 = pd.read_csv('/content/drive/MyDrive/데이콘/농산물/test/meta/TEST_산지공판장_21.csv')
print(f"sanji_test_data_21 정보\n{sanji_test_data_21.head}")

jeonguk_test_data_03 = pd.read_csv('/content/drive/MyDrive/데이콘/농산물/test/meta/TEST_전국도매_03.csv')
print(f"jeonguk_test_data_03 정보\n{jeonguk_test_data_03.head}")
print(f"{jeonguk_test_data_03.columns}")

jeonguk_test_data_21 = pd.read_csv('/content/drive/MyDrive/데이콘/농산물/test/meta/TEST_전국도매_21.csv')
print(f"jeonguk_test_data_21 정보\n{jeonguk_test_data_21.head}")
```

    test_data_03 정보
    <bound method NDFrame.head of         시점  품목명     품종명    거래단위  등급     평년 평균가격(원)   평균가격(원)
    0     T-8순  건고추      화건   30 kg  상품  517227.666667  543000.0
    1     T-7순  건고추      화건   30 kg  상품  520908.333333  543000.0
    2     T-6순  건고추      화건   30 kg  상품  521533.333333  543000.0
    3     T-5순  건고추      화건   30 kg  상품  519866.666667  543000.0
    4     T-4순  건고추      화건   30 kg  상품  519390.333333  543000.0
    ...    ...  ...     ...     ...  ..            ...       ...
    1831  T-4순   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    1832  T-3순   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    1833  T-2순   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    1834  T-1순   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    1835     T   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    
    [1836 rows x 7 columns]>
    Index(['시점', '품목명', '품종명', '거래단위', '등급', '평년 평균가격(원)', '평균가격(원)'], dtype='object')
    test_data_21 정보
    <bound method NDFrame.head of         시점  품목명     품종명    거래단위  등급     평년 평균가격(원)   평균가격(원)
    0     T-8순  건고추      화건   30 kg  상품  519866.666667  543000.0
    1     T-7순  건고추      화건   30 kg  상품  519390.333333  543000.0
    2     T-6순  건고추      화건   30 kg  상품  518200.000000  543000.0
    3     T-5순  건고추      화건   30 kg  상품  518200.000000  543000.0
    4     T-4순  건고추      화건   30 kg  상품  518325.000000  543000.0
    ...    ...  ...     ...     ...  ..            ...       ...
    1831  T-4순   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    1832  T-3순   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    1833  T-2순   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    1834  T-1순   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    1835     T   대파  대파(일반)  10키로묶음   상       0.000000       0.0
    
    [1836 rows x 7 columns]>
    sanji_test_data_03 정보
    <bound method NDFrame.head of         시점       공판장코드         공판장명  품목코드 품목명    품종코드   품종명  등급코드 등급명  \
    0     T-8순  1000000000     *전국농협공판장   501  감자   50113    두백    11   특   
    1     T-8순  1000000000     *전국농협공판장   501  감자   50113    두백    12   상   
    2     T-8순  1000000000     *전국농협공판장   501  감자   50103    대지    10   .   
    3     T-8순  1000000000     *전국농협공판장   501  감자   50101    수미    19  등외   
    4     T-8순  1000000000     *전국농협공판장   501  감자   50101    수미    11   특   
    ...    ...         ...          ...   ...  ..     ...   ...   ...  ..   
    5892     T  6198200402     서포농협(공판)  1209  마늘  120906   깐마늘    11   특   
    5893     T  6198200402     서포농협(공판)  1209  마늘  120999  기타마늘    11   특   
    5894     T  6198201338  삼천포농협농산물공판장   501  감자   50199  기타감자    10   .   
    5895     T  6198201338  삼천포농협농산물공판장   601  사과   60199  기타사과    10   .   
    5896     T  6198201338  삼천포농협농산물공판장  1209  마늘  120999  기타마늘    10   .   
    
          총반입량(kg)  ...     평균가(원/kg)     중간가(원/kg)    최저가(원/kg)     최고가(원/kg)  \
    0         40.0  ...   1350.000000   1350.000000  1350.000000   1350.000000   
    1         60.0  ...    225.000000    225.000000   225.000000    225.000000   
    2         30.0  ...   1733.333333   1733.333333  1733.333333   1733.333333   
    3       3880.0  ...    877.912371    914.150943   321.538462   1221.428571   
    4       9116.0  ...   1279.611672   1233.642127   680.357143   2100.000000   
    ...        ...  ...           ...           ...          ...           ...   
    5892    1920.0  ...   7032.973958   7120.601852  6737.766990   7264.468085   
    5893      60.0  ...  33200.000000  32331.578947  5785.714286  62200.000000   
    5894    5920.0  ...   1394.932432   1635.106383  1114.032258   2166.666667   
    5895    1000.0  ...   3869.000000   3869.000000  3869.000000   3869.000000   
    5896    5670.0  ...   5829.805996   5695.833333  5331.000000   6501.515152   
    
          경매 건수  전순 평균가격(원) PreVious SOON  전달 평균가격(원) PreVious MMonth  \
    0         1                950.000000                  836.666667   
    1         1                750.000000                  160.000000   
    2         1                  0.000000                    0.000000   
    3         7               1256.493506                    0.000000   
    4         8               1474.647748                 1437.418699   
    ...     ...                       ...                         ...   
    5892    273               7050.167715                    0.000000   
    5893      7              24800.000000                    0.000000   
    5894     98               2205.263158                    0.000000   
    5895     11               3605.405405                 3255.192878   
    5896    112               3055.555556                    0.000000   
    
          전년 평균가격(원) PreVious YeaR  평년 평균가격(원) Common Year SOON    연도  
    0                  1093.606965                     0.000000  2022  
    1                   464.000000                     0.000000  2022  
    2                     0.000000                     0.000000  2022  
    3                  1072.564103                   683.867448  2022  
    4                   963.208552                  1145.540723  2022  
    ...                        ...                          ...   ...  
    5892               6369.957537                     0.000000  2022  
    5893                  0.000000                     0.000000  2022  
    5894                  0.000000                     0.000000  2022  
    5895                  0.000000                     0.000000  2022  
    5896               4131.192661                  2676.200380  2022  
    
    [5897 rows x 21 columns]>
    Index(['시점', '공판장코드', '공판장명', '품목코드', '품목명', '품종코드', '품종명', '등급코드', '등급명',
           '총반입량(kg)', '총거래금액(원)', '평균가(원/kg)', '중간가(원/kg)', '최저가(원/kg)',
           '최고가(원/kg)', '경매 건수', '전순 평균가격(원) PreVious SOON',
           '전달 평균가격(원) PreVious MMonth', '전년 평균가격(원) PreVious YeaR',
           '평년 평균가격(원) Common Year SOON', '연도'],
          dtype='object')
    sanji_test_data_21 정보
    <bound method NDFrame.head of         시점       공판장코드         공판장명  품목코드 품목명    품종코드     품종명  등급코드 등급명  \
    0     T-8순  1000000000     *전국농협공판장   501  감자   50101      수미    10   .   
    1     T-8순  1000000000     *전국농협공판장   501  감자   50199    기타감자    19  등외   
    2     T-8순  1000000000     *전국농협공판장   501  감자   50101      수미    12   상   
    3     T-8순  1000000000     *전국농협공판장   501  감자   50101      수미    13  보통   
    4     T-8순  1000000000     *전국농협공판장   501  감자   50101      수미    19  등외   
    ...    ...         ...          ...   ...  ..     ...     ...   ...  ..   
    6675     T  6198200402     서포농협(공판)  1209  마늘  120906     깐마늘    11   특   
    6676     T  6198200402     서포농협(공판)  1209  마늘  120999    기타마늘    10   .   
    6677     T  6198200402     서포농협(공판)  1209  마늘  120904  햇마늘 난지    10   .   
    6678     T  6198201338  삼천포농협농산물공판장  1201  양파  120199    기타양파    10   .   
    6679     T  6198201338  삼천포농협농산물공판장  1209  마늘  120999    기타마늘    10   .   
    
          총반입량(kg)  ...     평균가(원/kg)     중간가(원/kg)     최저가(원/kg)     최고가(원/kg)  \
    0       1507.0  ...   2075.049768   2852.500000   1571.218206   4400.000000   
    1       1680.0  ...   1075.595238    975.044563    600.000000   1253.030303   
    2       1390.0  ...   1596.330935   1443.750000   1200.000000   1805.312500   
    3       1960.0  ...    981.989796    787.500000    600.000000   1415.333333   
    4        788.0  ...    487.436548    472.955975    452.727273   1150.000000   
    ...        ...  ...           ...           ...           ...           ...   
    6675    1452.0  ...   7893.829201   7882.046784   7696.666667   8079.753086   
    6676      31.0  ...  38064.516129  38064.516129  38064.516129  38064.516129   
    6677     183.0  ...  37423.497268  37423.497268  37423.497268  37423.497268   
    6678      70.0  ...    507.142857    507.142857    507.142857    507.142857   
    6679    1198.0  ...   6577.629382   6553.093434   5371.428571   7272.727273   
    
          경매 건수  전순 평균가격(원) PreVious SOON  전달 평균가격(원) PreVious MMonth  \
    0         6               2465.991736                 2133.908046   
    1         4               1038.411215                  517.857143   
    2         6               1322.627119                  935.789474   
    3         5                869.911504                  608.051020   
    4         3                650.151515                  877.912371   
    ...     ...                       ...                         ...   
    6675    218               7952.884764                 7032.973958   
    6676      6                  0.000000                    0.000000   
    6677     55                  0.000000                    0.000000   
    6678      5                634.059406                    0.000000   
    6679     36               6377.109383                 5829.805996   
    
          전년 평균가격(원) PreVious YeaR  평년 평균가격(원) Common Year SOON    연도  
    0                  1182.756757                  1118.240494  2022  
    1                   498.039216                   634.854010  2022  
    2                   604.450549                  1267.559974  2022  
    3                   692.000000                   710.886685  2022  
    4                  1308.295455                   991.291628  2022  
    ...                        ...                          ...   ...  
    6675               6741.148225                     0.000000  2022  
    6676                  0.000000                     0.000000  2022  
    6677                  0.000000                     0.000000  2022  
    6678                521.144578                   550.074197  2022  
    6679               5643.658226                  2931.493233  2022  
    
    [6680 rows x 21 columns]>
    jeonguk_test_data_03 정보
    <bound method NDFrame.head of         시점    시장코드      시장명  품목코드 품목명    품종코드      품종명   총반입량(kg)    총거래금액(원)  \
    0     T-8순  100000  *전국도매시장   501  감자   50110     자주감자     1082.0     1300200   
    1     T-8순  100000  *전국도매시장   501  감자   50114      봄감자     5140.0     7385500   
    2     T-8순  100000  *전국도매시장   501  감자   50108     홍깨니백     2150.0     2557900   
    3     T-8순  100000  *전국도매시장   501  감자   50199     기타감자  2538262.0  4216592354   
    4     T-8순  100000  *전국도매시장   501  감자   50115     조림감자     1600.0     1214000   
    ...    ...     ...      ...   ...  ..     ...      ...        ...         ...   
    9767     T  380401       진주  1209  마늘  120943   깐마늘 남도     9250.0    45000000   
    9768     T  380401       진주  1209  마늘  120942   깐마늘 대서     3250.0    15000000   
    9769     T  380401       진주  1209  마늘  120933   저장형 남도     3159.0    13590700   
    9770     T  380401       진주  1209  마늘  120999     기타마늘     4797.0    18204400   
    9771     T  380401       진주  1209  마늘  120917  마늘쫑(수입)       10.0       37000   
    
            평균가(원/kg)  ...  저가(20%) 평균가    중간가(원/kg)    최저가(원/kg)    최고가(원/kg)  \
    0     1201.663586  ...   642.241379  1136.153846   200.000000  2068.571429   
    1     1436.867704  ...   353.197674  1250.000000   281.521739  2500.000000   
    2     1189.720930  ...   640.392157  1038.750000   350.000000  2108.571429   
    3     1661.212418  ...   897.361664  1247.500000     0.000000  4054.000000   
    4      758.750000  ...   700.000000   750.000000   700.000000  1250.000000   
    ...           ...  ...          ...          ...          ...          ...   
    9767  4864.864865  ...  4000.000000  4500.000000  4000.000000  6000.000000   
    9768  4615.384615  ...  4000.000000  4500.000000  4000.000000  5000.000000   
    9769  4302.215891  ...  2634.883721  4200.000000  1400.000000  6800.000000   
    9770  3794.955180  ...  2362.162162  3870.000000  1600.000000  6400.000000   
    9771  3700.000000  ...  3700.000000  3700.000000  3700.000000  3700.000000   
    
          경매 건수  전순 평균가격(원) PreVious SOON  전달 평균가격(원) PreVious MMonth  \
    0        10                382.456140                  631.562500   
    1         9                528.084746                  853.191489   
    2        20               1538.717949                    0.000000   
    3      1460               1540.221201                 1495.137734   
    4         5                580.000000                  662.765957   
    ...     ...                       ...                         ...   
    9767      4                  0.000000                 5454.545455   
    9768      2                  0.000000                 4615.384615   
    9769     31               3759.696970                    0.000000   
    9770     62               3400.413223                    0.000000   
    9771      1                  0.000000                    0.000000   
    
          전년 평균가격(원) PreVious YeaR  평년 평균가격(원) Common Year SOON    연도  
    0                  1230.432822                  1087.911742  2022  
    1                   555.522201                  1330.461704  2022  
    2                   461.409396                     0.000000  2022  
    3                  1287.517343                  1626.391847  2022  
    4                   889.393939                   831.786507  2022  
    ...                        ...                          ...   ...  
    9767               3600.000000                     0.000000  2022  
    9768               4000.000000                     0.000000  2022  
    9769                  0.000000                     0.000000  2022  
    9770               2702.827204                  2059.224261  2022  
    9771                  0.000000                     0.000000  2022  
    
    [9772 rows x 22 columns]>
    Index(['시점', '시장코드', '시장명', '품목코드', '품목명', '품종코드', '품종명', '총반입량(kg)',
           '총거래금액(원)', '평균가(원/kg)', '고가(20%) 평균가', '중가(60%) 평균가 ', '저가(20%) 평균가',
           '중간가(원/kg)', '최저가(원/kg)', '최고가(원/kg)', '경매 건수',
           '전순 평균가격(원) PreVious SOON', '전달 평균가격(원) PreVious MMonth',
           '전년 평균가격(원) PreVious YeaR', '평년 평균가격(원) Common Year SOON', '연도'],
          dtype='object')
    jeonguk_test_data_21 정보
    <bound method NDFrame.head of          시점    시장코드      시장명  품목코드 품목명    품종코드     품종명   총반입량(kg)    총거래금액(원)  \
    0      T-8순  100000  *전국도매시장   501  감자   50101      수미  2013576.0  4832049263   
    1      T-8순  100000  *전국도매시장   501  감자   50113      두백   114460.0   200423000   
    2      T-8순  100000  *전국도매시장   501  감자   50199    기타감자  1836666.2  4412017418   
    3      T-8순  100000  *전국도매시장   501  감자   50114     봄감자     4720.0    10216000   
    4      T-8순  100000  *전국도매시장   501  감자   50198  감자(수입)   160600.0   324776500   
    ...     ...     ...      ...   ...  ..     ...     ...        ...         ...   
    10143     T  380401       진주  1202  대파  120201  대파(일반)    19862.0    40310070   
    10144     T  380401       진주  1209  마늘  120999    기타마늘     1005.0     6158000   
    10145     T  380401       진주  1209  마늘  120943  깐마늘 남도    10000.0    60000000   
    10146     T  380401       진주  1209  마늘  120942  깐마늘 대서       14.0      100800   
    10147     T  380401       진주  1209  마늘  120933  저장형 남도     1230.0     6879100   
    
             평균가(원/kg)  ...  저가(20%) 평균가    중간가(원/kg)    최저가(원/kg)     최고가(원/kg)  \
    0      2399.735229  ...  1219.237550  1845.321759     0.000000   9157.883333   
    1      1751.030928  ...  1002.860412  1800.000000     0.000000   2197.500000   
    2      2402.187952  ...  1169.937872  1800.000000    50.000000  49568.500000   
    3      2164.406780  ...   816.666667  1270.833333   650.000000   3132.377049   
    4      2022.269614  ...  1535.135135  2050.000000  1400.000000   4600.000000   
    ...            ...  ...          ...          ...          ...           ...   
    10143  2029.507099  ...  1517.099407  1860.000000   900.000000   5107.194030   
    10144  6127.363184  ...  3801.290323  6535.384615  2609.090909   8330.000000   
    10145  6000.000000  ...  3000.000000  7000.000000  3000.000000   8000.000000   
    10146  7200.000000  ...  7200.000000  7200.000000  7200.000000   7200.000000   
    10147  5592.764228  ...  4292.682927  4942.000000  3000.000000   7310.000000   
    
           경매 건수  전순 평균가격(원) PreVious SOON  전달 평균가격(원) PreVious MMonth  \
    0        996               2142.420178                 1829.705423   
    1         21               1959.042658                 1364.686684   
    2       1198               2156.371290                 1661.212418   
    3         10               1540.769231                 1436.867704   
    4         23               2438.811437                    0.000000   
    ...      ...                       ...                         ...   
    10143     73               2056.051767                 1906.710336   
    10144     21               5993.568014                 3794.955180   
    10145      5                  0.000000                 4864.864865   
    10146      1               8000.000000                 4615.384615   
    10147      9               5366.728452                 4302.215891   
    
           전년 평균가격(원) PreVious YeaR  평년 평균가격(원) Common Year SOON    연도  
    0                   1533.137835                  2464.433857  2022  
    1                    916.920908                     0.000000  2022  
    2                   1384.496506                  2400.650755  2022  
    3                    901.351351                  1658.790023  2022  
    4                   1173.234487                     0.000000  2022  
    ...                         ...                          ...   ...  
    10143               1053.252418                  1280.391736  2022  
    10144               4808.939974                  3064.712433  2022  
    10145               4000.000000                     0.000000  2022  
    10146               4675.324675                     0.000000  2022  
    10147                  0.000000                     0.000000  2022  
    
    [10148 rows x 22 columns]>
    


```python
test_data_03.columns
```




    Index(['시점', '품목명', '품종명', '거래단위', '등급', '평년 평균가격(원)', '평균가격(원)'], dtype='object')




```python
# 품종별 평균 가격 및 평년 평균 가격을 계산하는 함수
def analyze_price_data(test_data):
    # 가격이 0이거나 NaN인 경우를 처리
    test_data['평균가격(원)'].replace(0, pd.NA, inplace=True)
    test_data['평년 평균가격(원)'].replace(0, pd.NA, inplace=True)

    # 품종별 평균 가격 계산
    price_analysis = test_data.groupby(['품목명', '품종명']).agg({
        '평균가격(원)': 'mean',
        '평년 평균가격(원)': 'mean',
        '거래단위': 'first'  # 거래 단위는 첫 번째 값만 가져오기
    }).reset_index()

    return price_analysis

# TEST_03 및 TEST_21 데이터 분석
price_analysis_03 = analyze_price_data(test_data_03)
price_analysis_21 = analyze_price_data(test_data_21)

# 결과 출력
print("TEST_03 품종별 평균 가격 분석:")
print(price_analysis_03)

print("\nTEST_21 품종별 평균 가격 분석:")
print(price_analysis_21)

# 상관관계 분석
correlation_columns_03 = ['평균가격(원)', '평년 평균가격(원)']
correlation_matrix_03 = test_data_03[correlation_columns_03].dropna().corr()

print("\nTEST_03 상관관계 매트릭스:")
print(correlation_matrix_03)

correlation_columns_21 = ['평균가격(원)', '평년 평균가격(원)']
correlation_matrix_21 = test_data_21[correlation_columns_21].dropna().corr()

print("\nTEST_21 상관관계 매트릭스:")
print(correlation_matrix_21)
```

    TEST_03 품종별 평균 가격 분석:
            품목명        품종명        평균가격(원)     평년 평균가격(원)    거래단위
    0        감자         감자   49064.133256            NaN  20키로상자
    1        감자      감자 대지   35099.755208   27012.798495  20키로상자
    2        감자      감자 두백     31858.2889            NaN  20키로상자
    3        감자      감자 수미    48856.58125   35737.656327  20키로상자
    4        감자  감자 수미(저장)   38555.416964            NaN  20키로상자
    5        감자   감자 수미(햇)   53216.907407            NaN  20키로상자
    6        감자      감자 수입            NaN            NaN  23키로상자
    7        감자      감자 조풍            NaN            NaN  20키로상자
    8        감자        홍감자            NaN            NaN  10키로상자
    9       건고추         양건  672472.222222  599482.814815   30 kg
    10      건고추       햇산양건            NaN            NaN   30 kg
    11      건고추       햇산화건            NaN            NaN   30 kg
    12      건고추         화건       517200.0  493425.648148   30 kg
    13  깐마늘(국산)    깐마늘(국산)  166221.055556            NaN   20 kg
    14       대파        깐쪽파   47518.036651   35753.594162  10키로상자
    15       대파      대파 수입            NaN            NaN  10키로상자
    16       대파     대파(일반)    1264.396373    1262.489017    1키로단
    17       대파         실파   64748.157986   48562.487384    20키로
    18       대파         쪽파   31030.773997   25528.259568  10키로상자
    19        무        다발무            NaN            NaN    10키로
    20        무          무   10316.475849            NaN  20키로상자
    21        무         열무    5584.752984    2857.937469   4키로상자
    22        배         신고   33532.833333    28417.37037    10 개
    23        배         원황            NaN            NaN    10 개
    24       배추         배추    8236.463272    5625.402366  10키로망대
    25       배추       봄동배추   21177.394907   12519.885053  15키로상자
    26       배추        쌈배추   10738.027701   11398.398817   1키로상자
    27       배추      알배기배추   20067.963889   12404.717464   8키로상자
    28       배추      얼갈이배추    6436.674537    3709.495405   8키로상자
    29       배추       절임배추            NaN            NaN  20키로상자
    30       사과        쓰가루            NaN            NaN    10 개
    31       사과         홍로            NaN            NaN    10 개
    32       사과         후지   23565.833333   18718.185185    10 개
    33       상추          적     745.388889     590.907407   100 g
    34       상추          청     766.055556     584.166667   100 g
    35       양파         양파    4874.905312    5361.914198     1키로
    36       양파      양파 수입            NaN            NaN     1키로
    37       양파      양파(햇)    6650.506443            NaN    12키로
    38       양파       자주양파    8718.353993    6777.088387    12키로
    39       양파       저장양파    4508.145507            NaN    15키로
    40       양파       조생양파    7679.793403            NaN    15키로
    
    TEST_21 품종별 평균 가격 분석:
            품목명        품종명        평균가격(원)     평년 평균가격(원)    거래단위
    0        감자         감자   44331.225694            NaN  20키로상자
    1        감자      감자 대지   38373.668056     27787.4625  20키로상자
    2        감자      감자 두백   32642.956267            NaN  20키로상자
    3        감자      감자 수미   44325.228395   29548.463066  20키로상자
    4        감자  감자 수미(저장)   44014.070312            NaN  20키로상자
    5        감자   감자 수미(햇)   45509.736883            NaN  20키로상자
    6        감자      감자 수입            NaN            NaN  23키로상자
    7        감자      감자 조풍            NaN            NaN  20키로상자
    8        감자        홍감자   14004.583333            NaN  10키로상자
    9       건고추         양건  667147.222222  602024.444444   30 kg
    10      건고추       햇산양건            NaN            NaN   30 kg
    11      건고추       햇산화건            NaN            NaN   30 kg
    12      건고추         화건  517354.166667  499332.907407   30 kg
    13  깐마늘(국산)    깐마늘(국산)  169673.333333            NaN   20 kg
    14       대파        깐쪽파   73097.880401   46369.821708  10키로상자
    15       대파      대파 수입            NaN            NaN  10키로상자
    16       대파     대파(일반)    1270.549769    1160.177932    1키로단
    17       대파         실파   86681.314484   52706.694345    20키로
    18       대파         쪽파   42195.557099   30048.150849  10키로상자
    19        무        다발무            NaN            NaN    10키로
    20        무          무   11616.911265            NaN  20키로상자
    21        무         열무    4831.901749    2766.245103   4키로상자
    22        배         신고   34195.222222   29456.648148    10 개
    23        배         원황            NaN            NaN    10 개
    24       배추         배추    7937.393133    4817.891667  10키로망대
    25       배추       봄동배추   16756.666667            NaN  15키로상자
    26       배추        쌈배추    10635.81848    9755.349434   1키로상자
    27       배추      알배기배추    18192.36304   11122.053318   8키로상자
    28       배추      얼갈이배추    6421.346965    3586.494582   8키로상자
    29       배추       절임배추            NaN            NaN  20키로상자
    30       사과        쓰가루            NaN            NaN    10 개
    31       사과         홍로            NaN            NaN    10 개
    32       사과         후지   23991.222222   19191.166667    10 개
    33       상추          적     771.333333     602.277778   100 g
    34       상추          청          799.5     591.259259   100 g
    35       양파         양파    8046.537068    3226.272569     1키로
    36       양파      양파 수입        1459.75            NaN     1키로
    37       양파      양파(햇)   11311.975694            NaN    12키로
    38       양파       자주양파    9970.795139    6334.284966    12키로
    39       양파       저장양파    6026.108507            NaN    15키로
    40       양파       조생양파    8566.818452            NaN    15키로
    
    TEST_03 상관관계 매트릭스:
                 평균가격(원)  평년 평균가격(원)
    평균가격(원)     1.000000    0.998418
    평년 평균가격(원)  0.998418    1.000000
    
    TEST_21 상관관계 매트릭스:
                 평균가격(원)  평년 평균가격(원)
    평균가격(원)     1.000000    0.995682
    평년 평균가격(원)  0.995682    1.000000
    


```python
sm_df = pd.read_csv('/content/drive/MyDrive/데이콘/농산물/sample_submission.csv')
sm_df.head()
```





  <div id="df-c17fdb11-3c8e-4e6f-bdb1-74c4d21dbd20" class="colab-df-container">
    <div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>시점</th>
      <th>감자</th>
      <th>건고추</th>
      <th>깐마늘(국산)</th>
      <th>대파</th>
      <th>무</th>
      <th>배추</th>
      <th>사과</th>
      <th>상추</th>
      <th>양파</th>
      <th>배</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>TEST_00+1순</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>TEST_00+2순</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>TEST_00+3순</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>TEST_01+1순</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>TEST_01+2순</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-c17fdb11-3c8e-4e6f-bdb1-74c4d21dbd20')"
            title="Convert this dataframe to an interactive table."
            style="display:none;">

  <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960">
    <path d="M120-120v-720h720v720H120Zm60-500h600v-160H180v160Zm220 220h160v-160H400v160Zm0 220h160v-160H400v160ZM180-400h160v-160H180v160Zm440 0h160v-160H620v160ZM180-180h160v-160H180v160Zm440 0h160v-160H620v160Z"/>
  </svg>
    </button>

  <style>
    .colab-df-container {
      display:flex;
      gap: 12px;
    }

    .colab-df-convert {
      background-color: #E8F0FE;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: none;
      fill: #1967D2;
      height: 32px;
      padding: 0 0 0 0;
      width: 32px;
    }

    .colab-df-convert:hover {
      background-color: #E2EBFA;
      box-shadow: 0px 1px 2px rgba(60, 64, 67, 0.3), 0px 1px 3px 1px rgba(60, 64, 67, 0.15);
      fill: #174EA6;
    }

    .colab-df-buttons div {
      margin-bottom: 4px;
    }

    [theme=dark] .colab-df-convert {
      background-color: #3B4455;
      fill: #D2E3FC;
    }

    [theme=dark] .colab-df-convert:hover {
      background-color: #434B5C;
      box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
      filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
      fill: #FFFFFF;
    }
  </style>

    <script>
      const buttonEl =
        document.querySelector('#df-c17fdb11-3c8e-4e6f-bdb1-74c4d21dbd20 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-c17fdb11-3c8e-4e6f-bdb1-74c4d21dbd20');
        const dataTable =
          await google.colab.kernel.invokeFunction('convertToInteractive',
                                                    [key], {});
        if (!dataTable) return;

        const docLinkHtml = 'Like what you see? Visit the ' +
          '<a target="_blank" href=https://colab.research.google.com/notebooks/data_table.ipynb>data table notebook</a>'
          + ' to learn more about interactive tables.';
        element.innerHTML = '';
        dataTable['output_type'] = 'display_data';
        await google.colab.output.renderOutput(dataTable, element);
        const docLink = document.createElement('div');
        docLink.innerHTML = docLinkHtml;
        element.appendChild(docLink);
      }
    </script>
  </div>


<div id="df-3f848c18-9e7b-4bf6-a168-1eb08435f80e">
  <button class="colab-df-quickchart" onclick="quickchart('df-3f848c18-9e7b-4bf6-a168-1eb08435f80e')"
            title="Suggest charts"
            style="display:none;">

<svg xmlns="http://www.w3.org/2000/svg" height="24px"viewBox="0 0 24 24"
     width="24px">
    <g>
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
    </g>
</svg>
  </button>

<style>
  .colab-df-quickchart {
      --bg-color: #E8F0FE;
      --fill-color: #1967D2;
      --hover-bg-color: #E2EBFA;
      --hover-fill-color: #174EA6;
      --disabled-fill-color: #AAA;
      --disabled-bg-color: #DDD;
  }

  [theme=dark] .colab-df-quickchart {
      --bg-color: #3B4455;
      --fill-color: #D2E3FC;
      --hover-bg-color: #434B5C;
      --hover-fill-color: #FFFFFF;
      --disabled-bg-color: #3B4455;
      --disabled-fill-color: #666;
  }

  .colab-df-quickchart {
    background-color: var(--bg-color);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: none;
    fill: var(--fill-color);
    height: 32px;
    padding: 0;
    width: 32px;
  }

  .colab-df-quickchart:hover {
    background-color: var(--hover-bg-color);
    box-shadow: 0 1px 2px rgba(60, 64, 67, 0.3), 0 1px 3px 1px rgba(60, 64, 67, 0.15);
    fill: var(--button-hover-fill-color);
  }

  .colab-df-quickchart-complete:disabled,
  .colab-df-quickchart-complete:disabled:hover {
    background-color: var(--disabled-bg-color);
    fill: var(--disabled-fill-color);
    box-shadow: none;
  }

  .colab-df-spinner {
    border: 2px solid var(--fill-color);
    border-color: transparent;
    border-bottom-color: var(--fill-color);
    animation:
      spin 1s steps(1) infinite;
  }

  @keyframes spin {
    0% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
      border-left-color: var(--fill-color);
    }
    20% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    30% {
      border-color: transparent;
      border-left-color: var(--fill-color);
      border-top-color: var(--fill-color);
      border-right-color: var(--fill-color);
    }
    40% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-top-color: var(--fill-color);
    }
    60% {
      border-color: transparent;
      border-right-color: var(--fill-color);
    }
    80% {
      border-color: transparent;
      border-right-color: var(--fill-color);
      border-bottom-color: var(--fill-color);
    }
    90% {
      border-color: transparent;
      border-bottom-color: var(--fill-color);
    }
  }
</style>

  <script>
    async function quickchart(key) {
      const quickchartButtonEl =
        document.querySelector('#' + key + ' button');
      quickchartButtonEl.disabled = true;  // To prevent multiple clicks.
      quickchartButtonEl.classList.add('colab-df-spinner');
      try {
        const charts = await google.colab.kernel.invokeFunction(
            'suggestCharts', [key], {});
      } catch (error) {
        console.error('Error during call to suggestCharts:', error);
      }
      quickchartButtonEl.classList.remove('colab-df-spinner');
      quickchartButtonEl.classList.add('colab-df-quickchart-complete');
    }
    (() => {
      let quickchartButtonEl =
        document.querySelector('#df-3f848c18-9e7b-4bf6-a168-1eb08435f80e button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>



## 데이터 살펴보기 리뷰
### train 폴더 살펴보기
 - 요약 : 
    - 결측치(0인 정보포함)를 0대신 다른방안 검토
    - meta 정보가없는 건고추 처리방안 검토
    - meta 필터링을 베이스코드 기준 말고 좀 더 적절하게(무를 시점별로 봄무, 여름무, 가을무 적용 등)
    - 계절요인을 생각해보자
    - 수요와 공급 요인들을 모델에 반영하자(총반입량이나 경매건수, 같은 시점에서 target의 대체제 품종들)

- train 파일의 target 데이터는 한정적(29,376건 중에 1,440건)입니다. target외 정보들을 적절히 사용하여 예측정확도를 높일 필요가 있습니다.

- 가격정보가 0인 데이터들이 많습니다. 베이스코드에서는 수치형 데이터의 결측치를 0으로 채웠는데, 0이아닌 중앙값이나 평균값 등으로 대체하는방안을 검토하는게 더적절해보입니다.

- 건고추는 meta 데이터에 존재하지 않았습니다. train 파일에서 어떤식으로 접근해야할지 고민할 필요가 있습니다.

- train 파일의 시점별 품목별 평균가격을 분석해보니, 전반적으로 품목별로 가격의 안정시기와 불안정시기가 공존하고 있었습니다. 감자, 배, 사과 등 일부품목은 주식차트마냥 규칙적인 패턴이 나타났지만 대부분 계절적인 요인에 영향을 받는것처럼 관찰됐습니다. 특히 '무'에서 가격변동이 제일 크게 관찰됐습니다.

- meta폴더에 산지공판장과 전국도매 데이터들의 필터링을 검토할 필요가 있어보입니다. 예를들어, 베이스코드에서는 무를 기타무로 필터링했는데 품종을보면 봄무, 여름무, 가을무, 기타무, 다발무, 등등 다양하게 존재했고 가격도 조금씩다른데 기타무가 제일 비싼축에 속했습니다. 계절별로 봄무, 여름무, 가을무 등으로 필터링해서 학습을 시킨다던지 필터링을 다르게 적용해보면 좀더정확한 자료가 나오지않을까 싶습니다. 사과같은경우에도 베이스코드에서는 후지만 사용했는데, target 대상에는 후지, 홍로가 명시됐고 실제 meta 데이터상에도 후지, 홍로가 각각 있었습니다. 홍로 품종을 추가로 모델에 적용할 필요가 있어보였습니다. 양파도 베이스코드는 기타양파를 선택했는데 양파(일반)도 고려할수있다고 생각됩니다. 이처럼 품목별로 품종선택을 좀더 면밀히 검토해볼 필요가 있습니다.

- 풍년이 들면 농산물의 가격이 급락해 농가의 수입이 감소하고, 흉년이 들면 농산물의 가격이 급등해 농가의 수입이 증가하는 것을 두고 ‘농부의 역설’ 또는 ‘풍년의 역설’이라고 부른다고 합니다. 산지공판장과 전국도매 데이터에는 총반입량과 경매 건수 열이 있는데요, 수요와 공급이 관련된 요인들을 모델링에 적용하면 더 정확한 target 예측이 가능할 것으로 보입니다. 경매건수는 다른요인들(한번에 대량구매라던지)이 있어서 제외할수도있지만 총반입량은 target 예측에 연관성이 있을것으로 보입니다.

- 수요와 공급 관점에서 좀 더 살펴본다면, 각 시점별로 '수입 품종'도 고려대상일 수 있습니다. 예를들어 target에서 깐마늘은 '국산' 품종이지만, 같은시기에 '깐마늘(수입)'산의 반입량과 가격이 영향을 줄수있다고 생각합니다. meta 데이터에도 수입품종이 일부있는것으로 확인됐고, 수입뿐만아니라 대체할수있는 target 대체제가 같은시기에 판매되고있다면 같이 검토해볼 필요가 있습니다.

- meta데이터 가격과 총반입량과 경매건수의 상관관계를 살펴봤을때, 산지공판장의 경우 평균가격이 전년과 평년의 상관관계가 0.78로 가장 높았고 그 외 상관관계는 0.3미만으로 낮았습니다. 다만, 제가 target 대상일것같은 품종들만 골라서 전체데이터 기준은 아닙니다. 전국도매는 전체데이터 기준으로 상관관계를 파악해봤는데요, 평균가격이 전달과 전순의 상관관계가 0.84로 가장높았고 총반입량과 경매건수도 0.66으로 높게 나타났습니다. 평균가격같은경우에는 어찌보면 전달과 전순은 비슷한시기라 상관관계가 높은게 정상인데, 필터링한 산지공판장에서는 0.21의 상관관계가 나와서 한번더 확인할 필요가있겠습니다.

### test 폴더 살펴보기
- 평균가격이나 평년 평균가격 둘의 상관관계는 0.99 이상으로 추론시, 둘중 하나의 기준으로만 진행해도 무리가 없을것으로 보입니다. test에도 target외 정보들도 제공되고있네요.

### 모델링 검토
- VAR같은경우 DA2 문제찾기 시간에 경제관련 정보를 찾다가 공신력있는 기관에서 데이터분석에 해당 모델을 사용해서 관심이갔습니다. 근데 데이터 양이 적으면 과적합 위험이 있을수 있다네요. 나머지는 GPT에 소규모 데이터 추론에 적합한 모델을 추천받았습니다.

- VAR (Vector Autoregressive): 여러 시계열 변수 간의 상호 의존성을 잘 설명할 수 있어 농산물의 여러 특성 (예: 날씨, 수확량) 사이의 관계를 예측할 때 효과적입니다.

- Prophet: 시계열 모델로, 복잡한 계절적 패턴과 연휴 등의 영향을 잘 반영합니다. 빠르게 결과를 도출할 수 있어 프로토타입용으로 적합합니다.

- 랜덤 포레스트 회귀: 비선형 관계를 잘 모델링하므로, 다양한 농산물의 가격 변동을 설명하는 데 유리할 수 있습니다.

- XGBoost/LightGBM: 부스팅 기반 모델로, 속도가 빠르고 정확도가 높으며, 데이터 전처리와 파라미터 튜닝에 민감하지만 매우 강력한 성능을 보여줍니다.

- SARIMA (Seasonal ARIMA): ARIMA 모델의 확장으로, 계절적 변동을 더 정확히 반영할 수 있습니다. 농산물은 계절적 특성이 강하기 때문에 이 모델을 고려해 볼 가치가 있습니다.

- CNN-LSTM: CNN(Convolutional Neural Networks)과 LSTM을 결합한 모델로, 시계열 데이터의 패턴을 추출하고, 이를 바탕으로 장기적인 예측을 할 수 있습니다. 특히 복잡한 데이터에서 의미 있는 패턴을 학습하는 데 효과적입니다.

- Ensemble 모델: 여러 모델을 결합하여 각 모델의 장점을 극대화할 수 있습니다. 예를 들어, ARIMA와 XGBoost를 결합하여 시계열 예측에 적합한 방법을 만들 수 있습니다.
