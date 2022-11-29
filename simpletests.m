% PSG id =2 set by some startup matlab script
PSGid=2; 
%% simple test 1: read a short list (run section)
Nsamplesperlist = 35; % num of samples in the list (limited by OutputBufferSize-BytesToOutput, 30 for %.6f, 40 for %.5f )
delay = .1; % dwell time for each point on the list [s]
power = -20; % power for each point [dbm]
nua = 4.5171122+400e-6; % axion freq [GHz] 
seed = 1; % any int.

% generate a random freq list
freqlist = rejectionsampling_fakeaxions(nua, seed, Nsamplesperlist);

% config trigger mode
trig = 'IMM'; %trigger mode: Key=press trigger on psg to start the sweep, IMM=start immediately, EXT=external TTL
disp('-------sweeping begins--------');

PSGdev = PSGopensession(PSGid); 
% turn PSG on
fprintf(PSGdev, 'OUTP ON'); 
% read the list
freqpoint = PSGreadlist(PSGid, freqlist, delay, power, trig); 
% wait for sweep to complete
pause(delay * freqpoint + 2);
% check status, 10=settleing, 40=sweeping, 0=complete
status = PSGchecksweepstat(PSGid);
% turn PSG off
fprintf(PSGdev, 'OUTP OFF');
disp('-------sweeping ends--------');
%% simple test 2: read a longer list with N samples

Nsamples = 30000; % total number of samples wanted
Nsamplesperlist = 35; % number of samplers for each sweep list (limited by OutputBufferSize-BytesToOutput, 30 for %.6f, 40 for %.5f )
delay = .005; % dwell time for each point on the list [s] 
power = -20; % power for each point [dbm]

nua = 4.5171122+400e-6; 
seed = 1;
% get the freq list
freqlisttotal = rejectionsampling_fakeaxions(nua, seed, Nsamples);

% estimate wait time between list [s]
waittimeperlist = 2 + 2*.5;

% disp. total run time
timeest=Nsamples/Nsamplesperlist*waittimeperlist+ Nsamples*delay;
disp(['time required for a sweep ~', num2str(timeest), ...
    ' s \n', 'duty cycle ', num2str(Nsamples*delay/timeest), '\n']);

% plot hist. and sampling dist.
vv = 270000; % virial velocity = 270 km/s
beta = vv/299792458; % vv/speed of light
r = sqrt(2/3); % accounting for modulation due to our rotation around in the galaxy
x = nua:10^-7:nua + 2 * 10^-4; % freq range
%axion lineshape function (from 2017 prd paper)
faxionEarth = 2/sqrt(pi)*sqrt(3/2)*1/(r*nua*beta^2).*sinh(3*r*sqrt(2*( ...
    x-nua)/(nua*beta^2))).*exp(-3*(x-nua)/(nua*beta^2)-3/2*r^2);

figure; hold on;
yyaxis left;
histogram(freqlisttotal); 
xlabel('freq \nu [GHz]'); ylabel('count');
yyaxis right; hold on;
plot(x, faxionEarth,'.');
ax = gca; ax.XLim = [nua nua+2*10^-5];
text(nua+10^-5, ax.YLim(1)/2+ax.YLim(2)/2, ['\nu_a = ', ...
    num2str(nua), ' GHz'], 'color', 'r');

ylabel('sampling distribution f(\nu_a, \nu)');
title(sprintf('histogram of %d rv from the sampling distribution', Nsamples));

% now read the list
trig1st = 'IMM'; % trig mode for the 1st list

disp('-------sweeping begins--------');
PSGdev = PSGopensession(PSGid);
% turn PSG on
fprintf(PSGdev, 'OUTP ON');
% % turn display off
% % fprintf(PSGdev, ':DISP OFF');
% read stacked lists
PSGreadliststack(PSGid, freqlisttotal, Nsamplesperlist, delay, power);
% turn PSG offS
fprintf(PSGdev, 'OUTP OFF');
disp('-------sweeping ends--------');
