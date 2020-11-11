import os
import zipfile
import random
import shutil
import tensorflow as tf
from tensorflow.keras.optimizers import RMSprop
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from shutil import copyfile
from os import getcwd
from os import listdir
from tensorflow import keras
import cv2
from tensorflow.keras.layers import Conv2D, Input, ZeroPadding2D, BatchNormalization, Activation, MaxPooling2D, Flatten, Dense
from tensorflow.keras.models import Model, load_model
from tensorflow.keras.callbacks import TensorBoard, ModelCheckpoint
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score
from sklearn.utils import shuffle
import imutils
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image  as mpimg


def train_model(training_dir, validation_dir, model_file):

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
                              epochs=15,
                              validation_data=validation_generator,
                              callbacks=[checkpoint])
    model.save(model_file)
    return history

#model.save("../outputfiles/classifier.keras")

if __name__ == "__main__":
    output = train_model("../Data/training", "../Data/testing", "../outputfiles/classifier.keras" )