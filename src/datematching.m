% matching datetime
% This function return index of slavedate vector that match each row in 
% masterdate vector. 'tol' is accepcted error in duration
% masterdate: datetime class
% slavedate: datetime class
% tol: duration class
% written by PN 10 Apri 2021 (Ver 0.0.1)
%------------------------------------------


% masterdate = HLspectruminfo.DateTime;
% slavedate = all_Power_V6.DATE_adelaide;
% tol = minutes(10); 


function [index, value] = datematching(masterdate, slavedate, tol)
    
    arguments
        masterdate (1,:) datetime 
        slavedate (1,:) datetime
        tol (1,1) duration
    end
    
    % initialise vectors
    nrow = length(masterdate);
    index = NaN(nrow,1);
    value = duration(NaN(nrow,3));

    % matching value by searching smallest difference
    for i=1:nrow

        delta_duration = abs(masterdate(i) - slavedate); % find difference
        [err, loc] = min(delta_duration); % find smallest different

        if err <= tol % check accepted error range
            index(i) = loc;
            value(i) = err;
        end

    end

end


