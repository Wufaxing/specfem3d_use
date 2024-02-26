
% ����������ͼ��������պ��������ƽ��պ�������ͼ
% SPECFEM3D FK-SEM written by yifan Lu 2021.1.22

clear;clc;fclose all;set(0,'defaultfigurecolor','w');

%******************************************
% ������

Indir = 'C:\Users\22247\Desktop\outputfile3\';    % *.semd�ļ�·��
Outdir =  'C:\Users\22247\Desktop\outputfile3\';  % ���ͼƬ�Ͳ���·��
baz = 0;        % ��Դ����λ��
deg = 60;        % ���о�
save_figure = 1;   % �Ƿ�洢ͼƬ(��΢��ʱ)
save_mat = 1;      % �Ƿ�洢���

%******************************************

% ������������������  
cd(Indir);
datax = dir('*X.semd');
datay = dir('*Y.semd');
dataz = dir('*Z.semd');
nstation = length(datax);

for i = 1:1:nstation
    datx = load(strcat(Indir, datax(i).name), '-ascii'); 
    daty = load(strcat(Indir, datay(i).name), '-ascii');
    datz = load(strcat(Indir, dataz(i).name), '-ascii');
    nt = size(datx, 1);  
    ux(1:nt,i) = datx(:,2);                                                 % ux����
    uy(1:nt,i) = daty(:,2);                                                 % uy����
    uz(1:nt,i) = datz(:,2);                                                 % uz����
    if (1 == i)
        t = datx(:,1);                                                      % t����
    end
end
fprintf('Finish read data ... \n\n');

%% ����zd rd ����ͼ

for i = 1:nstation
    [rd(:,i) ~] = calcrdtd( ux(:,i) , uy(:,i) , baz ); %����ֻ���㾶����պ�����û����������պ���
end

% Z����
figure(1);
for i = 1:1:nstation
    plot(t,uz(:,i)/5 + i,'k');
    hold on;
end
xlabel('Times (s)','fontsize',12);ylabel('# Station','fontsize',12);
set(gca,'xminortick','on');xlim([0,100]);ylim([-10,nstation+10]);
title('Z component','fontsize',20);
textstring = strcat('baz =',32,num2str(baz),'��',32,'deg =',32,num2str(deg),'��');
text(40,105,textstring,'fontsize',15,'color','k');
set(gcf,'Units','centimeter','Position',[2 2 20 30]);

% R����
figure(2);
for i = 1:1:nstation
    plot(t,rd(:,i)/5 + i,'k');
    hold on;
end
xlabel('Times (s)','fontsize',12);ylabel('# Station','fontsize',12);
set(gca,'xminortick','on');xlim([0,100]);ylim([-10,nstation+10]);
title('R component','fontsize',20);
textstring = strcat('baz =',32,num2str(baz),'��',32,'deg =',32,num2str(deg),'��');
text(40,105,textstring,'fontsize',15,'color','k');
set(gcf,'Units','centimeter','Position',[2 2 20 30]);

%% ������պ�������ͼ

tlag = 2;
gauss = 1.5;
half_length = 25;  

for i = 1:nstation
     [RFs(:,i),~] = makeRFitdecon(rd(:,i),uz(:,i),t(2)-t(1),0,half_length,tlag,gauss,20,0.0001,0);
     fprintf('%d / %d RFs have been finished ... \n',i,nstation);
end

t_rf = ((1:size(RFs,1))-1)*(t(2)-t(1))-tlag;                           % RFʱ������

figure(3);                                                             % RF����ͼ
ampl = 5.0;                                                            % **********************************
hold off;
for j = 1:1:nstation
    normalization = max(abs(RFs(:,j)));
    tr = RFs(:,j)/normalization * ampl;                                % ��һ����ĸõ� * 5 ������ͼ����Է��ȣ�
    tr(1)=0;
    tr(end)=0;
    tr_positive = tr.*(tr > 0.0);
    tr_negative = tr - tr_positive;
    fill(j + tr_positive, t_rf, 'r');
    hold on
    fill(j + tr_negative, t_rf, 'b');
    hold on;
end
hold off;
set(gca, 'ydir', 'reverse');
set(gca, 'xlim', [1-ampl nstation+ampl]);
set(gca, 'ylim', [-tlag half_length]);
set(gca, 'yminortick','on');
xlabel('# STATION');
ylabel('Time (s)');
title('RF');
ylim([-5,25]);
set(gcf,'Units','centimeter','Position',[30 15 40 10]);

%% ���ͼƬ������

if save_figure == 1
    cd(Outdir);
    print(['component_Z.jpeg'],figure(1),'-djpeg','-r300');
    print(['component_R.jpeg'],figure(2),'-djpeg','-r300');
    print(['RF.jpeg'],figure(3),'-djpeg','-r300');
end

if save_mat == 1
    cd(Outdir);
    save('matlab.mat','RFs','t_rf');
end

pause(1)
close all;



