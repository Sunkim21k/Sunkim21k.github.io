---
#layout: post
title: 파이썬 데이터분석 데이터시각화2
date: 2024-09-25
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
import pandas as pd
import numpy as np
import seaborn as sns
```

## Seaborn 라이브러리
  - seaborn은 matplotlib을 기반으로 하는 라이브러리이다
  - seaborn은 `Figure-level`과 `Axes-level` 두 가지 타입의 함수를 지원한다
  - Figure-level 함수 하나에 여러 개의 Axes-level 함수가 대응되는 1:N의 관계를 가진다
  - ![png](/assets/img/py2_files/1.png)

 - `Axes-level`함수는 Axes를 생성하는 그래프 시각화 함수로 Matplotlib에서 지원되는 State-based 방식이나 Object-oriented 방식 모두 커스터마이징 가능하다
 - `Figure-level`함수는 Figure 자체를 생성하는 그래프 시각화 함수로 하나의 함수로 복수의 Axes를 생성하지만 Matplotlib의 Axes 레벨 함수로는 추가적인 가공이 어렵다


```python
tips_df = sns.load_dataset('tips') # Seaborn의 기본 데이터셋 중 하나
sns.catplot(data=tips_df, x='day', y='tip', kind='bar') # Figure-level 함수
```




    <seaborn.axisgrid.FacetGrid at 0x7afb7c274b50>




    
![png](/assets/img/py2_files/py2_3_1.png)
    



```python
sns.barplot(data=tips_df, x='day', y='tip') # Axes-level 함수
```




    <Axes: xlabel='day', ylabel='tip'>




    
![png](/assets/img/py2_files/py2_4_1.png)
    


### Figure-level 함수의 장점 : 그래프 쪼개 그리기
  - Figure-level 함수는 Figure 레벨 객체를 생성하는 것이기에, 함수 하나만으로 복수의 Subplot을 가진 Figure를 생성할 수 있다
    - 열`col`이나 행`row` 기준으로 데이터를 나누어 시각화 할 수 있다


```python
# 점심과 저녁 사이의 팁 차이가 있을까?
sns.catplot(data=tips_df, x='day', y='tip', kind='bar', col='time')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb7d1a2e90>




    
![png](/assets/img/py2_files/py2_6_1.png)
    



```python
# 점심과 저녁 사이의 팁차이는 큰 차이가 없어보인다
# 성별에 따른 팁 차이가 있을까?
sns.catplot(data=tips_df, x='day', y='tip', kind='bar', col='time', row='sex')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb3af3f160>




    
![png](/assets/img/py2_files/py2_7_1.png)
    


### Figure-level 함수 catplot()
 - `categorical plot`의 줄임으로 카테고리별 수치 비교 목적의 시각화에 적합한 함수
 - `sns.catplot(kind='bar')`처럼 `kind`를 지정하는 방식으로 다양한 종류의 시각화를 지원함
    - kind 옵션 : strip, swarm, box, violin, boxen, point, bar, count

#### 막대그래프 시각화


```python
customer_df = pd.read_csv('/content/drive/MyDrive/data/customer_personality.csv', sep='\t')
customer_df
```





  <div id="df-e1edd805-0493-47a6-a030-c3db28785102" class="colab-df-container">
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
      <th>ID</th>
      <th>Year_Birth</th>
      <th>Education</th>
      <th>Marital_Status</th>
      <th>Income</th>
      <th>Kidhome</th>
      <th>Teenhome</th>
      <th>Dt_Customer</th>
      <th>Recency</th>
      <th>MntWines</th>
      <th>...</th>
      <th>NumWebVisitsMonth</th>
      <th>AcceptedCmp3</th>
      <th>AcceptedCmp4</th>
      <th>AcceptedCmp5</th>
      <th>AcceptedCmp1</th>
      <th>AcceptedCmp2</th>
      <th>Complain</th>
      <th>Z_CostContact</th>
      <th>Z_Revenue</th>
      <th>Response</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>5524</td>
      <td>1957</td>
      <td>Graduation</td>
      <td>Single</td>
      <td>58138.0</td>
      <td>0</td>
      <td>0</td>
      <td>04-09-2012</td>
      <td>58</td>
      <td>635</td>
      <td>...</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2174</td>
      <td>1954</td>
      <td>Graduation</td>
      <td>Single</td>
      <td>46344.0</td>
      <td>1</td>
      <td>1</td>
      <td>08-03-2014</td>
      <td>38</td>
      <td>11</td>
      <td>...</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4141</td>
      <td>1965</td>
      <td>Graduation</td>
      <td>Together</td>
      <td>71613.0</td>
      <td>0</td>
      <td>0</td>
      <td>21-08-2013</td>
      <td>26</td>
      <td>426</td>
      <td>...</td>
      <td>4</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>6182</td>
      <td>1984</td>
      <td>Graduation</td>
      <td>Together</td>
      <td>26646.0</td>
      <td>1</td>
      <td>0</td>
      <td>10-02-2014</td>
      <td>26</td>
      <td>11</td>
      <td>...</td>
      <td>6</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5324</td>
      <td>1981</td>
      <td>PhD</td>
      <td>Married</td>
      <td>58293.0</td>
      <td>1</td>
      <td>0</td>
      <td>19-01-2014</td>
      <td>94</td>
      <td>173</td>
      <td>...</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
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
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>2235</th>
      <td>10870</td>
      <td>1967</td>
      <td>Graduation</td>
      <td>Married</td>
      <td>61223.0</td>
      <td>0</td>
      <td>1</td>
      <td>13-06-2013</td>
      <td>46</td>
      <td>709</td>
      <td>...</td>
      <td>5</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2236</th>
      <td>4001</td>
      <td>1946</td>
      <td>PhD</td>
      <td>Together</td>
      <td>64014.0</td>
      <td>2</td>
      <td>1</td>
      <td>10-06-2014</td>
      <td>56</td>
      <td>406</td>
      <td>...</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2237</th>
      <td>7270</td>
      <td>1981</td>
      <td>Graduation</td>
      <td>Divorced</td>
      <td>56981.0</td>
      <td>0</td>
      <td>0</td>
      <td>25-01-2014</td>
      <td>91</td>
      <td>908</td>
      <td>...</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2238</th>
      <td>8235</td>
      <td>1956</td>
      <td>Master</td>
      <td>Together</td>
      <td>69245.0</td>
      <td>0</td>
      <td>1</td>
      <td>24-01-2014</td>
      <td>8</td>
      <td>428</td>
      <td>...</td>
      <td>3</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2239</th>
      <td>9405</td>
      <td>1954</td>
      <td>PhD</td>
      <td>Married</td>
      <td>52869.0</td>
      <td>1</td>
      <td>1</td>
      <td>15-10-2012</td>
      <td>40</td>
      <td>84</td>
      <td>...</td>
      <td>7</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>11</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
<p>2240 rows × 29 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-e1edd805-0493-47a6-a030-c3db28785102')"
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
        document.querySelector('#df-e1edd805-0493-47a6-a030-c3db28785102 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-e1edd805-0493-47a6-a030-c3db28785102');
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


<div id="df-f4f97406-1ef9-4f5a-82d0-9bf63622f537">
  <button class="colab-df-quickchart" onclick="quickchart('df-f4f97406-1ef9-4f5a-82d0-9bf63622f537')"
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
        document.querySelector('#df-f4f97406-1ef9-4f5a-82d0-9bf63622f537 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_83575f30-4f8d-46c0-b1dc-7c3e999dda2e">
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
    <button class="colab-df-generate" onclick="generateWithVariable('customer_df')"
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
        document.querySelector('#id_83575f30-4f8d-46c0-b1dc-7c3e999dda2e button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('customer_df');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
customer_df['Marital_Status'].unique()
```




    array(['Single', 'Together', 'Married', 'Divorced', 'Widow', 'Alone',
           'Absurd', 'YOLO'], dtype=object)




```python
# 결혼 상태에 따른 평균 와인 소비 금액 시각화
temp = customer_df.query('Marital_Status in ["Single", "Together", "Married", "Divorced"]')

sns.catplot(kind='bar', data=temp, x='Marital_Status', y='MntWines')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb3af62440>




    
![png](/assets/img/py2_files/py2_12_1.png)
    



```python
# 아이 유무에 따라 가로 방향 그래프를 분리
# 아이 수를 Yes or No 타입으로 새로 변환
temp['Kids'] = temp['Kidhome'].apply(lambda x: 'Yes' if x >= 1 else 'No')

sns.catplot(kind='bar', data=temp, x='Marital_Status', y='MntWines', col='Kids')
```

    <ipython-input-9-195a5b59779a>:3: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#returning-a-view-versus-a-copy
      temp['Kids'] = temp['Kidhome'].apply(lambda x: 'Yes' if x >= 1 else 'No')
    




    <seaborn.axisgrid.FacetGrid at 0x7afb3a7163b0>




    
![png](/assets/img/py2_files/py2_13_2.png)
    



```python
# 10대 자녀 유무도 추가해서 시각화
temp['Teens'] = temp['Teenhome'].apply(lambda x: 'Yes' if x >= 1 else 'No')

sns.catplot(kind='bar', data=temp, x='Marital_Status', y='MntWines', col='Kids', row='Teens')
```

    <ipython-input-10-1fcbf46cd774>:2: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#returning-a-view-versus-a-copy
      temp['Teens'] = temp['Teenhome'].apply(lambda x: 'Yes' if x >= 1 else 'No')
    




    <seaborn.axisgrid.FacetGrid at 0x7afb3d2da740>




    
![png](/assets/img/py2_files/py2_14_2.png)
    


#### Count plot
  - 데이터의 수를 세주는 그래프 함수이기 때문에 x나 y중 하나의 값만 받는다


```python
# 결혼 상태별 인원수를 아이 유무와 10대 자녀 유무에 따라 나누어 집계
sns.catplot(data=temp, x='Marital_Status', kind='count', col='Kids', row='Teens')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb3a7153c0>




    
![png](/assets/img/py2_files/py2_16_1.png)
    


#### Strip plot


```python
# 아이 수에 따른 와인 소비 금액의 분포 파악
sns.catplot(data=customer_df, x='Kidhome', y='MntWines', kind='strip')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb3a3bb400>




    
![png](/assets/img/py2_files/py2_18_1.png)
    


#### 박스 플롯


```python
sns.catplot(data=customer_df, x='Kidhome', y='MntWines', kind='box')
# 아이가 1명 이상 있는 집에서 와인 소비 금액의 중앙값이 훨씬 작은것을 관찰할 수 있다
```




    <seaborn.axisgrid.FacetGrid at 0x7afb39bb73a0>




    
![png](/assets/img/py2_files/py2_20_1.png)
    


#### 바이올린 플롯


```python
sns.catplot(data=customer_df, x='Kidhome', y='MntWines', kind='violin')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb39c5dde0>




    
![png](/assets/img/py2_files/py2_22_1.png)
    


### relplot() 함수
 - relational plot의 줄임으로 두 연속형 변수 사이의 관계를 나타내는데 적합한 함수
     - kind 옵션은 scatter와 line 2가지가 있다

#### 산점도(Scatter plot)


```python
exam_df = pd.read_csv('/content/drive/MyDrive/data/student_exam.csv')
exam_df.head()
```





  <div id="df-2b57fe59-5d82-45ac-8dd9-88204e55431c" class="colab-df-container">
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
      <th>gender</th>
      <th>race/ethnicity</th>
      <th>parental level of education</th>
      <th>lunch</th>
      <th>test preparation course</th>
      <th>math score</th>
      <th>reading score</th>
      <th>writing score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>female</td>
      <td>group B</td>
      <td>bachelor's degree</td>
      <td>standard</td>
      <td>none</td>
      <td>72</td>
      <td>72</td>
      <td>74</td>
    </tr>
    <tr>
      <th>1</th>
      <td>female</td>
      <td>group C</td>
      <td>some college</td>
      <td>standard</td>
      <td>completed</td>
      <td>69</td>
      <td>90</td>
      <td>88</td>
    </tr>
    <tr>
      <th>2</th>
      <td>female</td>
      <td>group B</td>
      <td>master's degree</td>
      <td>standard</td>
      <td>none</td>
      <td>90</td>
      <td>95</td>
      <td>93</td>
    </tr>
    <tr>
      <th>3</th>
      <td>male</td>
      <td>group A</td>
      <td>associate's degree</td>
      <td>free/reduced</td>
      <td>none</td>
      <td>47</td>
      <td>57</td>
      <td>44</td>
    </tr>
    <tr>
      <th>4</th>
      <td>male</td>
      <td>group C</td>
      <td>some college</td>
      <td>standard</td>
      <td>none</td>
      <td>76</td>
      <td>78</td>
      <td>75</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-2b57fe59-5d82-45ac-8dd9-88204e55431c')"
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
        document.querySelector('#df-2b57fe59-5d82-45ac-8dd9-88204e55431c button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-2b57fe59-5d82-45ac-8dd9-88204e55431c');
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


<div id="df-0df20228-ea67-4946-9a46-483b50227014">
  <button class="colab-df-quickchart" onclick="quickchart('df-0df20228-ea67-4946-9a46-483b50227014')"
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
        document.querySelector('#df-0df20228-ea67-4946-9a46-483b50227014 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
# 수학 점수와 읽기 점수의 관계
sns.relplot(data=exam_df, x='math score', y='reading score', kind='scatter')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb399c3130>




    
![png](/assets/img/py2_files/py2_26_1.png)
    



```python
# 테스트 준비 과정의 이수 여부에 따라 수학 점수와 읽기 점수의 관계
sns.relplot(data=exam_df, x='math score', y='reading score', kind='scatter', col='test preparation course')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb39a5aad0>




    
![png](/assets/img/py2_files/py2_27_1.png)
    


#### 라인 그래프


```python
books_df = pd.read_csv('/content/drive/MyDrive/data/amazon_bestsellers.csv')
books_df.head()
```





  <div id="df-3cf8138d-69d6-4251-a030-d76c98069eb5" class="colab-df-container">
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
      <th>Name</th>
      <th>Author</th>
      <th>User Rating</th>
      <th>Reviews</th>
      <th>Price</th>
      <th>Year</th>
      <th>Genre</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>10-Day Green Smoothie Cleanse</td>
      <td>JJ Smith</td>
      <td>4.7</td>
      <td>17350</td>
      <td>8</td>
      <td>2016</td>
      <td>Non Fiction</td>
    </tr>
    <tr>
      <th>1</th>
      <td>11/22/63: A Novel</td>
      <td>Stephen King</td>
      <td>4.6</td>
      <td>2052</td>
      <td>22</td>
      <td>2011</td>
      <td>Fiction</td>
    </tr>
    <tr>
      <th>2</th>
      <td>12 Rules for Life: An Antidote to Chaos</td>
      <td>Jordan B. Peterson</td>
      <td>4.7</td>
      <td>18979</td>
      <td>15</td>
      <td>2018</td>
      <td>Non Fiction</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1984 (Signet Classics)</td>
      <td>George Orwell</td>
      <td>4.7</td>
      <td>21424</td>
      <td>6</td>
      <td>2017</td>
      <td>Fiction</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5,000 Awesome Facts (About Everything!) (Natio...</td>
      <td>National Geographic Kids</td>
      <td>4.8</td>
      <td>7665</td>
      <td>12</td>
      <td>2019</td>
      <td>Non Fiction</td>
    </tr>
  </tbody>
</table>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-3cf8138d-69d6-4251-a030-d76c98069eb5')"
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
        document.querySelector('#df-3cf8138d-69d6-4251-a030-d76c98069eb5 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-3cf8138d-69d6-4251-a030-d76c98069eb5');
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


<div id="df-7f295a5a-729a-4bad-9905-b404f3d9d6e6">
  <button class="colab-df-quickchart" onclick="quickchart('df-7f295a5a-729a-4bad-9905-b404f3d9d6e6')"
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
        document.querySelector('#df-7f295a5a-729a-4bad-9905-b404f3d9d6e6 button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

    </div>
  </div>





```python
sns.relplot(kind='line', x='Year', y='Reviews', data=books_df)
```




    <seaborn.axisgrid.FacetGrid at 0x7afb39971960>




    
![png](/assets/img/py2_files/py2_30_1.png)
    



```python
# 오차 영역 표시를 숨기고 hue 파라미터를 통해 특정 장르별 데이터 시각화
sns.relplot(kind='line', x='Year', y='Reviews', data=books_df, errorbar=None, hue='Genre')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb31f4b190>




    
![png](/assets/img/py2_files/py2_31_1.png)
    


### displot() 함수
  - distribution plot의 줄임으로 데이터의 분포를 시각화하는데 적합한 함수
    - kind 옵션 : hist, kde, ecdf

#### 히스토그램


```python
sns.displot(data=exam_df, x='math score', kind='hist')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb31f25f90>




    
![png](/assets/img/py2_files/py2_34_1.png)
    



```python
# bins 파라미터 이용 구간 조정
sns.displot(data=exam_df, x='math score', kind='hist', bins=10)
```




    <seaborn.axisgrid.FacetGrid at 0x7afb31e47520>




    
![png](/assets/img/py2_files/py2_35_1.png)
    



```python
# 테스트 준비 과정 여부로 분포 분류
sns.displot(data=exam_df, x='math score', kind='hist', col='test preparation course', hue='test preparation course', legend=False)
```




    <seaborn.axisgrid.FacetGrid at 0x7afb39bb6b00>




    
![png](/assets/img/py2_files/py2_36_1.png)
    


#### KDE plot


```python
sns.displot(data=exam_df, x='math score', kind='kde', bw_adjust=0.3)
```




    <seaborn.axisgrid.FacetGrid at 0x7afb31ff98a0>




    
![png](/assets/img/py2_files/py2_38_1.png)
    


#### 히스토그램과 KDE plot 함께 그리기 (kde=True옵션)


```python
sns.displot(data=exam_df, kind='hist', kde=True, x='math score')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb31caf550>




    
![png](/assets/img/py2_files/py2_40_1.png)
    


#### 두 개의 변수로 분포 시각화하기


```python
sns.displot(kind='hist', data=exam_df, x='math score', y='reading score')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb31b455d0>




    
![png](/assets/img/py2_files/py2_42_1.png)
    



```python
sns.displot(data=exam_df, kind='kde', x='math score', y='reading score')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb31b45f30>




    
![png](/assets/img/py2_files/py2_43_1.png)
    


### 실습 : 연도별 유니콘 스타트업 수 시각화
  1. 연도별 국가별 기업수를 집계할 때, 기업수를 집계한 컬럼명은 ‘Number of Unicorn Startups’로 바꿔주세요.
  2. 국가 중에서는 중국과 미국만 필터링해 사용하고, 그래프는 가로 방향으로 분리해 그려 주세요.


```python
unicorn_df = pd.read_csv('/content/drive/MyDrive/data/unicorn_startups.csv')
unicorn_df
```





  <div id="df-a324b511-94dd-479a-a2ff-febd05965a99" class="colab-df-container">
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
      <th>Company</th>
      <th>Valuation</th>
      <th>Date</th>
      <th>Country</th>
      <th>City</th>
      <th>Industry</th>
      <th>Investors</th>
      <th>year</th>
      <th>month</th>
      <th>day</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Bytedance</td>
      <td>140.0</td>
      <td>4/7/2017</td>
      <td>China</td>
      <td>Beijing</td>
      <td>Artificial intelligence</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2017</td>
      <td>7</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SpaceX</td>
      <td>100.3</td>
      <td>12/1/2012</td>
      <td>United States</td>
      <td>Hawthorne</td>
      <td>Other</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2012</td>
      <td>1</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Stripe</td>
      <td>95.0</td>
      <td>1/23/2014</td>
      <td>United States</td>
      <td>San Francisco</td>
      <td>Fintech</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2014</td>
      <td>23</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Klarna</td>
      <td>45.6</td>
      <td>12/12/2011</td>
      <td>Sweden</td>
      <td>Stockholm</td>
      <td>Fintech</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2011</td>
      <td>12</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Canva</td>
      <td>40.0</td>
      <td>1/8/2018</td>
      <td>Australia</td>
      <td>Surry Hills</td>
      <td>Internet software &amp; services</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2018</td>
      <td>8</td>
      <td>1</td>
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
      <th>931</th>
      <td>YipitData</td>
      <td>1.0</td>
      <td>12/6/2021</td>
      <td>United States</td>
      <td>New York</td>
      <td>Internet software &amp; services</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2021</td>
      <td>6</td>
      <td>12</td>
    </tr>
    <tr>
      <th>932</th>
      <td>Anyscale</td>
      <td>1.0</td>
      <td>12/7/2021</td>
      <td>United States</td>
      <td>Berkeley</td>
      <td>Artificial Intelligence</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2021</td>
      <td>7</td>
      <td>12</td>
    </tr>
    <tr>
      <th>933</th>
      <td>Iodine Software</td>
      <td>1.0</td>
      <td>12/1/2021</td>
      <td>United States</td>
      <td>Austin</td>
      <td>Data management &amp; analytics</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2021</td>
      <td>1</td>
      <td>12</td>
    </tr>
    <tr>
      <th>934</th>
      <td>ReliaQuest</td>
      <td>1.0</td>
      <td>12/1/2021</td>
      <td>United States</td>
      <td>Tampa</td>
      <td>Cybersecurity</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2021</td>
      <td>1</td>
      <td>12</td>
    </tr>
    <tr>
      <th>935</th>
      <td>Pet Circle</td>
      <td>1.0</td>
      <td>12/7/2021</td>
      <td>Australia</td>
      <td>Alexandria</td>
      <td>E-commerce &amp; direct-to-consumer</td>
      <td>0      Sequoia Capital China, SIG Asia Investm...</td>
      <td>2021</td>
      <td>7</td>
      <td>12</td>
    </tr>
  </tbody>
</table>
<p>936 rows × 10 columns</p>
</div>
    <div class="colab-df-buttons">

  <div class="colab-df-container">
    <button class="colab-df-convert" onclick="convertToInteractive('df-a324b511-94dd-479a-a2ff-febd05965a99')"
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
        document.querySelector('#df-a324b511-94dd-479a-a2ff-febd05965a99 button.colab-df-convert');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      async function convertToInteractive(key) {
        const element = document.querySelector('#df-a324b511-94dd-479a-a2ff-febd05965a99');
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


<div id="df-0b198eaa-d8e2-4514-b96f-41ee9434d34d">
  <button class="colab-df-quickchart" onclick="quickchart('df-0b198eaa-d8e2-4514-b96f-41ee9434d34d')"
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
        document.querySelector('#df-0b198eaa-d8e2-4514-b96f-41ee9434d34d button');
      quickchartButtonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';
    })();
  </script>
</div>

  <div id="id_73803a07-98c8-42d2-8966-8ecc664492b8">
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
    <button class="colab-df-generate" onclick="generateWithVariable('unicorn_df')"
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
        document.querySelector('#id_73803a07-98c8-42d2-8966-8ecc664492b8 button.colab-df-generate');
      buttonEl.style.display =
        google.colab.kernel.accessAllowed ? 'block' : 'none';

      buttonEl.onclick = () => {
        google.colab.notebook.generateWithVariable('unicorn_df');
      }
      })();
    </script>
  </div>

    </div>
  </div>





```python
unicorn_groupby = unicorn_df.groupby(['year', 'Country'])[['Company']].count().reset_index()
unicorn_groupby = unicorn_groupby.rename(columns={'Company' : 'Number of Unicorn Startups'})
select_unicorn = unicorn_groupby.query('Country in ["China", "United States"]')
sns.relplot(kind='line', data=select_unicorn, x='year', y='Number of Unicorn Startups', col='Country')
```




    <seaborn.axisgrid.FacetGrid at 0x7afb39b8c970>




    
![png](/assets/img/py2_files/py2_46_1.png)
    


### Axes-level 그래프 커스터마이징

#### 막대그래프 파라미터 사용하기
  - 값의 순서 조정하기 : order 파라미터에 리스트 형태로 정리


```python
sns.barplot(data=temp, x='Marital_Status', y='MntWines', order=['Married', 'Together', 'Single', 'Divorced'])
```




    <Axes: xlabel='Marital_Status', ylabel='MntWines'>




    
![png](/assets/img/py2_files/py2_49_1.png)
    


 - estimator 변경하기 : 지표를 평균값(기본값), 중앙값 등으로 변경


```python
sns.barplot(data=temp, x='Marital_Status', y='MntWines', order=['Married', 'Together', 'Single', 'Divorced'], estimator='median', errorbar=None)
```




    <Axes: xlabel='Marital_Status', ylabel='MntWines'>




    
![png](/assets/img/py2_files/py2_51_1.png)
    



```python
# 최대값 기준
sns.barplot(data=temp, x='Marital_Status', y='MntWines', order=['Married', 'Together', 'Single', 'Divorced'], estimator='max', errorbar=None)
```




    <Axes: xlabel='Marital_Status', ylabel='MntWines'>




    
![png](/assets/img/py2_files/py2_52_1.png)
    


 - 그래프 꾸미기 : palette 파라미터로 테마색 조정
    - 테마색에 `_d`가 붙으면 조금 더 어둡게 표현되고, `_r`이 붙으면 색상 순서가 거꾸로 뒤집힌다


```python
sns.barplot(data=temp, x='Marital_Status', y='MntWines', order=['Married', 'Together', 'Single', 'Divorced'], palette='Blues')
```

    <ipython-input-33-c11b1b66f8b8>:1: FutureWarning: 
    
    Passing `palette` without assigning `hue` is deprecated and will be removed in v0.14.0. Assign the `x` variable to `hue` and set `legend=False` for the same effect.
    
      sns.barplot(data=temp, x='Marital_Status', y='MntWines', order=['Married', 'Together', 'Single', 'Divorced'], palette='Blues')
    




    <Axes: xlabel='Marital_Status', ylabel='MntWines'>




    
![png](/assets/img/py2_files/py2_54_2.png)
    


#### 라인그래프 커스터마이징


```python
# 연도별 장르별 베스트셀러 수
books_groupby = books_df.groupby(['Year', 'Genre'])[['Name']].count().reset_index()
books_groupby.rename(columns={'Name':'Count'}, inplace=True)

# 라인 그래프
sns.lineplot(data=books_groupby, x='Year', y='Count', hue='Genre', palette='Purples_r')

```




    <Axes: xlabel='Year', ylabel='Count'>




    
![png](/assets/img/py2_files/py2_56_1.png)
    


 - Spine 제거하기 : despine() 함수
     - 기본값 : top=True, right=True


```python
sns.lineplot(data=books_groupby, x='Year', y='Count', hue='Genre', palette='Purples_r')
sns.despine()
```


    
![png](/assets/img/py2_files/py2_58_0.png)
    


- 범례 옮기기 : move_legend


```python
ax = sns.lineplot(data=books_groupby, x='Year', y='Count', hue='Genre', palette='Purples_r')
sns.move_legend(ax, "upper left")
sns.despine()
```


    
![png](/assets/img/py2_files/py2_60_0.png)
    



```python
# 범례 바깥쪽으로 빼기
ax = sns.lineplot(data=books_groupby, x='Year', y='Count', hue='Genre', palette='Purples_r')
sns.move_legend(ax, 'upper left', bbox_to_anchor=(1, 1))
sns.despine()
```


    
![png](/assets/img/py2_files/py2_61_0.png)
    


- 전체 그래프 설정 변경하기 : sns.set_style()
    - 기본 제공 스타일 : darkgrid, whitegrid, dark, white, ticks


```python
sns.set_style('dark')
sns.lineplot(data=books_groupby, x='Year', y='Count', hue='Genre')
```




    <Axes: xlabel='Year', ylabel='Count'>




    
![png](/assets/img/py2_files/py2_63_1.png)
    


- 전체 실행 환경의 팔레트를 일괄적으로 바꾸는 함수 : set_palette()


```python
sns.set_palette('Set2')
sns.lineplot(data=books_groupby, x='Year', y='Count', hue='Genre')
```




    <Axes: xlabel='Year', ylabel='Count'>




    
![png](/assets/img/py2_files/py2_65_1.png)
    


 - set_theme : set_style과 set_palette를 한번에 적용
    - ex) sns.set_theme(style='white', palette='Set1')


```python
sns.set_theme(style='white', palette='Set1')
sns.lineplot(data=books_groupby, x='Year', y='Count', hue='Genre')
```




    <Axes: xlabel='Year', ylabel='Count'>




    
![png](/assets/img/py2_files/py2_67_1.png)
    


#### 데이터실습 : Axes-level 그래프 사용, 할리우드 영화 장르별 평균 글로벌 매출 시각화

  1. 영화의 장르를 판단할 때는 Genre (First) 컬럼을 기준으로 사용해 주세요.
  2. 글로벌 매출의 평균값이 가장 큰 장르부터 작은 장르까지 내림차순으로 막대를 정렬해 주세요.
  3. errorbar는 없애주세요.
  4. 팔레트는 pink_d 그리고 스타일은 whitegrid를 사용해 주세요.
  5. 상단과 우측의 Spine은 제거해 주세요.


```python
movie_df = pd.read_csv('/content/drive/MyDrive/data/highest_grossing_movies.csv')
movie_df_genre = movie_df.groupby('Genre (First)')[['World Wide Sales (in $)']].mean().sort_values(by='World Wide Sales (in $)', ascending=False)
movie_df_genre = movie_df_genre.reset_index()  # 인덱스를 재설정하여 'Genre (First)'를 다시 열로 만듭니다.

sns.barplot(data=movie_df_genre, y='Genre (First)', x='World Wide Sales (in $)', errorbar=None, palette='pink_d')
sns.set_theme(style='whitegrid')
sns.despine()
```

    <ipython-input-41-430fc81c82ac>:5: FutureWarning: 
    
    Passing `palette` without assigning `hue` is deprecated and will be removed in v0.14.0. Assign the `y` variable to `hue` and set `legend=False` for the same effect.
    
      sns.barplot(data=movie_df_genre, y='Genre (First)', x='World Wide Sales (in $)', errorbar=None, palette='pink_d')
    


    
![png](/assets/img/py2_files/py2_69_1.png)
    


### Matplotlib 기반 그래프 커스터마이징

#### State-based 인터페이스
 - seaborn의 Axes-level 함수 그래프는 Matplotlib의 Axes 객체이기 때문에 동일하게 커스터마이징할 수 있다


```python
import seaborn as sns
import matplotlib.pyplot as plt

# 연도별 장르별 베스트셀러 수
books_groupby = books_df.groupby(['Year', 'Genre'])[['Name']].count().reset_index()

plt.figure(figsize=(9, 4))

sns.lineplot(data=books_groupby, x='Year', y='Name', hue='Genre', palette='Purples_r')
sns.despine()

plt.title('Number of Bestselling Books per Year') # 제목 붙이기
plt.ylabel('Number of Bestselling Books') # y축 라벨 변경

plt.ylim([0, 40])  # y축 표시 범위를 0 ~ 40으로 조정
plt.xticks(books_groupby['Year'].unique())  # x축에 연도가 모두 표시되도록 조정

plt.grid(axis='y', linestyle=':', color='lightgrey') # y축에만 Grid 추가: 점선 스타일, 연회색
```


    
![png](/assets/img/py2_files/py2_72_0.png)
    


#### Object-oriented 인터페이스
  - plt.subplots() 로 Figure와 Axes를 만들어준 후에, 이 Axes에 대한 정보를 seaborn Axes-level 그래프의 ax 파라미터에 넘겨줌


```python
figure, ax = plt.subplots(figsize=(9, 4))

sns.lineplot(data=books_groupby, x='Year', y='Name', hue='Genre', palette='Purples_r', ax=ax)
sns.despine()

ax.set_title('Number of Bestselling Books per Year') # 제목 붙이기
ax.set_ylabel('Number of Bestselling Books') # y축 라벨 변경

ax.set_ylim([0, 40])  # y축 표시 범위를 0~40으로 조정
ax.set_xticks(books_groupby['Year'].unique())  # x축에 연도가 모두 표시되도록 조정

ax.grid(axis='y', linestyle=':', color='lightgrey') # y축에만 Grid 추가: 점선 스타일, 연회색

```


    
![png](/assets/img/py2_files/py2_74_0.png)
    


#### Object-oriented 인터페이스로 여러 개의 Axes 다루기
  - subplots()로 figure와 두 개의 axes를 생성한 후, 각각의 seaborn 그래프 함수의 `ax`파라미터 대응


```python
fig, ax = plt.subplots(1, 2, figsize=(9, 4), constrained_layout=True)

sns.set_palette('Blues_d') # 팔레트 설정

sns.barplot(data=books_df, x='Genre', y='Reviews', errorbar=None, ax=ax[0])  # errorbar는 숨김 처리
sns.violinplot(data=books_df, x='Genre', y='Reviews', ax=ax[1])

sns.despine()  # 두 개 그래프에 다 적용됨

for axes in ax:
    axes.set_xlabel('')  # x축 라벨 숨기기

# ax[0] 가공하기
ax[0].set_title('Average Reviews per Genre') # 제목 붙이기
ax[0].axhline(books_df['Reviews'].mean(), color='grey', linestyle='--') # 평균선 추가하기

# ax[1] 가공하기
ax[1].set_title('Distribution of Reviews per Genre') # 제목 붙이기
ax[1].set_ylabel('')  # y축 라벨 숨기기
```




    Text(0, 0.5, '')




    
![png](/assets/img/py2_files/py2_76_1.png)
    


#### 실습 문제 : 할리우드 영화의 장르별 평균 글로벌 매출을 막대그래프로 시각화
 - 실습 가이드
   1. 기본적인 막대그래프는 아래 가이드에 따라 그려 주세요. 할리우드 영화 장르별 매출 시각화 I 실습에서 완성한 코드를 기반으로 하므로, 앞선 실습에서 작성한 코드를 가져와 기반으로 사용하셔도 무방해요.
     - 영화의 장르를 판단할 때는 Genre (First) 컬럼을 기준으로 사용해 주세요.
     - 글로벌 매출의 평균값이 가장 큰 장르부터 작은 장르까지 내림차순으로 막대를 정렬해 주세요.
     - errorbar는 없애주세요.
     - 팔레트는 pink_d 그리고 스타일은 whitegrid를 사용해 주세요.
     - 상단과 우측의 Spine은 제거해 주세요.
  2. ‘Average World Wide Sales per Genre’라는 제목을 추가해 주세요.
  3. 어차피 y축이 장르라는 사실은 명시적이므로 y축 라벨은 지워주세요.
  4. x축 눈금의 라벨을 million 단위로 잘라서 넣어주세요.
     - 이 내용은 조금 어려울 수 있습니다. 이전 챕터의 K-pop 아이돌의 인스타그램 팔로워 수 시각화 II 실습 중 해설 마지막 부분에서 언급된 axis.set_major_formatter()에 대한 설명을 참고해서 구현해 주세요.
  5. x축 라벨은 ‘World Wide Sales (in Million $)’로 변경해 주세요.


```python
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
movie_df = pd.read_csv('/content/drive/MyDrive/data/highest_grossing_movies.csv')
movie_df_genre = movie_df.groupby('Genre (First)')[['World Wide Sales (in $)']].mean().sort_values(by='World Wide Sales (in $)', ascending=False).reset_index()

fig, ax = plt.subplots()
sns.barplot(data=movie_df_genre, y='Genre (First)', x='World Wide Sales (in $)', errorbar=None, palette='pink_d')
sns.set_theme(style='whitegrid')
sns.despine()
ax.set_title('Average World Wide Sales per Genre')
ax.set_ylabel('')
ax.xaxis.set_major_formatter(ticker.FuncFormatter(lambda x, p: int(x / 1e6)))
ax.set_xlabel('World Wide Sales (in Million $)')
```

    <ipython-input-63-d2eef6cf9fb6>:7: FutureWarning: 
    
    Passing `palette` without assigning `hue` is deprecated and will be removed in v0.14.0. Assign the `y` variable to `hue` and set `legend=False` for the same effect.
    
      sns.barplot(data=movie_df_genre, y='Genre (First)', x='World Wide Sales (in $)', errorbar=None, palette='pink_d')
    




    Text(0.5, 0, 'World Wide Sales (in Million $)')




    
![png](/assets/img/py2_files/py2_78_2.png)
    

