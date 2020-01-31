// NOV 11 CLOUD INST 
// how to get rid of that ugly burst when turned on
// how to better control the echo/add FB 

// copy and add a second cloud? 

// when things become more dissonant == more activity from second cloud 
// add lfo to make the lower hz cloud more interesting 

//

class Cloudy extends Chubgraph
{
Echo ech[2];
0.5 => ech[0].mix => ech[1].mix;

5::second => ech[0].max => ech[1].max;
0.15::second => ech[0].delay;
0.33::second => ech[1].delay;

fun void delayParams(float dly1, float dly2, float mix, float fb)
{
    dly1::second => ech[0].delay;
    dly2::second => ech[1].delay;

    mix => ech[0].mix => ech[1].mix;

} 

ResonZ rez[15];

CNoise noise;

0.01  => noise.gain;

Gain delayLimit;
0.05 => delayLimit.gain;

Gain masterOut;
0.001 => masterOut.gain;

Gain delayFB;

for (0 => int a; a < rez.cap(); a++)
{
    noise => rez[a] => masterOut => outlet;
    rez[a] => delayLimit => ech[0] => ech[1] => masterOut => outlet;    
    
}


fun void rezParams(float baseFreq, int cons, float stagger,int waitNext)
{
    [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19] @=> int pitchMult[];
    
    float stagger; 
    0.25 => stagger;
    
    while (true)
    {
        for( 0 => int b; b < rez.cap(); b++)
        {
        (baseFreq * pitchMult[b]) * Math.random2(1,4) => float rezFreq;
        
         rezFreq => rez[b].freq;
        Math.random2(50,100) => rez[b].Q;
        
        stagger::second => now;
       }
        
        waitNext::second => now;
    }
    
}

}


SinOsc lfo1 => blackhole;
0.01 => lfo1.freq;

// Cloudy cloud => dac;

Cloudy cloud2 => dac; 


/*
while (true)
{
    Math.fabs(lfo1.last())* 0.33 => cloud.gain;
    Math.fabs(lfo1.last())* 0.33 => cloud2.gain;
    5::samp => now;
}
 */

//cloud.rezParams(550, 1,0.25);
//cloud.delayParams(0.15,0.33, 0.5,0.0);


cloud2.rezParams(55, 1,0.1,5); // choose low base freqs
cloud2.delayParams(0.1,0.5, 0.5,0.0);

1::day => now;
        