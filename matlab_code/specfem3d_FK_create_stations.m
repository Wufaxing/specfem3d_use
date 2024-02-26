
% create stations for SPECFEM
% written by yifan Lu 2021.3.6

clear;clc;
cd C:\Users\22247\Desktop\SEM\test_demo;
a = 5;
disp('Output Dir:  ');
fprintf('%c',8);         % 評茅算佩憲8
disp(pwd);

%！！！！！！！！！！！！！！
nstations = 61;
y_start = -90e3;
y_end = 60e3;
%！！！！！！！！！！！！！！

dy = (y_end - y_start) / (nstations-1);       
fid = fopen('STATIONS','w');
for j = 1:nstations
    y = y_start + (j-1)*dy;
    fprintf(fid,'%s  %s  %.6f  %.6f  %.1f  %.1f\n', strcat('S',num2str(j,'%04d')), 'AA', 0, y, 0.0, 0.0);
end
fclose(fid);
disp('Finished!!!')



