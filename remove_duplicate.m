function c_dup = remove_duplicate(countery_colume)
c_dup=[];
for ii=1:length(countery_colume) - 1   
     if countery_colume(ii)~= countery_colume(ii+1)
               if ii == length(countery_colume) - 1   
                       c_dup=[c_dup;countery_colume(ii);countery_colume(ii+1)];
                       return
               end
               c_dup=[c_dup;countery_colume(ii)];
     end
end

end