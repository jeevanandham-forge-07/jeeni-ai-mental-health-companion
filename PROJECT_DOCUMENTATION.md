# 🧠 Jeeni — AI Mental Health Companion

## Complete Project Documentation

---

## 📖 Table of Contents

1. [Project Concept](#1-project-concept)
2. [Purpose & Why This Project Exists](#2-purpose--why-this-project-exists)
3. [System Architecture](#3-system-architecture)
4. [Technology Stack](#4-technology-stack)
5. [Feature Breakdown](#5-feature-breakdown)
6. [Safety & Guardian Alert System](#6-safety--guardian-alert-system)
7. [Data Flow & How It Works](#7-data-flow--how-it-works)
8. [Project Structure](#8-project-structure)
9. [How to Run](#9-how-to-run)
10. [Environment Configuration](#10-environment-configuration)
11. [Security Considerations](#11-security-considerations)

---

## 1. Project Concept

**Jeeni** is an AI-powered mental health companion web application that provides emotional support through real-time conversations. It leverages large language models (LLMs) running locally via Ollama to act as a warm, empathetic friend who helps users explore their feelings and emotions.

Unlike traditional therapy apps that provide generic advice, Jeeni:
- **Talks like a real friend** — warm, caring, non-judgmental, and personalized
- **Detects emotions in real-time** — from both text analysis and facial expression recognition via webcam
- **Monitors risk levels** — identifies signs of distress, self-harm, or crisis
- **Alerts guardians** — automatically notifies a trusted person (parent, counselor) via email/SMS when a user shows high-risk behavior
- **Works across platforms** — web (text chat + video chat) and Telegram

### Who Is It For?
- Students dealing with academic pressure, loneliness, or anxiety
- Anyone who needs a safe, always-available companion to talk to
- Young people whose guardians want to be alerted in case of crisis
- Mental health awareness initiatives

---

## 2. Purpose & Why This Project Exists

### The Problem
- Mental health issues are rising globally, especially among young people
- Many people don't have access to professional therapy due to cost, stigma, or availability
- People often need someone to talk to at odd hours when no one is available
- Early detection of mental health crises can save lives

### The Solution — Jeeni
Jeeni fills the gap by providing:
1. **24/7 availability** — AI doesn't sleep, always ready to listen
2. **Zero judgment** — users can share anything without fear
3. **Privacy-first** — conversations are private, AI runs locally on the user's machine
4. **Early warning system** — detects distress and alerts a guardian before a crisis escalates
5. **Multi-modal interaction** — text chat, voice conversation, video with facial emotion detection
6. **Cross-platform** — accessible via web browser and Telegram

### Why AI for Mental Health?
- AI can provide consistent, patient, empathetic responses every time
- It can analyze patterns in conversations that humans might miss
- It enables continuous monitoring without being intrusive
- It complements (not replaces) professional mental health care

---

## 3. System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INTERFACES                          │
│                                                                 │
│   ┌──────────┐   ┌──────────────┐   ┌──────────────────────┐   │
│   │ Text Chat│   │  Video Chat  │   │   Telegram Bot       │   │
│   │  (Web)   │   │ (Web+Camera) │   │  (Mobile/Desktop)    │   │
│   └────┬─────┘   └──────┬───────┘   └──────────┬───────────┘   │
│        │                │                       │               │
└────────┼────────────────┼───────────────────────┼───────────────┘
         │                │                       │
         ▼                ▼                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND PROXY SERVER                          │
│                    (Node.js + Express)                           │
│                    Port 3001                                     │
│                                                                 │
│   ┌──────────┐  ┌───────────┐  ┌──────────┐  ┌──────────────┐  │
│   │ /api/chat│  │/api/analyze│  │/api/send- │  │/api/send-    │  │
│   │ (Stream) │  │ (Emotion) │  │  sms      │  │  email       │  │
│   └────┬─────┘  └─────┬─────┘  └────┬─────┘  └──────┬───────┘  │
│        │              │              │               │          │
└────────┼──────────────┼──────────────┼───────────────┼──────────┘
         │              │              │               │
         ▼              ▼              ▼               ▼
┌────────────────┐  ┌────────┐  ┌──────────┐  ┌──────────────┐
│   Ollama LLM   │  │Firebase│  │  Twilio   │  │ Gmail SMTP   │
│  (llama3 model)│  │Firestore│ │  SMS API  │  │ (Nodemailer) │
│  localhost:11434│  │(Cloud) │  │(optional) │  │              │
└────────────────┘  └────────┘  └──────────┘  └──────────────┘
```

### Architecture Decisions:
- **Backend Proxy**: All AI requests go through the backend server, never directly from the browser. This allows LAN/remote devices to use the AI, and keeps Ollama's port secure.
- **Streaming SSE**: Chat responses are streamed token-by-token using Server-Sent Events (SSE), giving users a real-time typing effect instead of waiting for the full response.
- **Local AI**: Ollama runs locally, so conversations never leave the user's machine — true privacy.
- **Firebase for persistence**: User data, conversations, emotion history, and alerts are stored in Firestore for cross-device sync.

---

## 4. Technology Stack

### Frontend Technologies

| Technology | What It Is | Why It's Used | Role in This Project |
|------------|-----------|---------------|---------------------|
| **React 19** | JavaScript UI library by Meta | Component-based architecture, fast rendering, huge ecosystem | Core framework for all UI pages — login, dashboard, chat, video chat, settings |
| **Vite 7** | Next-generation build tool & dev server | Lightning-fast Hot Module Replacement (HMR), instant server start, modern ES module support | Development server, build tool, and API proxy (forwards `/api/*` to backend) |
| **React Router 7** | Client-side routing library | Single-page app navigation without full page reloads | Routes: `/login`, `/` (dashboard), `/text-chat`, `/video-chat`, `/telegram`, `/settings` |
| **Chart.js + react-chartjs-2** | Charting library | Beautiful, responsive charts with minimal setup | Dashboard emotion trend charts, session analytics graphs |
| **face-api.js** | Face detection & expression recognition | Client-side facial emotion detection using TensorFlow.js under the hood | Video chat webcam emotion detection — detects happy, sad, angry, surprised, etc. |
| **Web Speech API** | Browser-native speech recognition & synthesis | No external API needed, runs locally in the browser | Voice Mode (speech-to-text for input) + Text-to-Speech (Jeeni speaks responses aloud) |
| **Firebase SDK** | Google's app development platform | Authentication, real-time database, cloud hosting | Google Sign-In auth, Firestore for conversations/emotions/alerts, user profiles |

### Backend Technologies

| Technology | What It Is | Why It's Used | Role in This Project |
|------------|-----------|---------------|---------------------|
| **Node.js** | JavaScript runtime for server-side code | Same language as frontend, excellent for I/O-heavy tasks like streaming | Runs the backend proxy server and Telegram bot |
| **Express.js** | Minimalist web framework for Node.js | Simple routing, middleware support, industry standard | API endpoints: `/api/chat`, `/api/analyze`, `/api/health`, `/api/send-sms`, `/api/send-email` |
| **Ollama** | Local LLM inference engine | Runs AI models locally — no cloud API keys, no cost, full privacy | Powers Jeeni's conversation AI using the `llama3` model |
| **Nodemailer** | Email sending library for Node.js | Reliable SMTP-based email delivery, supports Gmail | Sends guardian safety alert emails when high-risk behavior is detected |
| **Twilio** | Cloud communications platform | Industry-standard SMS API | Sends SMS alerts to guardians (optional, falls back to console log in test mode) |
| **node-telegram-bot-api** | Telegram Bot API wrapper | Easy integration with Telegram's bot platform | Powers the Jeeni Telegram bot for mobile/desktop chat access |
| **dotenv** | Environment variable loader | Keeps sensitive keys (API tokens, passwords) out of source code | Loads `.env` file config for ports, API keys, email credentials |
| **CORS** | Cross-Origin Resource Sharing middleware | Allows frontend (port 5173) to communicate with backend (port 3001) | Enables the Vite dev server to proxy API requests to the Express server |

### External Services

| Service | What It Is | Role |
|---------|-----------|------|
| **Firebase Authentication** | Google's auth service | User sign-up/login via Google account (OAuth 2.0) |
| **Cloud Firestore** | NoSQL document database | Stores users, conversations, messages, emotion history, alerts, guardian settings |
| **Gmail SMTP** | Google's email service | Sends guardian alert emails (uses App Password for authentication) |
| **Telegram Bot API** | Telegram's bot platform | Enables Jeeni to chat with users on Telegram with full conversation sync |
| **jsDelivr CDN** | Free CDN for npm packages | Hosts face-api.js model files for facial expression recognition |

---

## 5. Feature Breakdown

### 5.1 Dashboard (HomePage)
- **Session overview**: Total sessions, last mood, risk score trend
- **Emotion trend chart**: Line/area chart showing mood changes over time (Chart.js)
- **Quick actions**: Navigate to Text Chat, Video Chat, Telegram, Settings
- **Daily affirmation**: Motivational message to start the day
- **Breathing exercise**: Guided inhale-hold-exhale animation for instant calm
- **Mood journal**: Write daily mood entries stored in Firestore
- **Crisis resources**: Quick access to 988 Suicide & Crisis Lifeline, Crisis Text Line

### 5.2 Text Chat
- **Real-time streaming**: Jeeni's responses appear word-by-word (SSE streaming)
- **Emotion analysis**: Every user message is analyzed for emotion and risk score
- **Chat history**: Conversations persist across sessions via Firestore
- **Self-harm detection**: Direct keyword matching runs alongside AI analysis for reliability
- **Guardian alerts**: Automatically triggered when risk score exceeds 70% or self-harm keywords detected
- **Session sidebar**: Shows current emotion, risk level, message count, and AI status

### 5.3 Video Chat
- **Webcam feed**: Live camera preview with face emotion overlay
- **Facial expression recognition**: face-api.js detects emotions from facial expressions in real-time
- **Voice Mode**: Continuous speech recognition — speak naturally, Jeeni responds aloud
- **Text-to-Speech**: Jeeni speaks responses using Web Speech API with natural-sounding voices
- **Anti-echo**: Voice recognition pauses while Jeeni speaks to prevent self-hearing
- **Emotion report**: End-of-session summary showing all detected emotions with timestamps
- **Dual-modal emotion**: Combines text sentiment + facial expression for comprehensive analysis

### 5.4 Telegram Bot
- **Account linking**: Users link their Telegram to their web account with a 6-digit code
- **Full conversation sync**: Messages from Telegram are saved to the same Firestore conversations
- **Isolated context**: Telegram has its own conversation thread (separate from web text/video)
- **High-risk detection**: Keyword-based crisis detection with guardian SMS + email alerts
- **Multi-user support**: Each Telegram user is mapped to their Jeeni account

### 5.5 Guardian Settings
- **Guardian registration**: Name, phone, email, relationship
- **Consent management**: Guardian alerts only sent if consent is explicitly given
- **Dual notification**: Both SMS (Twilio) and Email (Gmail SMTP) alerts
- **Privacy-preserving**: Alerts never include actual conversation content

### 5.6 Settings Page
- **Voice settings**: Test voice, select TTS voice, adjust volume
- **Account info**: Display name, email, account creation date
- **Theme preferences**: System settings and display options

---

## 6. Safety & Guardian Alert System

This is the most critical feature of Jeeni. Here's how it works:

### Detection Pipeline
```
User Message
    │
    ├──→ Direct Keyword Detection (instant, no AI needed)
    │    • "i want to die", "kill myself", "suicide", "self-harm", etc.
    │    • If matched → riskScore = 90, selfHarmFlag = true
    │
    ├──→ AI Emotion Analysis (Ollama)
    │    • Analyzes emotional state: happy/sad/angry/fearful/anxious/etc.
    │    • Assigns risk score 0-100
    │    • Flags self-harm indicators
    │
    └──→ Combined Risk Assessment
         • Takes the MAXIMUM risk score from both methods
         • If riskScore ≥ 70 OR selfHarmFlag === true → TRIGGER ALERT
```

### Alert Pipeline
```
Risk Detected (score ≥ 70 or selfHarmFlag)
    │
    ├──→ Check: Does user have guardian configured? Has consent been given?
    │    • No → Log warning, skip alert
    │    • Yes → Continue
    │
    ├──→ Create Alert Document in Firestore
    │    • Stores: userId, risk level, emotion, timestamp, status
    │
    ├──→ Send SMS (if guardian phone configured)
    │    • Via Twilio API (live) or console log (test mode)
    │    • Message: "Urgent: [Name] is showing signs of distress. Risk Level: [level]. Please check in."
    │
    └──→ Send Email (if guardian email configured)
         • Via Gmail SMTP (Nodemailer) or console log (test mode)
         • Professional HTML email with alert details
         • Never includes private conversation content
```

### Safety Rules for Jeeni's AI
- Never diagnoses or prescribes medication
- For crisis language: responds with deep empathy + "Are you safe right now?" + 988 helpline
- For general distress: suggests one simple coping technique
- Always validates the user's feelings first

---

## 7. Data Flow & How It Works

### Chat Message Flow
```
1. User types message in TextChatPage
2. Message saved to Firestore (users/{uid}/conversations/{convId}/messages)
3. Message sent to backend: POST /api/chat (with conversation history)
4. Backend forwards to Ollama: POST http://localhost:11434/api/chat
5. Ollama streams response token-by-token
6. Backend re-streams as SSE to frontend
7. Frontend displays tokens as they arrive (typing effect)
8. On complete: AI response saved to Firestore
9. Parallel: Emotion analysis via POST /api/analyze
10. Parallel: Guardian alert check (keyword + AI-based)
```

### Firestore Data Structure
```
firestore/
├── users/{userId}
│   ├── displayName, email, lastMood, lastRiskScore, totalSessions
│   ├── guardian_name, guardian_phone, guardian_email, guardian_consent
│   ├── telegram_chat_id
│   └── conversations/{conversationId}
│       ├── active, channel, createdAt, updatedAt
│       └── messages/{messageId}
│           ├── sender (user/jeeni)
│           ├── channel (web_text/web_video/telegram)
│           ├── text, createdAt
│           └── analysis_summary { emotion, risk_score, risk_level }
│
├── emotionHistory/{docId}
│   └── userId, emotion, riskScore, timestamp
│
├── alerts/{alertId}
│   └── uid, userName, guardianPhone, guardianEmail, reason_short,
│       risk_level, selfHarmFlag, riskScore, emotion, processed,
│       sms_status, email_status, createdAt
│
├── telegram_links/{userId}
│   └── telegramChatId, linkedAt, userId
│
└── link_codes/{code}
    └── uid, expiresAt
```

---

## 8. Project Structure

```
mental-health/
├── index.html                  # Entry HTML file
├── package.json                # Frontend dependencies
├── vite.config.js              # Vite config + API proxy
├── .env.example                # Example environment variables
│
├── src/
│   ├── main.jsx                # React entry point
│   ├── App.jsx                 # Root component with routing
│   ├── firebase.js             # Firebase initialization
│   ├── index.css               # Global styles & design system
│   │
│   ├── pages/
│   │   ├── LoginPage.jsx/css   # Google auth login
│   │   ├── HomePage.jsx/css    # Dashboard with charts
│   │   ├── TextChatPage.jsx/css # Text-based chat
│   │   ├── VideoChatPage.jsx/css # Video + voice chat
│   │   ├── TelegramLinkPage.jsx/css # Telegram account linking
│   │   └── SettingsPage.jsx/css # User settings
│   │
│   ├── components/
│   │   ├── Navbar.jsx/css      # Navigation bar
│   │   ├── ChatBubble.jsx/css  # Chat message bubble
│   │   ├── EmotionIndicator.jsx/css # Emotion display
│   │   ├── GuardianSettings.jsx/css # Guardian config form
│   │   ├── VoiceOrb.jsx/css    # Animated voice indicator
│   │   ├── BreathingExercise.jsx/css # Guided breathing
│   │   ├── MoodJournal.jsx/css # Daily mood journal
│   │   ├── DailyAffirmation.jsx/css # Motivational quotes
│   │   ├── CrisisResources.jsx/css  # Emergency help info
│   │   ├── EmotionTrendChart.jsx/css # Dashboard chart
│   │   └── ProtectedRoute.jsx  # Auth guard
│   │
│   ├── services/
│   │   ├── ollamaService.js    # AI chat + emotion analysis
│   │   ├── guardianService.js  # Firestore + guardian alerts
│   │   ├── speechService.js    # Voice recognition + TTS
│   │   ├── emotionService.js   # Face emotion detection
│   │   └── prompts.js          # AI system prompts
│   │
│   └── contexts/
│       ├── ThemeContext.jsx     # Dark/light theme
│       └── ToastContext.jsx     # Toast notifications
│
├── server/
│   ├── server.js               # Express backend proxy
│   ├── telegramBot.js          # Telegram bot script
│   ├── package.json            # Backend dependencies
│   └── .env                    # Server environment config
│
└── firestore.rules             # Firestore security rules
```

---

## 9. How to Run

### Prerequisites
- **Node.js** v18+ installed
- **Ollama** installed with `llama3` model pulled (`ollama pull llama3`)
- **Google account** for Firebase authentication (already configured)

### Step 1: Start Ollama
```bash
ollama serve
```
Ollama runs on `http://localhost:11434` by default.

### Step 2: Start the Backend Server
```bash
cd server
npm install
node server.js
```
Server starts on `http://localhost:3001`. You'll see:
```
🧠 Jeeni Proxy Server running on port 3001
   Ollama URL: http://localhost:11434
   Model: llama3
   SMS Mode: 🧪 TEST (console log)
   Email Mode: 🧪 TEST (console log)
```

### Step 3: Start the Frontend
```bash
# In the project root (not /server)
npm install
npm run dev
```
Frontend starts on `http://localhost:5173`. Open it in your browser.

### Step 4 (Optional): Start Telegram Bot
```bash
cd server
node telegramBot.js
```

### Quick Start (Windows)
Use the included `start.bat` script to start everything at once.

---

## 10. Environment Configuration

### Server `.env` File (`server/.env`)

```env
# Ollama Configuration
OLLAMA_URL=http://localhost:11434    # Where Ollama is running
OLLAMA_MODEL=llama3                 # Which LLM model to use

# Server Port
PORT=3001                           # Backend server port

# Telegram Bot Token
TELEGRAM_BOT_TOKEN=your_token       # From @BotFather on Telegram

# Email Configuration (Gmail SMTP)
EMAIL_USER=your@gmail.com           # Your Gmail address
EMAIL_PASS=xxxx xxxx xxxx xxxx      # 16-char App Password (NOT regular password)
# To generate App Password:
# Google Account → Security → 2-Step Verification → App Passwords

# Twilio SMS (Optional)
TWILIO_ACCOUNT_SID=ACxxxxxxxx       # From Twilio console
TWILIO_AUTH_TOKEN=xxxxxxxx          # From Twilio console
TWILIO_FROM_NUMBER=+1234567890      # Your Twilio phone number
```

### Email Setup Guide
1. Enable **2-Step Verification** on your Google Account
2. Go to Google Account → Security → App Passwords
3. Generate a new App Password for "Mail"
4. Copy the 16-character password into `EMAIL_PASS`
5. Set `EMAIL_USER` to your Gmail address
6. Restart the backend server

When configured correctly, you'll see:
```
✅ Email transporter verified — ready to send emails
```

---

## 11. Security Considerations

### Privacy
- **Local AI**: Ollama runs on the user's machine — conversations never leave the device
- **No conversation logging in alerts**: Guardian alerts mention risk levels but NEVER include actual message content
- **Firebase Security Rules**: Firestore rules restrict users to only access their own data

### Authentication
- **Google OAuth 2.0**: Secure sign-in via Firebase Authentication
- **Protected routes**: All pages except login require authentication
- **Session persistence**: Firebase handles token refresh automatically

### Data Protection
- **Firestore rules**: Users can only read/write their own documents
- **Environment variables**: All sensitive credentials stored in `.env` (not committed to git)
- **HTTPS ready**: Vite dev server supports HTTPS for production deployment

---

## Creator

**Jeeni** was created by **Jeevanandham S** (Jeeva) as an AI-driven mental health support system. The name "Jeeni" is derived from the creator's name, reflecting the personal mission to make mental health support accessible to everyone.

---

*Last updated: March 2026*
