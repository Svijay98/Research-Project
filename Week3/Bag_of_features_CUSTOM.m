clc;
clear all;
image_dataset_path = 'D:\Research Project\Matlab\MerchData';
image_dataset = dir(fullfile(image_dataset_path,'*'));
sub_folders = setdiff({image_dataset([image_dataset.isdir]).name},{'.','..'});
descriptor_set = zeros(1,64);
for k = 1:numel(sub_folders)
    sub_folder = dir(fullfile(image_dataset_path,sub_folders{k},'*')); % improve by specifying the file extension.
    all_files_in_subfolder = {sub_folder(~[sub_folder.isdir]).name}; % files in subfolder.
    for f = 1:numel(all_files_in_subfolder)
        img_path = fullfile(image_dataset_path,sub_folders{k},all_files_in_subfolder{f});
        img = imread(img_path);
        img = rgb2gray(img);
        feature_points = detectSURFFeatures(img);
        [descriptor,~] = extractFeatures(img,feature_points);
        descriptor_set = [descriptor_set ; descriptor];
    end
end
descriptor_set(1,:) = [];
[idx,C] = kmeans(descriptor_set,80);

%test_img = imread('D:\Research Project\Matlab\test_merchdata_images\screw_0.jpg');
test_img = imread('D:\Research Project\Matlab\test_merchdata_images\MathWorks cube_492.jpg');
test_img = rgb2gray(test_img);
feature_points = detectSURFFeatures(img);
[descriptor,~] = extractFeatures(img,feature_points);

hist_gram = zeros(1,80);
for i = 1:size(descriptor,1)
    min = 99999999;
    min_index = 1;
    for j = 1:size(C,1)
        dist = norm(descriptor(i,:) - C(j,:));
        if dist<min
            min = dist;
            min_index = j;
        end
    end
    hist_gram(min_index) = hist_gram(min_index) + 1; 
end
hist_gram
histogram(hist_gram',80,'BinWidth',1,'BinEdges',1:80);





