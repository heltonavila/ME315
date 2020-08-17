#!/usr/bin/env python
# coding: utf-8

# In[53]:


import pandas as pd


# In[54]:


#Importa o BD com zero nos NA's
chuva = pd.read_csv("http://www.ime.unicamp.br/~gvludwig/2018s2-me315/INMET-14JAN2018-14AUG2018-SOROCABA.csv", na_values = 0)

#Converte a variavel precipitacao em numerico
chuva.loc[:,'precipitacao'] = chuva['precipitacao'].apply(pd.to_numeric, errors = 'coerce')

#Converte a variavel data em data
chuva.loc[:,'data'] = chuva['data'].apply(pd.to_datetime, dayfirst = True)


# In[55]:


#Encontra a precipitacao diaria
chuvaDiaria = chuva[['data','hora','precipitacao']].groupby('data').sum().reset_index()

#Remove a coluna chuva
chuvaDiaria = chuvaDiaria.drop(columns = 'hora')

#Remove o primeiro e ultimo dia
chuvaDiaria = chuvaDiaria.drop(chuvaDiaria.index[[0, -1]])


# In[58]:


def group10(x):
    datas = pd.date_range(start = chuvaDiaria.data.min(), end = chuvaDiaria.data.max(), freq = '10D')
    for i in range(0, len(datas)-1): # Only need to check until before last day
        if ((x >= datas[i]) & (x < datas[i+1])): # Matching types!
            return i
        else:
             pass
    return float('NaN')


# In[59]:


chuvaDiaria['grupo'] = chuvaDiaria['data'].apply(func = group10)

chuvaAgrupada = chuvaDiaria.groupby('grupo').agg({'precipitacao':'sum', 'data':'first'})#.reset_index()


# In[60]:


def alis_exp(x, alpha = 0.2):
    if (alpha <= 0.0) | (alpha >= 1.0):
        raise ValueError("alpha must be a number between 0 and 1.")
    # implemente seu loop aqui
    ae = x.copy()
    for i in range(1, len(x)-2):
        ae[i] = (alpha * ae[i]) + ((1 - alpha) * ae[i-1])
    # implemente seu loop aqui
    return ae # assumindo a série suavizada em um objeto de nome ae.


# In[122]:





# In[61]:


chuvaAgrupada['alisado02'] = alis_exp(chuvaAgrupada['precipitacao'], 0.2)
chuvaAgrupada['alisado08'] = alis_exp(chuvaAgrupada['precipitacao'], 0.8)


# In[63]:


import matplotlib.pyplot as plt
chuvaAgrupada.plot(x = 'data', y = ['precipitacao','alisado08','alisado02'])
plt.show()


# In[68]:


import pandas as pd
baby = pd.read_csv("http://www.ime.unicamp.br/~gvludwig/2018s2-me315/baby-names.csv")


# In[69]:


baby['endswith'] = baby.loc[:,'name'].apply(lambda x: x[-1])


# In[116]:


import numpy as np
babyLetra = baby.pivot_table(values='percent', index=['year', 'endswith'], columns=['sex'], aggfunc=np.sum, fill_value = 0).reset_index()



#teste.loc[:,'year'] = teste['year'].apply(pd.to_datetime, format='%Y')

#teste.groupby(['decade','endswith']).sum()


# In[97]:


def decada(x):
    inicio = babyLetra['year'].min()
    return (np.trunc((x - inicio)/10))+1


# In[117]:


babyLetra['decade'] = babyLetra['year'].apply(func = decada)


# In[118]:


babyDecada = babyLetra.groupby(['decade','endswith']).agg({'boy':'mean', 'girl':'mean'}).reset_index()


# In[112]:


def ano(x):
    return round(1880+10*(x-1))


# In[133]:


babyDecada['ano'] = babyDecada['decade'].apply(func = ano)

#Tabela dos nomes dos meninos e das meninas
meninos = babyDecada.drop(columns = ['decade', 'girl'])
meninas = babyDecada.drop(columns = ['decade', 'boy'])


# In[135]:


import matplotlib.pyplot as plt
meninas.groupby('ano').plot.bar(x = 'endswith', y = 'girl', ylim = (0, 0.35))
plt.show()


# In[142]:


import matplotlib.pyplot as plt
meninos.groupby('ano').plot.bar(x = 'endswith', y = 'boy', ylim = (0, 0.3))
plt.show()


# In[ ]:




