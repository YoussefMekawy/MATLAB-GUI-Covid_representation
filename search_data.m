function states_list = search_data(countery_colume,countery_Non_Dup,states_colume,counter_num)
name=countery_Non_Dup(counter_num);
states_list = [];
z=0;
for ii=1:length(countery_colume)-1
     if(strcmpi(char(countery_colume{ii,1}),name))
          if z == 0
                    states_list=[states_list;"All"];
                    z = z+1;
          else
                    states_list = [states_list;string(states_colume{ii,1})];
          end
      if(~strcmpi(char(countery_colume{ii+1,1}),name))    
          return
      end
     end   
end
if ii == length(countery_colume)-1
          states_list=[states_list;"All"];
end
end