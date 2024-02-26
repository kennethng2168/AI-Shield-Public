# AIShield
AI Shield for Google Solution Challenge 2024

## Technologies Used

*   Flutter (Android/IOS)
*   Firestore
*   Google Storage
*   YoloV8
*   Python
*   Unity/C#
*   Nvidia Cuda
*   Google Map
*   Cesium Google Earth Map
*   Firebase App Distribution for tester [link](https://appdistribution.firebase.google.com/pub/i/b2e86e62680b0e7c)

## Features

*   Crowd Mapping by taking a photo of the incidents such as Flood, Fires, Potholes and Accidents that you encounter in real life, then the image will be uploaded to Firebase and running the inference using YoloV8 Optimized by CUDA to identify the images.
*   Each uploaded images will have the geo location when users take a picture.
*   The evidences that has been uploaded will be showed in the Omni Twin (3D Management System/Digital Twin) with Cesium Google Map to identify the incidents accurately.
*   The 3D Digital Twin can be used to simulate flood particles based on the terrain height from the Cesium Google Map.
*   Users can use the Digital Twin to predict and direct relief efforts to the incidents location with accuracy to increase the response efficiency.

## Mobile App
#### Usage

AI Shield is a flutter mobile project that can be used in both IOS and Android

* `git clone https://github.com/kennethng2168/AI-Shield-Public.git`
* `flutter pub get`

To run the app, use the following command:

* `flutter run`

To debug or use the app for IOS, follow below steps:
1. Open the AI Shield Folder
2. Run without debugging on the main.dart

Alternatively, head over to the [release](https://github.com/kennethng2168/AI-Shield-Public/releases) page and download the `app-release.apk` file or [direct download link](https://github.com/kennethng2168/AI-Shield-Public/releases/download/v1.0/app-release.apk) for Android device.

## AI Shield Screenshots

Gemini Pro Flood Messages | Gemini Pro Potholes Messages| Gemini Pro Potholes Messages
:-------------------------:|:-------------------------:|:-------------------------:
![flood_messages](./Screenshots/AIShield/GeminiPro/flood_messages.jpg) |  ![potholes_messages](./Screenshots/AIShield/GeminiPro/potholes_messages.png)|![potholes_messages](./Screenshots/AIShield/GeminiPro/potholes_messages2.jpg)
Home  |  Share Location | Security (Blur Screen)
![home](./Screenshots/AIShield/Home/home.jpg) |  ![share_location](./Screenshots/AIShield/Home/share_location.png)|![blur_screen](./Screenshots/AIShield/Login_Security/blur_screen.png)
Login Cover  |  Login | Recovery Phrase
![cover](./Screenshots/AIShield/Login_Security/cover.jpg) |  ![login](./Screenshots/AIShield/Login_Security/login.png)|![recovery_phrase](./Screenshots/AIShield/Login_Security/recovery_phrase.jpg)
Sign Up | Accident Details | Fire Details
![sign_up](./Screenshots/AIShield/Login_Security/sign_up.png) |  ![accident_details](./Screenshots/AIShield/Report/accident_details.jpg)|![fire_details](./Screenshots/AIShield/Report/fire_details.png)
Report history Delete  | Report History | No Emergency Details
![history_delete](./Screenshots/AIShield/Report/history_delete.png) |  ![history](./Screenshots/AIShield/Report/history.jpg)|![no_emergency_details](./Screenshots/AIShield/Report/no_emergency_details.png)
Potholes Details | Reward | Reward Box
![potholes_details](./Screenshots/AIShield/Report/potholes_details.jpg) |  ![reward](./Screenshots/AIShield/Rewards/reward.jpg)|![reward_box](./Screenshots/AIShield/Rewards/reward_box.jpg)
Reward Card | Reward Album 
![reward_card](./Screenshots/AIShield/Rewards/reward_card.jpg) |  ![accident_details](./Screenshots/AIShield/Rewards/reward_album.jpg)|

##  Python Backend AI Inference
The AI Inference is built by using Python. The data was streamed from the firebase when there's new update to send AI inference images and results back to firestore and storage which can be visualize in both AI Shield (Flutter App) or Omni Twin (Unity)
```sh
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip install -r requirements.txt
python read_data.py
```

## Omni Twin

#### Usage

Omni Twin is a Unity project.

1. Download [Unity](https://unity.com/download)
2. Open the project in Unity.

Alternatively, head over to the [release](https://github.com/kennethng2168/AI-Shield-Public/releases) page and download the `OmniTwin.zip` file which contains the `OmniTwin.exe` binary.

### Flood Simulation

![flood-sim1](./Screenshots/OmniTwin/flood-sim1.png)

![flood-sim2](./Screenshots/OmniTwin/flood-sim2.png)

![flood-sim3](./Screenshots/OmniTwin/flood-sim3.png)

![flood-sim4](./Screenshots/OmniTwin/flood-sim4.png)

### Disaster

![disaster1](./Screenshots/OmniTwin/disaster1.png)

![disaster2](./Screenshots/OmniTwin/disaster2.png)

![disaster3](./Screenshots/OmniTwin/disaster3.png)

![disaster4](./Screenshots/OmniTwin/disaster4.png)

![disaster5](./Screenshots/OmniTwin/disaster5.png)

### Weather

![weather1](./Screenshots/OmniTwin/weather1.png)

![weather2](./Screenshots/OmniTwin/weather2.png)

![weather3](./Screenshots/OmniTwin/weather3.png)
