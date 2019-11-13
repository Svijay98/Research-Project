clc;
nei_len = 31;
video_dataset_path = 'D:\Research Project\Matlab\training_dataset'; % Path for the dataset
video_dataset = dir(fullfile(video_dataset_path,'*')); 
sub_folders = setdiff({video_dataset([video_dataset.isdir]).name},{'.','..'});
%% Loop through the folders
for sf = 1:numel(sub_folders)
    sub_folder = dir(fullfile(video_dataset_path,sub_folders{sf},'*')); % improve by specifying the file extension.
    all_files_in_subfolder = {sub_folder(~[sub_folder.isdir]).name}; % files in subfolder
    
    %% Loop through the files(Videos) in each folder
    for f = 1:numel(all_files_in_subfolder)
        video_path = fullfile(video_dataset_path,sub_folders{sf},all_files_in_subfolder{f});
        v = VideoReader(video_path); % Read the video
        duration = v.Duration;
        total_frames = duration * v.FrameRate;
        [total_cuboids,rem] = quorem(sym(total_frames),15); % Calculating the number of 15-frames sets in the video and ignoring the remaining frames
        cnt = 0;
        disp('whole video');
        tic
        while cnt < total_cuboids
                tic
                cnt = cnt + 1
                prev_frame = readFrame(v); % First frame of a 15-frame set
                prev_frame = rgb2gray(prev_frame);
                %prev_frame = imresize(prev_frame, [256 256]);
                prev_features = detectHarrisFeatures(prev_frame);
                tracker = vision.PointTracker(); 
                initialize(tracker,prev_features.Location,prev_frame); % Initializing KLT Tracker
                prev_points = prev_features.Location; % Storing the locations

                [num_of_xy,xy] = size(prev_features.Location);
                xy_points = zeros(num_of_xy,2);
                xy_points(:,:,1) = prev_features.Location; % zy_points stores the location of the feature points of each frame of a 15-frame set
                t = 2;
                frame_len = 14;
                cuboids = zeros(32,32,1,1); 
                while frame_len > 0
                    curr_frame = readFrame(v); % Reading the consecutive frame
                    curr_frame = rgb2gray(curr_frame);
                    %curr_frame = imresize(curr_frame, [256 256]);
                    [curr_points,validity] = tracker(curr_frame);
                    prev_points = curr_points; % Current points become the previous points for the next iteration 
                    prev_frame = curr_frame; % Current frame becomes the previous frame for the next iteration
                    frame_len = frame_len - 1;
                    xy_points(:,:,t) = curr_points;

                    %% Cubes 32x32
                    curr_frame_padded = padarray(curr_frame,[16 16],0,'both');  % Padding zeros
                    curr_points = abs(round(curr_points));
                    curr_points(curr_points==0) = 1;
                    
                    %% The following is done to make sure all the tracked points are within the frame size and extracting the 32x32 neighbourhood of a feature point
                    for k = 1:size(curr_points,1)
                        x = curr_points(k,2);
                        if(x > size(curr_frame,1))
                            x = size(curr_frame,1);
                        end
                        y = curr_points(k,1);
                        if(y > size(curr_frame,2))
                            y = size(curr_frame,2);
                        end
                        cuboids(:,:,t,k) = curr_frame_padded(x : x+nei_len , y : y+nei_len);
                    end
                    %%
                    t = t + 1;   
                end
                xy_points_displacement = displacement(xy_points);
                
                %% Parallel computing - To get the descriptors
                parfor i = 1:num_of_xy
                    temp = [];
                    temp = cat(2,temp,normalize(reshape(xy_points_displacement(i,:,:),[1 28]),'norm',2));
                    %temp = cat(2,temp,normalize(hog_descriptor(cuboids(:,:,:,i)),'norm',2));
                    %temp = cat(2,temp,normalize(hof_descriptor(cuboids(:,:,:,i)),'norm',2));
                    temp = cat(2,temp,normalize(mbhx_descriptor(cuboids(:,:,:,i)),'norm',2));
                    temp = cat(2,temp,normalize(mbhy_descriptor(cuboids(:,:,:,i)),'norm',2));
                    %temp = cat(2,temp,sf);
                    dlmwrite('descriptors_harris_t+mbh_temp.csv',temp,'-append','delimiter',',','precision',4); % Storing the descriptors in a csv file
                end
                toc
        end
        toc
    end
end

