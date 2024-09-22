---
#layout: post
title: 파이썬 데이터분석 클러스터와 차원축소 실습
date: 2024-09-23
description: # 검색어 및 글요약
categories: [Data_analysis, Python_DA_Library]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Python
- Data_analysis
#pin: true # 해당글을 홈에서 고정시킬지
#toc: false # 오른쪽 목차 설정
#comments: false # 댓글 설정

#image: # 미리보기 이미지 설정
#  path: /path/to/image # 경로
#  alt: image alternative text # 이미지 설명 (생략가능)

#mermaid: true # 다이어그램 생성 도구 (https://github.com/mermaid-js/mermaid)
#math : true # 수학도구
---


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
    Fetched 10.3 MB in 0s (39.8 MB/s)
    debconf: unable to initialize frontend: Dialog
    debconf: (No usable dialog-like program is installed, so the dialog based frontend cannot be used. at /usr/share/perl5/Debconf/FrontEnd/Dialog.pm line 78, <> line 1.)
    debconf: falling back to frontend: Readline
    debconf: unable to initialize frontend: Readline
    debconf: (This frontend requires a controlling tty.)
    debconf: falling back to frontend: Teletype
    dpkg-preconfigure: unable to re-open stdin: 
    Selecting previously unselected package fonts-nanum.
    (Reading database ... 123599 files and directories currently installed.)
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

# ▶ Google drive mount or 폴더 클릭 후 구글드라이브 연결
from google.colab import drive
drive.mount('/content/drive')
```

    Mounted at /content/drive
    


```python
##########################################
### 한글이 깨지는 경우 아래 코드 실행하기 !!!###
##########################################
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
    


```python
import os
import pandas as pd
import numpy as np
import seaborn as sns
```

## **데이터 준비하기**
---

> **데이터 준비하기**

- 데이터 출처: [Kaggle](https://www.kaggle.com/datasets/arjunbhasin2013/ccdata/data) `Credit Card Dataset`

- 데이터 명세

| No. | 표준항목명            | 영문명                           | 설명                                     | 표현형식/단위 | 예시   |
| --- | --------------------- | -------------------------------- | ---------------------------------------- | ------------- | ------ |
| 1   | 고객 ID               | CUST_ID                          | 고객을 식별하기 위한 고유 ID             | -             | C10001 |
| 2   | 잔액                  | BALANCE                          | 신용카드 계좌의 현재 잔액                | N             | 40.9   |
| 3   | 잔액 업데이트 빈도    | BALANCE_FREQUENCY                | 잔액이 업데이트 되는 빈도                | N             | 0.818  |
| 4   | 총 구매액             | PURCHASES                        | 신용카드로 이루어진 총 구매액            | N             | 95.4   |
| 5   | 일회성 구매액         | ONEOFF_PURCHASES                 | 일회성으로 이루어진 구매액               | N             | 0.0    |
| 6   | 할부 구매액           | INSTALLMENTS_PURCHASES           | 할부로 이루어진 구매액                   | N             | 95.4   |
| 7   | 현금 서비스 금액      | CASH_ADVANCE                     | 현금 서비스로 인출한 금액                | N             | 0.0    |
| 8   | 구매 빈도             | PURCHASES_FREQUENCY              | 구매가 이루어진 빈도                     | N             | 0.167  |
| 9   | 일회성 구매 빈도      | ONEOFF_PURCHASES_FREQUENCY       | 일회성 구매가 이루어진 빈도              | N             | 0.0    |
| 10  | 할부 구매 빈도        | PURCHASES_INSTALLMENTS_FREQUENCY | 할부 구매가 이루어진 빈도                | N             | 0.083  |
| 11  | 현금 서비스 빈도      | CASH_ADVANCE_FREQUENCY           | 현금 서비스가 이루어진 빈도              | N             | 0.0    |
| 12  | 현금 서비스 거래 횟수 | CASH_ADVANCE_TRX                 | 현금 서비스 거래의 횟수                  | N             | 0      |
| 13  | 구매 횟수             | PURCHASES_TRX                    | 총 구매 거래의 횟수                      | N             | 2      |
| 14  | 신용 한도             | CREDIT_LIMIT                     | 신용카드의 신용 한도                     | N             | 1000.0 |
| 15  | 지불액                | PAYMENTS                         | 신용카드 계좌에 지불한 총 금액           | N             | 201.8  |
| 16  | 최소 지불액           | MINIMUM_PAYMENTS                 | 신용카드 계좌의 최소 지불액              | N             | 139.5  |
| 17  | 전액 지불 비율        | PRC_FULL_PAYMENT                 | 신용카드 결제 금액 중 전액을 지불한 비율 | N             | 0.0    |
| 18  | 카드 소지 기간        | TENURE                           | 신용카드 계좌를 소지한 기간 (월)         | N             | 12     |




```python
# 데이터 불러오기
data = pd.read_csv("/content/drive/MyDrive/CC GENERAL.csv")
data
```





  <div id="df-ac5701b9-6b9b-4978-a0db-49939ed760a4" class="colab-df-container">
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
      <th>CUST_ID</th>
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>C10001</td>
      <td>40.900749</td>
      <td>0.818182</td>
      <td>95.40</td>
      <td>0.00</td>
      <td>95.40</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
      <td>1000.0</td>
      <td>201.802084</td>
      <td>139.509787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>1</th>
      <td>C10002</td>
      <td>3202.467416</td>
      <td>0.909091</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>6442.945483</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.250000</td>
      <td>4</td>
      <td>0</td>
      <td>7000.0</td>
      <td>4103.032597</td>
      <td>1072.340217</td>
      <td>0.222222</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>C10003</td>
      <td>2495.148862</td>
      <td>1.000000</td>
      <td>773.17</td>
      <td>773.17</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>7500.0</td>
      <td>622.066742</td>
      <td>627.284787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>3</th>
      <td>C10004</td>
      <td>1666.670542</td>
      <td>0.636364</td>
      <td>1499.00</td>
      <td>1499.00</td>
      <td>0.00</td>
      <td>205.788017</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>1</td>
      <td>1</td>
      <td>7500.0</td>
      <td>0.000000</td>
      <td>NaN</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>C10005</td>
      <td>817.714335</td>
      <td>1.000000</td>
      <td>16.00</td>
      <td>16.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1200.0</td>
      <td>678.334763</td>
      <td>244.791237</td>
      <td>0.000000</td>
      <td>12</td>
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
    </tr>
    <tr>
      <th>8945</th>
      <td>C19186</td>
      <td>28.493517</td>
      <td>1.000000</td>
      <td>291.12</td>
      <td>0.00</td>
      <td>291.12</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>325.594462</td>
      <td>48.886365</td>
      <td>0.500000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8946</th>
      <td>C19187</td>
      <td>19.183215</td>
      <td>1.000000</td>
      <td>300.00</td>
      <td>0.00</td>
      <td>300.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>275.861322</td>
      <td>NaN</td>
      <td>0.000000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8947</th>
      <td>C19188</td>
      <td>23.398673</td>
      <td>0.833333</td>
      <td>144.40</td>
      <td>0.00</td>
      <td>144.40</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0.666667</td>
      <td>0.000000</td>
      <td>0</td>
      <td>5</td>
      <td>1000.0</td>
      <td>81.270775</td>
      <td>82.418369</td>
      <td>0.250000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8948</th>
      <td>C19189</td>
      <td>13.457564</td>
      <td>0.833333</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>36.558778</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>2</td>
      <td>0</td>
      <td>500.0</td>
      <td>52.549959</td>
      <td>55.755628</td>
      <td>0.250000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8949</th>
      <td>C19190</td>
      <td>372.708075</td>
      <td>0.666667</td>
      <td>1093.25</td>
      <td>1093.25</td>
      <td>0.00</td>
      <td>127.040008</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.000000</td>
      <td>0.333333</td>
      <td>2</td>
      <td>23</td>
      <td>1200.0</td>
      <td>63.165404</td>
      <td>88.288956</td>
      <td>0.000000</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
<p>8950 rows × 18 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-ac5701b9-6b9b-4978-a0db-49939ed760a4')"
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
        document.querySelector('#df-ac5701b9-6b9b-4978-a0db-49939ed760a4 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-ac5701b9-6b9b-4978-a0db-49939ed760a4');
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


<div id="df-c3533214-512c-4140-9517-1bed52fa15f6">
  <button class="colab-df-quickchart" onclick="quickchart('df-c3533214-512c-4140-9517-1bed52fa15f6')"
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
        document.querySelector('#df-c3533214-512c-4140-9517-1bed52fa15f6 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_6e2c229d-de51-4d5b-9b53-8ebe4943fad0">
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
    <button class="colab-df-generate" onclick="generateWithVariable('data')"
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
        document.querySelector('#id_6e2c229d-de51-4d5b-9b53-8ebe4943fad0 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('data');
      }
      })();
    </script>
  </div>

    </div>
  </div>




## 데이터 파악 및 EDA (6문제)

### 문제1: 데이터셋 기본 정보 확인하기
- 데이터프레임의 기본 정보를 확인하고, 각 변수의 데이터 타입과 결측치 유무를 파악하세요.


```python
# 데이터프레임의 기본 정보 확인
data.info()
# 최소 지불액 변수에 일부 결측치 파악됨
# id를 제외하면 수치형 변수
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 8950 entries, 0 to 8949
    Data columns (total 18 columns):
     #   Column                            Non-Null Count  Dtype  
    ---  ------                            --------------  -----  
     0   CUST_ID                           8950 non-null   object 
     1   BALANCE                           8950 non-null   float64
     2   BALANCE_FREQUENCY                 8950 non-null   float64
     3   PURCHASES                         8950 non-null   float64
     4   ONEOFF_PURCHASES                  8950 non-null   float64
     5   INSTALLMENTS_PURCHASES            8950 non-null   float64
     6   CASH_ADVANCE                      8950 non-null   float64
     7   PURCHASES_FREQUENCY               8950 non-null   float64
     8   ONEOFF_PURCHASES_FREQUENCY        8950 non-null   float64
     9   PURCHASES_INSTALLMENTS_FREQUENCY  8950 non-null   float64
     10  CASH_ADVANCE_FREQUENCY            8950 non-null   float64
     11  CASH_ADVANCE_TRX                  8950 non-null   int64  
     12  PURCHASES_TRX                     8950 non-null   int64  
     13  CREDIT_LIMIT                      8949 non-null   float64
     14  PAYMENTS                          8950 non-null   float64
     15  MINIMUM_PAYMENTS                  8637 non-null   float64
     16  PRC_FULL_PAYMENT                  8950 non-null   float64
     17  TENURE                            8950 non-null   int64  
    dtypes: float64(14), int64(3), object(1)
    memory usage: 1.2+ MB
    

- 데이터프레임의 총 행 수와 열 수, 각 변수의 데이터 타입 및 결측치 여부를 확인할 수 있습니다.
- MINIMUM_PAYMENTS와 CREDIT_LIMIT 변수에 결측치가 있습니다.

### 문제2: 기술 통계량 계산하기
각 변수의 기술 통계량을 계산하여 평균, 표준편차, 최소값, 최대값 등을 파악하세요.


```python
# 각 변수의 기술 통계량 계산
data.describe()
# 금수저가 관찰됨
```





  <div id="df-63fa12fa-b519-43ed-9e61-0d30286025cd" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
      <td>8949.000000</td>
      <td>8950.000000</td>
      <td>8637.000000</td>
      <td>8950.000000</td>
      <td>8950.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1564.474828</td>
      <td>0.877271</td>
      <td>1003.204834</td>
      <td>592.437371</td>
      <td>411.067645</td>
      <td>978.871112</td>
      <td>0.490351</td>
      <td>0.202458</td>
      <td>0.364437</td>
      <td>0.135144</td>
      <td>3.248827</td>
      <td>14.709832</td>
      <td>4494.449450</td>
      <td>1733.143852</td>
      <td>864.206542</td>
      <td>0.153715</td>
      <td>11.517318</td>
    </tr>
    <tr>
      <th>std</th>
      <td>2081.531879</td>
      <td>0.236904</td>
      <td>2136.634782</td>
      <td>1659.887917</td>
      <td>904.338115</td>
      <td>2097.163877</td>
      <td>0.401371</td>
      <td>0.298336</td>
      <td>0.397448</td>
      <td>0.200121</td>
      <td>6.824647</td>
      <td>24.857649</td>
      <td>3638.815725</td>
      <td>2895.063757</td>
      <td>2372.446607</td>
      <td>0.292499</td>
      <td>1.338331</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>50.000000</td>
      <td>0.000000</td>
      <td>0.019163</td>
      <td>0.000000</td>
      <td>6.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>128.281915</td>
      <td>0.888889</td>
      <td>39.635000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1600.000000</td>
      <td>383.276166</td>
      <td>169.123707</td>
      <td>0.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>873.385231</td>
      <td>1.000000</td>
      <td>361.280000</td>
      <td>38.000000</td>
      <td>89.000000</td>
      <td>0.000000</td>
      <td>0.500000</td>
      <td>0.083333</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>7.000000</td>
      <td>3000.000000</td>
      <td>856.901546</td>
      <td>312.343947</td>
      <td>0.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2054.140036</td>
      <td>1.000000</td>
      <td>1110.130000</td>
      <td>577.405000</td>
      <td>468.637500</td>
      <td>1113.821139</td>
      <td>0.916667</td>
      <td>0.300000</td>
      <td>0.750000</td>
      <td>0.222222</td>
      <td>4.000000</td>
      <td>17.000000</td>
      <td>6500.000000</td>
      <td>1901.134317</td>
      <td>825.485459</td>
      <td>0.142857</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>19043.138560</td>
      <td>1.000000</td>
      <td>49039.570000</td>
      <td>40761.250000</td>
      <td>22500.000000</td>
      <td>47137.211760</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.500000</td>
      <td>123.000000</td>
      <td>358.000000</td>
      <td>30000.000000</td>
      <td>50721.483360</td>
      <td>76406.207520</td>
      <td>1.000000</td>
      <td>12.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-63fa12fa-b519-43ed-9e61-0d30286025cd')"
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
        document.querySelector('#df-63fa12fa-b519-43ed-9e61-0d30286025cd button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-63fa12fa-b519-43ed-9e61-0d30286025cd');
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


<div id="df-1703ab77-3490-41be-a2a1-556e554daade">
  <button class="colab-df-quickchart" onclick="quickchart('df-1703ab77-3490-41be-a2a1-556e554daade')"
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
        document.querySelector('#df-1703ab77-3490-41be-a2a1-556e554daade button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




### 문제3 : 중복값 확인하기
- 데이터프레임에서 중복값이 있는 지 확인해보세요. 있다면 중복값을 제거하세요.  


```python
data.duplicated(keep=False).sum()  # 중복값 없음
```




    0



### 문제4: 결측치 파악하기
- 데이터프레임에서 결측치가 존재하는 부분을 시각화해보세요.


```python
sns.heatmap(data.isnull())
plt.show()
# 최소 지불액 변수에 일부 결측치 관찰됨
```


    
![png](/assets/img/clustering3/1.png)
    


### 문제5: 데이터 분포 시각화하기 - 히스토그램
각 변수의 데이터 분포를 히스토그램으로 시각화하세요.


```python
data.columns
```




    Index(['CUST_ID', 'BALANCE', 'BALANCE_FREQUENCY', 'PURCHASES',
           'ONEOFF_PURCHASES', 'INSTALLMENTS_PURCHASES', 'CASH_ADVANCE',
           'PURCHASES_FREQUENCY', 'ONEOFF_PURCHASES_FREQUENCY',
           'PURCHASES_INSTALLMENTS_FREQUENCY', 'CASH_ADVANCE_FREQUENCY',
           'CASH_ADVANCE_TRX', 'PURCHASES_TRX', 'CREDIT_LIMIT', 'PAYMENTS',
           'MINIMUM_PAYMENTS', 'PRC_FULL_PAYMENT', 'TENURE'],
          dtype='object')




```python
# 히스토그램 시각화
numeric_columns = data.drop(columns='CUST_ID')
numeric_columns
```





  <div id="df-c1d903da-8aec-4993-b9dc-374652956952" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>40.900749</td>
      <td>0.818182</td>
      <td>95.40</td>
      <td>0.00</td>
      <td>95.40</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
      <td>1000.0</td>
      <td>201.802084</td>
      <td>139.509787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3202.467416</td>
      <td>0.909091</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>6442.945483</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.250000</td>
      <td>4</td>
      <td>0</td>
      <td>7000.0</td>
      <td>4103.032597</td>
      <td>1072.340217</td>
      <td>0.222222</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2495.148862</td>
      <td>1.000000</td>
      <td>773.17</td>
      <td>773.17</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>7500.0</td>
      <td>622.066742</td>
      <td>627.284787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1666.670542</td>
      <td>0.636364</td>
      <td>1499.00</td>
      <td>1499.00</td>
      <td>0.00</td>
      <td>205.788017</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>1</td>
      <td>1</td>
      <td>7500.0</td>
      <td>0.000000</td>
      <td>NaN</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>817.714335</td>
      <td>1.000000</td>
      <td>16.00</td>
      <td>16.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1200.0</td>
      <td>678.334763</td>
      <td>244.791237</td>
      <td>0.000000</td>
      <td>12</td>
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
    </tr>
    <tr>
      <th>8945</th>
      <td>28.493517</td>
      <td>1.000000</td>
      <td>291.12</td>
      <td>0.00</td>
      <td>291.12</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>325.594462</td>
      <td>48.886365</td>
      <td>0.500000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8946</th>
      <td>19.183215</td>
      <td>1.000000</td>
      <td>300.00</td>
      <td>0.00</td>
      <td>300.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>275.861322</td>
      <td>NaN</td>
      <td>0.000000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8947</th>
      <td>23.398673</td>
      <td>0.833333</td>
      <td>144.40</td>
      <td>0.00</td>
      <td>144.40</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0.666667</td>
      <td>0.000000</td>
      <td>0</td>
      <td>5</td>
      <td>1000.0</td>
      <td>81.270775</td>
      <td>82.418369</td>
      <td>0.250000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8948</th>
      <td>13.457564</td>
      <td>0.833333</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>36.558778</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>2</td>
      <td>0</td>
      <td>500.0</td>
      <td>52.549959</td>
      <td>55.755628</td>
      <td>0.250000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8949</th>
      <td>372.708075</td>
      <td>0.666667</td>
      <td>1093.25</td>
      <td>1093.25</td>
      <td>0.00</td>
      <td>127.040008</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.000000</td>
      <td>0.333333</td>
      <td>2</td>
      <td>23</td>
      <td>1200.0</td>
      <td>63.165404</td>
      <td>88.288956</td>
      <td>0.000000</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
<p>8950 rows × 17 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-c1d903da-8aec-4993-b9dc-374652956952')"
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
        document.querySelector('#df-c1d903da-8aec-4993-b9dc-374652956952 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-c1d903da-8aec-4993-b9dc-374652956952');
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


<div id="df-1bb3e3d8-67aa-4d2a-b24f-4e76a8ae4ef9">
  <button class="colab-df-quickchart" onclick="quickchart('df-1bb3e3d8-67aa-4d2a-b24f-4e76a8ae4ef9')"
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
        document.querySelector('#df-1bb3e3d8-67aa-4d2a-b24f-4e76a8ae4ef9 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_93233009-bd53-49b8-ba9e-dc6c33c1d078">
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
    <button class="colab-df-generate" onclick="generateWithVariable('numeric_columns')"
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
        document.querySelector('#id_93233009-bd53-49b8-ba9e-dc6c33c1d078 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('numeric_columns');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
plt.figure(figsize=(20,16))
for index, col in enumerate(numeric_columns):
    plt.subplot(4, 5, index + 1)
    sns.histplot(numeric_columns[col], bins=15, kde=True)
    plt.title(f"{col} 데이터 분포")
    plt.xlabel('')
    plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/clustering3/2.png)
    



```python
# 전체데이터로는 대부분 한쪽으로 치우쳐진 형태를 보이고 있다
```

### 문제6: 데이터의 이상치 파악하기
- 데이터의 이상치를 파악하세요. 이를 위해 각 변수의 분포를 상자 그림으로 시각화하세요.


```python
plt.figure(figsize=(20,16))
for index, col in enumerate(numeric_columns):
    plt.subplot(4, 5, index + 1)
    sns.boxplot(data=numeric_columns, y=col)
    plt.title(f"{col} 데이터 분포")
    plt.xlabel('')
    plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/clustering3/3.png)
    



```python
# 금수저들에의해 이상치가 무수히 발생하고있다
```

## 데이터 전처리 (3문제)

### 문제7: 결측치 처리하기
-  변수의 결측치 수를 확인하고, 결측치가 존재하는 변수들을 적절한 방법으로 전처리하세요.


```python
data2 = numeric_columns
data2.isna().sum().sort_values(ascending=False)
# 최소 지불액 변수에서 313개 결측치, 신용 한도에서 1개 결측치 관찰됨
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
      <th>MINIMUM_PAYMENTS</th>
      <td>313</td>
    </tr>
    <tr>
      <th>CREDIT_LIMIT</th>
      <td>1</td>
    </tr>
    <tr>
      <th>BALANCE</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PRC_FULL_PAYMENT</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_TRX</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_TRX</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>BALANCE_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE</th>
      <td>0</td>
    </tr>
    <tr>
      <th>INSTALLMENTS_PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>TENURE</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
data2[data2['CREDIT_LIMIT'].isnull()]
```





  <div id="df-edc6bc1c-8693-4277-b708-6c8d4dbd60c0" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5203</th>
      <td>18.400472</td>
      <td>0.166667</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>186.853063</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.166667</td>
      <td>1</td>
      <td>0</td>
      <td>NaN</td>
      <td>9.040017</td>
      <td>14.418723</td>
      <td>0.0</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-edc6bc1c-8693-4277-b708-6c8d4dbd60c0')"
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
        document.querySelector('#df-edc6bc1c-8693-4277-b708-6c8d4dbd60c0 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-edc6bc1c-8693-4277-b708-6c8d4dbd60c0');
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


    </div>
  </div>





```python
# 신용 한도 결측치 1개는 단순제거를 수행한다
data2 = data2.dropna(subset=['CREDIT_LIMIT'])
```


```python
data2['MINIMUM_PAYMENTS'].describe()
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
      <th>MINIMUM_PAYMENTS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>8636.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>864.304943</td>
    </tr>
    <tr>
      <th>std</th>
      <td>2372.566350</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.019163</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>169.163545</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>312.452292</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>825.496463</td>
    </tr>
    <tr>
      <th>max</th>
      <td>76406.207520</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> float64</label>




```python
# 최소 지불액 시각화 : 75%가 825인데 max값이 76406이다. 결측치는 중앙값처리가 더 적절해보인다.
sns.histplot(data2['MINIMUM_PAYMENTS'])
plt.title("MINIMUM_PAYMENTS의 데이터 분포")
plt.xlabel('')
plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/clustering3/4.png)
    



```python
# 최소지불액과 지불액 관계 : 최소지불액 결측치가 지불액에서 어떻게 나타나는지 확인
data2['PAYMENTS'][data2['MINIMUM_PAYMENTS'].isna()].value_counts().sort_values(ascending=False)
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
      <th>count</th>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0.000000</th>
      <td>240</td>
    </tr>
    <tr>
      <th>432.927281</th>
      <td>1</td>
    </tr>
    <tr>
      <th>746.691026</th>
      <td>1</td>
    </tr>
    <tr>
      <th>1159.135064</th>
      <td>1</td>
    </tr>
    <tr>
      <th>29272.486070</th>
      <td>1</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
    </tr>
    <tr>
      <th>295.937124</th>
      <td>1</td>
    </tr>
    <tr>
      <th>3905.430817</th>
      <td>1</td>
    </tr>
    <tr>
      <th>5.070726</th>
      <td>1</td>
    </tr>
    <tr>
      <th>578.819329</th>
      <td>1</td>
    </tr>
    <tr>
      <th>275.861322</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
<p>74 rows × 1 columns</p>
</div><br><label><b>dtype:</b> int64</label>




```python
# 최소지불액 결측치 처리
# 1) 지불액 변수값이 0이다 : 최소지불액 결측치도 0으로 처리
# 2) 지불액 변수값이 0이 아니다 : 최소지불액 결측치 중앙값 처리
median_minimum_payments = data2['MINIMUM_PAYMENTS'].median()

for index, row in data2.iterrows():
    if pd.isnull(row['MINIMUM_PAYMENTS']):
        if row['PAYMENTS'] == 0:
            data2.at[index, 'MINIMUM_PAYMENTS'] = 0
        else:
            data2.at[index, 'MINIMUM_PAYMENTS'] = median_minimum_payments

data2.isna().sum().sort_values(ascending=False)
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
      <th>BALANCE</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PRC_FULL_PAYMENT</th>
      <td>0</td>
    </tr>
    <tr>
      <th>MINIMUM_PAYMENTS</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CREDIT_LIMIT</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_TRX</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_TRX</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>BALANCE_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES_FREQUENCY</th>
      <td>0</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE</th>
      <td>0</td>
    </tr>
    <tr>
      <th>INSTALLMENTS_PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>PURCHASES</th>
      <td>0</td>
    </tr>
    <tr>
      <th>TENURE</th>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>




```python
# 추가 점검 : 총 지불액이 최소지불액보다 작을수있을까?
payment_check = data2[data2['MINIMUM_PAYMENTS'] > data2['PAYMENTS']]
print(f"최소지불액보다 작은 총 지불액 개수 : {payment_check.shape[0]}")
print(f"전체 데이터 중 약 {round((payment_check.shape[0])/(data2.shape[0])*100)}%에서 발견됨")
```

    최소지불액보다 작은 총 지불액 개수 : 2397
    전체 데이터 중 약 27%에서 발견됨
    


```python
payment_check[['MINIMUM_PAYMENTS','PAYMENTS']]
```





  <div id="df-6ab137b3-a8b3-46ba-8b60-d2d6ff5ac85a" class="colab-df-container">
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
      <th>MINIMUM_PAYMENTS</th>
      <th>PAYMENTS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>627.284787</td>
      <td>622.066742</td>
    </tr>
    <tr>
      <th>5</th>
      <td>2407.246035</td>
      <td>1400.057770</td>
    </tr>
    <tr>
      <th>10</th>
      <td>2172.697765</td>
      <td>1083.301007</td>
    </tr>
    <tr>
      <th>14</th>
      <td>989.962866</td>
      <td>805.647974</td>
    </tr>
    <tr>
      <th>15</th>
      <td>2109.906490</td>
      <td>1993.439277</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>8939</th>
      <td>110.950798</td>
      <td>72.530037</td>
    </tr>
    <tr>
      <th>8946</th>
      <td>312.452292</td>
      <td>275.861322</td>
    </tr>
    <tr>
      <th>8947</th>
      <td>82.418369</td>
      <td>81.270775</td>
    </tr>
    <tr>
      <th>8948</th>
      <td>55.755628</td>
      <td>52.549959</td>
    </tr>
    <tr>
      <th>8949</th>
      <td>88.288956</td>
      <td>63.165404</td>
    </tr>
  </tbody>
</table>
<p>2397 rows × 2 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-6ab137b3-a8b3-46ba-8b60-d2d6ff5ac85a')"
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
        document.querySelector('#df-6ab137b3-a8b3-46ba-8b60-d2d6ff5ac85a button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-6ab137b3-a8b3-46ba-8b60-d2d6ff5ac85a');
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


<div id="df-8b58a283-563d-450f-bc2c-a4b770f51bf4">
  <button class="colab-df-quickchart" onclick="quickchart('df-8b58a283-563d-450f-bc2c-a4b770f51bf4')"
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
        document.querySelector('#df-8b58a283-563d-450f-bc2c-a4b770f51bf4 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# 총 지불액이 최소 지불액보다 작은경우?
# 1) 환불발생 : 현재데이터로 확인불가
# 2) 할인발생 : 현재데이터로 확인불가
# 3) 할부구매 : INSTALLMENTS_PURCHASES, PURCHASES_INSTALLMENTS_FREQUENCY의 값이 0보다 크다면 할부금액으로 인한 지불액 차이가 고려될 수 있다.
# 4) 신용한도 초과 : CREDIT_LIMIT에 영향을 받을수있다. 신용한도가 낮아 최소 결제 금액을 충족하지 못한 경우.
# 5) 미지급 : 신용카드 결제일에 고객이 전액을 지급하지 않거나 일부만 납부한 경우. 현재데이터로 확인불가
# 6) 현금서비스 : CASH_ADVANCE, CASH_ADVANCE_FREQUENCY의 값이 0보다 크다면 고려될 수 있다.
# 7) 기타 : 시스템오류나 고객의 단순 지불액 착각, 돌려막기 등...

# 하지만 현재데이터상으로는 이상치로 판단하기에는 너무많은 데이터가 소실될 위험이 있다.
# 주어진 데이터의 한계로 위와같은 데이터가 제공되지 않아 비정상적으로 보일 수 있다고 판단하여 이상치를 제거하지 않음.
```

### 문제8: 이상치 처리하기

- 데이터에 이상치가 있는지 확인해보세요. 확인 후, 전처리가 필요하다면 진행해주세요.


```python
# 이상치 제거 전 시각화
data3 = data2.copy()

plt.figure(figsize=(20,16))
for index, col in enumerate(data3):
    plt.subplot(4, 5, index + 1)
    sns.boxplot(data=data3, y=col)
    plt.title(f"{col} 데이터 분포")
    plt.xlabel('')
    plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/clustering3/5.png)
    



```python
# 이상치가 너무 많다 : 다양한방법으로 시도해보자
# 1. IQR기준 이상치 처리
# 2. IQR 0.10 ~ 0.90 기준 이상치 처리
# 3. 특정변수만 이상치처리
```

 - 이상치 처리 : 1. IQR기준 이상치 처리


```python
# 이상치 제거 (전처리 진행)
data4 = data2.copy()
def get_outlier_mask(df, weight=1.5):
    Q1 = df.quantile(0.25)
    Q3 = df.quantile(0.75)

    IQR = Q3 - Q1
    IQR_weight = IQR * weight

    range_min = Q1 - IQR_weight
    range_max = Q3 + IQR_weight

    outlier_per_column = (df < range_min) | (df > range_max)

    is_outlier = outlier_per_column.any(axis=1)

    return is_outlier

outlier_idx_cust_df = get_outlier_mask(data4, weight=1.5)

# 이상치를 제거한 데이터 프레임만 추가
data4 = data4[~outlier_idx_cust_df]
data4
```





  <div id="df-b97397cc-db1c-4e7c-aeed-78e6364cea38" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>40.900749</td>
      <td>0.818182</td>
      <td>95.40</td>
      <td>0.00</td>
      <td>95.40</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
      <td>1000.0</td>
      <td>201.802084</td>
      <td>139.509787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>817.714335</td>
      <td>1.000000</td>
      <td>16.00</td>
      <td>16.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1200.0</td>
      <td>678.334763</td>
      <td>244.791237</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1823.652743</td>
      <td>1.000000</td>
      <td>436.20</td>
      <td>0.00</td>
      <td>436.20</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>2300.0</td>
      <td>679.065082</td>
      <td>532.033990</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1014.926473</td>
      <td>1.000000</td>
      <td>861.49</td>
      <td>661.49</td>
      <td>200.00</td>
      <td>0.000000</td>
      <td>0.333333</td>
      <td>0.083333</td>
      <td>0.250000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>5</td>
      <td>7000.0</td>
      <td>688.278568</td>
      <td>311.963409</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>14</th>
      <td>2772.772734</td>
      <td>1.000000</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>346.811390</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>1</td>
      <td>0</td>
      <td>3000.0</td>
      <td>805.647974</td>
      <td>989.962866</td>
      <td>0.000000</td>
      <td>12</td>
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
    </tr>
    <tr>
      <th>8738</th>
      <td>981.286008</td>
      <td>1.000000</td>
      <td>1370.00</td>
      <td>1370.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1400.0</td>
      <td>596.685481</td>
      <td>451.584847</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>8742</th>
      <td>87.026009</td>
      <td>1.000000</td>
      <td>605.52</td>
      <td>0.00</td>
      <td>605.52</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.916667</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>1500.0</td>
      <td>511.637312</td>
      <td>175.012705</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>8747</th>
      <td>16.428326</td>
      <td>0.909091</td>
      <td>441.50</td>
      <td>124.70</td>
      <td>316.80</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.166667</td>
      <td>0.916667</td>
      <td>0.000000</td>
      <td>0</td>
      <td>14</td>
      <td>1000.0</td>
      <td>482.547848</td>
      <td>91.328536</td>
      <td>0.333333</td>
      <td>12</td>
    </tr>
    <tr>
      <th>8759</th>
      <td>67.377243</td>
      <td>1.000000</td>
      <td>295.00</td>
      <td>0.00</td>
      <td>295.00</td>
      <td>0.000000</td>
      <td>0.500000</td>
      <td>0.000000</td>
      <td>0.416667</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>245.689379</td>
      <td>167.126034</td>
      <td>0.300000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>8760</th>
      <td>307.127754</td>
      <td>1.000000</td>
      <td>909.30</td>
      <td>409.30</td>
      <td>500.00</td>
      <td>237.378894</td>
      <td>0.583333</td>
      <td>0.166667</td>
      <td>0.500000</td>
      <td>0.166667</td>
      <td>4</td>
      <td>12</td>
      <td>1000.0</td>
      <td>943.278170</td>
      <td>179.258575</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
  </tbody>
</table>
<p>2987 rows × 17 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-b97397cc-db1c-4e7c-aeed-78e6364cea38')"
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
        document.querySelector('#df-b97397cc-db1c-4e7c-aeed-78e6364cea38 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-b97397cc-db1c-4e7c-aeed-78e6364cea38');
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


<div id="df-7353c4ec-651f-47c8-9fd7-f3aed7b20ab3">
  <button class="colab-df-quickchart" onclick="quickchart('df-7353c4ec-651f-47c8-9fd7-f3aed7b20ab3')"
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
        document.querySelector('#df-7353c4ec-651f-47c8-9fd7-f3aed7b20ab3 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_7b4aa16b-82ea-4153-a512-b7f8923ebc5c">
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
    <button class="colab-df-generate" onclick="generateWithVariable('data4')"
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
        document.querySelector('#id_7b4aa16b-82ea-4153-a512-b7f8923ebc5c button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('data4');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# IQR기준으로 이상치를 처리하면 데이터가 33% 밖에 남지 않는다.
# 이번데이터는 마케팅 전략을 수립하기 위해 고객 세분화 방안을 찾는것이다.
# 그런데 전체 데이터를 67% 버리고 고객 세분화 방안을 찾는것은 원래목적의 의미가 퇴색될수있다.
# 다른방안을 선택하는것이 좋아보인다.
```

- 이상치 처리 : 2. IQR 0.10 ~ 0.90 기준 이상치 처리


```python
# 1. IQR 0.10 ~ 0.90버전
data5 = data2.copy()
def get_outlier_mask(df, weight=1.5):
    Q1 = df.quantile(0.10)
    Q3 = df.quantile(0.90)

    IQR = Q3 - Q1
    IQR_weight = IQR * weight

    range_min = Q1 - IQR_weight
    range_max = Q3 + IQR_weight

    outlier_per_column = (df < range_min) | (df > range_max)

    is_outlier = outlier_per_column.any(axis=1)

    return is_outlier

outlier_idx_cust_df = get_outlier_mask(data5, weight=1.5)

# 이상치를 제거한 데이터 프레임만 추가
data5 = data5[~outlier_idx_cust_df]
data5
```





  <div id="df-25be6d0c-5da1-40c9-bd94-4770a06e2722" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>40.900749</td>
      <td>0.818182</td>
      <td>95.40</td>
      <td>0.00</td>
      <td>95.40</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
      <td>1000.0</td>
      <td>201.802084</td>
      <td>139.509787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3202.467416</td>
      <td>0.909091</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>6442.945483</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.250000</td>
      <td>4</td>
      <td>0</td>
      <td>7000.0</td>
      <td>4103.032597</td>
      <td>1072.340217</td>
      <td>0.222222</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2495.148862</td>
      <td>1.000000</td>
      <td>773.17</td>
      <td>773.17</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>7500.0</td>
      <td>622.066742</td>
      <td>627.284787</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1666.670542</td>
      <td>0.636364</td>
      <td>1499.00</td>
      <td>1499.00</td>
      <td>0.00</td>
      <td>205.788017</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>1</td>
      <td>1</td>
      <td>7500.0</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>817.714335</td>
      <td>1.000000</td>
      <td>16.00</td>
      <td>16.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1200.0</td>
      <td>678.334763</td>
      <td>244.791237</td>
      <td>0.000000</td>
      <td>12</td>
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
    </tr>
    <tr>
      <th>8908</th>
      <td>21.357267</td>
      <td>1.000000</td>
      <td>212.87</td>
      <td>0.00</td>
      <td>212.87</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.857143</td>
      <td>0.000000</td>
      <td>0</td>
      <td>7</td>
      <td>1000.0</td>
      <td>169.713838</td>
      <td>103.387362</td>
      <td>1.000000</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8909</th>
      <td>641.282519</td>
      <td>1.000000</td>
      <td>750.00</td>
      <td>750.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.142857</td>
      <td>0.142857</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1000.0</td>
      <td>105.582942</td>
      <td>302.743881</td>
      <td>0.000000</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8910</th>
      <td>356.108694</td>
      <td>1.000000</td>
      <td>465.00</td>
      <td>465.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.142857</td>
      <td>0.142857</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1000.0</td>
      <td>118.775188</td>
      <td>109.227176</td>
      <td>0.000000</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8911</th>
      <td>30.709172</td>
      <td>0.285714</td>
      <td>693.42</td>
      <td>0.00</td>
      <td>693.42</td>
      <td>0.000000</td>
      <td>0.714286</td>
      <td>0.000000</td>
      <td>0.571429</td>
      <td>0.000000</td>
      <td>0</td>
      <td>7</td>
      <td>1000.0</td>
      <td>1154.520085</td>
      <td>15.853873</td>
      <td>0.000000</td>
      <td>7</td>
    </tr>
    <tr>
      <th>8912</th>
      <td>376.547421</td>
      <td>0.857143</td>
      <td>520.00</td>
      <td>280.00</td>
      <td>240.00</td>
      <td>1178.402416</td>
      <td>0.857143</td>
      <td>0.142857</td>
      <td>0.714286</td>
      <td>0.714286</td>
      <td>9</td>
      <td>7</td>
      <td>1000.0</td>
      <td>929.415656</td>
      <td>103.927887</td>
      <td>0.200000</td>
      <td>7</td>
    </tr>
  </tbody>
</table>
<p>7860 rows × 17 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-25be6d0c-5da1-40c9-bd94-4770a06e2722')"
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
        document.querySelector('#df-25be6d0c-5da1-40c9-bd94-4770a06e2722 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-25be6d0c-5da1-40c9-bd94-4770a06e2722');
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


<div id="df-32152499-91ab-4563-9036-1c3fcb750cf9">
  <button class="colab-df-quickchart" onclick="quickchart('df-32152499-91ab-4563-9036-1c3fcb750cf9')"
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
        document.querySelector('#df-32152499-91ab-4563-9036-1c3fcb750cf9 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_28cb157e-4604-4eb0-a843-e31fab953ae1">
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
    <button class="colab-df-generate" onclick="generateWithVariable('data5')"
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
        document.querySelector('#id_28cb157e-4604-4eb0-a843-e31fab953ae1 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('data5');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# IQR을 0.10 ~ 0.90 기준으로 이상치를 처리하면 88% 데이터가 남는다.
# 대부분의 데이터가 살아있지만 시각화를 통해 한번더 확인이 필요해보인다.
```

- 이상치 처리 : 3. 특정변수만 이상치처리


```python
# max값이 많이 튀는 특정 변수만 이상치 처리 : BALANCE, PURCHASES, ONEOFF_PURCHASES, INSTALLMENTS_PURCHASES, CASH_ADVANCE, CREDIT_LIMIT, PAYMENTS, MINIMUM_PAYMENTS
data6 = data2.copy()
data6.describe()
```





  <div id="df-921f790a-2364-49e5-96e7-b5bb3bded69f" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
      <td>8949.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1564.647593</td>
      <td>0.877350</td>
      <td>1003.316936</td>
      <td>592.503572</td>
      <td>411.113579</td>
      <td>978.959616</td>
      <td>0.490405</td>
      <td>0.202480</td>
      <td>0.364478</td>
      <td>0.135141</td>
      <td>3.249078</td>
      <td>14.711476</td>
      <td>4494.449450</td>
      <td>1733.336511</td>
      <td>836.623813</td>
      <td>0.153732</td>
      <td>11.517935</td>
    </tr>
    <tr>
      <th>std</th>
      <td>2081.584016</td>
      <td>0.236798</td>
      <td>2136.727848</td>
      <td>1659.968851</td>
      <td>904.378205</td>
      <td>2097.264344</td>
      <td>0.401360</td>
      <td>0.298345</td>
      <td>0.397451</td>
      <td>0.200132</td>
      <td>6.824987</td>
      <td>24.858552</td>
      <td>3638.815725</td>
      <td>2895.168146</td>
      <td>2335.363228</td>
      <td>0.292511</td>
      <td>1.337134</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>50.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>6.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>128.365782</td>
      <td>0.888889</td>
      <td>39.800000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1600.000000</td>
      <td>383.282850</td>
      <td>164.687639</td>
      <td>0.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>873.680279</td>
      <td>1.000000</td>
      <td>361.490000</td>
      <td>38.000000</td>
      <td>89.000000</td>
      <td>0.000000</td>
      <td>0.500000</td>
      <td>0.083333</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>7.000000</td>
      <td>3000.000000</td>
      <td>857.062706</td>
      <td>299.935043</td>
      <td>0.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>2054.372848</td>
      <td>1.000000</td>
      <td>1110.170000</td>
      <td>577.830000</td>
      <td>468.650000</td>
      <td>1113.868654</td>
      <td>0.916667</td>
      <td>0.300000</td>
      <td>0.750000</td>
      <td>0.222222</td>
      <td>4.000000</td>
      <td>17.000000</td>
      <td>6500.000000</td>
      <td>1901.279320</td>
      <td>788.721609</td>
      <td>0.142857</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>19043.138560</td>
      <td>1.000000</td>
      <td>49039.570000</td>
      <td>40761.250000</td>
      <td>22500.000000</td>
      <td>47137.211760</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>1.500000</td>
      <td>123.000000</td>
      <td>358.000000</td>
      <td>30000.000000</td>
      <td>50721.483360</td>
      <td>76406.207520</td>
      <td>1.000000</td>
      <td>12.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-921f790a-2364-49e5-96e7-b5bb3bded69f')"
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
        document.querySelector('#df-921f790a-2364-49e5-96e7-b5bb3bded69f button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-921f790a-2364-49e5-96e7-b5bb3bded69f');
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


<div id="df-1cca9e32-0d54-4eb7-aa0d-5fee949fc4ad">
  <button class="colab-df-quickchart" onclick="quickchart('df-1cca9e32-0d54-4eb7-aa0d-5fee949fc4ad')"
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
        document.querySelector('#df-1cca9e32-0d54-4eb7-aa0d-5fee949fc4ad button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
data6 = data2.copy()

def get_outlier_mask(df, columns, weight=1.5):
    # 선택한 열만 사용
    df_selected = df[columns]

    Q1 = df_selected.quantile(0.25)
    Q3 = df_selected.quantile(0.75)

    IQR = Q3 - Q1
    IQR_weight = IQR * weight

    range_min = Q1 - IQR_weight
    range_max = Q3 + IQR_weight

    outlier_per_column = (df_selected < range_min) | (df_selected > range_max)

    is_outlier = outlier_per_column.any(axis=1)

    return is_outlier

# 이상치를 처리할 열 리스트
columns_to_check = ['BALANCE', 'PURCHASES', 'ONEOFF_PURCHASES', 'INSTALLMENTS_PURCHASES', 'CASH_ADVANCE', 'CREDIT_LIMIT', 'PAYMENTS', 'MINIMUM_PAYMENTS']

# 이상치 인덱스 생성
outlier_idx_cust_df = get_outlier_mask(data6, columns_to_check, weight=1.5)

# 이상치를 제거한 데이터프레임 생성
data6 = data6[~outlier_idx_cust_df]
data6
```





  <div id="df-09f0ec8d-f040-41ff-984d-03552c04de70" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>40.900749</td>
      <td>0.818182</td>
      <td>95.40</td>
      <td>0.00</td>
      <td>95.40</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>2</td>
      <td>1000.0</td>
      <td>201.802084</td>
      <td>139.509787</td>
      <td>0.00</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2495.148862</td>
      <td>1.000000</td>
      <td>773.17</td>
      <td>773.17</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>7500.0</td>
      <td>622.066742</td>
      <td>627.284787</td>
      <td>0.00</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>817.714335</td>
      <td>1.000000</td>
      <td>16.00</td>
      <td>16.00</td>
      <td>0.00</td>
      <td>0.000000</td>
      <td>0.083333</td>
      <td>0.083333</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>1</td>
      <td>1200.0</td>
      <td>678.334763</td>
      <td>244.791237</td>
      <td>0.00</td>
      <td>12</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1823.652743</td>
      <td>1.000000</td>
      <td>436.20</td>
      <td>0.00</td>
      <td>436.20</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>12</td>
      <td>2300.0</td>
      <td>679.065082</td>
      <td>532.033990</td>
      <td>0.00</td>
      <td>12</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1014.926473</td>
      <td>1.000000</td>
      <td>861.49</td>
      <td>661.49</td>
      <td>200.00</td>
      <td>0.000000</td>
      <td>0.333333</td>
      <td>0.083333</td>
      <td>0.250000</td>
      <td>0.000000</td>
      <td>0</td>
      <td>5</td>
      <td>7000.0</td>
      <td>688.278568</td>
      <td>311.963409</td>
      <td>0.00</td>
      <td>12</td>
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
    </tr>
    <tr>
      <th>8945</th>
      <td>28.493517</td>
      <td>1.000000</td>
      <td>291.12</td>
      <td>0.00</td>
      <td>291.12</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>325.594462</td>
      <td>48.886365</td>
      <td>0.50</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8946</th>
      <td>19.183215</td>
      <td>1.000000</td>
      <td>300.00</td>
      <td>0.00</td>
      <td>300.00</td>
      <td>0.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0</td>
      <td>6</td>
      <td>1000.0</td>
      <td>275.861322</td>
      <td>312.452292</td>
      <td>0.00</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8947</th>
      <td>23.398673</td>
      <td>0.833333</td>
      <td>144.40</td>
      <td>0.00</td>
      <td>144.40</td>
      <td>0.000000</td>
      <td>0.833333</td>
      <td>0.000000</td>
      <td>0.666667</td>
      <td>0.000000</td>
      <td>0</td>
      <td>5</td>
      <td>1000.0</td>
      <td>81.270775</td>
      <td>82.418369</td>
      <td>0.25</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8948</th>
      <td>13.457564</td>
      <td>0.833333</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>0.00</td>
      <td>36.558778</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.166667</td>
      <td>2</td>
      <td>0</td>
      <td>500.0</td>
      <td>52.549959</td>
      <td>55.755628</td>
      <td>0.25</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8949</th>
      <td>372.708075</td>
      <td>0.666667</td>
      <td>1093.25</td>
      <td>1093.25</td>
      <td>0.00</td>
      <td>127.040008</td>
      <td>0.666667</td>
      <td>0.666667</td>
      <td>0.000000</td>
      <td>0.333333</td>
      <td>2</td>
      <td>23</td>
      <td>1200.0</td>
      <td>63.165404</td>
      <td>88.288956</td>
      <td>0.00</td>
      <td>6</td>
    </tr>
  </tbody>
</table>
<p>5869 rows × 17 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-09f0ec8d-f040-41ff-984d-03552c04de70')"
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
        document.querySelector('#df-09f0ec8d-f040-41ff-984d-03552c04de70 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-09f0ec8d-f040-41ff-984d-03552c04de70');
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


<div id="df-9f9e741e-c465-4055-87dc-5c28c21d8d57">
  <button class="colab-df-quickchart" onclick="quickchart('df-9f9e741e-c465-4055-87dc-5c28c21d8d57')"
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
        document.querySelector('#df-9f9e741e-c465-4055-87dc-5c28c21d8d57 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_92e5a11a-3d3b-4553-a08d-695e7b244900">
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
    <button class="colab-df-generate" onclick="generateWithVariable('data6')"
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
        document.querySelector('#id_92e5a11a-3d3b-4553-a08d-695e7b244900 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('data6');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 특정변수만 이상치를 처리하면 66% 데이터가 남는다.
# 시각화를 통해 2번과 3번 방안중에 선택고려
```


```python
# 이상치 제거 후 시각화
# 2. IQR 0.10 ~ 0.90 버전
plt.figure(figsize=(20,16))
for index, col in enumerate(data5):
    plt.subplot(4, 5, index + 1)
    sns.boxplot(data=data5, y=col)
    plt.title(f"{col} 데이터 분포")
    plt.xlabel('')
    plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/clustering3/6.png)
    



```python
# 이상치 제거 전 박스플롯과 비슷해보이지만, 전반적으로 변수별로 이상치들이 잘 모여있다.
```


```python
# 3. 특정변수만 이상치 제거 버전
# max값이 많이 튀는 특정 변수만 이상치 처리 : BALANCE, PURCHASES, ONEOFF_PURCHASES, INSTALLMENTS_PURCHASES, CASH_ADVANCE, CREDIT_LIMIT, PAYMENTS, MINIMUM_PAYMENTS
plt.figure(figsize=(20,16))
for index, col in enumerate(data6):
    plt.subplot(4, 5, index + 1)
    sns.boxplot(data=data6, y=col)
    plt.title(f"{col} 데이터 분포")
    plt.xlabel('')
    plt.ylabel('')

plt.tight_layout()
plt.show()
```


    
![png](/assets/img/clustering3/7.png)
    



```python
# 2번 IQR 0.1 ~ 0.9 버전보다 3번 방식으로 선택한 변수들은 데이터가 더 잘모여있고, 선택되지않은 데이터들은 이상치가 조금 튀고있다.
# 우선, 2번 방식으로 데이터분석을 진행하되, 적절한 분석이 안될경우 2번 데이터를 추가적인 전처리를 취하거나 3번 데이터를 사용한다.
```

### 문제9: 데이터 스케일링하기
- 각 변수의 데이터를 표준화 혹은 정규화하세요.


```python
data7 = data5.copy()

df_mean = data7.mean()  # 각 컬럼의 평균값
df_std = data7.std()  # 각 컬럼의 표준편차

scaled_df = (data7 - df_mean)/df_std  # 컬럼별 표준화 진행

scaled_df
```





  <div id="df-aa4f4fd0-116c-4275-b6df-11723559a876" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.759182</td>
      <td>-0.215160</td>
      <td>-0.647033</td>
      <td>-0.562980</td>
      <td>-0.438501</td>
      <td>-0.554363</td>
      <td>-0.781661</td>
      <td>-0.655331</td>
      <td>-0.686195</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.642690</td>
      <td>-0.963550</td>
      <td>-0.757062</td>
      <td>-0.619400</td>
      <td>-0.519489</td>
      <td>0.342764</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.133650</td>
      <td>0.157721</td>
      <td>-0.749808</td>
      <td>-0.562980</td>
      <td>-0.636448</td>
      <td>4.353579</td>
      <td>-1.201814</td>
      <td>-0.655331</td>
      <td>-0.899241</td>
      <td>0.741303</td>
      <td>0.340613</td>
      <td>-0.777379</td>
      <td>0.886997</td>
      <td>2.054140</td>
      <td>0.838968</td>
      <td>0.253563</td>
      <td>0.342764</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.710178</td>
      <td>0.530603</td>
      <td>0.083138</td>
      <td>0.554513</td>
      <td>-0.636448</td>
      <td>-0.554363</td>
      <td>1.319102</td>
      <td>2.889269</td>
      <td>-0.899241</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>0.030750</td>
      <td>1.041209</td>
      <td>-0.454222</td>
      <td>0.143178</td>
      <td>-0.519489</td>
      <td>0.342764</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.214168</td>
      <td>-0.960924</td>
      <td>0.865084</td>
      <td>1.603584</td>
      <td>-0.636448</td>
      <td>-0.397603</td>
      <td>-0.991739</td>
      <td>-0.359948</td>
      <td>-0.899241</td>
      <td>-0.207402</td>
      <td>-0.352608</td>
      <td>-0.710034</td>
      <td>1.041209</td>
      <td>-0.902479</td>
      <td>-0.837506</td>
      <td>-0.519489</td>
      <td>0.342764</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-0.294103</td>
      <td>0.530603</td>
      <td>-0.732571</td>
      <td>-0.539855</td>
      <td>-0.636448</td>
      <td>-0.554363</td>
      <td>-0.991739</td>
      <td>-0.359948</td>
      <td>-0.899241</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.710034</td>
      <td>-0.901865</td>
      <td>-0.413676</td>
      <td>-0.454805</td>
      <td>-0.519489</td>
      <td>0.342764</td>
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
    </tr>
    <tr>
      <th>8908</th>
      <td>-0.770882</td>
      <td>0.530603</td>
      <td>-0.520481</td>
      <td>-0.562980</td>
      <td>-0.194761</td>
      <td>-0.554363</td>
      <td>1.319102</td>
      <td>-0.655331</td>
      <td>1.292097</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.305970</td>
      <td>-0.963550</td>
      <td>-0.780185</td>
      <td>-0.675873</td>
      <td>2.959249</td>
      <td>-4.300677</td>
    </tr>
    <tr>
      <th>8909</th>
      <td>-0.399733</td>
      <td>0.530603</td>
      <td>0.058177</td>
      <td>0.521025</td>
      <td>-0.636448</td>
      <td>-0.554363</td>
      <td>-0.841684</td>
      <td>-0.148960</td>
      <td>-0.899241</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.710034</td>
      <td>-0.963550</td>
      <td>-0.826397</td>
      <td>-0.364203</td>
      <td>-0.519489</td>
      <td>-4.300677</td>
    </tr>
    <tr>
      <th>8910</th>
      <td>-0.570467</td>
      <td>0.530603</td>
      <td>-0.248858</td>
      <td>0.109103</td>
      <td>-0.636448</td>
      <td>-0.554363</td>
      <td>-0.841684</td>
      <td>-0.148960</td>
      <td>-0.899241</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.710034</td>
      <td>-0.963550</td>
      <td>-0.816891</td>
      <td>-0.666743</td>
      <td>-0.519489</td>
      <td>-4.300677</td>
    </tr>
    <tr>
      <th>8911</th>
      <td>-0.765283</td>
      <td>-2.399186</td>
      <td>-0.002778</td>
      <td>-0.562980</td>
      <td>0.802339</td>
      <td>-0.554363</td>
      <td>0.598841</td>
      <td>-0.655331</td>
      <td>0.561652</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.305970</td>
      <td>-0.963550</td>
      <td>-0.070540</td>
      <td>-0.812721</td>
      <td>-0.519489</td>
      <td>-4.300677</td>
    </tr>
    <tr>
      <th>8912</th>
      <td>-0.558230</td>
      <td>-0.055354</td>
      <td>-0.189605</td>
      <td>-0.158285</td>
      <td>-0.138469</td>
      <td>0.343290</td>
      <td>0.958971</td>
      <td>-0.148960</td>
      <td>0.926875</td>
      <td>3.384121</td>
      <td>1.495983</td>
      <td>-0.305970</td>
      <td>-0.963550</td>
      <td>-0.232748</td>
      <td>-0.675028</td>
      <td>0.176258</td>
      <td>-4.300677</td>
    </tr>
  </tbody>
</table>
<p>7860 rows × 17 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-aa4f4fd0-116c-4275-b6df-11723559a876')"
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
        document.querySelector('#df-aa4f4fd0-116c-4275-b6df-11723559a876 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-aa4f4fd0-116c-4275-b6df-11723559a876');
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


<div id="df-fe2da63e-4621-4f0d-bde1-deba47285fb6">
  <button class="colab-df-quickchart" onclick="quickchart('df-fe2da63e-4621-4f0d-bde1-deba47285fb6')"
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
        document.querySelector('#df-fe2da63e-4621-4f0d-bde1-deba47285fb6 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_fe2c8e8e-1536-43fe-a62f-20b2db14e14f">
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
    <button class="colab-df-generate" onclick="generateWithVariable('scaled_df')"
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
        document.querySelector('#id_fe2c8e8e-1536-43fe-a62f-20b2db14e14f button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('scaled_df');
      }
      })();
    </script>
  </div>

    </div>
  </div>




- 표준화는 데이터의 평균을 0, 표준편차를 1로 맞추어 변환합니다.
- 정규화는 데이터 값을 0과 1 사이로 변환합니다.
- 표준화와 정규화는 모델 학습의 성능을 향상시킬 수 있습니다.

이후 분석은 표준화된 데이터를 바탕으로 진행하겠습니다.

## 클러스터 분석 (11문제)

###문제10: K-means 클러스터링 모델 학습
- K-means 알고리즘을 사용하여 클러스터링 모델을 학습하세요. 클러스터의 수는 3로 설정하세요.


```python
from sklearn.cluster import KMeans
data10 = scaled_df.copy()
model = KMeans(n_clusters=3, random_state=21)
model.fit(data10)
```




<style>#sk-container-id-1 {color: black;}#sk-container-id-1 pre{padding: 0;}#sk-container-id-1 div.sk-toggleable {background-color: white;}#sk-container-id-1 label.sk-toggleable__label {cursor: pointer;display: block;width: 100%;margin-bottom: 0;padding: 0.3em;box-sizing: border-box;text-align: center;}#sk-container-id-1 label.sk-toggleable__label-arrow:before {content: "▸";float: left;margin-right: 0.25em;color: #696969;}#sk-container-id-1 label.sk-toggleable__label-arrow:hover:before {color: black;}#sk-container-id-1 div.sk-estimator:hover label.sk-toggleable__label-arrow:before {color: black;}#sk-container-id-1 div.sk-toggleable__content {max-height: 0;max-width: 0;overflow: hidden;text-align: left;background-color: #f0f8ff;}#sk-container-id-1 div.sk-toggleable__content pre {margin: 0.2em;color: black;border-radius: 0.25em;background-color: #f0f8ff;}#sk-container-id-1 input.sk-toggleable__control:checked~div.sk-toggleable__content {max-height: 200px;max-width: 100%;overflow: auto;}#sk-container-id-1 input.sk-toggleable__control:checked~label.sk-toggleable__label-arrow:before {content: "▾";}#sk-container-id-1 div.sk-estimator input.sk-toggleable__control:checked~label.sk-toggleable__label {background-color: #d4ebff;}#sk-container-id-1 div.sk-label input.sk-toggleable__control:checked~label.sk-toggleable__label {background-color: #d4ebff;}#sk-container-id-1 input.sk-hidden--visually {border: 0;clip: rect(1px 1px 1px 1px);clip: rect(1px, 1px, 1px, 1px);height: 1px;margin: -1px;overflow: hidden;padding: 0;position: absolute;width: 1px;}#sk-container-id-1 div.sk-estimator {font-family: monospace;background-color: #f0f8ff;border: 1px dotted black;border-radius: 0.25em;box-sizing: border-box;margin-bottom: 0.5em;}#sk-container-id-1 div.sk-estimator:hover {background-color: #d4ebff;}#sk-container-id-1 div.sk-parallel-item::after {content: "";width: 100%;border-bottom: 1px solid gray;flex-grow: 1;}#sk-container-id-1 div.sk-label:hover label.sk-toggleable__label {background-color: #d4ebff;}#sk-container-id-1 div.sk-serial::before {content: "";position: absolute;border-left: 1px solid gray;box-sizing: border-box;top: 0;bottom: 0;left: 50%;z-index: 0;}#sk-container-id-1 div.sk-serial {display: flex;flex-direction: column;align-items: center;background-color: white;padding-right: 0.2em;padding-left: 0.2em;position: relative;}#sk-container-id-1 div.sk-item {position: relative;z-index: 1;}#sk-container-id-1 div.sk-parallel {display: flex;align-items: stretch;justify-content: center;background-color: white;position: relative;}#sk-container-id-1 div.sk-item::before, #sk-container-id-1 div.sk-parallel-item::before {content: "";position: absolute;border-left: 1px solid gray;box-sizing: border-box;top: 0;bottom: 0;left: 50%;z-index: -1;}#sk-container-id-1 div.sk-parallel-item {display: flex;flex-direction: column;z-index: 1;position: relative;background-color: white;}#sk-container-id-1 div.sk-parallel-item:first-child::after {align-self: flex-end;width: 50%;}#sk-container-id-1 div.sk-parallel-item:last-child::after {align-self: flex-start;width: 50%;}#sk-container-id-1 div.sk-parallel-item:only-child::after {width: 0;}#sk-container-id-1 div.sk-dashed-wrapped {border: 1px dashed gray;margin: 0 0.4em 0.5em 0.4em;box-sizing: border-box;padding-bottom: 0.4em;background-color: white;}#sk-container-id-1 div.sk-label label {font-family: monospace;font-weight: bold;display: inline-block;line-height: 1.2em;}#sk-container-id-1 div.sk-label-container {text-align: center;}#sk-container-id-1 div.sk-container {/* jupyter's `normalize.less` sets `[hidden] { display: none; }` but bootstrap.min.css set `[hidden] { display: none !important; }` so we also need the `!important` here to be able to override the default hidden behavior on the sphinx rendered scikit-learn.org. See: https://github.com/scikit-learn/scikit-learn/issues/21755 */display: inline-block !important;position: relative;}#sk-container-id-1 div.sk-text-repr-fallback {display: none;}</style><div id="sk-container-id-1" class="sk-top-container"><div class="sk-text-repr-fallback"><pre>KMeans(n_clusters=3, random_state=21)</pre><b>In a Jupyter environment, please rerun this cell to show the HTML representation or trust the notebook. <br />On GitHub, the HTML representation is unable to render, please try loading this page with nbviewer.org.</b></div><div class="sk-container" hidden><div class="sk-item"><div class="sk-estimator sk-toggleable"><input class="sk-toggleable__control sk-hidden--visually" id="sk-estimator-id-1" type="checkbox" checked><label for="sk-estimator-id-1" class="sk-toggleable__label sk-toggleable__label-arrow">KMeans</label><div class="sk-toggleable__content"><pre>KMeans(n_clusters=3, random_state=21)</pre></div></div></div></div></div>




```python
# 군집 레이블을 데이터프레임에 추가
data10['cluster'] = model.predict(data10)

# 군집별 데이터 개수 확인
cluster_counts = data10['cluster'].value_counts()
cluster_counts
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
      <th>count</th>
    </tr>
    <tr>
      <th>cluster</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>4610</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1653</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1597</td>
    </tr>
  </tbody>
</table>
</div><br><label><b>dtype:</b> int64</label>



### 문제11 : 클러스터링 결과 시각화 (2D)
- 두 개의 주요 변수(BALANCE, PURCHASES)를 사용하여 클러스터링 결과를 2D로 시각화하세요.


```python
# 시각화

sns.scatterplot(x=data10['BALANCE'], y=data10['PURCHASES'], hue=data10['cluster'], s=50, palette='bright')

```




    <Axes: xlabel='BALANCE', ylabel='PURCHASES'>




    
![png](/assets/img/clustering3/8.png)
    


### 문제12: 클러스터 수 결정 (Elbow Method)
- Elbow Method를 사용하여 최적의 클러스터 수를 결정하세요.


```python
# 엘보우 기법을 위한 KMeans 모델 실행 및 inertia 계산
inertia_list = []
k_values = range(1, 11)

for k in k_values:
    kmeans = KMeans(n_clusters=k, random_state=21)
    kmeans.fit(data10)
    inertia_list.append(kmeans.inertia_)  # 각 k에 대한 inertia 저장

# 3. 엘보우 기법 시각화
plt.figure(figsize=(10, 6))
plt.plot(k_values, inertia_list, 'bo-', markersize=8)
plt.xlabel('Number of clusters (k)')
plt.ylabel('Inertia')
plt.title('Elbow Method for Optimal k')
plt.grid(True)
plt.show()

```


    
![png](/assets/img/clustering3/9.png)
    



```python
# 엘보우기법 상 클러스터수는 3개 혹은 4개가 최적으로 보인다
```

### 문제13 : 결과를 해석해보세요.

- 아래는 클러스터의 수를 5로 진행하고, 2가지 변수(BALANCE, PURCHASES)로 시각화를 한 결과입니다.
- 결과를 보고 추가 분석을 진행하여 인사이트를 발견해보세요. 클러스터 별로 어떤 차이가 있나요?


```python
data11 = scaled_df.copy()
model = KMeans(n_clusters=5, random_state=21)
model.fit(data11)
data11['cluster'] = model.predict(data11)

# 군집별 데이터 개수 확인
cluster_counts2 = data11['cluster'].value_counts()
cluster_counts2

# 시각화
plt.figure(figsize=(16,10))
sns.scatterplot(x=data11['BALANCE'], y=data11['PURCHASES'], hue=data11['cluster'], s=50, palette='bright')
```




    <Axes: xlabel='BALANCE', ylabel='PURCHASES'>




    
![png](/assets/img/clustering3/10.png)
    



```python
mask1 = data11.groupby('cluster').mean()
mask1['cluster_counts'] = data11['cluster'].value_counts()
mask1
```





  <div id="df-3fa38035-e82c-4789-a5e8-bf4b19fe8e9c" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
      <th>cluster_counts</th>
    </tr>
    <tr>
      <th>cluster</th>
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
      <th>0</th>
      <td>-0.729883</td>
      <td>-2.035002</td>
      <td>-0.426298</td>
      <td>-0.297514</td>
      <td>-0.393996</td>
      <td>-0.366573</td>
      <td>-0.511288</td>
      <td>-0.388173</td>
      <td>-0.415927</td>
      <td>-0.505307</td>
      <td>-0.442185</td>
      <td>-0.500797</td>
      <td>-0.147300</td>
      <td>-0.338790</td>
      <td>-0.638524</td>
      <td>0.273897</td>
      <td>-0.176996</td>
      <td>1215</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.147331</td>
      <td>0.412228</td>
      <td>1.861311</td>
      <td>1.843091</td>
      <td>0.938551</td>
      <td>-0.308683</td>
      <td>1.053260</td>
      <td>1.746964</td>
      <td>0.601723</td>
      <td>-0.344255</td>
      <td>-0.318608</td>
      <td>1.605048</td>
      <td>0.710747</td>
      <td>0.824771</td>
      <td>0.052332</td>
      <td>0.347233</td>
      <td>0.217927</td>
      <td>1101</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.471556</td>
      <td>0.383702</td>
      <td>-0.385522</td>
      <td>-0.268878</td>
      <td>-0.356974</td>
      <td>1.829729</td>
      <td>-0.547150</td>
      <td>-0.272870</td>
      <td>-0.474317</td>
      <td>1.682473</td>
      <td>1.768427</td>
      <td>-0.406299</td>
      <td>0.680189</td>
      <td>0.742301</td>
      <td>1.151377</td>
      <td>-0.416675</td>
      <td>-0.069891</td>
      <td>1078</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-0.447853</td>
      <td>0.307518</td>
      <td>0.077789</td>
      <td>-0.353665</td>
      <td>0.658288</td>
      <td>-0.450774</td>
      <td>1.017808</td>
      <td>-0.301107</td>
      <td>1.169951</td>
      <td>-0.505259</td>
      <td>-0.456185</td>
      <td>0.374902</td>
      <td>-0.260058</td>
      <td>-0.267901</td>
      <td>-0.197094</td>
      <td>0.461860</td>
      <td>-0.004701</td>
      <td>1903</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-0.003698</td>
      <td>0.397903</td>
      <td>-0.493090</td>
      <td>-0.275025</td>
      <td>-0.555031</td>
      <td>-0.128512</td>
      <td>-0.735656</td>
      <td>-0.228098</td>
      <td>-0.730491</td>
      <td>0.054925</td>
      <td>-0.058604</td>
      <td>-0.559555</td>
      <td>-0.328488</td>
      <td>-0.306995</td>
      <td>-0.057716</td>
      <td>-0.446677</td>
      <td>0.023176</td>
      <td>2563</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-3fa38035-e82c-4789-a5e8-bf4b19fe8e9c')"
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
        document.querySelector('#df-3fa38035-e82c-4789-a5e8-bf4b19fe8e9c button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-3fa38035-e82c-4789-a5e8-bf4b19fe8e9c');
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


<div id="df-332af245-50a0-402c-acec-5d58fa349ccd">
  <button class="colab-df-quickchart" onclick="quickchart('df-332af245-50a0-402c-acec-5d58fa349ccd')"
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
        document.querySelector('#df-332af245-50a0-402c-acec-5d58fa349ccd button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_ae0bb43e-d813-4713-85e0-2ad92caca5d2">
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
    <button class="colab-df-generate" onclick="generateWithVariable('mask1')"
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
        document.querySelector('#id_ae0bb43e-d813-4713-85e0-2ad92caca5d2 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('mask1');
      }
      })();
    </script>
  </div>

    </div>
  </div>




 **- 결과 해석**
  - 클러스터0 : 가장 낮은 잔액과 비교적 낮은 구매액을 가진 고객. 현금서비스이용도 거의 사용안하고있음. 총 지불액이 가장 낮게 나타남.
  - 클러스터1 : 중간 정도의 잔액과 가장 높은 구매액 및 구매빈도를 가진 고객. 할부로 이루어진 구매액이 높고 총 지불액도 가장 높게 나타나고있음.
  - 클러스터2 : 가장 높은 잔액과 비교적 낮은 구매액, 현금서비스를 가장 많이 이용한 고객. 총 지불액도 비교적 높게 나타나고있음. 최소 지불액이 가장 높고 다른 군집보다 확연하게 높음.
  - 클러스터3 : 비교적 낮은 잔액과 비교적 높은 구매액 및 높은 구매빈도를 가진 고객. 할부 구매 빈도가 가장 높게 나타나고있음. 현금서비스 이용을 가장 낮게 사용하고있음.
  - 클러스터4 : 중간 정도의 잔액과 구매빈도가 가장 낮은 고객. 할부 구매 빈도는 가장 낮게 나타남. 총 지불액이 비교적 낮게 나타남.

  - 클러스터1은 구매빈도가 높은 충성고객으로 이들이 이탈하지않을만한 꾸준한 서비스를 제공할 필요가 있음
  - 클러스터2는 다른 클러스터 집단보다 잔액이 압도적으로 많이 보유하고있는 고객들임. 다만, 현금서비스 이용도 높고 최소지불액도 높은것에비해 구매이용률이 낮아 구매를 유도할만한 상품이나 서비스가 필요함
  - 클러스터0,3,4는 잔액과 구매빈도가 낮은편이다. 이들이 구매활동을 하기위한 적절한 서비스가 필요하다


### 문제14: 계층적 클러스터링 모델 학습 및 덴드로그램 시각화
- 계층적 클러스터링을 scipy를 사용하여 모델을 학습하고, 덴드로그램을 시각화하세요.


```python
from scipy.cluster.hierarchy import dendrogram, linkage, cut_tree
import matplotlib.pyplot as plt

data12 = scaled_df.copy()

# 거리 : ward method 사용
model = linkage(data12, 'ward')  # single, complete, average, centroid, median 등

labelList = data12.index

# 덴드로그램 사이즈와 스타일 조정
plt.figure(figsize=(16,9))
plt.style.use("default")

dendrogram(model, labels=labelList)
plt.show()
```


    
![png](/assets/img/clustering3/11.png)
    



```python
cluster_num = 5

# 고객별 클러스터 라벨 구하기
data12['label'] = cut_tree(model, cluster_num)

pd.DataFrame(data12['label'].value_counts())

```





  <div id="df-c4c7f87f-6880-4a26-ac39-daf28ae12334" class="colab-df-container">
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
      <th>count</th>
    </tr>
    <tr>
      <th>label</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>2971</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2780</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1135</td>
    </tr>
    <tr>
      <th>4</th>
      <td>570</td>
    </tr>
    <tr>
      <th>3</th>
      <td>404</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-c4c7f87f-6880-4a26-ac39-daf28ae12334')"
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
        document.querySelector('#df-c4c7f87f-6880-4a26-ac39-daf28ae12334 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-c4c7f87f-6880-4a26-ac39-daf28ae12334');
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


<div id="df-6da15b7f-61a3-4e30-90a9-57079be58614">
  <button class="colab-df-quickchart" onclick="quickchart('df-6da15b7f-61a3-4e30-90a9-57079be58614')"
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
        document.querySelector('#df-6da15b7f-61a3-4e30-90a9-57079be58614 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
sns.set(style="darkgrid",
        rc = {'figure.figsize':(16,9)})

# 시각화
sns.scatterplot(x=data12['BALANCE'], y=data12['PURCHASES'], hue=data12['label'], s=50, palette='bright')

```




    <Axes: xlabel='BALANCE', ylabel='PURCHASES'>




    
![png](/assets/img/clustering3/12.png)
    


### 문제15: DBSCAN 클러스터링 모델 학습
- DBSCAN 알고리즘을 사용하여 클러스터링 모델을 학습하고, 결과를 얻으세요.


```python
import pandas as pd
from sklearn.cluster import DBSCAN
import matplotlib.pyplot as plt
import seaborn as sns

data13 = scaled_df.copy()

# DBSCAN 모델 생성
# eps와 min_samples는 데이터에 따라 조정해야 합니다.
dbscan = DBSCAN(eps=0.5, min_samples=5)

# DBSCAN을 사용하여 클러스터링 수행
clusters = dbscan.fit_predict(data13)

# 클러스터 레이블을 데이터프레임에 추가
data13['cluster'] = clusters

# 클러스터 개수 확인
cluster_counts = data13['cluster'].value_counts()
print("Cluster Counts:")
print(cluster_counts)


```

    Cluster Counts:
    cluster
    -1     6623
     1      448
     2      262
     0      215
     3      151
     8       16
     17      15
     15      13
     12      11
     6       11
     9       10
     7        9
     4        9
     11       9
     16       8
     14       7
     20       6
     5        6
     21       6
     22       5
     18       5
     10       5
     13       5
     19       5
    Name: count, dtype: int64
    

### 문제16: DBSCAN 클러스터링 모델 학습 (매개변수 조정)
- DBSCAN의 eps와 min_samples 값을 조정하여, 클러스터링 결과가 개선되도록 하세요.


```python
# DBSCAN 모델 학습 (매개변수 조정)
data14 = scaled_df.copy()

# DBSCAN 모델 생성
# eps와 min_samples는 데이터에 따라 조정해야 합니다.
dbscan = DBSCAN(eps=0.8, min_samples=5)

# DBSCAN을 사용하여 클러스터링 수행
clusters = dbscan.fit_predict(data14)

# 클러스터 레이블을 데이터프레임에 추가
data14['cluster'] = clusters

# 클러스터 개수 확인
cluster_counts = data14['cluster'].value_counts()
print("Cluster Counts:")
print(cluster_counts)
```

    Cluster Counts:
    cluster
    -1     4891
     0     2711
     9       47
     4       28
     2       16
     6       15
     13      12
     1       10
     20       8
     11       7
     17       7
     12       7
     27       7
     28       7
     23       6
     5        6
     10       6
     15       6
     7        6
     3        6
     26       5
     19       5
     22       5
     24       5
     8        5
     18       5
     16       5
     29       5
     14       4
     25       4
     21       3
    Name: count, dtype: int64
    

### 문제17: 클러스터링 결과 시각화 및 노이즈 탐지
- DBSCAN 결과를 시각화하고, 노이즈 데이터를 탐지하세요.


```python
# DBSCAN 결과 시각화 (최적 매개변수 사용 후)
plt.figure(figsize=(10, 6))
plt.scatter(data14['PURCHASES'], data14['BALANCE'], c=data14['cluster'], cmap='viridis')
plt.xlabel('PURCHASES')
plt.ylabel('BALANCE')
plt.title('DBSCAN Clustering Results (2D)')
plt.show()
```


    
![png](/assets/img/clustering3/13.png)
    



```python
# 노이즈 데이터 개수 확인
noise_check = data14[data14['cluster'] == -1]
print(f"Number of noise points: {len(noise_check)}")

```

    Number of noise points: 4891
    

### 문제18: GMM 클러스터링 모델 학습
- Gaussian Mixture Model을 사용하여 클러스터링 모델을 학습하고, 결과를 얻으세요. 클러스터의 수는 3으로 설정하세요.


```python
from sklearn.mixture import GaussianMixture
data15 = scaled_df.copy()
n_components = 3
random_state = 21
model = GaussianMixture(n_components=n_components, random_state=random_state)

# GMM 모델 학습
model.fit(data15)
data15['gmm_label'] = model.predict(data15)
print(data15['gmm_label'].value_counts())
```

    gmm_label
    1    3534
    2    2572
    0    1754
    Name: count, dtype: int64
    

### 문제19: 클러스터링 결과 시각화 및 클러스터 확률 해석
- GMM 결과를 시각화하고, 각 데이터 포인트의 클러스터 소속 확률을 확인하세요.


```python
import seaborn as sns
# 시각화
sns.scatterplot(x=data15['PURCHASES'], y=data15['BALANCE'], hue=data15['gmm_label'], palette='rainbow', alpha=0.7, s=100)
```




    <Axes: xlabel='PURCHASES', ylabel='BALANCE'>




    
![png](/assets/img/clustering3/14.png)
    



```python
# 클러스터 소속 확률 확인
data15['Cluster_probabilities'] = model.predict_proba(data7).max(axis=1)
print(data15[['gmm_label', 'Cluster_probabilities']].head())
```

       gmm_label  Cluster_probabilities
    0          1                    1.0
    1          2                    1.0
    2          1                    1.0
    3          0                    1.0
    4          2                    1.0
    

### 문제20: 클러스터링 결과 해석 및 비교
- K-means, 계층적 클러스터링, DBSCAN, GMM의 클러스터링 결과를 비교해보세요.
- 각 방법의 장단점, 특징도 고려해서 결과 분석을 진행해보세요.


```python
print("K-means 클러스터 수:\n", data10['cluster'].value_counts())
print("계층적 클러스터링 클러스터 수:\n", data12['label'].value_counts())
print("DBSCAN 클러스터 수:\n", data14['cluster'].value_counts())
print("GMM 클러스터 수:\n", data15['gmm_label'].value_counts())
```

    K-means 클러스터 수:
     cluster
    0    4610
    1    1653
    2    1597
    Name: count, dtype: int64
    계층적 클러스터링 클러스터 수:
     label
    2    2971
    0    2780
    1    1135
    4     570
    3     404
    Name: count, dtype: int64
    DBSCAN 클러스터 수:
     cluster
    -1     4891
     0     2711
     9       47
     4       28
     2       16
     6       15
     13      12
     1       10
     20       8
     11       7
     17       7
     12       7
     27       7
     28       7
     23       6
     5        6
     10       6
     15       6
     7        6
     3        6
     26       5
     19       5
     22       5
     24       5
     8        5
     18       5
     16       5
     29       5
     14       4
     25       4
     21       3
    Name: count, dtype: int64
    GMM 클러스터 수:
     gmm_label
    1    3534
    2    2572
    0    1754
    Name: count, dtype: int64
    


```python
data10.columns
```




    Index(['BALANCE', 'BALANCE_FREQUENCY', 'PURCHASES', 'ONEOFF_PURCHASES',
           'INSTALLMENTS_PURCHASES', 'CASH_ADVANCE', 'PURCHASES_FREQUENCY',
           'ONEOFF_PURCHASES_FREQUENCY', 'PURCHASES_INSTALLMENTS_FREQUENCY',
           'CASH_ADVANCE_FREQUENCY', 'CASH_ADVANCE_TRX', 'PURCHASES_TRX',
           'CREDIT_LIMIT', 'PAYMENTS', 'MINIMUM_PAYMENTS', 'PRC_FULL_PAYMENT',
           'TENURE', 'cluster'],
          dtype='object')




```python
# 클러스터별 평균 지출 금액 및 잔액 확인
print("K-means : \n", data10.groupby('cluster')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
print("계층적 클러스터링 : \n", data12.groupby('label')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
print("DBSCAN : \n", data14.groupby('cluster')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
print("GMM : \n", data15.groupby('gmm_label')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
```

    K-means : 
               BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    cluster                                             
    0       -0.394715  -0.373719     -0.367362 -0.391423
    1        0.005521   1.493598     -0.337212  0.623774
    2        1.133694  -0.467172      1.409488  0.484259
    계층적 클러스터링 : 
             BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    label                                             
    0     -0.316863  -0.507112     -0.309739 -0.394281
    1      1.143575  -0.555477      1.630805  0.605988
    2     -0.091108   0.371079     -0.323698  0.044065
    3      0.072240   2.703237     -0.344377  1.284015
    4     -0.308039  -0.270784      0.194640 -0.423429
    DBSCAN : 
               BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    cluster                                             
    -1       0.204454   0.308840      0.220776  0.316698
     0      -0.332428  -0.517793     -0.371473 -0.525591
     1      -0.750215  -0.252501     -0.554363 -0.591529
     2      -0.246830  -0.726132      0.385987 -0.543469
     3       1.865787  -0.736625      0.180720 -0.023997
     4      -0.121388  -0.705041     -0.344316 -0.633206
     5      -0.699802  -0.337088     -0.554363 -0.592240
     6      -0.636324  -0.303431     -0.542537 -0.665515
     7      -0.752321  -0.128951     -0.554363 -0.492969
     8      -0.734494   0.252138     -0.554363 -0.279774
     9      -0.782024  -0.407821     -0.554363 -0.690939
     10      2.264016  -0.737627      1.372147  0.015497
     11     -0.590144  -0.749808      0.344613  0.998125
     12     -0.758299  -0.398275     -0.554363 -0.710500
     13     -0.753246  -0.111330     -0.554363 -0.423695
     14     -0.734383  -0.118559     -0.554363 -0.538804
     15     -0.766121  -0.458413     -0.554363 -0.740171
     16      3.126313  -0.749808      1.449965  0.255077
     17     -0.752260  -0.510008     -0.554363 -0.763259
     18     -0.663792   1.271664     -0.554363  0.358995
     19     -0.725419   0.450775     -0.554363 -0.015808
     20     -0.759766  -0.231603     -0.554363 -0.599557
     21     -0.315080   0.152215     -0.554363 -0.355780
     22      0.280371  -0.741190      1.052935  0.860523
     23     -0.730730  -0.463189     -0.554363 -0.826363
     24     -0.238408  -0.749808      0.327747 -0.760784
     25     -0.514970  -0.749808      0.060645 -0.517330
     26     -0.772262  -0.576344     -0.554363 -0.611633
     27     -0.169226  -0.732417     -0.272267 -0.765029
     28     -0.764356  -0.343223     -0.554363 -0.668904
     29     -0.754164  -0.494573     -0.554363 -0.765622
    GMM : 
                 BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    gmm_label                                             
    0          0.567485   0.456135      0.431318  0.452079
    1         -0.483555   0.274891     -0.554274 -0.174449
    2          0.277416  -0.688774      0.467447 -0.068601
    

- K-means의 장단점
  - 장점 :
     - 각 변수(특성)들에 대한 배경지식, 역할, 영향도에 대해 모르더라도 데이터 사이의 거리만 구할 수 있다면 사용할 수 있다.
     - 알고리즘이 비교적 간단하여 이해와 해석이 용이하다
  - 단점 :
     - 최적의 클러스터 개수인 k를 정하는게 어려울 수 있다. elbow method등의 방법으로 추론할 수 있지만 항상 정답은 아니다.
     - 이상치에 영향을 많이 받는다. 이상치가 포함될 경우 중심점 위치가 크게 변동될 수 있고 클러스터가 원치않게 묶여질 수 있다.
     - 차원이 높은 데이터에 적용할 때 성능이 떨어진다
  - 단점 보완 : 중심점을 찾아주는 과정을 보안해주는 k-means++ 모델 등장

- 계층적 클러스터링 장단점
  - 장점 :
     - 모델을 학습시킬 때 클러스터의 개수를 미리 가정하지 않아도 됨
     - 따라서 클러스터의 개수를 몇개로 해야할 지 모를 때 유용함
  - 단점 :
     - 모든 데이터끼리의 거리를 반복해서 계산해야 하기 때문에 많은 연산이 필요함
     - 따라서 대용량 데이터에 적용하는데 어려움이 있음

 - DBSCAN 장단점
   - 장점 : 데이터의 밀도에 따라 클러스터를 만들기 때문에 복잡하거나 기하학적인 형태를 가진 데이터 세트에 효과적이다
   - 단점 : 고차원 데이터일수록 데이터 간 밀도를 계산하기 어려워 연산이 많아지며 학습 속도가 느려질 수 있다

 - GMM은 데이터가 서로 다른 k 개의 정규분포에서 생성되었다고 가정하는 모델 기법
     - 데이터가 정규 분포를 따를 때 값이 특정 구간에 속할 확률을 계산할 수 있고, GMM은 이 확률을 통해 클러스터를 구분한다
     - 특정 데이터의 값이 어떤 분포에 포함될 확률이 더 큰지를 따져서 각 클러스터로 구분하는게 GMM 방법이다
     - GMM을 사용하면 데이터가 단순한 원형 분포 뿐만 아니라 타원형이나 비대칭 등의 데이터도 효과적으로 클러스터링을 할 수 있다
     - 다만, k-means와 비슷하게 사전에 클러스터 개수를 설정해야 하며, k의 개수에 따라 결과가 달라질 수 있다
     - 또한, 특정 분포에 할당되는 데이터 수가 적으면 모수 추정이 잘 이뤄지지 않아 많은 수의 데이터가 없으면 적용하기 어렵다
     - 그리고 정규분포가 아닌 범주형 데이터 등에는 다룰 수 없다

 - 결과해석 :

   - k-means 클러스터링은 0과 1,2 집단의 수 차이가 심하다. 데이터에 이상치가 많고, 차원이 높은것이 영향이 있던것으로 파악된다.

  - 계층적 클러스터링은 클러스터의 개수를 임의로 정할수 있지만 해석이 어렵다.

  - DBSCAN도 차원이 높은 데이터를 사용하고있어 노이즈가많고 해석이 어렵다.

  - GMM 클러스터는 겉으로는 집단을 잘 분배한것처럼 보이지만, 정규분포가 아닌 데이터가 대부분이라 효과적인지 판단하기 어렵다.

  - 따라서 주성분분석 등을 이용하여 차원을 축소하고 클러스터링을 수행할 필요가 있다


- K-means :
  - 클러스터0은 잔액과 구매금액, 현금서비스 모두 낮게 나타남. 이들이 소비하기위해 저가형 상품을 진열할 필요가 있다.
  - 클러스터1은 보통의 잔액이지만 구매금액이 압도적으로 높은 충성고객으로 이들을 이탈시키지 않도록 꾸준한 관리가 필요하다
  - 클러스터2는 잔액과 현금서비스 이용이 높지만 구매금액이 낮은 고객으로 이들의 소비를 촉진시키기위한 상품과 서비스를 개발할 필요가 있다

- 계층적 클러스터링 :
  - 클러스터1은 k-means의 클러스터2와 유사한 고객유형이다
  - 클러스터0,4는 k-means의 클러스터0과 유사한 고객유형이다
  - 클러스터3은 k-means의 클러스터1과 유사한 고객유형이다

- DBSCAN :
  - k-means의 클러스터0과 유사한 고객유형들(클러스터 0, 1, 2, 4, 5 ...)
  - k-means의 클러스터2와 유사한 고객유형들(클러스터 10, 16)

- GMM :
  - 클러스터0은 잔액과 구매금액 등 중상층 유형의 고객유형이다. 사람들이 많이찾는 상품들을 추가할 필요가 있을수있다.
  - 클러스터1은 잔액과 현금서비스 이용은 낮은데 구매는 평균이상의 고객이다. 저가형 상품등 추가할 필요가 있다.
  - 클러스터2는 평균이상의 잔액과 현금서비스 이용이지만 구매금액이 낮다. 이들이 구입한 상품들을 찾아 관심을 끌만한 상품을 추가해야한다

## PCA (3문제)


### 문제21: PCA의 주성분 계산 및 시각화
- 주성분 분석(PCA)을 사용하여 주성분을 계산하고, 첫 두 주성분을 시각화하세요.


```python
from sklearn.decomposition import PCA
data20 = scaled_df.copy()

pca = PCA(n_components=2)
pca_transformed = pca.fit_transform(data20)

# 주성분을 데이터프레임으로 변환
pca_df = pd.DataFrame(data=pca_transformed, columns=['PC1', 'PC2'])

# PCA 결과 시각화
plt.figure(figsize=(10, 6))
sns.scatterplot(x='PC1', y='PC2', data=pca_df, s=100)
plt.title('PCA 2D')
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.grid()
plt.show()
```


    
![png](/assets/img/clustering3/15.png)
    


### 문제22: 적절한 주성분 수 결정
- 적절한 주성분 수를 결정하기 위해, 주성분의 설명력(분산 설명 비율)을 시각화하세요.


```python
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

data21 = scaled_df.copy()

pca = PCA()
pca.fit(data20)

# 주성분의 설명력 (분산 설명 비율)
explained_variance = pca.explained_variance_ratio_

# 설명력 시각화
plt.figure(figsize=(10, 6))
plt.plot(range(1, len(explained_variance) + 1), explained_variance, marker='o', linestyle='--')
plt.title('Explained Variance by Principal Components')
plt.xlabel('Principal Component')
plt.ylabel('Explained Variance Ratio')
plt.xticks(range(1, len(explained_variance) + 1))
plt.grid()
plt.show()
```


    
![png](/assets/img/clustering3/16.png)
    



```python
# 누적 분산 비율 계산
cumulative_variance_ratio = np.cumsum(pca.explained_variance_ratio_)

cumulative_variance_ratio
```




    array([0.28944758, 0.50530762, 0.59853074, 0.67316781, 0.73860167,
           0.79126589, 0.83743209, 0.87564215, 0.90736008, 0.93555131,
           0.95312777, 0.97006002, 0.982218  , 0.9918921 , 0.99784582,
           0.99999769, 1.        ])



### 문제23: 차원 축소를 활용한 데이터 시각화
- 적절한 주성분 수를 선택한 후, 이를 사용하여 데이터를 저차원으로 변환하세요.
- 시각화가 가능하다면, 데이터 시각화를 진행해주세요.


```python
# 문제 22번을 통해 완만하게 바뀌는 지점인 주성분 3차원 기준으로 데이터 변환 진행
# 만약, 적정한 설명력을 가진 차원 축소를 하고싶다면 70% 이상인 5-7개의 주성분을 선택해야 함
data23 = scaled_df.copy()
pca = PCA(n_components=3)
principal_components = pca.fit_transform(data23)

pca_df = pd.DataFrame(data=principal_components, columns=['PC1','PC2','PC3'])

fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')
ax.scatter(pca_df['PC1'], pca_df['PC2'], pca_df['PC3'], s=50)

ax.set_title('3D PCA')
ax.set_xlabel('Principal Component 1')
ax.set_ylabel('Principal Component 2')
ax.set_zlabel('Principal Component 3')
plt.show()
```


    
![png](/assets/img/clustering3/17.png)
    


## PCA를 활용한 클러스터링 (6문제)


CUST_ID를 제외하면 분석 중인 데이터에 총 17개의 열이 있습니다. 차원이 너무 많아서 데이터의 분포나 특징을 시각화로 파악하는 것이 어렵네요. 관련하여, PCA를 통해 모든 차원의 특징을 최대한 살리면서, 동시에 데이터의 특징을 한눈에 파악할 수 있도록 2차원으로 차원을 축소해 봅시다.

### 문제24: PCA를 활용한 차원 축소 후 K-means 클러스터링
- PCA를 통해 차원 축소한 데이터를 사용하여 K-means 클러스터링을 수행하고 결과를 분석해보세요.
-  최적의 군집 개수를 Elbow plot를 통해 확인해보세요.



```python
# PCA 2차원 축소
data24 = scaled_df.copy()
data24.reset_index(drop=True, inplace=True)
pca = PCA(n_components=2)
pca_transformed = pca.fit_transform(data24)
pca_df = pd.DataFrame(data=pca_transformed, columns=['PC1', 'PC2'])

# 차원 축소한 데이터를 K-means 클러스터링 수행
# 엘보우 기법 이용 최적의 군집 개수 확인
inertia = []

# 클러스터 수를 1에서 10까지 변화시키며 K-Means 수행
for k in range(1, 11):
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(pca_df)
    inertia.append(kmeans.inertia_)

# Elbow plot 시각화
plt.figure(figsize=(10, 6))
plt.plot(range(1, 11), inertia, marker='o')
plt.title('Elbow Method for Optimal k')
plt.xlabel('Number of Clusters (k)')
plt.ylabel('Inertia')
plt.xticks(range(1, 11))
plt.grid()
plt.show()
```


    
![png](/assets/img/clustering3/18.png)
    



```python
# 엘보우기법 시각화결과 군집개수 3개 기준으로 클러스터링 수행
optimal_k = 3
kmeans = KMeans(n_clusters=optimal_k, random_state=21)
pca_df['cluster'] = kmeans.fit_predict(pca_df)
pca_df
```





  <div id="df-9b74c514-f673-4fb6-8f64-9ba68a2372e0" class="colab-df-container">
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
      <th>PC1</th>
      <th>PC2</th>
      <th>cluster</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-1.272749</td>
      <td>-2.012017</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-2.693997</td>
      <td>3.122103</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.308761</td>
      <td>0.557358</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-0.377331</td>
      <td>-0.426854</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-1.411984</td>
      <td>-1.458604</td>
      <td>0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>7855</th>
      <td>0.766955</td>
      <td>-2.521954</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7856</th>
      <td>-1.045427</td>
      <td>-1.483733</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7857</th>
      <td>-1.247922</td>
      <td>-1.783102</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7858</th>
      <td>0.060160</td>
      <td>-2.381176</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7859</th>
      <td>-1.056373</td>
      <td>0.633281</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>7860 rows × 3 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-9b74c514-f673-4fb6-8f64-9ba68a2372e0')"
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
        document.querySelector('#df-9b74c514-f673-4fb6-8f64-9ba68a2372e0 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-9b74c514-f673-4fb6-8f64-9ba68a2372e0');
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


<div id="df-182627ec-6024-461a-84fc-d0dc6700138e">
  <button class="colab-df-quickchart" onclick="quickchart('df-182627ec-6024-461a-84fc-d0dc6700138e')"
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
        document.querySelector('#df-182627ec-6024-461a-84fc-d0dc6700138e button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_700fe135-b598-4c97-a195-3734400b8083">
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
    <button class="colab-df-generate" onclick="generateWithVariable('pca_df')"
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
        document.querySelector('#id_700fe135-b598-4c97-a195-3734400b8083 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('pca_df');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 클러스터 개수 확인
cluster_counts = pca_df['cluster'].value_counts()
print("Cluster Counts:")
print(cluster_counts)
```

    Cluster Counts:
    cluster
    0    4429
    2    1751
    1    1680
    Name: count, dtype: int64
    

### 문제25 : K-means 결과 해석하기
- 위 클러스터링 결과를 시각화해보세요.
- K-means의 결과를 해석해봅시다.

  - 각 클러스터별로 고객들은 어떤 특징을 가지나요?
  - 위 분석을 토대로 대출 서비스를 제안한다면, 어떤 전략이 좋을까요?


```python
# 클러스터링 결과 시각화
plt.figure(figsize=(10, 6))
sns.scatterplot(x='PC1', y='PC2', hue='cluster', data=pca_df, palette='bright', s=100)
plt.title('K-Means Clustering on PCA')
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.legend(title='Cluster')
plt.grid()
plt.show()
```


    
![png](/assets/img/clustering3/19.png)
    



```python
# PCA 모델 학습
pca = PCA(n_components=2)
pca.fit(data24)

# 주성분 로딩 값 확인
loadings = pd.DataFrame(pca.components_.T, columns=['PC1', 'PC2'], index=data24.columns)
print(loadings)
```

                                           PC1       PC2
    BALANCE                          -0.090241  0.420046
    BALANCE_FREQUENCY                 0.069763  0.228970
    PURCHASES                         0.383308  0.167065
    ONEOFF_PURCHASES                  0.285660  0.174522
    INSTALLMENTS_PURCHASES            0.328199  0.071088
    CASH_ADVANCE                     -0.188539  0.361044
    PURCHASES_FREQUENCY               0.378707  0.007411
    ONEOFF_PURCHASES_FREQUENCY        0.273971  0.140280
    PURCHASES_INSTALLMENTS_FREQUENCY  0.320547 -0.021894
    CASH_ADVANCE_FREQUENCY           -0.220366  0.343392
    CASH_ADVANCE_TRX                 -0.201693  0.349779
    PURCHASES_TRX                     0.383084  0.128441
    CREDIT_LIMIT                      0.089493  0.256660
    PAYMENTS                          0.110606  0.295697
    MINIMUM_PAYMENTS                 -0.054220  0.354595
    PRC_FULL_PAYMENT                  0.174370 -0.137956
    TENURE                            0.066260  0.048020
    

- PC1 : 구매관련변수에 영향력있음  
- PC2 : 잔액, 현금서비스, 지불액 관련 변수가 영향력있음


```python
data24['cluster'] = pca_df['cluster']
data24
```





  <div id="df-a601ac73-9a12-4bad-ba63-55c02d5002ac" class="colab-df-container">
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
      <th>BALANCE</th>
      <th>BALANCE_FREQUENCY</th>
      <th>PURCHASES</th>
      <th>ONEOFF_PURCHASES</th>
      <th>INSTALLMENTS_PURCHASES</th>
      <th>CASH_ADVANCE</th>
      <th>PURCHASES_FREQUENCY</th>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <th>CASH_ADVANCE_TRX</th>
      <th>PURCHASES_TRX</th>
      <th>CREDIT_LIMIT</th>
      <th>PAYMENTS</th>
      <th>MINIMUM_PAYMENTS</th>
      <th>PRC_FULL_PAYMENT</th>
      <th>TENURE</th>
      <th>cluster</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.759182</td>
      <td>-0.215160</td>
      <td>-0.647033</td>
      <td>-0.562980</td>
      <td>-0.438501</td>
      <td>-0.554363</td>
      <td>-0.781661</td>
      <td>-0.655331</td>
      <td>-0.686195</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.642690</td>
      <td>-0.963550</td>
      <td>-0.757062</td>
      <td>-0.619400</td>
      <td>-0.519489</td>
      <td>0.342764</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.133650</td>
      <td>0.157721</td>
      <td>-0.749808</td>
      <td>-0.562980</td>
      <td>-0.636448</td>
      <td>4.353579</td>
      <td>-1.201814</td>
      <td>-0.655331</td>
      <td>-0.899241</td>
      <td>0.741303</td>
      <td>0.340613</td>
      <td>-0.777379</td>
      <td>0.886997</td>
      <td>2.054140</td>
      <td>0.838968</td>
      <td>0.253563</td>
      <td>0.342764</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.710178</td>
      <td>0.530603</td>
      <td>0.083138</td>
      <td>0.554513</td>
      <td>-0.636448</td>
      <td>-0.554363</td>
      <td>1.319102</td>
      <td>2.889269</td>
      <td>-0.899241</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>0.030750</td>
      <td>1.041209</td>
      <td>-0.454222</td>
      <td>0.143178</td>
      <td>-0.519489</td>
      <td>0.342764</td>
      <td>2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.214168</td>
      <td>-0.960924</td>
      <td>0.865084</td>
      <td>1.603584</td>
      <td>-0.636448</td>
      <td>-0.397603</td>
      <td>-0.991739</td>
      <td>-0.359948</td>
      <td>-0.899241</td>
      <td>-0.207402</td>
      <td>-0.352608</td>
      <td>-0.710034</td>
      <td>1.041209</td>
      <td>-0.902479</td>
      <td>-0.837506</td>
      <td>-0.519489</td>
      <td>0.342764</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-0.294103</td>
      <td>0.530603</td>
      <td>-0.732571</td>
      <td>-0.539855</td>
      <td>-0.636448</td>
      <td>-0.554363</td>
      <td>-0.991739</td>
      <td>-0.359948</td>
      <td>-0.899241</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.710034</td>
      <td>-0.901865</td>
      <td>-0.413676</td>
      <td>-0.454805</td>
      <td>-0.519489</td>
      <td>0.342764</td>
      <td>0</td>
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
    </tr>
    <tr>
      <th>7855</th>
      <td>-0.770882</td>
      <td>0.530603</td>
      <td>-0.520481</td>
      <td>-0.562980</td>
      <td>-0.194761</td>
      <td>-0.554363</td>
      <td>1.319102</td>
      <td>-0.655331</td>
      <td>1.292097</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.305970</td>
      <td>-0.963550</td>
      <td>-0.780185</td>
      <td>-0.675873</td>
      <td>2.959249</td>
      <td>-4.300677</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7856</th>
      <td>-0.399733</td>
      <td>0.530603</td>
      <td>0.058177</td>
      <td>0.521025</td>
      <td>-0.636448</td>
      <td>-0.554363</td>
      <td>-0.841684</td>
      <td>-0.148960</td>
      <td>-0.899241</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.710034</td>
      <td>-0.963550</td>
      <td>-0.826397</td>
      <td>-0.364203</td>
      <td>-0.519489</td>
      <td>-4.300677</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7857</th>
      <td>-0.570467</td>
      <td>0.530603</td>
      <td>-0.248858</td>
      <td>0.109103</td>
      <td>-0.636448</td>
      <td>-0.554363</td>
      <td>-0.841684</td>
      <td>-0.148960</td>
      <td>-0.899241</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.710034</td>
      <td>-0.963550</td>
      <td>-0.816891</td>
      <td>-0.666743</td>
      <td>-0.519489</td>
      <td>-4.300677</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7858</th>
      <td>-0.765283</td>
      <td>-2.399186</td>
      <td>-0.002778</td>
      <td>-0.562980</td>
      <td>0.802339</td>
      <td>-0.554363</td>
      <td>0.598841</td>
      <td>-0.655331</td>
      <td>0.561652</td>
      <td>-0.681752</td>
      <td>-0.583682</td>
      <td>-0.305970</td>
      <td>-0.963550</td>
      <td>-0.070540</td>
      <td>-0.812721</td>
      <td>-0.519489</td>
      <td>-4.300677</td>
      <td>0</td>
    </tr>
    <tr>
      <th>7859</th>
      <td>-0.558230</td>
      <td>-0.055354</td>
      <td>-0.189605</td>
      <td>-0.158285</td>
      <td>-0.138469</td>
      <td>0.343290</td>
      <td>0.958971</td>
      <td>-0.148960</td>
      <td>0.926875</td>
      <td>3.384121</td>
      <td>1.495983</td>
      <td>-0.305970</td>
      <td>-0.963550</td>
      <td>-0.232748</td>
      <td>-0.675028</td>
      <td>0.176258</td>
      <td>-4.300677</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>7860 rows × 18 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-a601ac73-9a12-4bad-ba63-55c02d5002ac')"
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
        document.querySelector('#df-a601ac73-9a12-4bad-ba63-55c02d5002ac button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-a601ac73-9a12-4bad-ba63-55c02d5002ac');
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


<div id="df-03dc1f89-1d6b-4047-9058-ec546dab40f6">
  <button class="colab-df-quickchart" onclick="quickchart('df-03dc1f89-1d6b-4047-9058-ec546dab40f6')"
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
        document.querySelector('#df-03dc1f89-1d6b-4047-9058-ec546dab40f6 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_5309a88a-5407-480f-bef5-f8b0494d3fa4">
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
    <button class="colab-df-generate" onclick="generateWithVariable('data24')"
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
        document.querySelector('#id_5309a88a-5407-480f-bef5-f8b0494d3fa4 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('data24');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 클러스터별 고객 특성 파악하기
mask1 = data24.groupby('cluster').mean()
mask1['cluster_counts'] = data24['cluster'].value_counts()
mask1.T
```





  <div id="df-1881d0c7-e4ac-4c43-9e53-95b6556c3b9b" class="colab-df-container">
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
      <th>cluster</th>
      <th>0</th>
      <th>1</th>
      <th>2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>BALANCE</th>
      <td>-0.423397</td>
      <td>1.109025</td>
      <td>0.006890</td>
    </tr>
    <tr>
      <th>BALANCE_FREQUENCY</th>
      <td>-0.297038</td>
      <td>0.366001</td>
      <td>0.400171</td>
    </tr>
    <tr>
      <th>PURCHASES</th>
      <td>-0.379753</td>
      <td>-0.477710</td>
      <td>1.418891</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES</th>
      <td>-0.314337</td>
      <td>-0.320109</td>
      <td>1.102216</td>
    </tr>
    <tr>
      <th>INSTALLMENTS_PURCHASES</th>
      <td>-0.279808</td>
      <td>-0.461005</td>
      <td>1.150061</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE</th>
      <td>-0.373524</td>
      <td>1.327753</td>
      <td>-0.329119</td>
    </tr>
    <tr>
      <th>PURCHASES_FREQUENCY</th>
      <td>-0.158581</td>
      <td>-0.708416</td>
      <td>1.080807</td>
    </tr>
    <tr>
      <th>ONEOFF_PURCHASES_FREQUENCY</th>
      <td>-0.300788</td>
      <td>-0.329786</td>
      <td>1.077230</td>
    </tr>
    <tr>
      <th>PURCHASES_INSTALLMENTS_FREQUENCY</th>
      <td>-0.107056</td>
      <td>-0.613825</td>
      <td>0.859723</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_FREQUENCY</th>
      <td>-0.367145</td>
      <td>1.359571</td>
      <td>-0.375781</td>
    </tr>
    <tr>
      <th>CASH_ADVANCE_TRX</th>
      <td>-0.368886</td>
      <td>1.332030</td>
      <td>-0.344954</td>
    </tr>
    <tr>
      <th>PURCHASES_TRX</th>
      <td>-0.338236</td>
      <td>-0.513253</td>
      <td>1.347979</td>
    </tr>
    <tr>
      <th>CREDIT_LIMIT</th>
      <td>-0.347275</td>
      <td>0.400359</td>
      <td>0.494277</td>
    </tr>
    <tr>
      <th>PAYMENTS</th>
      <td>-0.404550</td>
      <td>0.453219</td>
      <td>0.588431</td>
    </tr>
    <tr>
      <th>MINIMUM_PAYMENTS</th>
      <td>-0.360473</td>
      <td>0.878280</td>
      <td>0.069117</td>
    </tr>
    <tr>
      <th>PRC_FULL_PAYMENT</th>
      <td>0.006958</td>
      <td>-0.429023</td>
      <td>0.394028</td>
    </tr>
    <tr>
      <th>TENURE</th>
      <td>-0.065700</td>
      <td>-0.060773</td>
      <td>0.224490</td>
    </tr>
    <tr>
      <th>cluster_counts</th>
      <td>4429.000000</td>
      <td>1680.000000</td>
      <td>1751.000000</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-1881d0c7-e4ac-4c43-9e53-95b6556c3b9b')"
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
        document.querySelector('#df-1881d0c7-e4ac-4c43-9e53-95b6556c3b9b button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-1881d0c7-e4ac-4c43-9e53-95b6556c3b9b');
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


<div id="df-099fb8bc-51b0-42c2-ae8d-01eb157946cf">
  <button class="colab-df-quickchart" onclick="quickchart('df-099fb8bc-51b0-42c2-ae8d-01eb157946cf')"
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
        document.querySelector('#df-099fb8bc-51b0-42c2-ae8d-01eb157946cf button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




- **클러스터별 고객 특성**
   - 클러스터 0 : 잔액이 가장 적은 고객. 총구매액과 구매빈도가 비교적 낮은 고객. 현금서비스 이용이 낮은 고객. 신용한도는 비교적 낮은 고객. 총 지불액이 가장 낮고 최소 지불액도 가장낮은 고객.
   - 클러스터 1 : 잔액을 가장 많이 보유한 고객. 총구매액과 구매빈도가 가장 낮은 고객. 현금서비스 인출 금액과 빈도, 거래 횟수가 가장 높은 고객. 신용 한도는 비교적 높은 고객. 총 지불액은 비교적 높고 최소 지불액이 가장 높은 고객.
   - 클러스터 2 : 평균적인 잔액 보유 고객. 총구매액과 구매빈도가 가장 높은 고객. 현금서비스 이용이 낮은 고객. 신용한도는 가장 높은 고객. 총 지불액이 가장 높고 최소 지불액은 평균인 고객.

- **군집별 대출서비스 제안**
   - 클러스터 0 : 잔액이 낮아 현금서비스 이용을 유도해야한다. 소액대출 서비스나 장기대출 서비스 혹은 낮은 이자율로 단기대출 서비스 등을 제공하여 현금을 마련할수있도록 유도하고 구매를 촉진
   - 클러스터 1 : 잔액과 현금서비스 이용도 높고 구매빈도는 낮지만 최소지불액은 높은것으로보아 고가형 상품을 구매하는 고객으로 판단된다. 이들이 고가형 상품을 구매할수있도록 흥미있는 상품들을 제시함과 동시에 고가상품 대상으로 잔액과 신용한도 등을 고려하여 합리적인 대출서비스를 제안하여 구매를 촉진한다.   
   - 클러스터 2 : 구매빈도에 따른 대출 이자율 할인 등으로 충성고객에 맞춤형 대출서비스를 제안한다. 이들은 현금서비스 이용률이 높지않아 소액대출 등의 금전적인 부담이 적은 대출을 제안할 필요가 있다

### 문제26 : PCA를 활용한 차원 축소 후 계층적 클러스터링
- PCA를 통해 차원 축소한 데이터를 사용하여 계층적 클러스터링을 수행하고 덴드로그램을 시각화하세요.


```python
from scipy.cluster.hierarchy import dendrogram, linkage, cut_tree
import matplotlib.pyplot as plt

# 거리 : ward method 사용
model = linkage(pca_transformed, 'ward')  # single, complete, average, centroid, median 등

# 덴드로그램 사이즈와 스타일 조정
plt.figure(figsize=(10, 7))
dendrogram(model, orientation='top', distance_sort='descending', show_leaf_counts=True)
plt.title('Hierarchical Clustering Dendrogram')
plt.show()
```


    
![png](/assets/img/clustering3/20.png)
    


### 문제27 : PCA를 활용한 차원 축소 후 DBSCAN 클러스터링
- PCA를 통해 차원 축소한 데이터를 사용하여 DBSCAN 클러스터링을 수행하고 결과를 시각화하세요.


```python
from sklearn.cluster import DBSCAN

# DBSCAN 모델 학습
dbscan_pca = DBSCAN(eps=0.5, min_samples=5)
dbscan_pca.fit(pca_transformed)

# 클러스터 할당 결과
pca_df_dbscan = pd.DataFrame(data=pca_transformed, columns=['PC1', 'PC2'])
pca_df_dbscan['Cluster'] = dbscan_pca.labels_

# 클러스터링 결과 시각화
plt.figure(figsize=(10, 6))
plt.scatter(pca_df_dbscan['PC1'], pca_df_dbscan['PC2'], c=pca_df_dbscan['Cluster'], cmap='viridis')
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.title('DBSCAN Clustering on PCA-Reduced Data (2D)')
plt.show()

```


    
![png](/assets/img/clustering3/21.png)
    


### 문제28 : PCA를 활용한 차원 축소 후 GMM 클러스터링
- PCA를 통해 차원 축소한 데이터를 사용하여 GMM 클러스터링을 수행하고 결과를 시각화하세요.


```python
from sklearn.mixture import GaussianMixture

# GMM 모델 학습
gmm_pca = GaussianMixture(n_components=3, random_state=42)
gmm_pca.fit(pca_transformed)

# 클러스터 할당 결과
pca_df_gmm = pd.DataFrame(data=pca_transformed, columns=['PC1', 'PC2'])
pca_df_gmm['Cluster'] = gmm_pca.predict(pca_transformed)

# 클러스터링 결과 시각화
plt.figure(figsize=(10, 6))
plt.scatter(pca_df_gmm['PC1'], pca_df_gmm['PC2'], c=pca_df_gmm['Cluster'], cmap='viridis')
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.title('GMM Clustering on PCA-Reduced Data (2D)')
plt.show()

```


    
![png](/assets/img/clustering3/22.png)
    


### 문제29 : 원본 데이터와 차원 축소 데이터를 사용한 클러스터링 결과 비교
- 원본 데이터와 차원 축소 데이터를 사용하여 다양한 클러스터링 기법을 적용한 결과를 비교해보세요.


```python
# 위에 분석한 내용을 바탕으로 자유롭게 의견을 작성해주세요.
```


```python
data28 = data24.copy()
data28['label'] = cut_tree(model, 5)
```


```python
print("K-means 클러스터 수:\n", data10['cluster'].value_counts())
print("PCA K-means 클러스터 수:\n", pca_df['cluster'].value_counts())

print("K-means : \n", data10.groupby('cluster')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
print("PCA K-means : \n", data24.groupby('cluster')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
```

    K-means 클러스터 수:
     cluster
    0    4610
    1    1653
    2    1597
    Name: count, dtype: int64
    PCA K-means 클러스터 수:
     cluster
    0    4429
    2    1751
    1    1680
    Name: count, dtype: int64
    K-means : 
               BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    cluster                                             
    0       -0.394715  -0.373719     -0.367362 -0.391423
    1        0.005521   1.493598     -0.337212  0.623774
    2        1.133694  -0.467172      1.409488  0.484259
    PCA K-means : 
               BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    cluster                                             
    0       -0.423397  -0.379753     -0.373524 -0.404550
    1        1.109025  -0.477710      1.327753  0.453219
    2        0.006890   1.418891     -0.329119  0.588431
    

- K-means 클러스터는 PCA 전/후 집단별 표본수는 비슷하다.
- 클러스터별 변수 데이터 평균또한 PCA에 의해 달라지지도 명확해지지도 않았다.


```python
print("계층적 클러스터링 클러스터 수:\n", data12['label'].value_counts())
print("PCA 계층적 클러스터링 클러스터 수:\n", data28['label'].value_counts())

print("계층적 클러스터링 : \n", data12.groupby('label')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
print("PCA 계층적 클러스터링 : \n", data28.groupby('label')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
```

    계층적 클러스터링 클러스터 수:
     label
    2    2971
    0    2780
    1    1135
    4     570
    3     404
    Name: count, dtype: int64
    PCA 계층적 클러스터링 클러스터 수:
     label
    0    2507
    3    2003
    4    1928
    2     965
    1     457
    Name: count, dtype: int64
    계층적 클러스터링 : 
             BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    label                                             
    0     -0.316863  -0.507112     -0.309739 -0.394281
    1      1.143575  -0.555477      1.630805  0.605988
    2     -0.091108   0.371079     -0.323698  0.044065
    3      0.072240   2.703237     -0.344377  1.284015
    4     -0.308039  -0.270784      0.194640 -0.423429
    PCA 계층적 클러스터링 : 
             BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    label                                             
    0     -0.585739  -0.354672     -0.520650 -0.496698
    1      2.132258  -0.527027      2.378315  0.887991
    2      0.769819   0.304411      0.411214  0.564403
    3      0.112583  -0.706605      0.356102 -0.184201
    4     -0.246044   1.167836     -0.462507  0.344250
    

- 계층적 클러스터링은 PCA 사용후 좀 더 고르게 군집별 표본이 분포되었다
- 데이터또한 PCA 사용후 vip집단(클러스터1), 저소득 혹은 저지출(클러스터0) 등 집단 특성이 명확해졌고, 클러스터3같이 평균의 잔액에서 구매금액이 낮은 유형의 고객들을 파악할수있었다


```python
data29 = data24.copy()
data29['cluster'] = pca_df_dbscan['Cluster']
```


```python
print("DBSCAN 클러스터 수:\n", data14['cluster'].value_counts())
print("PCA DBSCAN 클러스터 수:\n", data29['cluster'].value_counts())

print("DBSCAN : \n", data14.groupby('cluster')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
print("PCA DBSCAN : \n", data29.groupby('cluster')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())

```

    DBSCAN 클러스터 수:
     cluster
    -1     4891
     0     2711
     9       47
     4       28
     2       16
     6       15
     13      12
     1       10
     20       8
     11       7
     17       7
     12       7
     27       7
     28       7
     23       6
     5        6
     10       6
     15       6
     7        6
     3        6
     26       5
     19       5
     22       5
     24       5
     8        5
     18       5
     16       5
     29       5
     14       4
     25       4
     21       3
    Name: count, dtype: int64
    PCA DBSCAN 클러스터 수:
     cluster
     0    7804
    -1      47
     1       5
     2       4
    Name: count, dtype: int64
    DBSCAN : 
               BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    cluster                                             
    -1       0.204454   0.308840      0.220776  0.316698
     0      -0.332428  -0.517793     -0.371473 -0.525591
     1      -0.750215  -0.252501     -0.554363 -0.591529
     2      -0.246830  -0.726132      0.385987 -0.543469
     3       1.865787  -0.736625      0.180720 -0.023997
     4      -0.121388  -0.705041     -0.344316 -0.633206
     5      -0.699802  -0.337088     -0.554363 -0.592240
     6      -0.636324  -0.303431     -0.542537 -0.665515
     7      -0.752321  -0.128951     -0.554363 -0.492969
     8      -0.734494   0.252138     -0.554363 -0.279774
     9      -0.782024  -0.407821     -0.554363 -0.690939
     10      2.264016  -0.737627      1.372147  0.015497
     11     -0.590144  -0.749808      0.344613  0.998125
     12     -0.758299  -0.398275     -0.554363 -0.710500
     13     -0.753246  -0.111330     -0.554363 -0.423695
     14     -0.734383  -0.118559     -0.554363 -0.538804
     15     -0.766121  -0.458413     -0.554363 -0.740171
     16      3.126313  -0.749808      1.449965  0.255077
     17     -0.752260  -0.510008     -0.554363 -0.763259
     18     -0.663792   1.271664     -0.554363  0.358995
     19     -0.725419   0.450775     -0.554363 -0.015808
     20     -0.759766  -0.231603     -0.554363 -0.599557
     21     -0.315080   0.152215     -0.554363 -0.355780
     22      0.280371  -0.741190      1.052935  0.860523
     23     -0.730730  -0.463189     -0.554363 -0.826363
     24     -0.238408  -0.749808      0.327747 -0.760784
     25     -0.514970  -0.749808      0.060645 -0.517330
     26     -0.772262  -0.576344     -0.554363 -0.611633
     27     -0.169226  -0.732417     -0.272267 -0.765029
     28     -0.764356  -0.343223     -0.554363 -0.668904
     29     -0.754164  -0.494573     -0.554363 -0.765622
    PCA DBSCAN : 
               BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    cluster                                             
    -1       2.226393   2.788045      1.783141  2.299069
     0      -0.016820  -0.017252     -0.014855 -0.016116
     1       2.652106   0.180706      3.955163  2.736456
     2       3.341396   0.673516      3.086260  1.008206
    

- DBSCAN은 차원축소를 통해 노이즈를 대폭감소하였다(4,891개 → 47개)
- 다만, 클러스터0에서 대부분의 데이터가 모여있어 데이터를 구분하지 못하였다고 할수있다
- eps와 최소샘플등을 조정하거나 추가적인 모델개선작업이 필요하다


```python
data30 = data24.copy()
data30['cluster'] = pca_df_gmm['Cluster']
```


```python
print("GMM 클러스터 수:\n", data15['gmm_label'].value_counts())
print("PCA GMM 클러스터 수:\n", data30['cluster'].value_counts())

print("GMM : \n", data15.groupby('gmm_label')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
print("PCA GMM : \n", data30.groupby('cluster')[['BALANCE', 'PURCHASES', 'CASH_ADVANCE', 'PAYMENTS']].mean())
```

    GMM 클러스터 수:
     gmm_label
    1    3534
    2    2572
    0    1754
    Name: count, dtype: int64
    PCA GMM 클러스터 수:
     cluster
    1    3824
    2    2394
    0    1642
    Name: count, dtype: int64
    GMM : 
                 BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    gmm_label                                             
    0          0.567485   0.456135      0.431318  0.452079
    1         -0.483555   0.274891     -0.554274 -0.174449
    2          0.277416  -0.688774      0.467447 -0.068601
    PCA GMM : 
               BALANCE  PURCHASES  CASH_ADVANCE  PAYMENTS
    cluster                                             
    0        0.863400   1.118011      0.511977  0.955534
    1       -0.488237  -0.038512     -0.493579 -0.305846
    2        0.187684  -0.705306      0.437251 -0.166847
    

- GMM은 차원축소 전과 후의 군집별 표본차이는 비슷하게 나왔다.
- 다만, 클러스터 0처럼 일부 군집은 데이터 특성이 좀 더 명확하게 관찰되었다.
