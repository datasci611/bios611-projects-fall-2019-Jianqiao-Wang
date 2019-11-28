# packages for data processing
import pandas as pd
import numpy as np
from datetime import datetime
from matplotlib import pyplot as plt
# for VCL
plt.switch_backend('agg')

# packages for linear model
import statsmodels
import statsmodels.formula.api as smf
import statsmodels.api as sm

# convert date into datetime type
def parse_date(string):
	month, day, year = string.split('/')
	return datetime(int(year), int(month), int(day))

# extract number of days from datetime
def stay(time):
	return time.days

def remove_HUD(string):
	return string[:-6]

# read and select data with parameters of interest
client_background = ["Client ID", "Client Age at Entry", "Client Gender", "Client Primary Race", "Client Ethnicity", "Client Veteran Status"]
duration_interest = ['Client ID', 'Entry Date', 'Exit Date']
client = pd.read_csv("https://raw.githubusercontent.com/datasci611/bios611-projects-fall-2019-Jianqiao-Wang/master/project_3/data/CLIENT_191102.tsv", sep="\t")[client_background]
duration = pd.read_csv("https://raw.githubusercontent.com/datasci611/bios611-projects-fall-2019-Jianqiao-Wang/master/project_3/data/ENTRY_EXIT_191102.tsv", sep="\t")[duration_interest]

# join two datasets by client ID
data = pd.concat([duration, client], axis=1, join="inner")

# replace cells with NAN
data.replace('Data not collected (HUD)', np.nan, inplace=True)
data.replace("Client doesn't know (HUD)", np.nan, inplace=True)
data.replace('Client refused (HUD)', np.nan, inplace=True)

# remove missing data
data.dropna(inplace=True)

# calculate duration of people
data["Entry Date"] = data["Entry Date"].apply(parse_date)
data["Exit Date"] = data["Exit Date"].apply(parse_date)
data["duration"] = (data["Exit Date"] - data["Entry Date"]).apply(stay)
data = data.loc[data['duration']>0]

# rename some column names for later analysis
data.rename(columns={"Client Primary Race": "Race", 
                     "Client Ethnicity": "Ethnicity", 
                     "Client Veteran Status": "VeteranStatus", 
                     "Client Age at Entry": "Age", 
                     "Client Gender": "Gender"}, inplace=True)

# remove HUD tail
data["Race"]=data["Race"].apply(remove_HUD)
data["Ethnicity"]=data["Ethnicity"].apply(remove_HUD)
data["VeteranStatus"]=data["VeteranStatus"].apply(remove_HUD)

# save data
data.to_csv("./results/duration.csv")

# gamma regression to test effect of different covariates
model = smf.glm(formula='duration~Age+Gender+Ethnicity+Race+VeteranStatus', 
                family=sm.families.Gamma(), data=data,).fit()

model.save("./results/gamma_regression.pickle")