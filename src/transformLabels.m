function [ yOut ] = transformLabels( yIn, symbolList )
% Transforms labels which yIn is filled with (described in symbolList)
%  so that they are a sequence of integers starting at 1
% Warning: symbolList must be a list of labels (as strings)

nClasses = length(symbolList)-1;
oldy = yIn;
yOut = -1*ones(size(yIn,1), 1); % -1*ones(n,1)
y_translate = zeros([nClasses 1]); %% Initialize vector with size = nr classes
for i = 1:(nClasses)
    curlabel = str2double(symbolList(i+1));
    y_translate(i) = curlabel;
    yOut(oldy == curlabel) = i;
end

end

