import os
# import zipfile
import random
# import shutil
import tensorflow as tf
# from tensorflow.keras.optimizers import RMSprop
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from shutil import copyfile
# from os import getcwd
# from os import listdir
# from tensorflow import keras
# import cv2
# from tensorflow.keras.layers import Conv2D, Input, ZeroPadding2D, BatchNormalization, Activation, MaxPooling2D, Flatten, Dense
# from tensorflow.keras.models import Model, load_model
from tensorflow.keras.callbacks import TensorBoard, ModelCheckpoint
# from sklearn.model_selection import train_test_split
# from sklearn.metrics import f1_score
# from sklearn.utils import shuffle
# #import imutils
# import numpy as np
# import matplotlib.pyplot as plt
# import matplotlib.image  as mpimg

YES_SOURCE_DIR = "../Data/with_mask/"
TRAINING_YES_DIR = "../Data/training/yes1/"
TESTING_YES_DIR = "../Data/testing/yes1/"
NO_SOURCE_DIR = "../Data/without_mask/"
TRAINING_NO_DIR = "../Data/training/no1/"
TESTING_NO_DIR = "../Data/testing/no1/"
split_size = .8

def split_data(SOURCE, TRAINING, TESTING, split_size):
    dataset = []
    # for f in os.listdir(TRAINING):
    #     if not f.endswith(".bak"):
    #         continue
    #     os.remove(os.path.join(TRAINING, f))
    #
    # for f in os.listdir(TESTING):
    #     if not f.endswith(".bak"):
    #         continue
    #     os.remove(os.path.join(TESTING, f))

    for unitData in os.listdir(SOURCE):
        data = SOURCE + unitData
        if (os.path.getsize(data) > 0):
            dataset.append(unitData)
        else:
            print('Skipped ' + unitData)
            print('Invalid file i.e zero size')

    train_set_length = int(len(dataset) * split_size)
    test_set_length = int(len(dataset) - train_set_length)
    #shuffled_set = random.sample(dataset, len(dataset))
    train_set = dataset[0:train_set_length]
    test_set = dataset[-test_set_length:]

    for unitData in train_set:
        temp_train_set = SOURCE + unitData
        final_train_set = TRAINING + unitData
        copyfile(temp_train_set, final_train_set)

    for unitData in test_set:
        temp_test_set = SOURCE + unitData
        final_test_set = TESTING + unitData
        copyfile(temp_test_set, final_test_set)
    return None






def train_model(training_dir, validation_dir, model_file):


    split_data(YES_SOURCE_DIR, TRAINING_YES_DIR, TESTING_YES_DIR, split_size)
    split_data(NO_SOURCE_DIR, TRAINING_NO_DIR, TESTING_NO_DIR, split_size)

    # Network Architecture
    model = tf.keras.models.Sequential([
        tf.keras.layers.Conv2D(100, (3, 3), activation='relu', input_shape=(150, 150, 3)),
        tf.keras.layers.MaxPooling2D(2, 2),

        tf.keras.layers.Conv2D(100, (3, 3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),

        tf.keras.layers.Flatten(),
        tf.keras.layers.Dropout(0.5),
        tf.keras.layers.Dense(50, activation='relu'),
        tf.keras.layers.Dense(2, activation='softmax')
    ])
    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['acc'])

# Image data generator
    train_datagen = ImageDataGenerator(rescale=1.0/255,
                                   rotation_range=40,
                                   width_shift_range=0.2,
                                   height_shift_range=0.2,
                                   shear_range=0.2,
                                   zoom_range=0.2,
                                   horizontal_flip=True,
                                   fill_mode='nearest')

    train_generator = train_datagen.flow_from_directory(training_dir,
                                                    batch_size=10,
                                                    target_size=(150, 150))
    validation_datagen = ImageDataGenerator(rescale=1.0/255)

    validation_generator = validation_datagen.flow_from_directory(validation_dir,
                                                         batch_size=10,
                                                         target_size=(150, 150))
    checkpoint = ModelCheckpoint('model-{epoch:03d}.model',monitor='val_loss',verbose=0,save_best_only=True,mode='auto')


    history = model.fit_generator(train_generator,
                              epochs=1,
                              validation_data=validation_generator,
                              callbacks=[checkpoint])
    model.save(model_file)
    return history

#model.save("../outputfiles/classifier.keras")

if __name__ == "__main__":
    output = train_model("../Data/training", "../Data/testing", "../outputfiles/classifier.keras" )
    # # split_data(YES_SOURCE_DIR, TRAINING_YES_DIR, TESTING_YES_DIR, split_size)
    # # split_data(NO_SOURCE_DIR, TRAINING_NO_DIR, TESTING_NO_DIR, split_size)
    # dir_path = os.path.dirname(os.path.realpath(TESTING_NO_DIR)).replace('\\', '/') + "/no1/"
    # filelist = [f for f in os.listdir(dir_path) if f.endswith(".bak")]
    # # #print(TESTING_NO_DIR)
    #
    # print(dir_path)
    # print(filelist)
    # # for f in filelist:
    # #     os.remove(os.path.join(TESTING_NO_DIR, f))
    #
    # # for f in os.listdir(os.path.dirname(os.path.realpath(TESTING_NO_DIR))):
    # #     if not f.endswith(".bak"):
    # #         continue
    # #     os.remove(os.path.join(TESTING_NO_DIR, f))