files = dir('/home/leon/data/version1/metopa/level2/wetPrf/2019.0*/wetPrf*_nc');

for ifile = 1:length(files)
    try 
        file = [files(ifile).folder,'/',files(ifile).name];
        lat = ncread(file,'Lat');
        temp = ncread(file,'Temp');
        temp = temp + 273.15;
        pres = ncread(file,'Pres');
        vp = ncread(file,'Vp');
        id = find(pres > 0);
        if max(pres) > 900 & max(abs(lat)) < 10  
            T_logP(temp,pres,vp)
            set(gcf,'visible','off')
            %xlim([-120,40])
            title(files(ifile).name)
            disp(files(ifile).name)
            print('-dpng','-r100',['~/tmp/',files(ifile).name,'.png'])
        end
    end
    close all
end

