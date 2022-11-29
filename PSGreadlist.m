function freqpoint=PSGreadlist(PSGid, freqlist, delay, power, trig)
%% read a list of freq. amp. and dwell time
% input
% PSGid: 2 for the one on the bottom 
% freqlist: list of freq [GHz]
% delay[s]: dwell time. fixed option: min=1ms; list opt: min=50 ms 
% power [dbm]: same for all. range -135 dbm~25 dbm. list opt available
% trig={ 'KEY', 'IMM', 'EXT', 'BUS'}.
% KEY: 'Trigger' key on PSG; IMM: autostart; EXT: TTL; BUS: never tried 
% return 
% number of freq points read

  [freqliststr, delaystr, powerstr]=formatlists(freqlist, delay, power);

  PSGdev = PSGopensession(PSGid);

  % put it into the arb. list mode
  fprintf(PSGdev,'SOUR:LIST:TYPE LIST');
  fprintf(PSGdev,'SOUR:LIST:MODE AUTO');
  fprintf(PSGdev,'SOUR:FREQ:MODE LIST');
  fprintf(PSGdev,'SOUR:POW:MODE LIST');

  % read the list in normal order
  fprintf(PSGdev,'SOUR:LIST:DIR UP');

  % set dwell time same for all points min dwell time =1ms
  fprintf(PSGdev,'SOUR:LIST:DWEL %0.3f', delay);
  % list option available: min dwell time =50ms
  % fprintf(PSGdev,strjoin({'SOUR:LIST:DWEL', delaystr}));

  % set power
  fprintf(PSGdev,'SOUR:LIST:POW %0.3f', power);
  % list option available
  % fprintf(PSGdev,strjoin({'SOUR:LIST:POW', powerstr}));

  % set freq list
  fprintf(PSGdev,strjoin({'SOUR:LIST:FREQ',freqliststr}));

  % set retrace off--stay at the last sweep point 
  fprintf(PSGdev,'SOUR:LIST:RETR OFF');

  % set trigger source 
  fwrite(PSGdev,strjoin({'TRIG:SOUR',trig}));

  continuous='0';
  % single sweep: continuous=0
  fwrite(PSGdev,strjoin({':INIT:CONT ',continuous}));

  % initiate the scan
  fwrite(PSGdev,':INIT');

  % check the number of freq points in the list
  fprintf(PSGdev,'SOUR:LIST:FREQ:POIN?');
  freqpoint=fscanf(PSGdev,'%f');
end

function [freqliststr, delaystr, powerstr]=formatlists(freqlist, delay, power)
% input
% freqlist: list of freq [GHz]
% delay[s]: dwell time same for all points
% power [dbm]: same for all
% return
% freqliststr: freq [GHz] list as 1 str
% delaystr: dwell time [s] list as 1 str
% powerstr: power [dbm] list as 1 str

  Nsamplesperlist = length(freqlist);
  % format lists
  freqliststr = sprintf('%.7f GHZ,', freqlist); % freq resolution
  freqliststr = freqliststr(1:end-1);
  delaystr = sprintf('%.1f,', ones(Nsamplesperlist,1)*delay);
  delaystr = delaystr(1:end-1);
  powerstr = sprintf('%.1f,', ones(Nsamplesperlist,1)*power);
  powerstr = powerstr(1:end-1);

end
