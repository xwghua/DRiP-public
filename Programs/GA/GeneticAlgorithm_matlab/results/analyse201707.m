clear,clc

disp('     ======================================================')
disp('          Analyser 2017 | Prog. by Xuanwen v2017.0711')
disp('     This program is suitable for GA 201707xx data or later')
disp('     ------------------------------------------------------')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reading data.....................................................
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('     Reading data......')
for i = 1:5
    STR = load(['run20170710_0',num2str(i),'.mat']);
    eval(['rec',num2str(i),' = STR.Record;']);
    disp(['     # Record ',num2str(i),' set!'])
end
disp('     All data are read!')
clear i STR
disp('     * Temp cleared')
disp('     ------------------------------------------------------')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% colecting maximum indiciduals....................................
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('     Collecting maxium individuals of each generation......')
for i = 1:5
    eval(['index',num2str(i),' = find(rec',num2str(i),'(:,7));']);
    disp(['     # Maxium ind/s for record ',num2str(i),' collected!'])
end
disp('     All maxium individuals are collected!')
clear i
disp('     * Temp cleared')
disp('     ------------------------------------------------------')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Selecting 100 MAX individuals....................................
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('     Selecting 100 maximum individuals for each record......')
for i = 1:5
    eval(['recmax',num2str(i),' = rec',num2str(i),'(index',num2str(i),',1:6);']);
    %     eval(['recmax',num2str(i),' = rec']);
    eval(['rec_100_',num2str(i),' = rec',num2str(i),'(index',num2str(i),'(1:5:496),1:6);']);
end
disp('     All 100 individuals are selected!')
clear i
disp('     * Temp cleared')
disp('     ------------------------------------------------------')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combining selected parameters....................................
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('     Combiining selected parameters for experiments......')
parameters = [rec_100_1;
              rec_100_2;
              rec_100_3;
              rec_100_4;
              rec_100_5];
disp('     *** Compelected!')
disp('     ------------------------------------------------------')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('     Generating pattern into images......')
addpath('C:\Users\xuhua\Google Drive\thesisproj\DRIM')
para = xlsread('C:\Users\xuhua\Google Drive\thesisproj\Experiments\Exp20170829\ExpPara.xlsx');
parameters = para(:,1:4);
mafolder = 'mask_p60_20170914';
tafolder = 'ta_p60_20170829';
MaskFunc(parameters,60,mafolder,tafolder);

disp('     *** Compelected!')
