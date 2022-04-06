%%function for plotting data
function Plotting_Fun(handles)
D_plot = cell2mat(handles.All_Data(handles.current_countery_num + handles.current_state_num -1 , 3:end));
%select Global
red_com = 0.3;
gre_com = 0.5;
blue_com = 1;
 
d1 = datetime('22/01/2020','InputFormat','dd/MM/uuuu');
d2 = datetime('30/01/2021','InputFormat','dd/MM/uuuu');
days = d1:d2;

if handles.current_countery_num == 1 
   if strcmpi(handles.option,'Daily')
          if handles.Data_plot == "Cases"
                    b1=bar(days,handles.Global_Cases_Daily);
                    b1.FaceColor = [red_com gre_com blue_com];
          elseif handles.Data_plot == "Deaths"
                    b2=plot(days,handles.Global_Deathes_Daily);
                    b2.Color = [1 0 0];              
          else
                    yyaxis right
                    b2=plot(days,handles.Global_Deathes_Daily);
                    b2.Color = [1 0 0];
                    ylabel('Deaths')
                    yyaxis left
                    b1=bar(days,handles.Global_Cases_Daily);
                    b1.FaceColor = [red_com gre_com blue_com];
          end
   else
          if handles.Data_plot == "Cases"                  
                    b1=bar(days,handles.Global_Cases_Cumulative);
                    b1.FaceColor = [red_com gre_com blue_com];
          elseif handles.Data_plot == "Deaths"                
                    b2=plot(days,handles.Global_Deathes_Cumulative);
                    b2.Color = [1 0 0];
          else                
                    yyaxis right
                    b2=plot(days,handles.Global_Deathes_Cumulative);
                    b2.Color = [1 0 0];
                    ylabel('Deaths')
                    yyaxis left
                    b1=bar(days,handles.Global_Cases_Cumulative);
                    b1.FaceColor = [red_com gre_com blue_com];                    
          end
   end
else
%select other counteries
          if strcmpi(handles.option,'Daily')
                    [Daily_Data_Cases,Daily_Data_Deaths] = daily(D_plot);
                    if handles.Data_plot == "Cases"
                              b1=bar(days,Daily_Data_Cases);
                              b1.FaceColor = [red_com gre_com blue_com];
                    elseif handles.Data_plot == "Deaths"
                              b2=plot(days,Daily_Data_Deaths);
                              b2.Color = [1 0 0];
                    else
                              yyaxis right
                              b2=plot(days,Daily_Data_Deaths);
                              b2.Color = [1 0 0];
                              ylabel('Deaths')
                              yyaxis left
                              b1=bar(days,Daily_Data_Cases);
                              b1.FaceColor = [red_com gre_com blue_com];
                    end
          else
                    if handles.Data_plot == "Cases"
                              D_plot1 = D_plot(1:2:end);
                              b1=bar(days,D_plot1);
                              b1.FaceColor = [red_com gre_com blue_com];
                    elseif handles.Data_plot == "Deaths"
                              D_plot2 = D_plot(2:2:end);
                              b2=plot(days,D_plot2);
                              b2.Color = [1 0 0];
                    else
                              yyaxis right
                              D_plot2 = D_plot(2:2:end);
                              b2=plot(days,D_plot2);
                              b2.Color = [1 0 0];
                              ylabel('Deaths')
                              yyaxis left
                              D_plot1 = D_plot(1:2:end);
                              b1=bar(days,D_plot1);
                              b1.FaceColor = [red_com gre_com blue_com];
                    end
          end
end
xlabel('Days')
if handles.Data_plot == "Cases & Deaths"
          ylabel("Cases")
else
          ylabel(handles.Data_plot)
end

grid on
end