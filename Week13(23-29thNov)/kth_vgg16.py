from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers.convolutional import Conv3D, MaxPooling3D
import keras
from keras.optimizers import SGD, RMSprop
from keras.utils import np_utils, generic_utils

import theano
import os
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import cv2
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
#from sklearn import cross_validation
from sklearn import preprocessing

#input shape for VGG16
input_shape = (224,224,3)

# image specification
img_rows,img_cols,img_depth=16,16,15


# Training data

X_tr=[]           # variable to store entire dataset

#Reading boxing action class

listing = os.listdir('/home/cis/Downloads/reg/kth dataset/boxing')

for vid in listing:
    vid = '/home/cis/Downloads/reg/kth dataset/boxing/'+vid
    frames = []
    cap = cv2.VideoCapture(vid)
    fps = cap.get(5)
    #print ("Frames per second using video.get(cv2.cv.CV_CAP_PROP_FPS): {0}".format(fps))
 

    for k in range(15):
        ret, frame = cap.read()
        frame=cv2.resize(frame,(img_rows,img_cols),interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frames.append(gray)

        #plt.imshow(gray, cmap = plt.get_cmap('gray'))
        #plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
        #plt.show()
        #cv2.imshow('frame',gray)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()

    input=np.array(frames)

    print (input.shape)
    ipt=np.rollaxis(np.rollaxis(input,2,0),2,0)
    print( ipt.shape)

    X_tr.append(ipt)
print("BOX DONE")

#Reading hand clapping action class

listing2 = os.listdir('/home/cis/Downloads/reg/kth dataset/handclapping')

for vid2 in listing2:
    vid2 = '/home/cis/Downloads/reg/kth dataset/handclapping/'+vid2
    frames = []
    cap = cv2.VideoCapture(vid2)
    fps = cap.get(5)
    #print ("Frames per second using video.get(cv2.cv.CV_CAP_PROP_FPS): {0}".format(fps))
 
    k =1
    while(cap.isOpened() and k<16):

        ret, frame = cap.read()
        if(ret!= True):
            break
        
        frame=cv2.resize(frame,(img_rows,img_cols),interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frames.append(gray)
        k+=1

        #plt.imshow(gray, cmap = plt.get_cmap('gray'))
        #plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
        #plt.show()
        #cv2.imshow('frame',gray)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()

    input=np.array(frames)

    print (input.shape)
    ipt=np.rollaxis(np.rollaxis(input,2,0),2,0)
    print( ipt.shape)

    X_tr.append(ipt)
print("handwave DONE")   
#Reading hand waving action class

listing3 = os.listdir('/home/cis/Downloads/reg/kth dataset/handwaving')

for vid3 in listing3:
    vid3 = '/home/cis/Downloads/reg/kth dataset/handwaving/'+vid3
    frames = []
    cap = cv2.VideoCapture(vid3)
    fps = cap.get(5)
    #print ("Frames per second using video.get(cv2.cv.CV_CAP_PROP_FPS): {0}".format(fps))
 
    k =1
    while(cap.isOpened() and k<16):

        ret, frame = cap.read()
        if(ret!= True):
            break
        
        frame=cv2.resize(frame,(img_rows,img_cols),interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frames.append(gray)
        k+=1

        #plt.imshow(gray, cmap = plt.get_cmap('gray'))
        #plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
        #plt.show()
        #cv2.imshow('frame',gray)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()

    input=np.array(frames)

    print (input.shape)
    ipt=np.rollaxis(np.rollaxis(input,2,0),2,0)
    print( ipt.shape)

    X_tr.append(ipt)
print("HAND wave DONE")   

#Reading jogging action class

listing4 = os.listdir('/home/cis/Downloads/reg/kth dataset/jogging')

for vid4 in listing4:
    vid4 = '/home/cis/Downloads/reg/kth dataset/jogging/'+vid4
    frames = []
    cap = cv2.VideoCapture(vid4)
    fps = cap.get(5)
    #print ("Frames per second using video.get(cv2.cv.CV_CAP_PROP_FPS): {0}".format(fps))
 
    k =1
    while(cap.isOpened() and k<16):

        ret, frame = cap.read()
        if(ret!= True):
            break
        
        frame=cv2.resize(frame,(img_rows,img_cols),interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frames.append(gray)
        k+=1

        #plt.imshow(gray, cmap = plt.get_cmap('gray'))
        #plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
        #plt.show()
        #cv2.imshow('frame',gray)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()

    input=np.array(frames)

    print (input.shape)
    ipt=np.rollaxis(np.rollaxis(input,2,0),2,0)
    print( ipt.shape)

    X_tr.append(ipt)
print("jog DONE")   

#Reading running action class
 
listing5 = os.listdir('/home/cis/Downloads/reg/kth dataset/running')

for vid5 in listing5:
    vid5 = '/home/cis/Downloads/reg/kth dataset/running/'+vid5
    frames = []
    cap = cv2.VideoCapture(vid5)
    fps = cap.get(5)
    #print ("Frames per second using video.get(cv2.cv.CV_CAP_PROP_FPS): {0}".format(fps))
 
    k =1
    while(cap.isOpened() and k<16):

        ret, frame = cap.read()
        if(ret!= True):
            break
        
        frame=cv2.resize(frame,(img_rows,img_cols),interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frames.append(gray)
        k+=1

        #plt.imshow(gray, cmap = plt.get_cmap('gray'))
        #plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
        #plt.show()
        #cv2.imshow('frame',gray)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()

    input=np.array(frames)

    print (input.shape)
    ipt=np.rollaxis(np.rollaxis(input,2,0),2,0)
    print( ipt.shape)

    X_tr.append(ipt)
print("RUN DONE")   
 

#Reading walking action class 

listing6 = os.listdir('/home/cis/Downloads/reg/kth dataset/walking')

for vid6 in listing6:
    vid6 = '/home/cis/Downloads/reg/kth dataset/walking/'+vid6
    frames = []
    cap = cv2.VideoCapture(vid6)
    fps = cap.get(5)
    #print ("Frames per second using video.get(cv2.cv.CV_CAP_PROP_FPS): {0}".format(fps))
 
    k =1
    while(cap.isOpened() and k<16):

        ret, frame = cap.read()
        if(ret!= True):
            break
        
        frame=cv2.resize(frame,(img_rows,img_cols),interpolation=cv2.INTER_AREA)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frames.append(gray)
        k+=1

        #plt.imshow(gray, cmap = plt.get_cmap('gray'))
        #plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
        #plt.show()
        #cv2.imshow('frame',gray)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()

    input=np.array(frames)

    print (input.shape)
    ipt=np.rollaxis(np.rollaxis(input,2,0),2,0)
    print( ipt.shape)

    X_tr.append(ipt)
print("walk DONE")   



X_tr_array = np.array(X_tr)   # convert the frames read into array
print("xtr_array shape",X_tr_array.shape)
num_samples = len(X_tr_array)
print (num_samples)

#Assign Label to each class

label=np.ones((num_samples,),dtype = int)
label[0:87]= 0
label[87:186] = 1
label[186:286] = 2
label[286:386] = 3
label[386:486]= 4
label[486:] = 5


train_data = [X_tr_array,label]
#print(len(train_data),train_data)

(X_train, y_train) = (train_data[0],train_data[1])
print('X_Train shape:', X_train.shape)

train_set = np.zeros((num_samples, 1, img_rows,img_cols,img_depth))

for h in range(num_samples):
    train_set[h][0][:][:][:]=X_train[h,:,:,:]
 

patch_size = 15    # img_depth or number of frames used for each video

print(train_set.shape, 'train samples')

# CNN Training parameters

batch_size = 2
nb_classes = 6
nb_epoch =50

# convert class vectors to binary class matrices
Y_train = np_utils.to_categorical(y_train, nb_classes)


# number of convolutional filters to use at each layer
nb_filters = [32, 32]

# level of pooling to perform at each layer (POOL x POOL)
nb_pool = [3, 3]

# level of convolution to perform at each layer (CONV x CONV)
nb_conv = [5,5]

# Pre-processing

train_set = train_set.astype('float32')

train_set -= np.mean(train_set)

train_set /=np.max(train_set)



# Define model
# I think its VGG16, took it from here: https://github.com/harvitronix/five-video-classification-methods/blob/master/models.py
model = Sequential()
'''model.add(Conv3D(32,kernel_size = (5,5,5), input_shape = (1,img_rows, img_cols, patch_size), activation = 'relu',data_format="channels_first"))
model.add(MaxPooling3D(pool_size=(nb_pool[0], nb_pool[0], nb_pool[0])))
model.add(Conv3D(64,kernel_size = (5,5,5),activation = 'relu'))
model.add(MaxPooling3D(pool_size=(nb_pool[0], nb_pool[0], nb_pool[0])))
model.add(Conv3D(128,kernel_size=(5,5,5),activation = 'relu'))
model.add(Conv3D(128,kernel_size=(5,5,5),activation = 'relu'))
model.add(MaxPooling3D(pool_size=(nb_pool[0], nb_pool[0], nb_pool[0])))
model.add(Conv3D(256,kernel_size=(3,3,3),activation = 'relu'))
model.add(Conv3D(256,kernel_size=(3,3,3),activation = 'relu'))
model.add(MaxPooling3D(pool_size=(nb_pool[0], nb_pool[0], nb_pool[0])))
model.add(Flatten())
model.add(Dense(1024, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(1024))
model.add(Dropout(0.5))
model.add(Dense(nb_classes))
model.add(Activation('softmax'))'''

model.add(Conv3D(32,kernel_size = (3,3,3), input_shape = (1,img_rows, img_cols, patch_size), activation = 'relu',data_format="channels_first"))
print(model.layers[-1].output_shape)
model.add(MaxPooling3D(pool_size=(1, 2, 2)))
print(model.layers[-1].output_shape)
model.add(Conv3D(64, (3,3,3), activation='relu'))
print(model.layers[-1].output_shape)
model.add(MaxPooling3D(pool_size=(1, 2, 2)))
print(model.layers[-1].output_shape)
model.add(Conv3D(128, (3,3,3), activation='relu'))
print(model.layers[-1].output_shape)
model.add(Conv3D(128, (3,3,3), activation='relu'))
print(model.layers[-1].output_shape)
model.add(MaxPooling3D(pool_size=(1, 2, 2)))
print(model.layers[-1].output_shape)
model.add(Conv3D(256, (2,2,2), activation='relu'))
print(model.layers[-1].output_shape)
model.add(Conv3D(256, (2,2,2), activation='relu'))

model.add(MaxPooling3D(pool_size=(1, 2, 2)))
model.add(Flatten())
model.add(Dense(1024, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(1024))
model.add(Dropout(0.5))
model.add(Dense(nb_classes))
model.add(Activation('softmax'))


model.compile(loss='categorical_crossentropy', optimizer='RMSprop',metrics=['accuracy'])

 
# Split the data

X_train_new, X_val_new, y_train_new,y_val_new =  train_test_split(train_set, Y_train, test_size=0.2, random_state=4)


# Train the model

hist = model.fit(X_train_new, y_train_new, validation_data=(X_val_new,y_val_new),
          batch_size=batch_size,epochs= nb_epoch,shuffle=True)


#hist = model.fit(train_set, Y_train, batch_size=batch_size,
#         nb_epoch=nb_epoch,validation_split=0.2, show_accuracy=True,
#           shuffle=True)


 # Evaluate the model
score = model.evaluate(X_val_new, y_val_new, batch_size=batch_size)
print('Test score:', score)



# Plot the results
train_loss=hist.history['loss']
val_loss=hist.history['val_loss']
train_acc=hist.history['accuracy']
val_acc=hist.history['val_accuracy']
xc=range(50)

plt.figure(1)
plt.plot(xc,train_loss)
plt.plot(xc,val_loss)
plt.xlabel('num of Epochs')
plt.ylabel('loss')
plt.title('train_loss vs val_loss')
plt.grid(True)
plt.legend(['train','val'])
print (plt.style.available )# use bmh, classic,ggplot for big pictures
plt.style.use(['classic'])

plt.figure(2)
plt.plot(xc,train_acc)
plt.plot(xc,val_acc)
plt.xlabel('num of Epochs')
plt.ylabel('accuracy')
plt.title('train_acc vs val_acc')
plt.grid(True)
plt.legend(['train','val'],loc=4)
#print( plt.style.available # use bmh, classic,ggplot for big pictures)
plt.style.use(['classic'])
