function [d_cases, d_death]=daily (d_plot)
cases=d_plot(1:2:end);
death=d_plot(2:2:end);
d_cases=cases(1);
d_death=death(1);
for count = 2 : length(cases) 
   d_death = [d_death abs((death(count)-death(count-1)))];
   d_cases = [d_cases abs((cases(count)-cases(count-1)))];
end
end