import pandas as pd
import json
path="df_r.csv"
path="chinesedf_r.csv"
x = pd.read_csv(path)
#x = pd.read_csv("chinesedf_r.csv")

length=x.shape[0]
month=2
d_all={}
pop_all=0

def dict_add(dict1,dict2):
    newdict=dict(dict1)
    for key, value in dict2.items():
        if key in newdict:
            newdict[key]=newdict[key]+value
        else:
            newdict[key]=value
    return newdict

for i in range(length):
    str=x.iloc[i,month]
    #weight with popularity
    pop=x.iloc[i,3]
    pop_all+=pop
    d=json.loads(str)
    d = {key: value * pop for key, value in d.items()}
    #Plan B: using Counter package
    #d_all=dict(Counter(d)+Counter(d_all))
    d_all=dict_add(d_all,d)
result = {k: v / pop_all for k, v in d_all.items()}
print(pop_all)
result_sorted= sorted(result.items(), key=lambda item: item[1],reverse=True)
print(result_sorted)
df=pd.DataFrame(result_sorted)
df.to_csv('Chinese_POIs.csv', index=False)  



