%%function To calcualte Cumulative and Daily numbers of Cases and Deathes
%%Globaly
function [Global_Cases_Cumulative,Global_Deathes_Cumulative,Global_Cases_Daily,Global_Deathes_Daily]=Calc_Global(All_Data)
All_Data = cell2mat(All_Data(2:end,3:end));
Global_Cases_Cumulative = sum(All_Data(:,1:2:end));
Global_Deathes_Cumulative = sum(All_Data(:,2:2:end));
Global_Cases_Daily=Global_Cases_Cumulative(1);
Global_Deathes_Daily=Global_Deathes_Cumulative(1);
for count = 2 : length(Global_Cases_Cumulative)
   Global_Deathes_Daily = [Global_Deathes_Daily abs((Global_Deathes_Cumulative(count)-Global_Deathes_Cumulative(count-1)))];
   Global_Cases_Daily = [Global_Cases_Daily abs((Global_Cases_Cumulative(count)-Global_Cases_Cumulative(count-1)))];
end
end