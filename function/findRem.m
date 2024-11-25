function rem = findRem(information)
    loc_rem = find(strcmp(information,'REM'));
    rem_info = information(loc_rem,:);
    for j = 1:length(rem_info)
            x = [rem_info(j,1), rem_info(j,4)];
            for k = 1:length(information)
                z = [information(k,1), information(k,4)];
                if z(1,2) == x(1,2) && z(1,1) ~= x(1,1)
                    rem_info(length(rem_info)+1,:) = information(k,:);
                   continue
                end
            end
        end
    rem = sortrows(rem_info,4);
end