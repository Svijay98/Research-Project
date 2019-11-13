%% The following code does not use people detector and runs on youtube datset

clc;
clear all
nei_len = 31;
video_feature_count =[];

%% Path for the dataset
video_dataset_path = 'action_youtube_naudio'; % Path for the dataset
video_dataset = dir(fullfile(video_dataset_path,'*')); 
sub_folders_primary = setdiff({video_dataset([video_dataset.isdir]).name},{'.','..'});

%% Loop through the primary sub_folders
for sfp = 1:numel(sub_folders_primary)
    disp('primary sub folder');
    disp(sfp);
    sub_folder_path_primary = dir(fullfile(video_dataset_path,sub_folders_primary{sfp},'*')); % improve by specifying the file extension.
    sub_folders_secondary = setdiff({sub_folder_path_primary([sub_folder_path_primary.isdir]).name},{'.','..'});
    %% Run through the secondary sub_folders
    for sfs = 1:numel(sub_folders_secondary)
        disp(sfs);
        sub_folder_path_secondary = dir(fullfile(video_dataset_path,sub_folders_primary{sfp},sub_folders_secondary{sfs},'*'));
        all_files_in_subfolder = {sub_folder_path_secondary(~[sub_folder_path_secondary.isdir]).name}; % files in subfolder.
                %% Loop through the files(Videos) in each folder
                for f = 1:numel(all_files_in_subfolder)
                    frame_no = 0;
                    %disp(f);
                    video_path = fullfile(video_dataset_path,sub_folders_primary{sfp},sub_folders_secondary{sfs},all_files_in_subfolder{f});
                    v = VideoReader(video_path); % Read the video
                    duration = v.Duration;
                    total_frames = (duration * v.FrameRate);
                    %[total_cuboids,rem] = quorem(sym(total_frames),15); % Calculating the number of 15-frames sets in the video and ignoring the remaining frames
                    cnt = 0;
                    disp('whole video');
                    tic
                    while (total_frames - frame_no) >= 15
                            %cnt = cnt + 1;
                            cuboids = zeros(32,32,1,1);
                            prev_frame = readFrame(v); % First frame of a 15-frame set
                            frame_no = frame_no + 1;
                            prev_frame = rgb2gray(prev_frame);
                            %prev_frame = imresize(prev_frame, [256 256]);
                            prev_features = detectHarrisFeatures(prev_frame);
                            while(prev_features.Count == 0)
                                prev_frame = readFrame(v); % First frame of a 15-frame set
                                frame_no = frame_no+1;
                                prev_frame = rgb2gray(prev_frame);
                                prev_features = detectHarrisFeatures(prev_frame);
                            end

                            cnt = cnt+prev_features.Count;
                            tracker = vision.PointTracker(); 
                            initialize(tracker,prev_features.Location,prev_frame); % Initializing KLT Tracker
                            prev_points = prev_features.Location; % Storing the locations
                            prev_frame_padded = padarray(prev_frame,[16 16],0,'both');  % Padding zeros
                            prev_points = abs(round(prev_points));
                            prev_points(prev_points==0) = 1;

                            [num_of_xy,xy] = size(prev_features.Location);
                            xy_points = zeros(num_of_xy,2);
                            xy_points(:,:,1) = prev_features.Location; % xy_points stores the location of the feature points of each frame of a 15-frame set
                            t = 1;
                            for k = 1:size(prev_points,1)
                                 x = prev_points(k,2);
                                 y = prev_points(k,1);
                                 cuboids(:,:,t,k) = prev_frame_padded(x : x+nei_len , y : y+nei_len);
                            end 
                            t = t + 1;
                            frame_len = 14;

                            while frame_len > 0
                                curr_frame = readFrame(v); % Reading the consecutive frame
                                frame_no = frame_no + 1;
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
                            %xy_points_displacement = displacement(xy_points);

                            %% Parallel computing - To get the descriptors
                            parfor i = 1:num_of_xy
                                temp = [];
                                %temp = cat(2,temp,normalize(reshape(xy_points_displacement(i,:,:),[1 28]),'norm',2));
                                %temp = cat(2,temp,normalize(hog_descriptor(cuboids(:,:,:,i)),'norm',2));
                                %temp = cat(2,temp,normalize(hof_descriptor(cuboids(:,:,:,i)),'norm',2));
                                temp = cat(2,temp,normalize(cslbp_descriptor(cuboids(:,:,:,i)),'norm',2));
                                temp = cat(2,temp,normalize(mbhx_descriptor(cuboids(:,:,:,i)),'norm',2));
                                temp = cat(2,temp,normalize(mbhy_descriptor(cuboids(:,:,:,i)),'norm',2));
                                %temp = cat(2,temp,sf);
                                dlmwrite('descriptors_cslbp+mbh_youtube_dataset_123.csv',temp,'-append','delimiter',',','precision',4); % Storing the descriptors in a csv file
                            end
                    end
                    video_feature_count =[];
                    video_feature_count = cat(2,video_feature_count,cnt);
                    video_feature_count = cat(2,video_feature_count,f);
                    video_feature_count = cat(2,video_feature_count,sfp);

                    dlmwrite('video_feature_count_cslbp+mbh_youtube_dataset_123.csv',video_feature_count,'-append','delimiter',',','precision',4);
                    toc
                end
    end
    
end