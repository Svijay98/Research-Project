clc;
img = imread('download.jpg');
gray = rgb2gray(img);
image = imresize(gray,[500 500]);


xy = zeros(1,2);
i =1;
for row = 1:5:500
    for col = 1:5:500
        points = detectMinEigenFeatures(image,'ROI',[row,col,5,5]);
        strongest = selectUniform(points,10,[5 5]);
        count=strongest.Count
        if count>0
            xy(i,1) = uint32(strongest.Location(1));
            xy(i,2) = uint32(strongest.Location(2));
            i = i+1;
            %count = count - 1;
        end
    end
end
points = cornerPoints(xy);
marker = insertMarker(image,points,'circle','size',5 );
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