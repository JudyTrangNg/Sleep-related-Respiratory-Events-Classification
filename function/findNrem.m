function nrem = findNrem(information)
    find(strcmp(information,'N1'));
    information(ans,1) = 'NREM';
    find(strcmp(information,'N2'));
    information(ans,1) = 'NREM';
    find(strcmp(information,'N3'));
    information(ans,1) = 'NREM';
    loc_nrem = find(strcmp(information,'NREM'));
    nrem_info = information(loc_nrem,:);
    for j = 1:length(nrem_info)
        x = [nrem_info(j,1), nrem_info(j,4)];
        for k = 1:length(information)
            z = [information(k,1), information(k,4)];
            if z(1,2) == x(1,2) && z(1,1) ~= x(1,1)
                nrem_info(length(nrem_info)+1,:) = information(k,:);
               continue
            end
        end
    end
    nrem = sortrows(nrem_info,4);
end