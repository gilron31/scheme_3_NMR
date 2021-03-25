function [ run_name ] = get_escaped_datetime()
%GET_DATE_AS_STR Summary of this function goes here
%   Detailed explanation goes here
run_name = datestr(now);
run_name(run_name==' ') = '_'; run_name(run_name==':') = [];
end

