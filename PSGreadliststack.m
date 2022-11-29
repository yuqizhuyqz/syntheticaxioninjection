function PSGreadliststack(PSGid, freqlisttotal, Nsamplesperlist,...
    delay, power, save2txtID)
% read a stack of lists
% input: 
% freqlisttotal: array of freq to read
% Nsamplesperlist: max sample size for a list default=35 for subKhz
% precision
% PSGid: default =2 
% delay: delay for each freq [s]
% power: power for each freq [dbm]
% save2txtID: file name if saving to txt, leave empty if not

     if exist('save2txtID','var')
        %write to file, append 
        fileID = fopen(save2txtID, 'a'); 
    
         % write headers
        fprintf(fileID, ['when sweep completed ' 'freq list [GHz]'  '\n']);
    end
    
    Nsamples = length(freqlisttotal);
    listcount=1;
 
    PSGdev = PSGopensession(PSGid);

    trig1st = 'IMM'; % trig mode for the 1st list
    trig = 'IMM';% auto continue for other lists
    
    % divide up the full list in to short lists and read them
    while listcount <= Nsamples/Nsamplesperlist
        disp(['reading ', num2str(Nsamplesperlist*(listcount-1)+1), ...
            ' to ', num2str(Nsamplesperlist*listcount), ' in the list... ']);
        if listcount == 1
            % use the specified trigger mode for the 1st list
            freqpoint = PSGreadlist(PSGid,...
                freqlisttotal(Nsamplesperlist*(listcount-1)...
                +1:Nsamplesperlist*listcount), delay, power, trig1st);
        else
            freqpoint = PSGreadlist(PSGid, ...
                freqlisttotal(Nsamplesperlist*(listcount-1)...
                +1:Nsamplesperlist*listcount), delay, power, trig);
        end
        
        % wait for sweep to complete 
%         pause(delay*freqpoint + 2);

        % wait for sweep to complete, add another rand wait time btw 0-3 s
        pause(delay*freqpoint + 2 + 3*rand(1));

        % check status, 10=settleing, 40=sweeping, 0=complete
        status = PSGchecksweepstat(PSGid);

        listcount = listcount+1;
    end
    
    % read the remainder
    if mod(Nsamples, Nsamplesperlist) ~= 0
       disp(['reading ', num2str(Nsamplesperlist*(listcount-1)+1), ...
           ' to ', num2str(Nsamples), ' in the list... ']);
       freqpoint = PSGreadlist(PSGid,...
           freqlisttotal(Nsamplesperlist*(listcount-1)+1:Nsamples),...
           delay, power, trig);
       
        % wait for sweep to complete, add another rand wait time btw 0-3 s
        pause(delay*freqpoint + 2 + 3*rand(1));
        
        % check status, 10=settleing, 40=sweeping, 0=complete
        status = PSGchecksweepstat(PSGid);
    end
    
    if exist('save2txtID','var')
        timestamp =datestr(datetime);
        % write time stamp and freqlist to file, ~450 KB for 30K samples
        fprintf(fileID, [timestamp  ' ' num2str(freqlisttotal, 8) '\n']);
        fclose(fileID);
    
    end
  
end
