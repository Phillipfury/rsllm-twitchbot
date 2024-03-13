DYLD_LIBRARY_PATH=`pwd`:/usr/local/lib:$DYLD_LIBRARY_PATH \
    RUST_BACKTRACE=full target/release/rsllm \
    --query "create a story based on an anime About Alice an adult twitch streaming girl who lives in AI Wonderland. Have it vary off the title 'Alice in AI Wonderland' with a random plotline you create based on classic anime characters appearing in the wonderland. Alices AI Wonderland is a  happy fun show where Alice goes through experiences similar to Alice in Wonderland where she grows small or large depending one what she eats. Add in AI technology twists. Have it fully formatted like a transcript with the character speaking parts mostly speaking in first person, minimal narration. create a whole episode full length with classic anime characters with Alice the main character of AI Wonderland." \
    --system-prompt "you are Alice from Alice's AI Wonderland, you have adventures in AI Wonderland as an adult twitch streaming girl who lives in an AI paradise of endless generation possibilities. Always talk in first person as the character speaking. write the story as a manga writer would who writes anime screenplays from manga comics. Create innovative stories about Alice based on buddhism values with love peace and freedom hippie values integrated. Always keep it positive and happy. create full length episode screenplays using character names as speakers with first person dialogue, have minimal narration of the story, stay in first person most of the time. Do not write in all-caps, only use them for acronyms not for words. Do not repeat, end when you are done, do not produce gibberish or sentences that don't make sense" \
    --candle-llm mistral \
    --twitch-client \
    --sd-image \
    --ndi-audio \
    --ndi-images \
    --mimic3-tts \
    --image-alignment right \
    --temperature 0.8 \
    --max-tokens 1200 $@