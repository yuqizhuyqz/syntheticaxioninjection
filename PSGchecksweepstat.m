function status=PSGchecksweepstat(PSGid)

        PSGdev = PSGopensession(PSGid);

        % status lookup table, 10=settling, 40=sweeping, 0=complete
        dict=struct(); % lookup table for status code
        dict.stat={'settling','sweeping','completed'}; dict.value=[10,40,0];

        % check PSG status
        fwrite(PSGdev,':STAT:OPER:COND?');
        status=fscanf(PSGdev,'%f');
        
        if status==0
            disp('completed');
            
        else
            pause(2);
            disp('wait 2 more sec...');
            
            % check status, 10=settling, 40=sweeping, 0=complete
            fwrite(PSGdev,':STAT:OPER:COND?');
            
            status = fscanf(PSGdev,'%f');

            index= find(dict.value==40); 
            status=dict.stat{index}; % code2word

            if status==0
                disp('completed');
            else
                disp(['status=', status]);
            end
        end
       
end