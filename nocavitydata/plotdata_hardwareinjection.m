% load hardware injection data downloaded from nocavitydata
data=load('gage_test_2022_02_04_10_01_06.mat');

% generate the input list that generated the data collected
Nsamples = 30000; % total number of samples wanted
% use the same seed and axion freq nua as in the test
nua = 4.5171122+400e-6; % GHz freq  
seed = 1; 
freqlisttotal = rejectionsampling_fakeaxions(nua, seed, Nsamples);
% plot data and input list
freqLO = 9.0343804/2; % LO freq [GHz] in the test
figure;hold on;
title({'spectral hopping:','30K samples (~0.5 hr), dwell time=5 ms, power=-20 dbm'});
yyaxis left;
histogram((freqlisttotal-freqLO)*1e9);
ax1=gca;xmin=ax1.XLim(1);xmax=ax1.XLim(2); ylabel('count');
yyaxis right;
% plot processed data--FFT of time series data
plot(data1.meanavgps.singlesided_freqaxis,...
    data.meanavgps.singlesided_powerspecavg,'LineWidth',2);
ax=gca;ax.XLim(1)=xmin;ax.XLim(2)=xmax;
xlabel('IF [Hz]');ylabel('FFT [arb. units]');
legend('histogram of input list', 'FFT of sampled list');
set(gca,'Fontsize',14,'FontWeight','bold'); 
% print
print('syninjectiondataexample','-dpdf')
