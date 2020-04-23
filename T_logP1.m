file = '/home/leon/data/version1/metopa/level2/wetPrf/2019.001/wetPrf_MTPA.2019.001.00.02.G30_2016.0120_nc';

temp = ncread(file,'Temp');
temp = temp + 273.15;
pres = ncread(file,'Pres');
vp = ncread(file,'Vp');
ref = ncread(file,'Ref');

figure('position',[100,100,800,1000])
p = plot(temp,pres,'r-');
set(p,'linewidth',2)
hold on
set(gca,'yscale','log','ydir','reverse',...
    'ytick',[100,150,200,300,500,700,1000])

[tt,pp] = meshgrid(-100:50,10.^(linspace(0,3,100)));

tt = tt + 273.15;

% es=(6.112*exp(17.67*(tt-273.15)./(tt-29.65)));

t0 = 273.15;
les = 10.79586*(1-t0./tt)-5.02808*log10(tt./t0)+...
      1.50475*1e-4*(1-10.^(-8.2969*(tt./t0-1)))+...
      0.42873*1e-3*(10.^(4.76955*(1-t0./tt)))+0.78614;
es = 10.0.^les;
qs=0.62197*es./(pp-es);
tlcl=55.0+2840.0./(3.5*log(tt)-log(es)-4.805);
pt2 = tt.*((1000./pp).^0.286);
eqt2=pt2.*exp(((3376./tlcl)-2.54).*qs.*(1.0+0.81*qs));

[c,h] = contour(tt,pp,pt2,[-100:20:550]+273.15);
set(h,'linestyle','-','color','k')

[c,h] = contour(tt,pp,eqt2,[-100:20:200]+273.15);
set(h,'linestyle','--','color','k')

xlim([-100,40]+273.15)
ylim([200,1000])
xlim([-60,30]+273.15)

id = find(pres > 0);
id0 = id(1);
p0 = pres(id0);
pt0 = temp(id0);
vp0 = vp(id0);

p1 = linspace(p0,1,1000);
t1 = pt0./((p0./p1).^0.286);
p = plot(t1,p1,'b--');
set(p,'linewidth',2)

t0 = 273.16;
les1 = 10.79586*(1-t0./t1)-5.02808*log10(t1./t0)+...
      1.50475*1e-4*(1-10.^(-8.2969*(t1./t0-1)))+...
      0.42873*1e-3*(10.^(4.76955*(1-t0./t1)))+0.78614;
es1 = 10.0.^les1;
qs1=0.62197*es1./(p1-es1);

q0=0.62197*vp0./(p0-vp0);
id = find(qs1 > q0);
p = plot(t1(id),p1(id),'b-');
set(p,'linewidth',2)
id1 = id(end)+1;

function pt = theta_temp(temp,pres,p0)
    pt = temp.*((p0./pres).^0.286);
end 

function [es1,qs1] = t2es(t1);
    t0 = 273.16;
    les1 = 10.79586*(1-t0./t1)-5.02808*log10(t1./t0)+...
          1.50475*1e-4*(1-10.^(-8.2969*(t1./t0-1)))+...
          0.42873*1e-3*(10.^(4.76955*(1-t0./t1)))+0.78614;
    es1 = 10.0.^les1;
end

function q = e2q(ep,pres)
    q=0.62197*ep./(pres-ep);
end 

function eqt2 = ptq2eqt(tt,pp);
    t0 = 273.15;
    les = 10.79586*(1-t0./tt)-5.02808*log10(tt./t0)+...
        1.50475*1e-4*(1-10.^(-8.2969*(tt./t0-1)))+...
        0.42873*1e-3*(10.^(4.76955*(1-t0./tt)))+0.78614;
    es = 10.0.^les;
    qs=0.62197*es./(pp-es);
    tlcl=55.0+2840.0./(3.5*log(tt)-log(es)-4.805);
    pt2 = tt.*((1000./pp).^0.286);
    eqt2=pt2.*exp(((3376./tlcl)-2.54).*qs.*(1.0+0.81*qs));
end 
