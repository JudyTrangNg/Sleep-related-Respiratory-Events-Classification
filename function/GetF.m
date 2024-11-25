function Feature = GetF(folname)
    path = pwd;
    fol = dir([folname, filesep]);
    fol(1:2) = [];
    Feature = [];
    for i = 1:length(fol)
        name = [fol(i).folder, filesep, fol(i).name];
        Feature = [Feature; ExtractF(name,path)];
    end
    cd(path)
end
