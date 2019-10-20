v = VideoReader('visiontraffic.avi');
cslbp=zeros(1,1);
 for i=1:15
while hasFrame(v)
    frameRGB = readFrame(v);
    frameGray = rgb2gray(frameRGB);
    t = CSLBP(frameGray);
end
    cslbp=cslbp+t;
 end
 
function lbp = CSLBP(I)
    lbp=zeros(1024,1);
    [x y]=size(I);
    for i=2:x-1
        for j=2:y-1
            a = (((I(i,j) - I(i, j+1)) ) * 2^0 );  
            b = (((I(i,j) - I(i+1, j+1)) ) * 2^1 ); 
            c = (((I(i,j) - I(i+1, j)) ) * 2^2 ); 
            d = (((I(i,j) - I(i+1, j-1))  ) * 2^3 );
            e = (((I(i,j) - I(i, j-1))  ) * 2^4 );
            f = (((I(i,j) - I(i-1, j-1))  ) * 2^5 );
            g = (((I(i,j) - I(i-1, j))  ) * 2^6 ); 
            h = (((I(i,j) - I(i-1, j+1))  ) * 2^7 ); 
            k=a+b+c+d+e+f+g+h;
            lbp(k+1) = lbp(k+1) + 1;
        end
    end 
end
