// Instrument 2 - is mandolin duo

// Make this instrument dynamic!!!


// cons/diss relationship will come from lIsa play rates and from the mandolin note rate and the notes themselves 

// instrument 3 is LiSa fun void musicalResult(string chord) // works!!! - OCT 4 


// 3 modes - arpeggios, sprawling dyads and long held sustained notes
// LiSa and/or comb for chaotic moments 


fun int pickrand(int rand_array[])
{
    
    Math.random2(0,rand_array.cap()-1) => int rand_member; 
    // make sure to use .cap()-1 b/c .cap() doesn't start at zero but the array does
    rand_array[rand_member] => int rand_result;
    
    return rand_result;
}

Gain mandoGain;
0.8 => mandoGain.gain;
Mandolin mando[2];

0.4 => mando[0].gain => mando[1].gain;

mando[0] => mandoGain;
mando[1] => mandoGain => dac;

mandoGain => LiSa mandoL => dac;

fun void mandoLisa(float duration, float rate, float pos, float rampUp, float rampDown, int biDirect)
{
    duration::second => mandoL.duration;
    rampUp::second => mandoL.duration;
    rampDown::second => mandoL.duration;
    
    (0, rate) => mandoL.rate;
    (1, 5.0) => mandoL.rate;
    (2,0.5) => mandoL.rate;
    pos::second => mandoL.playPos;
    
   /*  if (rec == 1)
         1 => mandoL.record;
     if (rec == 0)
         0 => mandoL.record;
     
     if (play == 1)
         1 => mandoL.play;
     if (play == 0)
         0 => mandoL.play;*/
     
     if (biDirect == 1)
         1 => mandoL.bi;
     if (biDirect == 0)
         0 => mandoL.bi;
}

fun void activeLisa(int onOff)
{
    if (onOff == 1)
        {
        mandoLisa(2.,3.0,0.0,0.5,0.5,1); // these params should be updatable according to activity
        4.0 => mandoL.gain;
        1 => mandoL.record;
        4::second => now;
        0 => mandoL.record;
        (0,1) => mandoL.play;
        (1,1) => mandoL.play;
        (2,1) => mandoL.play;
        (0,1) => mandoL.loop;
        (1,1) => mandoL.loop;
        (2,1) => mandoL.loop;
        1::hour => now;}
    
    if (onOff == 0)
    { // 4. => mandoL.record;
       
        (0,0) => mandoL.loop;
        (1,0) => mandoL.loop;
        (2,0) => mandoL.loop;
        }
    
   /* if (onOff == 2)   // how to keep playing but not record
    {  0 => mandoL.record;
    (0,1) => mandoL.loop;
    (1,1) => mandoL.loop;
    (2,1) => mandoL.loop; */


    
    
}

     
  
fun void pches(float basePitch, int cons)
{
    [1,2,3,4,5,6,7,8,9,10] @=> int pitchScale[];
      
    basePitch * pickrand(pitchScale) => mando[0].freq;
    basePitch * pickrand(pitchScale) => mando[1].freq;
    
    if (cons == 1)
    { mando[0].freq() * Math.random2f(0.5,3.33) => mando[0].freq;        
    mando[0].freq() * Math.random2f(0.5,3.33) => mando[0].freq;
    mando[1].freq() * Math.random2f(0.5,5.33) => mando[1].freq;}
    
}

fun void mando1(float nextNote, float body1, float body2, float pluck1, float pluck2)
{

body1 => mando[0].bodySize;
body2 => mando[1].bodySize;

pluck1 => mando[0].pluckPos;
pluck2 => mando[1].pluckPos;
 
while (true)
{
    1 => mando[0].noteOn;
    1 => mando[1].noteOn;
    
    nextNote::second => now;
}

}

fun void playMode(int mode, int keepLisa)
{
    float nextOne;
    
    [0.1,0.5,0.25] @=> float lengths[];   

while (true) // if LiSa is to be used, the rate => now needs to be > lisa rec+play dur 
{
    int a;
      
    if (a == 3)
        0 =>  a;
    
        if (mode == 0)
        Math.random2(1,2) * lengths[a] => nextOne;
        else if (mode == 1)
        Math.random2(10,50) * lengths[a] => nextOne;
        else if (mode ==2)
        Math.random2(75,180) * lengths[Math.random2(0,2)] => nextOne;
    
spork ~ activeLisa(1);
spork ~ mando1(10,0.1,0.9,0.9,0.9);
spork ~ pches(98,0);
nextOne::second => now;

a++;
    
}
/*
if (keepLisa == 1)
    spork ~ activeLisa(1);
else
    spork ~ activeLisa(0);
*/ // still need to sort out how to turn lisa/on off 

}
    
    
spork ~ playMode(2,0);
1::day => now;
    