% PSG id =2 set by some startup matlab script
PSGid=2; 

% set synthetic axion's freq and power here
nua=4.716; % GHz
power=-15; % dbm

% run until this date and time
theEnd=datetime('2022-03-30, 1:50 PM','InputFormat','yyyy-MM-dd, hh:mm a');

% axion lists saved as txt to datadir
datadir=pwd; % directory for saving freq lists
PSGreadtilldatetime(PSGid, 40000, theEnd, nua, power, datadir);
