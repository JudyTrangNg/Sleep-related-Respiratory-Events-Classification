%% Set up the Import Options and import the data
function Events = LoadXls(filename)
    opts = spreadsheetImportOptions("NumVariables", 4);
    opts.DataRange = [3 inf];

    opts.VariableNames = ["Event", "StartTime", "Duration", "StartEpoch"];
    opts.VariableTypes = ["string", "string", "string", "string"];

    opts = setvaropts(opts, ["Event", "StartTime", "Duration", "StartEpoch"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Event", "StartTime", "Duration", "StartEpoch"], "EmptyFieldRule", "auto");
% Import the data
    p=pwd;
    filepath = [p filesep 'XLS' filesep];
    EXCELfile = filename;
    Events = readmatrix([filepath EXCELfile], opts, "UseExcel",false);
    clear opts
end