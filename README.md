# AI-Shield-Public

AI Shield for Google Solution Challenge 2024

## AI Shield

#### Usage

AI Shield is a flutter mobile project that can be used in both IOS and Android

1. Open the AI Shield Folder
2. Run without debugging on the main.dart

Alternatively, head over to the [release](https://github.com/kennethng2168/AI-Shield-Public/releases) page and download the `app-release.apk` file in Android device.

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
