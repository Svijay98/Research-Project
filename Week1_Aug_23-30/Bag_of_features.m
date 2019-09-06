clc;
unzip('MerchData.zip');
imds = imageDatastore('MerchData','IncludeSubfolders',true,'LabelSource','foldernames');
tbl = countEachLabel(imds);
[trainingSet, validationSet] = splitEachLabel(imds, 0.6, 'randomize')
bag = bagOfFeatures(trainingSet)
img = readimage(imds, 1);
featureVector = encode(bag, img);

% Plot the histogram of visual word occurrences
figure
bar(featureVector)
title('Visual word occurrences')
xlabel('Visual word index')
ylabel('Frequency of occurrence')

categoryClassifier = trainImageCategoryClassifier(trainingSet, bag)
confMatrix = evaluate(categoryClassifier, validationSet)


