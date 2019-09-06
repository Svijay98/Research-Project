%C = magic(5);
I = [0.11372549,0.10588235,0.11372549,0.11764706,0.10980392,0.10980392,0.10196079;0.098039217,0.098039217,0.10588235,0.10980392,0.11372549,0.12156863,0.12156863;0.12156863,0.11372549,0.10196079,0.10980392,0.10980392,0.10196079,0.11372549;0.11372549,0.12549020,0.11764706,0.11764706,0.11764706,0.12156863,0.11372549;0.10588235,0.10588235,0.10196079,0.10196079,0.11764706,0.11764706,0.12156863;0.12156863,0.11764706,0.11764706,0.11764706,0.11764706,0.10588235,0.10980392;0.11764706,0.11764706,0.11764706,0.12549020,0.12549020,0.12941177,0.12941177];
h = [-1 0 1];
A = imfilter(I,[-1 0 1],'replicate','same','conv');
B= imfilter(I,[-1 0 1]' ,'replicate','same','conv');%this one is different because we are using transpose of [-1 0 1]

A = A(2:end-1,2:end-1);
B = B(2:end-1,2:end-1);



% Compute A, B, and C, which will be used to compute corner metric.
C = A .* B;
A = A .* A;
B = B .* B;
filter2D = createFilter(5);
% Filter A, B, and C.
A = imfilter(A,filter2D,'replicate','full','conv');
B = imfilter(B,filter2D,'replicate','full','conv');
C = imfilter(C,filter2D,'replicate','full','conv');

% Clip to image size
removed = max(0, (size(filter2D,1)-1) / 2 - 1);
A = A(removed+1:end-removed,removed+1:end-removed);
B = B(removed+1:end-removed,removed+1:end-removed);
C = C(removed+1:end-removed,removed+1:end-removed);


%test both with eig

% The parameter k which was defined in the Harris method is set to 0.04
k = 0.04; 
metric = (A .* B) - (C .^ 2) - k * ( A + B ) .^ 2;%harris metric 
metric1 = ((A + B) - sqrt((A - B) .^ 2 + 4 * C .^ 2)) / 2;%shi and tomasi metric

function f = createFilter(filterSize)
sigma = filterSize / 3;
f = fspecial('gaussian', filterSize, sigma);
end




