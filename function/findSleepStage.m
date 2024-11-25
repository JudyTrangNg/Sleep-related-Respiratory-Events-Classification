function nrem = findNrem(information)
    find(strcmp(information,'N1'));
    information(ans,1) = 'sleepstage';
    find(strcmp(information,'N2'));
    information(ans,1) = 'sleepstage';
    find(strcmp(information,'N3'));
    information(ans,1) = 'sleepstage';
    find(strcmp(information,'REM'));
    information(ans,1) = 'sleepstage';
    loc = find(strcmp(information,'sleepstage'));
    sleep_info = information(loc,:);
    for j = 1:length(sleep_info)
        x = [sleep_info(j,1), sleep_info(j,4)];
        for k = 1:length(information)
            z = [information(k,1), information(k,4)];
            if z(1,2) == x(1,2) && z(1,1) ~= x(1,1)
                sleep_info(length(sleep_info)+1,:) = information(k,:);
               continue
            end
        end
    end
    nrem = sortrows(sleep_info,4);
end