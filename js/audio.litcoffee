First set up a context within upon all the functions
used to parse the audio will be called:


	try audio = new AudioContext()

Then open an HTTP request to asynchronously get your audio file:

	url = 'data/11 Where I\'m Trying To Go (Marvel Years Remix).mp3';
	request = new XMLHttpRequest();
	request.open('GET', url, true);
	request.responseType = "arraybuffer";

When the request returns, onload is called, which in turn calls setup.

	request.onload = ()->
		audio.decodeAudioData(
			request.response,
			(buffer) ->

The AudioBufferSourceNode contains the buffer that is loaded asynchronously with decodeAudioData.

				source = audio.createBufferSource();
				source.buffer = buffer;

The ScriptProcessorNode takes the audio data as its input and outputs to the destination node which plays the sound.

				sourceJs = audio.createScriptProcessor(2048,1,1)
				sourceJs.buffer = buffer



The AnalyserNode takes the current frequency data from the AudioBufferSourceNode, smoothes it, and outputs to the ScriptProcessorNode

				analyser = audio.createAnalyser();
				analyser.smoothingTimeConstant = 1;
				analyser.fftSize = 512;
				source.connect(analyser);
				analyser.connect(sourceJs);

Create the oscilloscope and connect the AudioBufferSourceNode to it

				myOscilloscope = new WavyJones(audio, 'oscilloscope');
				source.connect(myOscilloscope);
				source.connect(audio.destination);
				sourceJs.onaudioprocess = (e) ->
					array = new Uint8Array(analyser.frequencyBinCount);
					analyser.getByteFrequencyData(array);
				source.start(0)
				return
			);

Finally, send the request which begins the flow that ends with the source.start function being called.

	request.send()
