function Feature = ExtractF(name,path)
    cd(name)
    addpath(path)
    Apnea = GetData('apnea');
    Central = GetData('central');
    Label = categorical([ ...
        repmat({'apnea'},size(Apnea,1),1); ...
        repmat({'central'},size(Central,1),1)]);
    Data = [Apnea;Central];
    Feature = array2table(Data, "VariableNames",strcat('F',string(1:510)));
    Feature.Label = Label;
end
function Data = GetData(name)
    file = dir([name, filesep, '*.mat']);
    Data = [];
    for i = 1:length(file)
        d = struct2array(load([file(i).folder, filesep, file(i).name]));
        if ~isempty(d)
        En = [];
        for j = 1:size(d,1)
            x = d(j,:);
            wpt = wpdec(x,8,'db3','shannon');
            node = get(wpt,'allNI');
            entropy = node(2:end,4);
            entropy = entropy';
            En = [En; entropy];
        end
        Data = [Data; En];
        end
    end
end