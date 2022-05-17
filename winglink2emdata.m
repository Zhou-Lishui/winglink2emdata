% ###################################################################################################################
% # A script for converting the input files uesd for inverson from WinGlink to the emdata file used for Mare2dem     
% #                                                      Author:Zhou Lishui                                         
% #                                                  Copyright (c) 2021-2022 CUGB 
% #                                                  E-mail:zhoulishui@cugb.edu.cn 
% # NOTE: 1, Input files: "*.tm"(not statics.tm),"*.,te","*.,tip","*,stn" from WinGlink                                                                                                           
% #       2, The output file is "winglink2mare2dem.emdata"                                                                                                                                                                                                                                                                                                                                                      #
% ###################################################################################################################

clc
clear
erroRhotm=0.1;%  set an errofloor for the TM log10(rho) eg: 0.1 is equal to 10%
erroPhasetm=0.05/2;%  set an errofloor for the TM phase eg: 0.05 is equal to 5%
erroRhote=0.1;%  set an errofloor for the TE log10(rho) 
erroPhasete=0.05/2;%  set an errofloor for the TE phase 
erroTip=0.05;%  set an errofloor for the Tipper
[filename,path]=uigetfile({'*.tm*'});
if filename==0
    disp('user canceled...')
    return
end
[WGtm1,WGtm2,WGtm3,WGtm4,WGtm5]=textread(filename,'%f %f %f %f %f', 'delimiter', ',()');
WGtm=[WGtm1,WGtm2,WGtm3,WGtm4,WGtm5];
num=WGtm(1,1);
WGtm(1,:)=[];
WGtm(:,3)=-WGtm(:,3);
WGtm(:,2)=log10(WGtm(:,2));
[N,K]=find(WGtm(:,3)==0);
N(num+1)=size(WGtm,1);
 for i=1:num
n(i)=WGtm(N(i),1);
WGtm(N(i),1)=NaN;
e(i)=i-1;
 end
WGtm(:,1)=1./WGtm(:,1);
WGtm(:,1)=roundn(WGtm(:,1),-5);
f1=unique(WGtm(:,1));
TF=isnan(f1);
f1(TF)=[];
[filename,path]=uigetfile({'*.tip*'});
if filename==0
    disp('user canceled...')
    return
end
[WGtip1,WGtip2,WGtip3,WGtip4]=textread(filename,'%f %f %f %f', 'delimiter', ',()');
WGtip3=-(WGtip3);
WGtip=[WGtip1,WGtip2,WGtip3,WGtip4];
num=WGtip(1,1);
WGtip(1,:)=[];
for i=1:size(WGtip,1)
    if WGtip(i,2)==0&&WGtip(i,3)==0
        WGtip(i,6)=1;
    end
end
[N1,K]=find(WGtip(:,6)==1);
N1(num+1)=size(WGtip,1);
 for i=1:num
n(i)=WGtip(N1(i),1);
WGtip(N1(i),1)=NaN;
e(i)=i-1;
 end
WGtip(:,1)=1./WGtip(:,1);
WGtip(:,1)=roundn(WGtip(:,1),-5);
 f2=unique(WGtip(:,1));
 TF=isnan(f2);
 f2(TF)=[];
 f3=[f1;f2];
 f=unique(f3);
for k=1:size(f,1)
    [P,Q]=find(WGtm(:,1)==f(k));
    WGtm(P,6)=k;
end
for i=1:num
WGtm(N(i):N(i+1),7:8)=i;
end
for i=1:num
WGtm(N(i)-e(i),:)=[];
end
maretm=zeros(((N(num+1)-num)-num)*2,6);
maretm(1:(N(num+1)-num),1)=125;
maretm(1:(N(num+1)-num),2)=WGtm(:,6);
maretm(1:(N(num+1)-num),3:4)=WGtm(:,7:8);
maretm(1:(N(num+1)-num),5)=WGtm(:,2);

for i=1:size(WGtm,1)
    if WGtm(i,4)<erroRhotm
        WGtm(i,4)=erroRhotm;
    end
end
maretm(1:(N(num+1)-num),6)=WGtm(:,4)./(log(10));
maretm((N(num+1)-num)+1:(N(num+1)-num)*2,1)=106;
maretm((N(num+1)-num)+1:(N(num+1)-num)*2,2)=WGtm(:,6);
maretm((N(num+1)-num)+1:(N(num+1)-num)*2,3:4)=WGtm(:,7:8);
maretm((N(num+1)-num)+1:(N(num+1)-num)*2,5)=WGtm(:,3);
for i=1:size(WGtm,1)
    if WGtm(i,5)<erroPhasetm
        WGtm(i,5)=erroPhasetm;
    end
end
maretm((N(num+1)-num)+1:(N(num+1)-num)*2,6)=WGtm(:,5)*(180/3.14);
[filename,path]=uigetfile({'*.te*'});
if filename==0
    disp('user canceled...')
    return
end
[WGte1,WGte2,WGte3,WGte4,WGte5]=textread(filename,'%f %f %f %f %f', 'delimiter', ',()');
WGte=[WGte1,WGte2,WGte3,WGte4,WGte5];
num=WGte(1,1);
WGte(1,:)=[];
WGte(:,3)=-WGte(:,3);
WGte(:,2)=log10(WGte(:,2));
[N,K]=find(WGte(:,3)==0);
N(num+1)=size(WGte,1);
 for i=1:num
n(i)=WGte(N(i),1);
WGte(N(i),1)=NaN;
e(i)=i-1;
 end
WGte(:,1)=1./WGte(:,1);
WGte(:,1)=roundn(WGte(:,1),-5);
for k=1:size(f,1)
    [P,Q]=find(WGte(:,1)==f(k));
    WGte(P,6)=k;
end
for i=1:num
WGte(N(i):N(i+1),7:8)=i;
end
for i=1:num
WGte(N(i)-e(i),:)=[];
end
marete=zeros(((N(num+1)-num)-num)*2,6);
marete(1:(N(num+1)-num),1)=123;
marete(1:(N(num+1)-num),2)=WGte(:,6);
marete(1:(N(num+1)-num),3:4)=WGte(:,7:8);
marete(1:(N(num+1)-num),5)=WGte(:,2);
for i=1:size(WGte,1)
    if WGte(i,4)<erroRhote
        WGte(i,4)=erroRhote;
    end
end
marete(1:(N(num+1)-num),6)=WGte(:,4)./(log(10));
marete((N(num+1)-num)+1:(N(num+1)-num)*2,1)=104;
marete((N(num+1)-num)+1:(N(num+1)-num)*2,2)=WGte(:,6);
marete((N(num+1)-num)+1:(N(num+1)-num)*2,3:4)=WGte(:,7:8);
marete((N(num+1)-num)+1:(N(num+1)-num)*2,5)=WGte(:,3);

for i=1:size(WGte,1)
    if WGte(i,5)<erroPhasete
        WGte(i,5)=erroPhasete;
    end
end
marete((N(num+1)-num)+1:(N(num+1)-num)*2,6)=WGte(:,5)*(180/3.14);

for k=1:size(f,1)
    [P,Q]=find(WGtip(:,1)==f(k));
    WGtip(P,6)=k;
end
for i=1:num
WGtip(N1(i):N1(i+1),7:8)=i;
end
for i=1:num
WGtip(N1(i)-e(i),:)=[];
end
maretip=zeros(((N1(num+1)-num)-num)*2,6);
maretip(1:(N1(num+1)-num),1)=133;
maretip(1:(N1(num+1)-num),2)=WGtip(:,6);
maretip(1:(N1(num+1)-num),3:4)=WGtip(:,7:8);
maretip(1:(N1(num+1)-num),5)=WGtip(:,2);

for i=1:size(WGtip,1)
    if WGtip(i,4)<erroTip
        WGtip(i,4)=erroTip;
    end
end
maretip(1:(N1(num+1)-num),6)=WGtip(:,4);
maretip((N1(num+1)-num)+1:(N1(num+1)-num)*2,1)=134;
maretip((N1(num+1)-num)+1:(N1(num+1)-num)*2,2)=WGtip(:,6);
maretip((N1(num+1)-num)+1:(N1(num+1)-num)*2,3:4)=WGtip(:,7:8);
maretip((N1(num+1)-num)+1:(N1(num+1)-num)*2,5)=WGtip(:,3);
maretip((N1(num+1)-num)+1:(N1(num+1)-num)*2,6)=WGtip(:,4); 
 mare2demdata=[maretm;marete;maretip];
%  mare2demdata=[maretm];
%  mare2demdata=[maretm;marete];
[filename,path]=uigetfile({'*.stn*'});
if filename==0
    disp('user canceled...')
    return
end
[Name,Y]=textread(filename,'%s %f', 'delimiter', ';','headerlines', 2);
Y=Y.*1000;
Name=string(Name);
nF=size(f,1);
ns=size(Y,1);
site=string(zeros(ns,9));
site(:,2)=string(Y);
site(:,9)=Name;
ndata=size(mare2demdata,1);
mat1=f;
mat2=site;
fid = fopen('winglink2mare2dem.emdata', 'wt');
fprintf(fid,'Format:  EMData_2.2');
fprintf(fid,'\nUTM of x,y origin (UTM zone, N, E, 2D strike): 0 N 0 0   0');
fprintf(fid,'\n# MT Frequencies: %d',nF);
fprintf(fid, '\n');
for i = 1:size(mat1, 1)
    fprintf(fid, '%f\t', mat1(i,:));
    fprintf(fid, '\n');
end
fprintf(fid,'# MT Receivers: %d',ns);
fprintf(fid,'\n!	X	Y	Z	Theta	Alpha	Beta	Length	SolveStatic	Name');
fprintf(fid, '\n');
for i = 1:size(mat2, 1)
    fprintf(fid, '%s\t', mat2(i,:));
    fprintf(fid, '\n');
end
fprintf(fid,'# Data: %d',ndata);
fprintf(fid,'\n!	Type	Freq #	Tx #	Rx #	Data	StdErr');
fprintf(fid, '\n');
mat3 = mare2demdata;
for i = 1:size(mat3, 1)
    fprintf(fid, '%f\t', mat3(i,:));
    fprintf(fid, '\n');
end
fclose(fid);
