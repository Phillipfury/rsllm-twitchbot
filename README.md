# Rust LLM - AI System/Network/Stream Analyzer

Simple rust program that can use an llm using the OpenAI specifications to analyze data from realtime captures of network devices or systems proc values or arbitrary streams of data. It can also be used to send prompts to the llm and display the results in the console. It is designed to be used with the llama.cpp server and the GGUF model Mixtral 8x7b. It can also be used with the OpenAI API.

A Rust-based client for interacting with the OpenAI API, designed to send prompts and receive responses asynchronously, displaying them in the console. Ideal for developers and researchers integrating AI responses into Rust applications or exploring OpenAI's capabilities programmatically. It also includes a system and network analyzer that can be used to capture and analyze network packets and system stats.

I recommend The Dolphin mixtral model is based on Mixtral-8x7b. The base model has 32k context, Dolphin finetuned it with 16k. This Dolphin is really good at coding, They trained with a lot of coding data. It is very obedient but it is not DPO tuned - so you still might need to encourage it in the system prompt as they show in the examples on the main model site on Huggingface.

## Recommended model and server in C++ to run it with:
- GGUF Model Mixtral 8x7b: <https://huggingface.co/TheBloke/dolphin-2.7-mixtral-8x7b-GGUF>
- Dolphin 2.7 information: <https://huggingface.co/cognitivecomputations/dolphin-2.7-mixtral-8x7b>
- Server Llama.cpp: <https://github.com/ggerganov/llama.cpp>

Run llama.cpp as a server with OpenAI API compatibility:

```bash
# Context to model max, port 8081 lisenting on 127.0.0.1.
# gpu 60x, threads 24x, slots of context 8 (divides up to allow multiple requests to the model).
# Tuned for a Mac Studio M2 Ultra in this example, adjust for your GPU/CPU.
server -m /Volumes/BrahmaSSD/LLM/models/GGUF/dolphin-2.7-mixtral-8x7b.Q5_K_M.gguf \
    -c 0 \
    --port 8081 \
    -ngl 60 \
    -np 8 \
    -t 24 \
    --host 127.0.0.1
```

## Features

- **LLM Client**: with OpenAI API compatibility that is simple for use without dependencies or complexity with async threading of stream output token by token.
- **LLM Analysis of OS**: System Stats.
- **LLM Analysis of Network**: Packet Capture (MpegTS support currently).
- **CLI Support**: Uses the clap crate for an easy command-line interface.
- **Async Requests**: Built with tokio for efficient non-blocking I/O operations.
- **Configurable**: Supports environment variables and command-line options for custom requests.
- **Structured Logging**: Implements the log crate for clear and configurable logging.
- **JSON Handling**: Utilizes serde and serde_json for hassle-free data serialization and deserialization.

![RSLLM](https://storage.googleapis.com/gaib/2/rsllm.webp)

## Dependencies

- Server Llama.cpp: <https://github.com/ggerganov/llama.cpp>
- GGUF Model Mixtral 8x7b: <https://huggingface.co/TheBloke/dolphin-2.7-mixtral-8x7b-GGUF>

## Getting Started

### Prerequisites

Ensure Rust and Cargo are installed on your system. If not, follow the installation guide [here](https://www.rust-lang.org/tools/install).

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/groovybits/rsllm.git
    ```

2. Move into the project directory:

    ```bash
    cd rsllm
    ```

3. Build the project:

    ```bash
    cargo build --release
    ```

### Configuration

Copy `.env.example` to `.env` file in the project root and add your OpenAI API key (if using OpenAI):

```bash
# .env
OPENAI_API_KEY=your_openai_api_key_here
```

To use OpenAI GPT API instead of a local LLM, you need to have an account and an API key. You can sign up for an API key [https://beta.openai.com/signup/](https://beta.openai.com/signup/).

You must alter the -llm-host option to match your server for rsllm to fit your environment. For example, if you are running llama.cpp on the same machine as rsllm, you can use the following: `--host http://127.0.0.1:8080`. For using OpenAI GPT API add --use-openai on the cmdline which will set the llm host for you to OpenAI's.

### Usage

Run the client with Cargo, passing your desired prompt and other options as arguments:

`cargo run -- --query "Your prompt here" --use-openai`

#### Command-Line Options:

```bash
RsLLM OpenAI API client

Usage: rsllm [OPTIONS]

Options:
      --system-prompt <SYSTEM_PROMPT>
          System prompt [env: SYSTEM_PROMPT=] [default: "you are able to say green or red depending on the mpegts stream health determined from packet analysis."]
      --query <QUERY>
          Query to generate completions for [env: QUERY=] [default: "Determine if the stream is healthy or sick, diagnose the issue if possible or give details about it. Use the historical view to see bigger trends of mpegts packet streams."]
      --temperature <TEMPERATURE>
          Temperature for LLM sampling, 0.0 to 1.0, it will cause the LLM to generate more random outputs. 0.0 is deterministic, 1.0 is maximum randomness. Default is 0.8. [env: TEMPERATURE=] [default: 0.8]
      --top-p <TOP_P>
          Top P [env: TOP_P=] [default: 1.0]
      --presence-penalty <PRESENCE_PENALTY>
          Presence Penalty, it will cause the LLM to generate more diverse outputs. 0.0 is deterministic, 1.0 is maximum randomness. Default is 0.0. [env: PRESENCE_PENALTY=] [default: 0.0]
      --frequency-penalty <FREQUENCY_PENALTY>
          Frequency Penalty, it will cause the LLM to generate more diverse outputs. 0.0 is deterministic, 1.0 is maximum randomness. Default is 0.0. [env: FREQUENCY_PENALTY=] [default: 0.0]
      --max-tokens <MAX_TOKENS>
          Max Tokens, 1 to N. Default is 800. [env: MAX_TOKENS=] [default: 800]
      --model <MODEL>
          OpenAI LLM Model (N/A with local Llama2 based LLM) [env: MODEL=] [default: gpt-4-turbo-preview]
      --llm-host <LLM_HOST>
          LLM Host url with protocol, host, port,  no path [env: LLM_HOST=] [default: http://127.0.0.1:8080]
      --llm-path <LLM_PATH>
          LLM Url path for completions, default is /v1/chat/completions. [env: LLM_PATH=] [default: /v1/chat/completions]
      --llm-history-size <LLM_HISTORY_SIZE>
          LLM History size, default is 0 (unlimited). [env: LLM_HISTORY_SIZE=] [default: 0]
      --no-stream
          Don't stream output, wait for all completions to be generated before returning. Default is false. [env: NO_STREAM=]
      --use-openai
          Safety feature for using openai api and confirming you understand the risks, you must also set the OPENAI_API_KEY, this will set the llm-host to api.openai.com. Default is false. [env: USE_OPENAI=]
      --debug-inline
          debug inline on output (can mess up the output) as a bool. Default is false. [env: DEBUG_INLINE=]
      --ai-os-stats
          Monitor system stats, default is false. [env: AI_OS_STATS=]
      --daemon
          run as a daemon monitoring the specified stats, default is false. [env: DAEMON=]
      --ai-network-stats
          Monitor network stats, default is false. [env: AI_NETWORK_STATS=]
      --ai-network-hexdump
          Monitor network full packet hex dump, default is false. [env: AI_NETWORK_HEXDUMP=]
      --ai-network-metadata-off
          Turn off ai metadata network packet processing, only hexdump, default is false. [env: AI_NETWORK_METADATA_OFF=]
      --ai-network-packet-count <AI_NETWORK_PACKET_COUNT>
          AI Network Packet Count [env: AI_NETWORK_PACKET_COUNT=] [default: 7]
      --pcap-stats
          PCAP output capture stats mode [env: PCAP_STATS=]
      --pcap-batch-size <PCAP_BATCH_SIZE>
          Sets the batch size [env: PCAP_BATCH_SIZE=] [default: 7]
      --payload-offset <PAYLOAD_OFFSET>
          Sets the payload offset [env: PAYLOAD_OFFSET=] [default: 42]
      --packet-size <PACKET_SIZE>
          Sets the packet size [env: PACKET_SIZE=] [default: 188]
      --buffer-size <BUFFER_SIZE>
          Sets the pcap buffer size [env: BUFFER_SIZE=] [default: 1358000]
      --read-time-out <READ_TIME_OUT>
          Sets the read timeout [env: READ_TIME_OUT=] [default: 60000]
      --source-device <SOURCE_DEVICE>
          Sets the source device [env: SOURCE_DEVICE=] [default: ]
      --source-ip <SOURCE_IP>
          Sets the source IP [env: SOURCE_IP=] [default: 224.0.0.200]
      --source-protocol <SOURCE_PROTOCOL>
          Sets the source protocol [env: SOURCE_PROTOCOL=] [default: udp]
      --source-port <SOURCE_PORT>
          Sets the source port [env: SOURCE_PORT=] [default: 10000]
      --use-wireless
          Sets if wireless is used [env: USE_WIRELESS=]
      --promiscuous
          Use promiscuous mode [env: PROMISCUOUS=]
      --immediate-mode
          PCAP immediate mode [env: IMMEDIATE_MODE=]
      --hexdump
          Hexdump [env: HEXDUMP=]
      --show-tr101290
          Show the TR101290 p1, p2 and p3 errors if any [env: SHOW_TR101290=]
      --pcap-channel-size <PCAP_CHANNEL_SIZE>
          PCAP Channel Size, drop packets if channel is full, 1g = 1_000_000 [env: PCAP_CHANNEL_SIZE=] [default: 1000000]
      --debug-llm-history
          DEBUG LLM Message History [env: DEBUG_LLM_HISTORY=]
      --poll-interval <POLL_INTERVAL>
          POLL Interval in ms, default to 60 seconds [env: POLL_INTERVAL=] [default: 60000]
      --no-progress
          Turn off progress output dots [env: NO_PROGRESS=]
  -h, --help
          Print help
  -V, --version
          Print version
```

### Example (default payload query is an mpegts nal packet to parse and analyze)

```bash
$ cargo run

Response status: 200 OK
---

Analyzing the provided MPEG-TS NAL (Network Abstraction Layer) dumps requires breaking down each dump into their respective sections, identifying packet headers, payload, and interpreting the key elements like PID (Packet Identifier), continuity counters, and payload unit start indicators, among others. Given the complexity and detail involved in real-time MPEG-TS packet analysis, below is a simplified breakdown based on the provided NAL dumps. This representation will closely resemble what you might see on a professional MPEG-TS analyzer's output.

### MPEG-TS Packet Analysis Overview

#### General Stream Settings
- **Video Codec**: H.264 (libx264)
- **Audio Codec**: AAC
- **Resolution**: 1920x1080
- **Frame Rate**: 29.976fps
- **Audio Sample Rate**: 48kHz
- **Audio Bitrate**: 128kbps
- **TS PMT PID**: 0x1000
- **TS Start PID**: 0x0100
- **Bitrate Settings**: CBR (Constant Bit Rate) 19Mbps
- **Service Provider**: TestStream
- **Service Name**: ColorBarsWithTone

#### Packet Breakdown (Simplified for the first packet of each dump)

1. **Packet 1**
   - **Header**: 0x47010010
     - Sync Byte: 0x47
     - Payload Unit Start Indicator: 1
     - PID: 0x0100
     - Continuity Counter: 0
   - **Payload Type**: Video
   - **Content**: Beginning of a video frame (NAL unit)

2. **Packet 2**
   - **Header**: 0x47010011
     - Sync Byte: 0x47
     - Payload Unit Start Indicator: 1
     - PID: 0x0101
     - Continuity Counter: 0
   - **Payload Type**: Audio
   - **Content**: Beginning of an audio frame

3. **Packet 3**
   - **Header**: 0x47010012
     - Sync Byte: 0x47
     - Payload Unit Start Indicator: 1
     - PID: 0x0102
     - Continuity Counter: 0
   - **Payload Type**: Undefined (could be metadata or additional stream data)
   - **Content**: Data packet

4. **Packet 4**
   - **Header**: 0x47010013
     - Sync Byte: 0x47
     - Payload Unit Start Indicator: 1
     - PID: 0x0103
     - Continuity Counter: 0
   - **Payload Type**: Undefined (could be metadata or additional stream data)
   - **Content**: Data packet

### Key Stats (Aggregated for simplicity)

- **Total Packets Analyzed**: 4 (Note: This is for illustration; a full analysis would involve all packets in the dump)
- **Video Packets**: Approx. 25% (Based on PID and content type)
- **Audio Packets**: Approx. 25%
- **Data/Undefined Packets**: Approx. 50%
- **Error Packets**: 0%
- **PAT/PMT Analysis**: Not directly provided in the dump, assumed based on settings
- **Continuity Errors**: None detected in the provided samples
- **PID Usage**:
  - 0x0100: Video
  - 0x0101: Audio
  - 0x0102, 0x0103: Data/Undefined

### Packet Flow Visualization

This would typically involve a time-based graph showing packet intervals, PID distribution, bitrate fluctuations, and possibly packet losses or errors, which is not feasible to accurately depict in text form here. A professional MPEG-TS analyzer would provide a graphical representation of these elements, offering insights
--
Index 0 ID chatcmpl-8olUak4ptUT1A3icM4w7flHRiC5zN
Object chat.completion.chunk by Model gpt-4-0125-preview User unknown
Created on 2024-02-05 05:07:32 Finish reason: length
Tokens 800 Bytes 2964
--
```

## TODO

- use pcap input and use LLM to analyze the network and provide insights, monitor, report, and alert.
- analyze system stats to keep track of resources used and throttle our usage, monitor, report, and alert.
- preserve history as a small db possibly sqlite or mongodb locally. feed history into chroma db for RAG.
- use chroma db to do RAG with documents for augmenting the prompt with relevant information.
- allow daemon mode to run and listent for requests via zmq input and pass to output.
- return results from streaming function, fix streaming function to non-block and be more efficient.
- segment output into smaller chunks for realtime processing downstream.
- add more options for the LLM and openai api.
- capnproto for serialization and deserialization of data.
- add stable diffusion for image generation for visualizing results.
- add text to speech for audio output of results.
- add music generation for mood enhancement based on results.
- add video generation with consistent frame context of objects staying same in frame.
- speech to text for audio input for llm ingestion and subtitling of video.
- setup as a crate library to use in other projects.
- freeform input options for the LLM to figure out what the user wants to do.
- dynamic code generation of python for new tasks on the fly like video processing? risks?
- iterations and multi-generational output with outlines leading to multiple passes till a final result is reached.
- use ffmpeg-next-sys to process video and audio in real-time, use for generating frames/audio/text to video etc / transforming video, creating mood videos or themes and stories. Experiment to see what an LLM + FFmpeg can do together.
- MpegTS Analyzer for real-time analysis of mpegts streams and reporting, with AI to detect issues and report them.
- Use Perceptual Hashes DCT64 based frame fingerprints from video input to detect changes in video frames, recognize and learn repeating frames / content sequences, commercial break verification, and ad insertion detection. Plug in SCTE35 and have database of content fingerprinted to compare to and various quality checks on iput and confirmation of break/logo fidelity and presence.

## License

This project is under the MIT License - see the LICENSE file for details.

## Author

Chris Kennedy, February 2024
