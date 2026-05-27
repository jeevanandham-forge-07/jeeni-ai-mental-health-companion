<div align="center">

# 🧠 Jeeni — AI Mental Health Companion

### *Your safe space to talk, heal, and grow 💜*

[![React](https://img.shields.io/badge/React-19-61DAFB?style=for-the-badge&logo=react&logoColor=white)](https://react.dev/)
[![Ollama](https://img.shields.io/badge/Ollama-Llama_3-000000?style=for-the-badge&logo=meta&logoColor=white)](https://ollama.com/)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Node.js](https://img.shields.io/badge/Node.js-Express-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![Vite](https://img.shields.io/badge/Vite-7-646CFF?style=for-the-badge&logo=vite&logoColor=white)](https://vitejs.dev/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

**An AI-powered mental health companion that provides empathetic emotional support through text chat, video chat with facial emotion detection, voice conversations, and Telegram — with a built-in guardian safety alert system.**

[Features](#-features) • [Demo](#-demo) • [Tech Stack](#-tech-stack) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Safety System](#-safety--guardian-alert-system)

</div>

---

## 🌟 Why Jeeni?

Mental health issues are rising globally, especially among young people. Many don't have access to professional therapy due to cost, stigma, or availability. People need someone to talk to at all hours — and early detection of crises can save lives.

**Jeeni** fills this gap by being:
- 🕐 **Available 24/7** — AI never sleeps, always ready to listen
- 🤝 **Zero judgment** — share anything without fear
- 🔒 **Privacy-first** — AI runs locally on your machine via Ollama
- 🚨 **Life-saving alerts** — detects distress and alerts a guardian before a crisis escalates
- 🎙️ **Multi-modal** — text, voice, video with facial emotion detection
- 📱 **Cross-platform** — web browser + Telegram

---

## ✨ Features

### 📊 Smart Dashboard
- Session overview with total sessions, last mood, and risk trends
- Emotion trend charts powered by Chart.js
- Daily affirmation, mood journal, and guided breathing exercise
- Quick access to crisis resources (988 Lifeline, Crisis Text Line)

### 💬 Text Chat
- Real-time streaming responses (word-by-word typing effect via SSE)
- Emotion analysis on every message
- Persistent chat history across sessions
- Self-harm keyword detection + AI-based risk analysis
- Automatic guardian email alerts on high-risk detection

### 🎥 Video Chat
- Live webcam with facial expression recognition (face-api.js)
- Voice mode — speak naturally, Jeeni responds aloud (Web Speech API)
- Text-to-speech with natural-sounding voices
- Anti-echo system to prevent AI from hearing itself
- End-of-session emotion report with timestamps
- Dual-modal emotion: text sentiment + facial expressions combined

### 📱 Telegram Bot
- Link your Telegram to your Jeeni account with a 6-digit code
- Full conversation sync with Firestore
- Isolated conversation thread (separate from web)
- Crisis keyword detection with guardian alerts

### 🛡️ Guardian Safety System
- Register a trusted guardian (parent, counselor, friend)
- Automatic email alerts when self-harm language is detected
- Dual detection: direct keyword matching + AI analysis
- Privacy-preserving — alerts never include private conversation content
- Consent-based — alerts only sent with explicit user permission

---

## 🛠️ Tech Stack

### Frontend
| Technology | Purpose |
|---|---|
| **React 19** | UI framework |
| **Vite 7** | Build tool & dev server |
| **React Router 7** | Client-side routing |
| **Chart.js** | Dashboard emotion charts |
| **face-api.js** | Webcam facial emotion detection |
| **Web Speech API** | Speech recognition & text-to-speech |
| **Firebase SDK** | Auth + Firestore |

### Backend
| Technology | Purpose |
|---|---|
| **Node.js + Express** | API proxy server |
| **Ollama (Llama 3)** | Local AI inference — fully private |
| **Nodemailer** | Guardian email alerts via Gmail SMTP |
| **Telegram Bot API** | Cross-platform chat access |
| **Firebase Firestore** | Real-time NoSQL database |

---

## 🏗️ Architecture

┌──────────────────────────────────────────────────────────────┐ │ USER INTERFACES │ │ ┌──────────┐ ┌──────────────┐ ┌───────────────────────┐ │ │ │ Text Chat│ │ Video Chat │ │ Telegram Bot │ │ │ │ (Web) │ │ (Web+Camera) │ │ (Mobile/Desktop) │ │ │ └────┬─────┘ └──────┬───────┘ └──────────┬────────────┘ │ └───────┼───────────────┼──────────────────────┼───────────────┘ │ │ │ ▼ ▼ ▼ ┌──────────────────────────────────────────────────────────────┐ │ BACKEND PROXY SERVER │ │ (Node.js + Express :3001) │ │ /api/chat (SSE) │ /api/analyze │ /api/send-email │ /health │ └───────┬──────────┴──────┬───────┴────────┬───────────────────┘ │ │ │ ▼ ▼ ▼ ┌──────────────┐ ┌──────────┐ ┌──────────────┐ │ Ollama LLM │ │ Firebase │ │ Gmail SMTP │ │ (Llama 3) │ │ Firestore│ │ (Nodemailer) │ │ :11434 │ │ (Cloud) │ │ │ └──────────────┘ └──────────┘ └──────────────┘


---
## 🚀 Getting Started
### Prerequisites
- **Node.js** v18+
- **Ollama** installed with Llama 3 model (`ollama pull llama3`)
- **Firebase** project configured
### Installation
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/jeeni-ai-mental-health-companion.git
cd jeeni-ai-mental-health-companion
# Install frontend dependencies
npm install
# Install backend dependencies
cd server
npm install
Configure Environment
Create server/.env:

env

OLLAMA_URL=http://localhost:11434
OLLAMA_MODEL=llama3
PORT=3001
# Email (Gmail SMTP — use App Password)
EMAIL_USER=your@gmail.com
EMAIL_PASS=xxxx xxxx xxxx xxxx
# Telegram Bot (optional)
TELEGRAM_BOT_TOKEN=your_token
Run
bash

# Terminal 1: Start Ollama
ollama serve
# Terminal 2: Start backend
cd server && node server.js
# Terminal 3: Start frontend
npm run dev
Open http://localhost:5173 🎉

🚨 Safety & Guardian Alert System
Detection Pipeline

User Message
    │
    ├─→ Direct Keyword Detection (instant, no AI needed)
    │   • "i want to die", "kill myself", "self-harm", etc.
    │   • If matched → riskScore = 90, selfHarmFlag = true
    │
    ├─→ AI Emotion Analysis (Ollama)
    │   • Emotional state: happy/sad/angry/fearful/anxious/etc.
    │   • Risk score 0-100 + self-harm flags
    │
    └─→ Combined Risk Assessment
        • Maximum risk score from both methods
        • If riskScore ≥ 70 OR selfHarmFlag → TRIGGER GUARDIAN ALERT
What Guardians Receive
Risk level and detection type
Timestamp
Never includes actual conversation content
Professionally designed HTML email with emergency resources
🔒 Privacy & Security
🧠 Local AI: Ollama runs on YOUR machine — conversations never leave your device
🔐 Firebase Security Rules: Users can only access their own data
🛡️ No conversation logging in alerts: Guardian alerts mention risk levels but never include messages
🔑 Google OAuth 2.0: Secure authentication via Firebase
📁 Project Structure

jeeni-ai-mental-health-companion/
├── src/
│   ├── pages/          # Login, Dashboard, Text Chat, Video Chat, Settings
│   ├── components/     # Navbar, ChatBubble, VoiceOrb, BreathingExercise, etc.
│   ├── services/       # AI chat, emotion analysis, guardian alerts, speech
│   └── contexts/       # Theme & Toast notification providers
├── server/
│   ├── server.js       # Express API proxy
│   └── telegramBot.js  # Telegram bot
├── firestore.rules     # Security rules
└── vite.config.js      # Build config + API proxy
👨‍💻 Creator
Jeeni was created by Jeevanandham S — driven by a personal mission to make mental health support accessible to everyone. The name "Jeeni" is derived from the creator's name, reflecting that this project comes from the heart. 💜

📄 License
This project is licensed under the MIT License — see the 
LICENSE
 file for details.

If you find this project helpful, please give it a ⭐ — it means the world! 💜

Mental health matters. You are not alone.
