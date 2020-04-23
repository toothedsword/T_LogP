file = '/home/leon/data/version1/metopa/level2/wetPrf/2019.030/wetPrf_MTPA.2019.030.02.06.G18_2016.0120_nc';

temp = ncread(file,'Temp');
temp = temp + 273.15;
pres = ncread(file,'Pres');
vp = ncread(file,'Vp');
ref = ncread(file,'Ref');

T_logP(temp,pres,vp)

