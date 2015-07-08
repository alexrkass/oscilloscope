var context;
var source, sourceJs;
var analyser;
var buffer;
var url = 'data/music.mp3';
var array = new Array();

try {
        context = new AudioContext();
        console.log("in");
}
catch(e) {
    alert("Web Audio API is not supported in this browser");
}

var request = new XMLHttpRequest();
request.open('GET', url, true);
request.responseType = "arraybuffer";
console.log("still");
request.onload = function() {
    console.log("loaded");
    context.decodeAudioData(
        request.response,
        function(buffer) {
            if(!buffer) {
                // Error decoding file data
                return;
            }
            console.log("in");
            sourceJs = context.createJavaScriptNode(2048);
            sourceJs.buffer = buffer;
            sourceJs.connect(context.destination);
            analyser = context.createAnalyser();
            analyser.smoothingTimeConstant = 0.6;
            analyser.fftSize = 512;

            source = context.createBufferSource();
            source.buffer = buffer;

            source.connect(analyser);
            analyser.connect(sourceJs);
            source.connect(context.destination);

            sourceJs.onaudioprocess = function(e) {
                array = new Uint8Array(analyser.frequencyBinCount);
                analyser.getByteFrequencyData(array);
            };

            source.start(0);
            console.log("here");
        },
        function(error) {
            // Decoding error
        }

    );
};
console.log("Here?");