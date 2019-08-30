clc;
img = imread('image.jpg');
gray = rgb2gray(img);
image = imresize(gray,[500 500]);


xy = zeros(1,2);
i =1;

    k =5;
    for row = 1:k:6
        for col = 1:k:6
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
    
points = cornerPoints(xy);
marker = insertMarker(image(1:7,1:7),points,'circle','size',1);
imshow(marker)
truesize([400 500])


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