

// Nov 11 works as a series of functions
// will not work as a class or chubgraphs because of issues with
// blackhole routing out of the class


// add panning and reverb 
// reverb = for sparse textures 

// expand on presets of modal bar and voice form 


Envelope e;

Echo ech[2];

SinOsc s => Gain initScale => Gain sGain => e;
PulseOsc p => Gain initScale2 => Gain pGain => e;
ModalBar mb => ech[0] => ech[1] => Gain mbFB => Gain mbGain => e;
VoicForm voices[2];

voices[0] => Gain vcGain;
voices[1] => vcGain;

vcGain => ech[0];

0.1 => initScale.gain;
0.025 => initScale2.gain;

mbFB => ech[0];

0.33 => mbFB.gain;

2 => mb.preset;
0.33 => ech[0].mix => ech[1].mix;
3::second => ech[0].max => ech[1].max;
0.1::second => ech[0].delay;
0.05::second => ech[1].delay;


fun void setFreqs(float cons, float baseFreq)
{
    // set the freqs to the pitch tracker base freq
    
    [1,2,3,4,5,6,7,8,9] @=> int freqSet[]; // for consonant 
    
    float randFact;
    
    if (cons == 1)
        1 => randFact; 
        
    if (cons == 0)
        Math.random2f(0.90,1.10) => randFact;
    
    (baseFreq * freqSet[1]) * randFact => s.freq;
    (baseFreq * freqSet[Math.random2(0,5)]) * randFact => p.freq;
    (baseFreq * freqSet[Math.random2(0,5)]) * randFact => mb.freq;
    (baseFreq * freqSet[Math.random2(0,5)]) * randFact => voices[0].freq;
    (baseFreq * freqSet[Math.random2(0,5)]) * randFact => voices[1].freq;
}

JCRev revMain;
Pan2 panMain;


fun void revMix(float mix)
{
    mix => revMain.mix;
}

e => panMain => revMain => dac;

SinOsc lfo1 => blackhole;
SinOsc lfoPan => blackhole;

fun void makePanLFO(float rate, float pos)
{
    rate => lfoPan.freq;
    
    
    if ( pos != 2)
        pos => panMain.pan;
    else
        while (pos == 2)
        {
        lfoPan.last() => panMain.pan;
        
        5::samp => now;
    } 
}
    

fun void makeLFO(float rate)
{
    rate => lfo1.freq;
    
    float gainScale;
    
    1/rate => float invRate;
    
    int sampCount;
    
    while (true)
    {    
        Math.fabs(lfo1.last() * 0.4) => gainScale;
        gainScale => s.gain;
        gainScale => p.gain;
        gainScale * 2 => mb.gain => voices[0].gain => voices[1].gain;
        
        if (sampCount == 48000 * invRate)
            0 => sampCount;
        
        if (sampCount > 24000 * invRate)
          { 0 => sGain.gain;
            0 => pGain.gain;
            1 => mbGain.gain;
          1 => vcGain.gain;}
        else
        {  0 => mbGain.gain;
           0 => vcGain.gain;
        1 => sGain.gain;
        1 => pGain.gain;}

        1::samp => now;
        sampCount++;
       // <<< sampCount >>>; causes crash
    }
    
}


fun void makeEnv(float rate)
{
    while (true)
        
    {   Math.random2f(0.0,1.0) => p.width;
        1 => mb.noteOn;
        1 => voices[0].noteOn => voices[1].noteOn;
        e.keyOn();
        rate::second => now;
        e.keyOff();
        rate::second => now;
    }
}

// update function calls as events according to input from pitch tracker 


fun void calls(int nextone)
{
while (true)
{

spork ~ setFreqs(1,330); // dissonance becomes very clear when time less than or = 5 is used 
spork ~ makePanLFO(2, 2); 
spork ~ revMix(0.1);  
spork ~ makeEnv(0.5);
spork ~ makeLFO(2.5);
nextone::second => now;
}}

spork ~ calls(5);
1::day => now;