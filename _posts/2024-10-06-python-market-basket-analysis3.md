---
#layout: post
title: 파이썬 데이터분석 - 장바구니 분석(연관분석)2 - FP-Growth, 순차패턴마이닝
date: 2024-10-06
description: # 검색어 및 글요약
categories: [Data_analysis, Python_DA_Library]        # 메인 카테고리, 하위 카테고리(생략가능)
tags:           # 반드시 소문자로 작성, 한글가능
- Market Basket Analysis
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


## FP-Growth 알고리즘
- `FP-Growth 알고리즘`은 최소지지도 이상인 아이템에만 주목하는 Apriori 알고리즘의 접근 방법을 비슷하게 가져오되, 트리 구조를 활용하여 속도를 개선시킨 방법론을 말한다
- 트리 구조를 활용해 빈발 항목 집합을 찾아내어 데이터셋을 반복적으로 스캔하는 Apriori 알고리즘의 단점을 보완한다
- 파이썬 mlxtend 라이브러리를 활용하여 FP-Growth 알고리즘을 적용해 볼 수 있다

### FP-Growth 알고리즘의 프로세스
1. 각각의 상품으로 단일 항목 집합을 만들고 최소 지지도 이상의 상품만 골라낸다
2. 1단계에서 제거한 상품을 데이터에서 제외한 후, 로우마다 상품 순서를 빈도순으로 재정렬한다
3. 정리한 데이터를 기준으로 FP-TRee를 생성한다
4. 완성된 FP-Tree를 활용해 최소 지지도를 넘는 조합을 추출한다
5. 최종적으로 선별된 빈발 항목 집합들을 기준으로 연관 규칙을 찾고, 규칙 간 비교를 위한 지표를 계산해 가장 적합한 규칙을 선별한다

### 파이썬으로 FP-Growth 알고리즘 구현


```python
# 데이터 준비 및 전처리
import pandas as pd
from mlxtend.preprocessing import TransactionEncoder

# 필요한 데이터를 불러옵니다.
df = pd.read_csv('/content/drive/MyDrive/data/retail_data.csv')

# 결제 건별로 로우를 재정비합니다.
basket_df = df.groupby('OrderID')['ProdName'].apply(list).reset_index()

# TransactionEncoder를 활용해 데이터를 One-Hot Encoding합니다.
te = TransactionEncoder()
te_result = te.fit_transform(basket_df['ProdName'])

# 위의 결과물을 DataFrame에 담아 te_df라는 이름으로 저장합니다.
te_df = pd.DataFrame(te_result, columns=te.columns_)
te_df.head()
```





  <div id="df-d717c472-5886-4225-bc48-bb01bfd7aad2" class="colab-df-container">
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
      <th>4 PURPLE FLOCK DINNER CANDLES</th>
      <th>SET 2 TEA TOWELS I LOVE LONDON</th>
      <th>10 COLOUR SPACEBOY PEN</th>
      <th>12 COLOURED PARTY BALLOONS</th>
      <th>12 DAISY PEGS IN WOOD BOX</th>
      <th>12 MESSAGE CARDS WITH ENVELOPES</th>
      <th>12 PENCIL SMALL TUBE WOODLAND</th>
      <th>12 PENCILS SMALL TUBE RED RETROSPOT</th>
      <th>12 PENCILS SMALL TUBE SKULL</th>
      <th>12 PENCILS TALL TUBE POSY</th>
      <th>...</th>
      <th>WRAP, BILLBOARD FONTS DESIGN</th>
      <th>YELLOW BREAKFAST CUP AND SAUCER</th>
      <th>YELLOW COAT RACK PARIS FASHION</th>
      <th>YELLOW GIANT GARDEN THERMOMETER</th>
      <th>YELLOW SHARK HELICOPTER</th>
      <th>YOU'RE CONFUSING ME METAL SIGN</th>
      <th>YULETIDE IMAGES GIFT WRAP SET</th>
      <th>ZINC FINISH 15CM PLANTER POTS</th>
      <th>ZINC METAL HEART DECORATION</th>
      <th>ZINC WILLIE WINKIE  CANDLE STICK</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>1</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>3</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>True</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>4</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>...</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 1343 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-d717c472-5886-4225-bc48-bb01bfd7aad2')"
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
        document.querySelector('#df-d717c472-5886-4225-bc48-bb01bfd7aad2 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-d717c472-5886-4225-bc48-bb01bfd7aad2');
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


<div id="df-b03e9207-cc88-4678-ba1e-b29686396fd0">
  <button class="colab-df-quickchart" onclick="quickchart('df-b03e9207-cc88-4678-ba1e-b29686396fd0')"
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
        document.querySelector('#df-b03e9207-cc88-4678-ba1e-b29686396fd0 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# FP-Growth 알고리즘 구현 : fpgrowth 함수 사용
from mlxtend.frequent_patterns import fpgrowth

# 최소 지지도 0.06
frequent_itemsets = fpgrowth(te_df, min_support=0.06, use_colnames=True)
frequent_itemsets
```





  <div id="df-85f18863-b93e-4d12-8616-4c448e95ec2f" class="colab-df-container">
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
      <th>support</th>
      <th>itemsets</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.137037</td>
      <td>(WHITE HANGING HEART T-LIGHT HOLDER)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.103704</td>
      <td>(RED WOOLLY HOTTIE WHITE HEART.)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.096296</td>
      <td>(SET 7 BABUSHKA NESTING BOXES)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.085185</td>
      <td>(KNITTED UNION FLAG HOT WATER BOTTLE)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.066667</td>
      <td>(CREAM CUPID HEARTS COAT HANGER)</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>56</th>
      <td>0.062963</td>
      <td>(GLASS STAR FROSTED T-LIGHT HOLDER, RED WOOLLY...</td>
    </tr>
    <tr>
      <th>57</th>
      <td>0.062963</td>
      <td>(WHITE HANGING HEART T-LIGHT HOLDER, KNITTED U...</td>
    </tr>
    <tr>
      <th>58</th>
      <td>0.062963</td>
      <td>(HAND WARMER RED POLKA DOT, HAND WARMER UNION ...</td>
    </tr>
    <tr>
      <th>59</th>
      <td>0.062963</td>
      <td>(WOOD 2 DRAWER CABINET WHITE FINISH, WHITE HAN...</td>
    </tr>
    <tr>
      <th>60</th>
      <td>0.062963</td>
      <td>(WOODEN FRAME ANTIQUE WHITE , WOOD S/3 CABINET...</td>
    </tr>
  </tbody>
</table>
<p>61 rows × 2 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-85f18863-b93e-4d12-8616-4c448e95ec2f')"
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
        document.querySelector('#df-85f18863-b93e-4d12-8616-4c448e95ec2f button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-85f18863-b93e-4d12-8616-4c448e95ec2f');
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


<div id="df-ccd1050f-7d2b-41e5-9f0d-4a8605227745">
  <button class="colab-df-quickchart" onclick="quickchart('df-ccd1050f-7d2b-41e5-9f0d-4a8605227745')"
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
        document.querySelector('#df-ccd1050f-7d2b-41e5-9f0d-4a8605227745 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_15693889-b525-4459-93b5-f3a201d1965f">
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
    <button class="colab-df-generate" onclick="generateWithVariable('frequent_itemsets')"
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
        document.querySelector('#id_15693889-b525-4459-93b5-f3a201d1965f button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('frequent_itemsets');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
# 연관 규칙 추출 및 평가
from mlxtend.frequent_patterns import association_rules

# 최소 신뢰도 0.8
association_rules(frequent_itemsets, metric='confidence', min_threshold=0.8)
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    





  <div id="df-fda5445d-1b14-42e2-9eae-772cb969b358" class="colab-df-container">
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
      <th>antecedents</th>
      <th>consequents</th>
      <th>antecedent support</th>
      <th>consequent support</th>
      <th>support</th>
      <th>confidence</th>
      <th>lift</th>
      <th>leverage</th>
      <th>conviction</th>
      <th>zhangs_metric</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>(SET 7 BABUSHKA NESTING BOXES, WHITE HANGING H...</td>
      <td>(RED WOOLLY HOTTIE WHITE HEART.)</td>
      <td>0.062963</td>
      <td>0.103704</td>
      <td>0.062963</td>
      <td>1.000000</td>
      <td>9.642857</td>
      <td>0.056433</td>
      <td>inf</td>
      <td>0.956522</td>
    </tr>
    <tr>
      <th>1</th>
      <td>(SET 7 BABUSHKA NESTING BOXES, RED WOOLLY HOTT...</td>
      <td>(WHITE HANGING HEART T-LIGHT HOLDER)</td>
      <td>0.062963</td>
      <td>0.137037</td>
      <td>0.062963</td>
      <td>1.000000</td>
      <td>7.297297</td>
      <td>0.054335</td>
      <td>inf</td>
      <td>0.920949</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(WHITE HANGING HEART T-LIGHT HOLDER, RED WOOLL...</td>
      <td>(SET 7 BABUSHKA NESTING BOXES)</td>
      <td>0.070370</td>
      <td>0.096296</td>
      <td>0.062963</td>
      <td>0.894737</td>
      <td>9.291498</td>
      <td>0.056187</td>
      <td>8.585185</td>
      <td>0.959925</td>
    </tr>
    <tr>
      <th>3</th>
      <td>(KNITTED UNION FLAG HOT WATER BOTTLE)</td>
      <td>(RED WOOLLY HOTTIE WHITE HEART.)</td>
      <td>0.085185</td>
      <td>0.103704</td>
      <td>0.074074</td>
      <td>0.869565</td>
      <td>8.385093</td>
      <td>0.065240</td>
      <td>6.871605</td>
      <td>0.962753</td>
    </tr>
    <tr>
      <th>4</th>
      <td>(KNITTED UNION FLAG HOT WATER BOTTLE)</td>
      <td>(WHITE HANGING HEART T-LIGHT HOLDER)</td>
      <td>0.085185</td>
      <td>0.137037</td>
      <td>0.070370</td>
      <td>0.826087</td>
      <td>6.028202</td>
      <td>0.058697</td>
      <td>4.962037</td>
      <td>0.911784</td>
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
    </tr>
    <tr>
      <th>154</th>
      <td>(GLASS STAR FROSTED T-LIGHT HOLDER)</td>
      <td>(WHITE METAL LANTERN, WHITE HANGING HEART T-LI...</td>
      <td>0.066667</td>
      <td>0.062963</td>
      <td>0.062963</td>
      <td>0.944444</td>
      <td>15.000000</td>
      <td>0.058765</td>
      <td>16.866667</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>155</th>
      <td>(WHITE METAL LANTERN)</td>
      <td>(GLASS STAR FROSTED T-LIGHT HOLDER, WHITE HANG...</td>
      <td>0.066667</td>
      <td>0.062963</td>
      <td>0.062963</td>
      <td>0.944444</td>
      <td>15.000000</td>
      <td>0.058765</td>
      <td>16.866667</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>156</th>
      <td>(HAND WARMER RED POLKA DOT)</td>
      <td>(HAND WARMER UNION JACK)</td>
      <td>0.066667</td>
      <td>0.118519</td>
      <td>0.062963</td>
      <td>0.944444</td>
      <td>7.968750</td>
      <td>0.055062</td>
      <td>15.866667</td>
      <td>0.936975</td>
    </tr>
    <tr>
      <th>157</th>
      <td>(WOOD 2 DRAWER CABINET WHITE FINISH)</td>
      <td>(WHITE HANGING HEART T-LIGHT HOLDER)</td>
      <td>0.066667</td>
      <td>0.137037</td>
      <td>0.062963</td>
      <td>0.944444</td>
      <td>6.891892</td>
      <td>0.053827</td>
      <td>15.533333</td>
      <td>0.915966</td>
    </tr>
    <tr>
      <th>158</th>
      <td>(WOOD S/3 CABINET ANT WHITE FINISH)</td>
      <td>(WOODEN FRAME ANTIQUE WHITE )</td>
      <td>0.066667</td>
      <td>0.081481</td>
      <td>0.062963</td>
      <td>0.944444</td>
      <td>11.590909</td>
      <td>0.057531</td>
      <td>16.533333</td>
      <td>0.978992</td>
    </tr>
  </tbody>
</table>
<p>159 rows × 10 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-fda5445d-1b14-42e2-9eae-772cb969b358')"
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
        document.querySelector('#df-fda5445d-1b14-42e2-9eae-772cb969b358 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-fda5445d-1b14-42e2-9eae-772cb969b358');
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


<div id="df-f756f4df-39e5-47cb-8d9d-8478726c6cda">
  <button class="colab-df-quickchart" onclick="quickchart('df-f756f4df-39e5-47cb-8d9d-8478726c6cda')"
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
        document.querySelector('#df-f756f4df-39e5-47cb-8d9d-8478726c6cda button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




### FP-Growth 알고리즘 실습


```python
import pandas as pd
from mlxtend.preprocessing import TransactionEncoder
from mlxtend.frequent_patterns import fpgrowth
from mlxtend.frequent_patterns import association_rules

df = pd.read_csv('/content/drive/MyDrive/data/shopping_data.csv')

df2 = df[['invoice_no', 'category']]
basket_df = df2.groupby('invoice_no')['category'].apply(list).reset_index()


# TransactionEncoder로 추가 전처리
te = TransactionEncoder()

te_result = te.fit_transform(basket_df['category'])  # 여기에 코드를 작성하세요

te_df = pd.DataFrame(te_result, columns=te.columns_)


# FP-Growth 알고리즘 적용하기
frequent_itemsets =  fpgrowth(te_df, min_support=0.05, use_colnames=True) # 여기에 코드를 작성하세요


# 연관 규칙 찾기
ar = association_rules(frequent_itemsets, metric='confidence', min_threshold=0.2)  # 여기에 코드를 작성하세요


# 향상도, 신뢰도 기준으로 내림차순 정렬
ar = ar.sort_values(by=['lift', 'confidence'], ascending=False)

# 인덱스를 재설정해 출력
ar.reset_index(drop=True)
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    





  <div id="df-bcde30f1-d272-40f1-abd8-9e07e11cac39" class="colab-df-container">
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
      <th>antecedents</th>
      <th>consequents</th>
      <th>antecedent support</th>
      <th>consequent support</th>
      <th>support</th>
      <th>confidence</th>
      <th>lift</th>
      <th>leverage</th>
      <th>conviction</th>
      <th>zhangs_metric</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>(Cosmetics)</td>
      <td>(Food &amp; Beverage)</td>
      <td>0.235832</td>
      <td>0.248629</td>
      <td>0.051188</td>
      <td>0.217054</td>
      <td>0.873005</td>
      <td>-0.007446</td>
      <td>0.959672</td>
      <td>-0.159920</td>
    </tr>
    <tr>
      <th>1</th>
      <td>(Food &amp; Beverage)</td>
      <td>(Cosmetics)</td>
      <td>0.248629</td>
      <td>0.235832</td>
      <td>0.051188</td>
      <td>0.205882</td>
      <td>0.873005</td>
      <td>-0.007446</td>
      <td>0.962286</td>
      <td>-0.162202</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(Cosmetics)</td>
      <td>(Clothing)</td>
      <td>0.235832</td>
      <td>0.418647</td>
      <td>0.074954</td>
      <td>0.317829</td>
      <td>0.759182</td>
      <td>-0.023776</td>
      <td>0.852210</td>
      <td>-0.293337</td>
    </tr>
    <tr>
      <th>3</th>
      <td>(Food &amp; Beverage)</td>
      <td>(Clothing)</td>
      <td>0.248629</td>
      <td>0.418647</td>
      <td>0.069470</td>
      <td>0.279412</td>
      <td>0.667416</td>
      <td>-0.034618</td>
      <td>0.806775</td>
      <td>-0.398753</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-bcde30f1-d272-40f1-abd8-9e07e11cac39')"
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
        document.querySelector('#df-bcde30f1-d272-40f1-abd8-9e07e11cac39 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-bcde30f1-d272-40f1-abd8-9e07e11cac39');
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


<div id="df-015aca99-b7b6-43d7-a6d5-1f93a0356910">
  <button class="colab-df-quickchart" onclick="quickchart('df-015aca99-b7b6-43d7-a6d5-1f93a0356910')"
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
        document.querySelector('#df-015aca99-b7b6-43d7-a6d5-1f93a0356910 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




## 순차 패턴 마이닝
> `순차 패턴 마이닝`은 데이터 안에서 아이템 간의 순차 관계를 탐색해 유의미한 패턴을 찾아내는 분석 방법론이다. '어떤 물건들이 함께 구매되는가'를 분석하는 게 연관 규칙 마이닝이라면 순차 패턴 마이닝은 '이 물건 다음에는 어떤 물건을 사는가?'에 대한 분석을 수행한다

- 연관 규칙
    - IF: 만약 고객이 우유와 달걀을 함께 구매하면 (조건)
    - THEN: 빵도 함께 구매할 가능성이 높다. (결과)

- 순차 패턴
    - IF: 만약 고객이 금요일에 빵을 구매하면 (조건)
    - THEN: 주말에 우유를 구매할 가능성이 높다. (결과)

> IF - THEN 형태로 표현된다는 점은 동일하지만, 연관 규칙에서는 조건과 결과가 동시에 발생하는 사건인 반면 순차 패턴에서는 IF와 THEN 사이에 시차가 존재한다. 조건 부분에 적힌 사건이 먼저 일어난 후 순차적으로 결과 부분의 사건이 발생해야 하는 차이가있다.

- 순차 패턴 마이닝 활용 예시
    - 웹/앱 화면 기획 : 사용자가 화면을 주로 어떤 순서로 방문하는지 파악해 사용자 경험을 개선할 수 있다. 예를 들어, 사용자들이 대부분 로그인 → 상품 검색 → 상품 상세 페이지 → 장바구니 추가 → 결제의 흐름을 보인다면, 화면을 새로 기획하거나 변경할 때 이러한 행동 패턴을 참고해 가장 효율적인 UX를 설계할 수 있다

    - 매장 내 동선 최적화 : 고객이 매장 내에서 어떤 경로로 이동하는지 파악해 매장의 구조를 최적화할 수 있다. 예를 들어, 고객들이 주로 입구 → A 섹션 → B 섹션 → 계산대의 이동 경로를 보인다면, 해당 패턴에 맞춰 상품 진열 위치를 조정할 수 있다

    - CRM 마케팅 : 고객이 이후에 소비할 제품/서비스를 예측해 개인화된 마케팅 메시지를 발송할 수 있다. 예를 들어, A 상품을 구매한 고객들이 대체로 며칠 안에 B 상품도 구매하는 패턴을 보인다면, 관련 쿠폰을 미리 발송하는 방법 등으로 고객의 소비를 독려하며 동시에 만족도도 높일 수 있다

    - 이상 거래 탐지 : 금융 거래의 발생 순서를 파악해 이상 거래를 감지할 수 있다. 예를 들어, 대량의 송금 → 새로운 계좌 개설 → 금융 상품 가입과 같은 흐름이 이상 거래에서 주로 반복되는 패턴이라면 이를 탐지하여 보안 조치를 취할 수 있다

    - 자연재해 예측 : 전조 증상의 발생 순서를 바탕으로 자연재해를 예측할 수 있다. 예를 들어, 미세 지진 발생 → 동물 이상 행동 → 지진운 발생 등의 흐름이 지진의 전조 패턴이라면 이를 활용해 미리 지진 발생 가능성을 예측해 조치를 취할 수 있다

### 시퀀스 데이터
> 순차 패턴 마이닝은 **시간의 흐름에 따른 패턴을 발견하는 분석 기법**이기에 순서를 갖는 데이터인 '시퀀스 데이터(Sequence Data)'를 활용한다. 시퀀스 데이터에서의 순서는 텍스트의 배열 순서 등 다양한 의미를 가질 수 있지만 장바구니 분석에서의 시퀀스 데이터는 보통 '시간의 순서'를 담고 있는 데이터를 의미한다.

> 특히, 순차 패턴 마이닝에서 활용되는 데이터는 보통 고객별 시퀀스 데이터이기 때문에 시간 순서에 대한 정보뿐 아니라 고객에 대한 구분자도 필요하다. 정리하자면, 연관 규칙 마이닝과 순차 패턴 마이닝에서 활용되는 정보는 각각 아래와 같다

- 연관 규칙 마이닝: 결제 ID, 구매 상품 정보
- 순차 패턴 마이닝: 결제 ID, 구매 상품 정보, 고객 정보, 거래 시점

### PrefixSpan 알고리즘
> 순차 패턴 마이닝에 사용되는 대표적인 알고리즘 중 하나인 PrefixSpan에 대해 알아보자. `PrefixSpan`은 Prefix-projected Sequential Pattern Mining의 줄임말로, 'Prefix'는 단어의 앞에 붙는 접두사를 의미하는데, 특정 아이템을 Prefix로 두고 해당 아이템으로부터 시작되는 패턴을 탐색하는 식으로 동작하기 때문에 이런 이름이 붙었다. 예를 들어, 상품이 A, B, C, D 네 개인 데이터셋이라면 먼저 A라는 상품을 Prefix로 둔 채 A로 시작되는 패턴을 찾아 나가고, 그다음 B, C, D 모두 순차적으로 Prefix로 삼아 패턴을 찾는 식이다.

- A, B, C, D → B, C, D
- A, C, B → C, B
- B, A, C, D → C, D
- D, B, A, C → C

- PrefixSpan 알고리즘의 프로세스
1. 먼저, 가능한 모든 1개 상품 시퀀스를 나열한 후 각각의 발생 빈도를 계산한다. 여기에서 특정 항목의 발생 빈도는 보통 지지도 카운트(Support Count)라고 부르는데, 비율 지표인 지지도(Support)의 분자 부분이자 지지도와 유사한 의미를 담은 지표이기에 이렇게 부른다. 설정한 최소 지지도 카운트 이하의 상품을 탈락시킨다. 참고로 연관 규칙 마이닝에서는 특정 지지도 이상의 항목을 빈발 항목 집합(Frequent Itemset)이라고 불렀다면 순차 패턴 마이닝에서는 '빈발 시퀀스(Frequent Sequence)'라고 부른다.

2. 1단계를 통과한 각 상품을 Prefix로 두고, Prefix별로 탐색 영역을 분리한다. 여기에서 Prefix별로 분리된 탐색 영역은 해당 Prefix의 'Projected Database'라고 부른다. Projected DB 규칙은 기본적으로 다음과 같다
    - 각각의 고객별 시퀀스 데이터에서 Prefix가 처음 등장하는 부분을 찾고, 그 Prefix의 뒷부분만 남긴다
    - 만약 (Prefix, 다른아이템)과 같은 형태의 요소가 있다면 Prefix를 언더바`_`로 처리해 표기한다
        - 예를들어, Prefix가 빵일때, <(고기, 빵), 달걀>은 <달걀>이 되고, <(빵, 우유), 생선>은 <(_, 우유), 생선>이 된다

3. Projected DB를 바탕으로 각 상품의 지지도 카운트를 다시 계산하고 시퀀스 영역을 쪼개서 Prefix로 두는 시퀀스가 없을때까지 탐색을 이어나간다

4. 트리 구조가 완성되면 빈발 시퀀스를 찾는다

### 파이썬으로 PrefixSpan 알고리즘 구현


```python
!pip install prefixspan
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    

    Collecting prefixspan
      Downloading prefixspan-0.5.2.tar.gz (10 kB)
      Preparing metadata (setup.py) ... [?25l[?25hdone
    Collecting docopt>=0.6.2 (from prefixspan)
      Downloading docopt-0.6.2.tar.gz (25 kB)
      Preparing metadata (setup.py) ... [?25l[?25hdone
    Collecting extratools>=0.8.1 (from prefixspan)
      Downloading extratools-0.8.2.1.tar.gz (25 kB)
      Preparing metadata (setup.py) ... [?25l[?25hdone
    Requirement already satisfied: sortedcontainers>=1.5.10 in /usr/local/lib/python3.10/dist-packages (from extratools>=0.8.1->prefixspan) (2.4.0)
    Requirement already satisfied: toolz>=0.9.0 in /usr/local/lib/python3.10/dist-packages (from extratools>=0.8.1->prefixspan) (0.12.1)
    Building wheels for collected packages: prefixspan, docopt, extratools
      Building wheel for prefixspan (setup.py) ... [?25l[?25hdone
      Created wheel for prefixspan: filename=prefixspan-0.5.2-py3-none-any.whl size=11214 sha256=e9d8af51d955a3742ab916fb34e9f2aa993f55e6992fdb59fa830d7c37809a53
      Stored in directory: /root/.cache/pip/wheels/bf/96/ee/9e087a6d0d3163ee363c069bf80eaa4ca4f5ee51f2b2b0521c
      Building wheel for docopt (setup.py) ... [?25l[?25hdone
      Created wheel for docopt: filename=docopt-0.6.2-py2.py3-none-any.whl size=13704 sha256=de3830c7b12451714e91efd0920450011edf387b6dd2c1403019caa9024afaae
      Stored in directory: /root/.cache/pip/wheels/fc/ab/d4/5da2067ac95b36618c629a5f93f809425700506f72c9732fac
      Building wheel for extratools (setup.py) ... [?25l[?25hdone
      Created wheel for extratools: filename=extratools-0.8.2.1-py3-none-any.whl size=28866 sha256=06ccefc293ee3965793fca0f50dd35308315bf45450a672f92e37f68b158fc5b
      Stored in directory: /root/.cache/pip/wheels/70/f3/03/3a98db17111f679c3291413b81d2a1e6e1bad5a3441175ace7
    Successfully built prefixspan docopt extratools
    Installing collected packages: docopt, extratools, prefixspan
    Successfully installed docopt-0.6.2 extratools-0.8.2.1 prefixspan-0.5.2
    


```python
import pandas as pd

df = pd.read_csv('/content/drive/MyDrive/data/retail_data.csv')
df.head()
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    





  <div id="df-cc6e056d-8b53-4a20-8baa-7157a1c94f65" class="colab-df-container">
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
      <th>OrderID</th>
      <th>StockCode</th>
      <th>ProdName</th>
      <th>Quantity</th>
      <th>OrderDate</th>
      <th>UnitPrice</th>
      <th>CustomerID</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>536365</td>
      <td>85123A</td>
      <td>WHITE HANGING HEART T-LIGHT HOLDER</td>
      <td>6</td>
      <td>2010-12-01</td>
      <td>2.55</td>
      <td>17850.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>536365</td>
      <td>71053</td>
      <td>WHITE METAL LANTERN</td>
      <td>6</td>
      <td>2010-12-01</td>
      <td>3.39</td>
      <td>17850.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>536365</td>
      <td>84406B</td>
      <td>CREAM CUPID HEARTS COAT HANGER</td>
      <td>8</td>
      <td>2010-12-01</td>
      <td>2.75</td>
      <td>17850.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>536365</td>
      <td>84029G</td>
      <td>KNITTED UNION FLAG HOT WATER BOTTLE</td>
      <td>6</td>
      <td>2010-12-01</td>
      <td>3.39</td>
      <td>17850.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>536365</td>
      <td>84029E</td>
      <td>RED WOOLLY HOTTIE WHITE HEART.</td>
      <td>6</td>
      <td>2010-12-01</td>
      <td>3.39</td>
      <td>17850.0</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-cc6e056d-8b53-4a20-8baa-7157a1c94f65')"
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
        document.querySelector('#df-cc6e056d-8b53-4a20-8baa-7157a1c94f65 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-cc6e056d-8b53-4a20-8baa-7157a1c94f65');
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


<div id="df-54be57ef-107a-4635-92d8-89e4dc12a782">
  <button class="colab-df-quickchart" onclick="quickchart('df-54be57ef-107a-4635-92d8-89e4dc12a782')"
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
        document.querySelector('#df-54be57ef-107a-4635-92d8-89e4dc12a782 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




- PrefixSpan 알고리즘을 적용하기위해 시퀀스 데이터로 변환
    - 전체적인 결제 순서 데이터는 리스트로, 함께 결제된 아이템은 튜플로 정렬


```python
# 아이템 정렬
df = df.sort_values('ProdName')

# 아이템 묶기 : 고객번호, 구매일, 거래번호가 같은 아이템을 튜플로 묶기
df2 = df.groupby(['CustomerID', 'OrderDate', 'OrderID'])['ProdName'].apply(tuple).reset_index()

# 구매일 기준 재정렬후 고객번호 별 리스트화
df2 = df2.sort_values('OrderDate')
sequence_df = df2.groupby(['CustomerID'])['ProdName'].apply(list).reset_index()
sequence_df.head()
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    





  <div id="df-fb5a6a00-37e7-4a2e-87bc-d63fac8708b3" class="colab-df-container">
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
      <th>CustomerID</th>
      <th>ProdName</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>12427.0</td>
      <td>[(6 RIBBONS RUSTIC CHARM, BALLOONS  WRITING SE...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>12431.0</td>
      <td>[(ALARM CLOCK BAKELIKE GREEN, ALARM CLOCK BAKE...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>12433.0</td>
      <td>[(20 DOLLY PEGS RETROSPOT, 200 RED + WHITE BEN...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>12583.0</td>
      <td>[( SET 2 TEA TOWELS I LOVE LONDON , ALARM CLOC...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>12662.0</td>
      <td>[(3 HOOK HANGER MAGIC GARDEN, 5 HOOK HANGER MA...</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-fb5a6a00-37e7-4a2e-87bc-d63fac8708b3')"
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
        document.querySelector('#df-fb5a6a00-37e7-4a2e-87bc-d63fac8708b3 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-fb5a6a00-37e7-4a2e-87bc-d63fac8708b3');
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


<div id="df-43bad859-3edd-4700-ab40-1575040d70a6">
  <button class="colab-df-quickchart" onclick="quickchart('df-43bad859-3edd-4700-ab40-1575040d70a6')"
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
        document.querySelector('#df-43bad859-3edd-4700-ab40-1575040d70a6 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# PrefixSpan 알고리즘 구현
from prefixspan import PrefixSpan

ps = PrefixSpan(sequence_df['ProdName'])
ps.frequent(2)  # 최소 지지도 카운트 2 이상
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    




    [(2, [('BATH BUILDING BLOCK WORD',)]),
     (2, [("PAPER CHAIN KIT 50'S CHRISTMAS ",)]),
     (2, [('JAM MAKING SET PRINTED', 'JAM MAKING SET WITH JARS')])]




```python
ps.topk(3)  # 상위 지지도 (갯수)만큼 출력
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    




    [(2, [('BATH BUILDING BLOCK WORD',)]),
     (2, [('JAM MAKING SET PRINTED', 'JAM MAKING SET WITH JARS')]),
     (2, [("PAPER CHAIN KIT 50'S CHRISTMAS ",)])]




```python
# 파이썬 코드로 PrefixSpan 알고리즘 직접 구현
class PrefixSpan:
    def __init__(self, min_support):
        self.min_support = min_support

    def run(self, sequences):
        frequent_patterns = []
        self.prefix_span([], sequences, frequent_patterns)
        return self.to_dataframe(frequent_patterns)

    def prefix_span(self, prefix, projected_db, frequent_patterns):
        frequent_items = self.get_frequent_items(projected_db)
        for item, support in frequent_items.items():
            new_prefix = prefix + [item]
            frequent_patterns.append((new_prefix, support))
            new_projected_db = self.build_projected_db(projected_db, item)
            if new_projected_db:
                self.prefix_span(new_prefix, new_projected_db, frequent_patterns)

    def get_frequent_items(self, projected_db):
        item_counts = {}
        for sequence in projected_db:
            visited = set()
            for itemset in sequence:
                for item in itemset:
                    if item not in visited:
                        if item not in item_counts:
                            item_counts[item] = 0
                        item_counts[item] += 1
                        visited.add(item)
        return {item: count for item, count in item_counts.items() if count >= self.min_support}

    def build_projected_db(self, projected_db, item):
        new_projected_db = []
        for sequence in projected_db:
            for idx, itemset in enumerate(sequence):
                if item in itemset:
                    new_projected_db.append(sequence[idx+1:])
                    break
        return new_projected_db

    def to_dataframe(self, frequent_patterns):
        pattern_data = [{'item': pattern[0], 'support_count': pattern[1], 'item_count': len(pattern[0])} for pattern in frequent_patterns]
        df_patterns = pd.DataFrame(pattern_data)
        return df_patterns
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    


```python
ps = PrefixSpan(min_support=2)  # 최소 지지도 카운트를 설정합니다.
patterns = ps.run(sequence_df['ProdName'])  # 계산할 대상 데이터를 넣습니다.

patterns.head()
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    





  <div id="df-a0dd47f6-01b3-45c8-ac1c-3931ef88b4a8" class="colab-df-container">
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
      <th>item</th>
      <th>support_count</th>
      <th>item_count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>[6 RIBBONS RUSTIC CHARM]</td>
      <td>9</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>[BALLOONS  WRITING SET ]</td>
      <td>6</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>[CHILDS BREAKFAST SET CIRCUS PARADE]</td>
      <td>4</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>[CHILDS BREAKFAST SET SPACEBOY ]</td>
      <td>9</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>[COFFEE MUG CAT + BIRD DESIGN]</td>
      <td>2</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-a0dd47f6-01b3-45c8-ac1c-3931ef88b4a8')"
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
        document.querySelector('#df-a0dd47f6-01b3-45c8-ac1c-3931ef88b4a8 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-a0dd47f6-01b3-45c8-ac1c-3931ef88b4a8');
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


<div id="df-d68d2da6-be22-4007-9ab4-0f493614ec15">
  <button class="colab-df-quickchart" onclick="quickchart('df-d68d2da6-be22-4007-9ab4-0f493614ec15')"
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
        document.querySelector('#df-d68d2da6-be22-4007-9ab4-0f493614ec15 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>




### PrefixSpan 알고리즘 실습


```python
import pandas as pd
from prefixspan import PrefixSpan

df = pd.read_csv('/content/drive/MyDrive/data/shopping_data.csv')

# 아이템 정렬
df = df.sort_values('category')

# 아이템 묶기 : 고객번호, 구매일, 거래번호가 같은 아이템을 튜플로 묶기
df2 = df.groupby(['invoice_no', 'invoice_date', 'customer_id'])['category'].apply(tuple).reset_index()

# 구매일 기준 재정렬후 고객번호 별 리스트화
df2 = df2.sort_values('invoice_date')
sequence_df = df2.groupby(['customer_id'])['category'].apply(list).reset_index()

ps = PrefixSpan(sequence_df['category'])
# ps.frequent(2)  # 최소 지지도 카운트 2 이상
ps.topk(7)  # 상위 지지도 (갯수)만큼 출력
```

    /usr/local/lib/python3.10/dist-packages/ipykernel/ipkernel.py:283: DeprecationWarning: `should_run_async` will not call `transform_cell` automatically in the future. Please pass the result to `transformed_cell` argument and any exception that happen during thetransform in `preprocessing_exc_tuple` in IPython 7.17 and above.
      and should_run_async(code)
    




    [(122, [('Clothing',)]),
     (64, [('Food & Beverage',)]),
     (61, [('Cosmetics',)]),
     (42, [('Toys',)]),
     (29, [('Shoes',)]),
     (21, [('Technology',)]),
     (18, [('Books',)])]


