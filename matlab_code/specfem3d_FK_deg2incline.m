
% writen by yifan Lu 2021.1.22
% 计算震中距和入射角的对应关系
% In：deg震中距、模型最底层vp纵波速度（单位km/s）、depth震源深度
% Out：incline 模型最底层入射角（单位°）
%
function incline = specfem3d_FK_deg2incline(deg,vp,depth)

    a = taupTime('iasp91',depth,'P','deg',deg);
    p = a.rayParam;
    incline = asin(p * vp / 6371);
    incline = incline * 360 / 2 / pi;
    fprintf("deg = %f   incline = %f\n",deg,incline);