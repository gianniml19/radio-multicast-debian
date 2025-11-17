# 📡 Radio Multicast Streaming with FFmpeg & Debian Slim Docker

This project converts an M3U playlist into UDP multicast radio streams using FFmpeg.  
Each station in the playlist is broadcast as an MPEG-TS multicast stream across your local network.

---

## ✨ Features

- Reads any `.m3u` playlist  
- Starts up to **20 multicast streams** (configurable)  
- Multicast output: `udp://239.10.10.X:5000`  
- Extremely low CPU usage (copy-mode, no transcoding)  
- Uses **Debian** for full FFmpeg protocol support
---

## 📦 Requirements

- Linux host with multicast enabled  
- Docker 20+  
- VLC, ffplay, or any multicast-capable media player  

---

## 🛠 Build the Docker Image

`docker compose build`

🐌 Build Time Notes
- Debian-based builds
- Takes ~20 minutes
- FFmpeg + dependencies are large
- Provides complete protocol support → required for web radio

---

## ▶️ Start the Container

`docker compose up -d`

---

## ⏹️ Stop the Container
`docker compose down`

---

## 📜 View Container Logs
`docker logs -f radio-multicast-debian`

---

## 🎧 Play a Stream in VLC
- Each station is streamed to:
   `udp://@239.10.10.X:5000`

  
