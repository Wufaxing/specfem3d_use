
% writen by yifan Lu 2021.1.22
% �������о������ǵĶ�Ӧ��ϵ
% In��deg���оࡢģ����ײ�vp�ݲ��ٶȣ���λkm/s����depth��Դ���
% Out��incline ģ����ײ�����ǣ���λ�㣩
%
function incline = specfem3d_FK_deg2incline(deg,vp,depth)

    a = taupTime('iasp91',depth,'P','deg',deg);
    p = a.rayParam;
    incline = asin(p * vp / 6371);
    incline = incline * 360 / 2 / pi;
    fprintf("deg = %f   incline = %f\n",deg,incline);