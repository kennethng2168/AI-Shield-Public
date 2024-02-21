import shutil

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
import threading
from time import sleep
import urllib.request
from PIL import Image
import subprocess
import asyncio
import os
from ultralytics import YOLO





cred = credentials.Certificate(r"C:\Users\user\PycharmProjects\nlpchat\mranti-a39d6-firebase-adminsdk-1av8e-2f8d4da874.json")
app = firebase_admin.initialize_app(cred, {
    'storageBucket': 'mranti-a39d6.appspot.com'
})
firestore = firestore.client()


# Create an Event for notifying main thread.
callback_done = threading.Event()
def run_inference (docDict, image):
    flag_flood = None
    flag_fire = None
    flag_accident = None
    flag_pothole = None
    # subprocess.run(
    #     r'yolo task=segment mode=predict model=C:\Users\user\PycharmProjects\nlpchat\runs\segment\train5\weights\best.pt source=C:\Users\user\PycharmProjects\nlpchat\runs\fire.jpg save=true project=C:\Users\user\PycharmProjects\nlpchat\Detection',
    #     shell=True)
    # model = YOLO(r'C:\Users\user\PycharmProjects\nlpchat\runs\segment\train5\weights\best.pt')
    print(docDict)
    if (docDict["selection"] == "Flood"):
        model_name = r"C:\Users\user\PycharmProjects\backendAIInference\models\flood.pt"
    elif(docDict["selection"] == "Fire"):
        model_name = r'C:\Users\user\PycharmProjects\backendAIInference\models\fire.pt'
    elif (docDict["selection"] == "Potholes"):
        model_name = r'C:\Users\user\PycharmProjects\backendAIInference\models\potholes.pt'
    elif (docDict["selection"] == "Accidents"):
        model_name = r'C:\Users\user\PycharmProjects\backendAIInference\models\accidents.pt'
    model = YOLO(model_name)
    results = model.predict(source=image, conf=0.6, save=True, project=r"C:\Users\user\PycharmProjects\nlpchat\Detection")
    result = results[0]
    # print(result.boxes.cls)
    prob = str(result.boxes.cls)
    prob=prob.split("tensor([")[1].split(']')[0]
    if model_name == r"C:\Users\user\PycharmProjects\nlpchat\runs\segment\train2\weights\flood.pt":
        print("flood")
        print(prob)
        for i in prob:
            print(i)
            if i == "1." or "1":
                classification = "Flood"
                flag_flood = True
                print("Flood")
                break;
            elif i == "":
                classification = "None"
                flag_flood = False
                print("None")
        print(flag_flood)
    elif model_name == r'C:\Users\user\PycharmProjects\nlpchat\runs\segment\train5\weights\fire_best.pt':
        for i in prob:
            if prob == "1." or "1":
                classification = "Fire"
                flag_fire = True
                print("Fire")
                break;
            elif prob == "3." or "3":
                classification = "Smoke"
                print("Smoke")
            elif i == "":
                flag_fire = False
                print("None")
    elif model_name == r'C:\Users\user\PycharmProjects\nlpchat\runs\segment\train20\weights\best.pt':
        for i in prob:
            if prob == "2." or "2":
                classification = "Pothole"
                flag_pothole = True
                print("Pothole")
                break;
            # elif prob == "1." or "1":
            #     classification = "Patch"
            #     print("Patch")
            elif i == "":
                flag_fire = False
                print("None")
    elif model_name == r'C:\Users\user\PycharmProjects\nlpchat\runs\detect\train3\weights\best.pt':
        for i in prob:
            if prob == "1." or "1":
                classification = "Accident"
                flag_accident = True
                print("Pothole")
                break;
            elif i == "":
                flag_accident = False
                print("None")



    import os

    directory_path = r'C:\Users\user\PycharmProjects\nlpchat\Detection'
    most_recent_file = None
    most_recent_time = 0

    directory = (os.listdir(directory_path))
    if directory != []:
        print(directory)
        print(directory[-1])
        # iterate over the files in the directory using os.scandir
        new_directory = directory_path + "\\" + directory[-1]
        for entry in os.scandir(new_directory):
            if entry.is_file():
                # get the modification time of the file using entry.stat().st_mtime_ns
                mod_time = entry.stat().st_mtime_ns
                if mod_time > most_recent_time:
                    # update the most recent file and its modification time
                    most_recent_file = entry.name
                    print(most_recent_file)
                    from PIL import Image
                    image = new_directory + "/" + most_recent_file
                    img = Image.open(image)
                    img.show()
                    print(image)
                    bucket = storage.bucket()
                    blob = bucket.blob(image)
                    blob.upload_from_filename(image)
                    blob.make_public()
                    print(blob.public_url)
                    updateData = firestore.collection(u'detection').document(docDict["id"])
                    if flag_flood:
                        updateData.update({u'detectionImageUrl': blob.public_url, 'categories':"Flood"})
                    elif flag_fire:
                        updateData.update({u'detectionImageUrl': blob.public_url, 'categories': "Fire"})
                    elif flag_pothole:
                        updateData.update({u'detectionImageUrl': blob.public_url, 'categories': "Pothole"})
                    elif flag_accident:
                        updateData.update({u'detectionImageUrl': blob.public_url, 'categories': "Accident"})
                    else:
                        updateData.update({u'detectionImageUrl': blob.public_url, 'categories': "No Emergency Detected"})
                    # This method will show image in any image viewer
                    flag_flood = None
                    flag_fire = None
                    most_recent_time = mod_time
                    sleep(10)
        if directory[-1] == "predict9":
            shutil.rmtree(directory_path)


# Create a callback on_snapshot function to capture changes
def on_snapshot(doc_snapshot, changes, read_time):
    for doc in doc_snapshot:
        docDict = doc.to_dict()
        print(docDict)

        if (docDict["categories"] ==  None):
            image_data = docDict["id"] + ".png"
            urllib.request.urlretrieve(docDict["imageUrl"], image_data)
            run_inference(docDict, image_data)
        else:
            print("Detected")
        print(f'Received document snapshot: {doc.id}')
    callback_done.set()

doc_ref = firestore.collection(u'detection')

# Watch the document
doc_watch = doc_ref.on_snapshot(on_snapshot)
while True:
   sleep(1)
   print('Updating...')