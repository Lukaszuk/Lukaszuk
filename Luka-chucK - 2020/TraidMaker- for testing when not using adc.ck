// Useful for testing triad detection with Luka-chucK system
// Triangle wave oscillator plays series of randomly chosen chords, single note at a time


TriOsc t => dac;

fun float pickrand(float rand_array[]) // just a quick shorthand for randomly selecting an array member 
{
    Math.random2(0,rand_array.cap()-1) => int rand_member; 
    rand_array[rand_member] => float rand_result;
    
    return rand_result;
}


fun void triadMaker(float root)
{
    [1.0, 1.25, 1.5,2.0,2.5,3.0,4.0] @=> float R35[];
    
    root * pickrand(R35) => float newRoot;
    
    
    while (true)
    {
        
        newRoot * pickrand(R35) => t.freq;
        
        2::second => now;
        
        newRoot * pickrand(R35) => t.freq;
        
        2::second => now;
        
        newRoot * pickrand(R35) => t.freq;
        
        2::second => now;
        
    }
}


spork ~ triadMaker(98.);
1::day => now;