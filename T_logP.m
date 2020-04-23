function T_logP(temp,pres,vp)  

    figure('position',[100,100,900,1000])
    p = plot(temp,pres,'r-');
    set(p,'linewidth',3)
    hold on
    xtk = -80:10:40;
    set(gca,'yscale','log','ydir','reverse','position',[0.07,0.05,0.90,0.92],...
        'ytick',[100,150,200,300,400,500,600,700,800,900,1000],...
        'xtick',xtk+273.15,'xticklabel',xtk);

    % 计算露点温度
    es = t2es(temp);
    rh = vp./es*100;
    dtemp = rh2dt(rh,temp-273.15)+273.15;
    p = plot(dtemp,pres);
    set(p,'linewidth',2,'linestyle','-','color',[1,0.5,0])

    [tt,pp] = meshgrid(-100:50,10.^(linspace(0,3,100)));
    tt = tt + 273.15;

    pt2 = pt2qt(tt,pp,1000); % 计算位温
    eqt2 = qt2eqt(pt2,tt,pp); % 计算假相当位温
    es2 = t2es(tt); % 计算饱和水汽压
    qs2 = e2q(es2,pp); % 计算饱和比湿

    [c,h] = contour(tt,pp,pt2,[-100:20:550]+273.15);
    set(h,'linestyle','-','color','k')
    [c,h] = contour(tt,pp,eqt2,[-100:20:200]+273.15);
    %[c,h] = contour(tt,pp,eqt2,exp(linspace(log(-100+273.15),log(200+273.15),10)));
    set(h,'linestyle','--','color','k')
    [c,h] = contour(tt,pp,qs2,exp(linspace(log(0.01),log(50),20))/1000);
    set(h,'linestyle','-.','color',[0,0.7,0])

    xlim([-100,40]+273.15)
    ylim([200,1000])
    xlim([-80,40]+273.15)

    id = find(pres > 0);
    id0 = id(1);
    p0 = pres(id0);
    pt0 = temp(id0);
    vp0 = vp(id0);

    p1 = linspace(p0,1,1000);
    t1 = pt0./((p0./p1).^0.286);

    %p = plot(t1,p1,'b--');
    %set(p,'linewidth',2)

    es1 = t2es(t1);
    qs1 = e2q(es1,p1);
    q0 = e2q(vp0,p0);

    [c,h] = contour(tt,pp,qs2,[q0,1000000]);
    set(h,'linestyle','-','color',[0,0.7,0],'linewidth',2)

    xa = [];
    ya = [];

    id = find(qs1 > q0);
    p = plot(t1(id),p1(id),'b-');
    set(p,'linewidth',3)
    id1 = id(end);
    xa = [xa,t1(id)];
    ya = [ya,p1(id)];

    t3 = t1(id1);
    p3 = p1(id1);
    pt3 = pt2qt(t3,p3,1000);
    eqt3 = qt2eqt(pt3,t3,p3);

    [c,h] = contour(tt,pp,eqt2,[eqt3,1000]);
    set(h,'linestyle','none')

    t = 1;
    n0 = 2;
    while t > 0
        n = c(2,n0-1);
        n1 = n0+n-1;
        if n1 > size(c,2)
            t = -1;
        end
        if t > 0 
            x = c(1,n0:n1);
            y = c(2,n0:n1);
            id = find(x < t3+10 & x > t3-10 & y < p3+50 & y > p3-50);
            if length(id) > 1 
                idt = y <= p3;
                plot([t3,x(idt)],[p3,y(idt)],'linestyle','-','color','b','linewidth',2)
                xa = [xa,x(idt)];
                ya = [ya,y(idt)];
            end
        end
        n0 = n1+2;
        if n0 > size(c,2)
            t = -2;
        end
    end

    [ya,is] = sort(ya);
    xa = xa(is);

    te = interp1(ya,xa,pres);
    if 0
        for i = 1:length(te)
            if te(i) > temp(i) 
                p = plot([te(i),temp(i)],pres(i)+[0,0]);
                set(p,'color',[1,0,1],'linewidth',2)
            else
                p = plot([te(i),temp(i)],pres(i)+[0,0]);
                set(p,'color',[0,1,1],'linewidth',2)
            end
        end
    end
    if 1
        for i = 2:length(te)
            if te(i) >= temp(i) & te(i-1) >= temp(i-1) 
                p = fill([te(i),temp(i),temp(i-1),te(i-1)],[pres(i),pres(i),pres(i-1),pres(i-1)],[1,0,1]);
                set(p,'edgecolor','none')
            end
            if te(i) <= temp(i) & te(i-1) <= temp(i-1)
                p = fill([te(i),temp(i),temp(i-1),te(i-1)],[pres(i),pres(i),pres(i-1),pres(i-1)],[0,1,1]);
                set(p,'edgecolor','none')
            end
            if 1
                if te(i) > temp(i) & te(i-1) < temp(i-1)
                    sc = (temp(i-1)-te(i-1))/(te(i)-temp(i)+temp(i-1)-te(i-1));
                    dt = temp(i)-temp(i-1);
                    dp = pres(i)-pres(i-1);
                    ctemp = temp(i-1)+dt*sc;
                    cpres = pres(i-1)+dp*sc;
                    p = fill([temp(i-1),te(i-1),ctemp],[pres(i-1),pres(i-1),cpres],[0,1,1]);
                    set(p,'edgecolor','none')
                    p = fill([temp(i),te(i),ctemp],[pres(i),pres(i),cpres],[1,0,1]);
                    set(p,'edgecolor','none')
                    % disp([ctemp,ctemp1])
                end
                if te(i) < temp(i) & te(i-1) > temp(i-1)
                    sc = (temp(i-1)-te(i-1))/(te(i) - temp(i)+temp(i-1)-te(i-1));
                    dt = temp(i)-temp(i-1);
                    dp = pres(i)-pres(i-1);
                    ctemp = temp(i-1)+dt*sc;
                    cpres = pres(i-1)+dp*sc;
                    p = fill([temp(i-1),te(i-1),ctemp],[pres(i-1),pres(i-1),cpres],[1,0,1]);
                    set(p,'edgecolor','none')
                    p = fill([temp(i),te(i),ctemp],[pres(i),pres(i),cpres],[0,1,1]);
                    set(p,'edgecolor','none')
                    % disp([temp(i-1),temp(i),ctemp,pres(i-1),pres(i),cpres])
                end
            end
        end
    end
end

% function 
% {{{
function pt = pt2qt(temp,pres,p0) % 位温 
    pt = temp.*((p0./pres).^0.286); 
end 

function es1 = t2es(t1); % 饱和水汽压
    t0 = 273.16;
    les1 = 10.79586*(1-t0./t1)-5.02808*log10(t1./t0)+...
          1.50475*1e-4*(1-10.^(-8.2969*(t1./t0-1)))+...
          0.42873*1e-3*(10.^(4.76955*(1-t0./t1)))+0.78614;
    es1 = 10.0.^les1;
end

function q = e2q(ep,pres) % 根据气压和水汽压计算比湿
    q=0.62197*ep./(pres-ep);
end 

function eqt2 = qt2eqt(pt2,tt,pp); % 根据温度气压、位温计算假相当位温
    es = t2es(tt);
    qs = e2q(es,pp);
    tlcl=55.0+2840.0./(3.5*log(tt)-log(es)-4.805);
    eqt2=pt2.*exp(((3376./tlcl)-2.54).*qs.*(1.0+0.81*qs));
end

function dtemp = rh2dt(rh,temp) % 通过相对湿度和温度计算露点温度
    t0 = 0;
    tk = temp+t0;
    a = 6.112;
    b = 17.62;
    c = 243.12;
    d = 234.5;
    et = log(rh/100.*exp((b-tk/d).*(tk./(c+tk))));
    dtk = c*et./(b-et);
    dtemp = dtk-t0;
end
% }}}
