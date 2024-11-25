function epoch = findEpoch(loc,SleepStage)
if ~isempty(loc)
    info_loc = SleepStage(loc,:);
    event_info = [str2double(info_loc(:,2)), str2double(info_loc(:,3))];
    temp = floor((event_info(:,1)/30-floor(event_info(:,1)/30))*6000);
    event_time = [floor(event_info(:,1)/30)+1, temp, round(event_info(:,2)*200 - (6000-temp))];  
    n1 = [];
    n2 = [];
    n3 = [];
    for i = 1: size(event_time,1)
        if event_time(i,3) >= 6000
            n1 = [n1; event_time(i,:)];
        elseif event_time(i,3) >= 2000
            n2 = [n2; event_time(i,:)];
        else
            n3 = [n3; event_time(i,:)];
        end
    end

    if isempty(n1) && isempty(n2)
        over1_n1=[]; over2_n1=[]; over3_n1=[]; over4_n1=[]; over5_n1=[]; over1_n2=[];
    elseif isempty(n1)
        over1_n2 = [n2(n2(:,3)>2000,1)+1, ones(length(find(n2(:,3)>2000)),1),...
        n2(n2(:,3)>2000,3)-2000];
        over1_n1=[]; over2_n1=[]; over3_n1=[]; over4_n1=[];over5_n1=[];
    elseif isempty(n2)
        over1_n1 = [n1(n1(:,3)>6000,1)+1, ones(length(find(n1(:,3)>6000)),1),...
        n1(n1(:,3)>6000,3)-6000];
        
        over2_n1 = [over1_n1(over1_n1(:,3)>6000,1)+1, ones(length(find(over1_n1(:,3)>6000)),1),...
        over1_n1(over1_n1(:,3)>6000,3)-6000];
        
        over3_n1 = [over1_n1(over1_n1(:,3)>2000,1)+1, ones(length(find(over1_n1(:,3)>2000)),1),...
        over1_n1(over1_n1(:,3)>2000,3)-2000];
        
        over4_n1 = [over2_n1(over2_n1(:,3)>6000,1)+1, ones(length(find(over2_n1(:,3)>6000)),1),...
        over2_n1(over2_n1(:,3)>6000,3)-6000];
        
        over5_n1 = [over2_n1(over2_n1(:,3)>2000,1)+1, ones(length(find(over2_n1(:,3)>2000)),1),...
        over2_n1(over2_n1(:,3)>2000,3)-2000];
    
        over1_n2 = [];
    else 
        over1_n1 = [n1(n1(:,3)>6000,1)+1, ones(length(find(n1(:,3)>6000)),1),...
        n1(n1(:,3)>6000,3)-6000];
        
        over2_n1 = [over1_n1(over1_n1(:,3)>6000,1)+1, ones(length(find(over1_n1(:,3)>6000)),1),...
        over1_n1(over1_n1(:,3)>6000,3)-6000];
        
        over3_n1 = [over1_n1(over1_n1(:,3)>2000,1)+1, ones(length(find(over1_n1(:,3)>2000)),1),...
        over1_n1(over1_n1(:,3)>2000,3)-2000];
        
        over4_n1 = [over2_n1(over2_n1(:,3)>6000,1)+1, ones(length(find(over2_n1(:,3)>6000)),1),...
        over2_n1(over2_n1(:,3)>6000,3)-6000];
        
        over5_n1 = [over2_n1(over2_n1(:,3)>2000,1)+1, ones(length(find(over2_n1(:,3)>2000)),1),...
        over2_n1(over2_n1(:,3)>2000,3)-2000];

        over1_n2 = [n2(n2(:,3)>2000,1)+1, ones(length(find(n2(:,3)>2000)),1),...
        n2(n2(:,3)>2000,3)-2000];
    end

    total_epoch = [n1; over1_n1; over2_n1; over3_n1; over4_n1;over5_n1; n2; over1_n2;n3];
    epoch = unique(total_epoch(:,1));
else
    epoch = [];
end
end

