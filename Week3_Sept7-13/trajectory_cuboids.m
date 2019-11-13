clc;
tic
nei_len = 31;
v = VideoReader('D:\Research Project\Matlab\KTH_dataset\handwaving\person01_handwaving_d1_uncomp.avi');
prev_frame = readFrame(v);
prev_frame = rgb2gray(prev_frame);
prev_frame = imresize(prev_frame, [256 256]);
prev_features = detectMinEigenFeatures(prev_frame);
tracker = vision.PointTracker();
initialize(tracker,prev_features.Location,prev_frame);
prev_points = prev_features.Location;

[num_of_xy,xy] = size(prev_features.Location);
xy_points = zeros(num_of_xy,2);
xy_points(:,:,2) = prev_features.Location;
t = 3;
frame_len = 14;
cuboids = zeros(32,32,1,1);
while frame_len > 0
    curr_frame = readFrame(v);
    curr_frame = rgb2gray(curr_frame);
    curr_frame = imresize(curr_frame, [256 256]);
    [curr_points,validity] = tracker(curr_frame);
    prev_points = curr_points;
    prev_frame = curr_frame;
    frame_len = frame_len - 1;
    xy_points(:,:,t) = curr_points;
    
    %% Cubes 32x32
    curr_frame_padded = padarray(curr_frame,[16 16],0,'both');    
    curr_points = round(curr_points);
    curr_points(curr_points>256) = 256;
    for k = 1:size(curr_points,1)
        x = curr_points(k,1);
        y = curr_points(k,2);
        cuboids(:,:,t,k) = curr_frame_padded(x : x+nei_len , y : y+nei_len);
    end
    %%
    t = t + 1;   
end
toc