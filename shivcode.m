clc;
img = imread('image.jpg');
gray = rgb2gray(img);
image = imresize(gray,[500 500]);


xy = zeros(1,2);
i =1;
for j=1:9
    k =5;
    m = uint32((501)*(0.707^(j-1)));
    n = rem(m,5);
    m = m-n+1;
    for row = 1:k:m-k
        for col = 1:k:m-k
            points = detectMinEigenFeatures(image,'ROI',[row,col,k,k]);
            strongest = selectStrongest(points,1);
            count=strongest.Count;
            if count>0
                xy(i,1) = floor(strongest.Location(1));
                xy(i,2) = floor(strongest.Location(2));
                i = i+1;
                %count = count - 1;
                
            end
        end
    end
end
    
points = cornerPoints(xy);
marker = insertMarker(image,points,'plus','size',2 );
imshow(marker)


%points = detectMinEigenFeatures(xy);

%for row = 1:5:500
 %   image(row,:) = 0;
%end
%for col = 1:5:500
 %   image(:,col) = 0;
%end

%marker = insertMarker(image,points,'circle','size',1);
%figure
%imshow(marker);