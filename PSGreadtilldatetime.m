function PSGreadtilldatetime(PSGid, Nsamplesperseg, theEnd, nua, power, ...
    datadir)

% this does signal injection till 
% theEnd: a datetime, eg datetime('2022-03-30, 1:50 PM','InputFormat','yyyy-MM-dd, hh:mm a') 
% regenerate/reseed the list for each segment, 
% lists with Nsamplesperseg samples each are saved as ...
% fakeaxionlistmm_dd_yyyy_hh_mm.txt under
% datadir: data directory 
% Nsamplesperseg: max~90K limited by max array size in matlab;
%                 w/5 ms delay + wait in btw lists, 50K takes ~1hr

    Nsamplesperlist = 35; % number of samplers for each sweep list (limited by OutputBufferSize-BytesToOutput, 30 for %.6f, 40 for %.5f )

    delay = .005; % dwell time for each point on the list [s] (min=0.001 s)
%         power = -8; % power for each point [dbm]      
%         nua = 4.5171122; % Ghz fake axion freq

    PSGdev = PSGopensession(PSGid);

    % turn display off
    fprintf(PSGdev, ':DISP OFF');
    % turn PSG on
    fprintf(PSGdev, 'OUTP ON');

    now =datetime;
    while now <= theEnd
        seed = randi(2022);% random seed between 1-2022

        % new txt for every segment
        save2txtID= strcat(datadir,filesep,'fakeaxionlist', ...
            datestr(datetime, 'mm_dd_yyyy_HH_MM'),'txt');

        % rejection sampling
        freqlisttotal = rejectionsampling_fakeaxions(nua, seed, Nsamplesperseg);

        PSGreadliststack(PSGid, freqlisttotal, Nsamplesperlist,delay, ...
            power, save2txtID);

        now =datetime;
    end

end
