
% written by yifan lu 2021.4
% ����FK-SEM��ģ

clear;clc;tic;set(0,'defaultfigurecolor','w');
cd C:\Users\22247\Desktop\SEM\test_demo\DATA\tomo_files;

%% ����

% ������ֵ
xmin = -90000;    % ƽ����γ�߷���
xmax =  60000;
ymin = -90000;    % ƽ���ھ��߷���
ymax =  60000;
zmin = -70000;
zmax = 0;

% �������ٶ�ģ����ɢ������������������ʹ�õ����񣬸��ٶ�ģ�Ͳ�ֵ������gll���ϣ�
nx = 261;
ny = 261;
nz = 121;
hx = (xmax-xmin) / (nx-1);
hy = (ymax-ymin) / (ny-1);
hz = (zmax-zmin) / (nz-1);

% ��Ļ��ʾ������
fprintf("grid on x = %8.2f m\n",hx);
fprintf("grid on y = %8.2f m\n",hy);
fprintf("grid on z = %8.2f m\n",hz);

vp1 = 6.7;  vs1 = 3.76;     rho1 = 2.8;    % ������ض�����
vp2 = 8.04;  vs2 = 4.37;    rho2 = 3.32;    % ������ص׽���
% vp3 = 8.0;  vs3 = 4.5;    rho3 = 3.3;    % �ؿ�
% vp4 = 8.1;  vs4 = 4.5;    rho4 = 3.2;    % �ϵ��

%% initialize models (true model)
RHO = ones(nx,ny,nz);
VP = ones(nx,ny,nz);
VS = ones(nx,ny,nz);
X = linspace(xmin,xmax,nx);
Y = linspace(ymin,ymax,ny);
Z = linspace(zmin,zmax,nz);
x = 0;
y = 0;
z = 0;

vp_tmp = ones(nx,1) ;
vs_tmp = ones(nx,1) ;
rho_tmp = ones(nx,1) ;

%% define model parameters

for k = 1:1:nz
    z = Z(k)/1000;
    for j = 1:1:ny
        y = Y(j)/1000;
        for i = 1:nx
            x = X(i)/1000;
            
%             if( z >= -20 && z <= 0 )
%                 vp_tmp(i) = vp2 ;
%                 vs_tmp(i) = vs2 ;
%                 rho_tmp(i) = rho2 ;
%             if( z >= -40 && z <= 0 )
%                 vp_tmp(i) = vp1 ;
%                 vs_tmp(i) = vs1 ;
%                 rho_tmp(i) = rho1 ;
            if( z >= -20-20/sqrt(3) && z <= 0 && x < -10 )
                vp_tmp(i) = vp1 ;
                vs_tmp(i) = vs1 ;
                rho_tmp(i) = rho1 ;
            elseif( z >= -70 && z < -20-20/sqrt(3) &&  x < -10 )
                vp_tmp(i) = vp2 ;
                vs_tmp(i) = vs2 ;
                rho_tmp(i) = rho2 ;
            elseif( z >= -70 && z <= 0 && z >= x/sqrt(3) - 10/sqrt(3) - 20 && x >= -10 && x <= 10 )
                vp_tmp(i) = vp1 ;
                vs_tmp(i) = vs1 ;
                rho_tmp(i) = rho1 ;
            elseif( z >= -70 && z <= 0 && z < x - 10/sqrt(3) - 20 && x >= -10 && x <= 10 )
                vp_tmp(i) = vp2 ;
                vs_tmp(i) = vs2 ;
                rho_tmp(i) = rho2 ;
            elseif( z >= -20 && z <= 0 && x >= 10 )
                vp_tmp(i) = vp1 ;
                vs_tmp(i) = vs1 ;
                rho_tmp(i) = rho1 ;
            elseif( z >= -70 && z < -20 &&  x >= 10 )
                vp_tmp(i) = vp2 ;
                vs_tmp(i) = vs2 ;
                rho_tmp(i) = rho2 ;
            
            end
            
%             % ������أ��쳣�壩       �޸� 5*sqrt(3) �ĵط����ɣ�Ҳ���Ƕ�Ӧ����һ��ֱ�Ǳߵĳ���
%             if ( z >= -5 &&  abs(x) <= 20 - 5*sqrt(3)/5*abs(z) && abs(y) <= 20 - 5*sqrt(3)/5*abs(z) )              % б����б30��
% %             if ( z >= -5 &&  abs(x) <= 20 - 5/5*abs(z) && abs(y) <= 20 - 5/5*abs(z) )                              % б���¶�45��
%                 vp_tmp(i) = vp1 + (vp2 - vp1) * abs(z)/5 ;
%                 vs_tmp(i) = vs1 + (vs2 - vs1) * abs(z)/5  ;
%                 rho_tmp(i) = rho1 + (rho2 - rho1) * abs(z)/5  ;
%             end
%             
        end
        
        VP(:,j,k) = 1000.*vp_tmp;
        VS(:,j,k) = 1000.*vs_tmp;
        RHO(:,j,k) = 1000.*rho_tmp;  % ����x����ģ�ͱ�����Ϊ3Dģ��
        
    end
    
    if( k==1 || mod(k,10)==0 )
        fprintf('%d / %d \n',k,nz)
    end
end

figure;  % ƽ����γ����Ƭ
subplot(1,5,[1 2]);
imagesc(X/1000,Z/1000,squeeze(VP(:,round(ny/2),:))'); axis image; set(gca,'Ydir','normal')
title(' V_p true model cross-section');axis image;ylabel(' depth (km)');xlabel('x longitude (km)');axis equal;colorbar;

subplot(1,5,[3 4 5]);  % ƽ���ھ�����Ƭ
imagesc(Y/1000,Z/1000,squeeze(VP(round(nx/2),:,:))'); axis image; set(gca,'Xdir','normal')
title(' V_p true model cross-section');axis image;ylabel(' depth (km)');xlabel('y latitude (km)');set(gca,'ydir','normal');axis equal;colorbar;
set(gcf,'Units','centimeter','Position',[30 10 30 15]);

pause(0.01);

return

%% write  model in disk

% TRUE δ�⻬

fid = fopen('tomography_model.xyz','w');
fprintf(fid,'#------------------------\n');
fprintf(fid,'# Sample tomographic file\n');
fprintf(fid,'#------------------------\n');
fprintf(fid,'#orig_x orig_y orig_z end_x end_y end_z\n');
fprintf(fid,'%.6f %.6f %.6f %.6f %.6f %.6f\n',xmin,ymin,zmax,xmax,ymax,zmin);
fprintf(fid,'#spacing_x spacing_y spacing_z\n');
fprintf(fid,'%.6f %.6f %.6f\n',hx,hy,-hz);
fprintf(fid,'#nx ny nz\n');
fprintf(fid,'%d %d %d\n',nx-1,ny-1,nz-1);
fprintf(fid,'#vpmin vpmax vsmin vsmax rhomin rhomax\n');
fprintf(fid,'%.6f %.6f %.6f %.6f %.6f %.6f\n',min(min(min(VP))),max(max(max(VP))),min(min(min(VS))),max(max(max(VS))),min(min(min(RHO))),max(max(max(RHO))));
fprintf(fid,'#model values\n');
for k = 2:nz
    for j = 1:ny - 1
        for i = 1:nx - 1
            fprintf(fid,'%.6f %.6f %.6f %.6f %.6f %.6f\n',X(i),Y(j),Z(nz-k+2),VP(i,j,nz-k+2),VS(i,j,nz-k+2),RHO(i,j,nz-k+2));
        end
    end
    fprintf("%d / %d layers in z have been finished !\n");
end
fclose all;

disp('finished')
toc
