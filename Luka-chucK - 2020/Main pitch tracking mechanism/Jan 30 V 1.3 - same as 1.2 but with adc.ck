// Luka-chucK System  - Jan 30 build - Main patch  

// The main diffrence between V1 and V2 is that the triad maker for testing
// is far less varied in terms of triad content in the synth triadMaker func

// This version doesn't have all of the histograms working - it's a very
// rough prototype - what it does is return an analyzed triad from a triad
// maker func consisting of a triangle wave playing broken chords (one note at a time)
// when a triad is analyzed a mandolin-sounding electronic instrument is activated
// playing sounds that are compatible with the audio from the triad maker 


// slight glitch - sometimes an array out of bounds error kills the patch 

2000 => int masterScan;

SinOsc s;

TriOsc t => dac;

0.0 => t.gain;


Gain mandoGain;
0.9 => mandoGain.gain;
Mandolin mando[2];

0.4 => mando[0].gain => mando[1].gain;

mando[0] => mandoGain;
mando[1] => mandoGain => dac;

mandoGain => LiSa mandoL => dac;


fun float pickrand(float rand_array[]) // just a quick shorthand for randomly selecting an array member 
{
    Math.random2(0,rand_array.cap()-1) => int rand_member; 
    rand_array[rand_member] => float rand_result;
    
    return rand_result;
}

fun int pickrandInt(int rand_array[])
{
    
    Math.random2(0,rand_array.cap()-1) => int rand_member; 
    // make sure to use .cap()-1 b/c .cap() doesn't start at zero but the array does
    rand_array[rand_member] => int rand_result;
    
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


//3::second => now; // wait a few sec to get ready 



fun float PITCHEY()
{
    
    spork ~ triadMaker(55.); // replace t with adc and comment out spork later on 
    
    adc => Gain inGain => dac; // create an oscillator
    // PitchTrack must connect to blackhole to run
    inGain => PitchTrack pitch => blackhole;
    float hzhz;
    //0.5 => osc.gain;
    
    while (true)
    {
        // set the oscillator to a random frequency
        // Math.random2f(200,1000) => osc.freq;
        //  <<< "Actual oscillator frequency:",osc.freq(),"Hz" >>>;
        // 250::ms => now; // pass a little time
        // <<< "PitchTrack thinks it's this:",pitch.get(),"Hz" >>>;
        //  <<< "Difference:",Math.fabs(osc.freq() - pitch.get()),"Hz\n" >>>;
        
        pitch.get() => hzhz;
        hzhz => s.freq;
        <<< hzhz >>>;
        
        0.1::second => now; // tracker analyzes input at speed of 100ms 
        
    }
    return hzhz;
}



//2::second => now;

//spork ~ sineHz();


fun int modal(string set[])
{
    int modal;
    
    int matchTest[set.cap()];
    
    for (0 => int a; a < set.cap(); a++)
    {
        string testIt;
        set[a] => testIt;
        int matchNumb;
        
        for (0 => int b; b < set.cap(); b++)
        {
            
            if (testIt == set[b])
                matchNumb++;
            
        }
        
        // <<< matchNumb >>>;
        matchNumb => matchTest[a]; 
    }
    
    int modalResult;
    
    for (0 => int u; u < matchTest.cap()-1; u++)
    {
        if (matchTest[u] <= matchTest[u+1])
            matchTest[u+1] => modalResult;
        //  <<< modalResult, "hi" >>>;
    }
    //  <<< modalResult, "is the modal val" >>>;
    
    
    
    
    return modalResult;
}


fun int histoMode(string pches[], string testFreq)
{
    //   <<< "test", testFreq >>>;
    
    0 => int amount_numb;
    
    for (0 => int f; f < pches.cap(); f++)
    {
        
        if (pches[f] == testFreq)
        {    amount_numb++;}
        //   <<< "test", amount_numb >>>;  // test that the val is working 
    }
    return amount_numb;
    <<< amount_numb >>>;
}


fun int pitchSet(string notes[], string testIt)
{
    
    histoMode(notes, testIt) => int hi;
    
    return hi;
    
}



fun string finalTest(string set[],int modal)
{
    
    int modeyTest;
    
    
    for (0 => int q; q < set.cap(); q++)
    {
        pitchSet(set, set[q]) => modeyTest;
        
        if (modeyTest == modal)
        {  "it's Done!";
        return set[q];}
    }
    
    
}



fun string[] scannerRepeat()
{
    spork ~ testCleanHz();
    
    string triadLog[5];
    
    
    for (0 => int a; a < triadLog.cap(); a++)
    {
        
        if (a == triadLog.cap())
            0 => a; // infinite loop 
        
        takePitches(masterScan) => triadLog[a] ; // ms for scan time 
        
        masterScan * 3 => int nextScan; // * 3 because the takePitches takes 3x the masterScan time to complete
        
        masterScan::ms => now;
        //  testChord(triad) => string triadType;
        
        // return triadType;
        
        
    }
    
    return triadLog;
    
    
}


fun string modeTell(string triadLog[])
{
    while (true)
    {
        modal(triadLog) => int mode;
        
        finalTest(triadLog,mode) => string final;
        
        <<< "modal chord is =" , final >>>;
        
        return final;
        
        30::second => now;
    }
}



/////////////////////// PART 2 HISTOGRAM FUNCS ***///////////////////

fun int histo1(float pches[], float testFreq) // function tells how many times does testFreq occur
{
    
    0 => int amount_numb;
    
    for (0 => int f; f < pches.cap(); f++)
    {
        
        if (pches[f] == testFreq)
        {    amount_numb++;}
        //   <<< "test", amount_numb >>>;  // test that the val is working 
    }
    return amount_numb;
    <<< amount_numb >>>;
}

fun int pitchSet(float notes[], float testIt)
{
    
    histo1(notes, testIt) => int hi;
    
    // <<< hi >>>;
    
    return hi;
    
}


// this func takes frequencies from the pitch tracker and fills them into an array "realHz[]" for testing 
fun float[] sineHz() 
{
    
    
    float realHz[40]; // we'll test 20 values over 0.05'' (the speed inside the loop @ line 135) 
    float cleanHz; 
    
    /*  while (true) // infinite loop can be used to repeatedly run the test 
    {*/
    for (0 => int r; r < 20; r++) // 40 values ovre 0.05 '' =  2 seconds, the master scan time 
    {
        Math.trunc(s.freq()) => realHz[r];  
        
        <<< Math.trunc(s.freq()) >>>;
        
        0.1 ::second => now;
        
    }
    
    <<< "real2 and 9 are ", realHz[2], realHz[9] >>>;
    // return realHz;
    
    //   histoMode(realHz);; // why is it giving 0.0 as the modal val? 
    
    //    <<< "the real Hz is", cleanHz >>>; ///
    
    return realHz;         
    //  }
}

int real;
fun float testCleanHz()
{
    
    float confirmedFreq;
    sineHz() @=> float realHz[];
    
    for ( 0 => int r; r < 5; r ++)
    {
        
        Math.random2(1,25) => int randMember;
        
        pitchSet(realHz, realHz[randMember]) => real; //testing the 10th member of the array 
        
        if (real > 6)
            realHz[randMember] => confirmedFreq;
        
        <<< "Confirmed:", confirmedFreq >>> ;
        
        return confirmedFreq;
        
    }
}

/////////////////////// **** PART 3 ***** TRIAD DETECTOR //////////////////// // stick in for D A F# still being root pos for example 


//Major triads
[["C","E","G"],["D","F#","A"],["E","G#","B"],["F","A","C"],["G","B","D"],["A","C#","E"],["B","D#","F#"]] @=> string rootQuality[][]; // add the rest 

[["C","G","E"],["D","A","F#"],["E","B","G#"],["F","C","A"],["G","D","A"],["A","E","C#"],["B","F#","D#"]] @=> string rootQuality2[][];


[["C#","F","G#"],["D#","G","A#"],["F#","A#","C#"],["G#","C","D#"],["A#","D","E#"]] @=> string rootQualityAccidentals[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 
[["C#","G#","F#"],["D#","A#","G"],["F#","C#","A#"],["G#","D#","C"],["A#","E#","D"]] @=> string rootQualityAccidentals2[][]; 

//////////////**************        Major triads - 1st inv 
[["E","G","C"],["F#","A","D"],["G#","B","E"],["A","C","F"],["B","D","G"],["C#","E","A"],["D#","B","F#"]] @=> string rootQualityInv1[][]; // add the rest 

[["E","C","G"],["F#","D","A"],["G#","E","B"],["A","F","C"],["B","G","D"],["C#","A","E"],["D#","F#","B"]] @=> string rootQuality2Inv1[][];


[["F","G#","C#"],["G","A#","D#"],["A#","C#","F#"],["C","D#","G#"],["D","E#","A#"]] @=> string rootQualityAccidentalsInv1[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 
[["F","C#","G#"],["G","D#","A#"],["A#","F#","C#"],["C","G#","D#"],["E#","A#","E#"]] @=> string rootQualityAccidentals2Inv1[][]; 


//////////////**************        Major triads - 2st inv 
[["G","C","E"],["A","D","F#"],["B","E","G#"],["C","F","A"],["D","G","B"],["E","A","C#"],["F#","B","D#"]] @=> string rootQualityInv2[][]; // add the rest 

[["G","E","C"],["A","F#","D"],["B","G#","E"],["C","A","F"],["D","B","G"],["E","C#","A"],["F#","D#","B"]] @=> string rootQuality2Inv2[][];


[["G#","C#","F"],["A#","D#","G"],["C#","F#","A#"],["D#","G#","C"],["E#","A#","D"]] @=> string rootQualityAccidentalsInv2[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 
[["G#","F#","C#"],["A#","G","D#"],["C#","A#","F#"],["D#","C","G#"],["E#","D","A#"]] @=> string rootQualityAccidentals2Inv2[][]; 

//Minor triads 
[["C","D#","G"],["D","F","A"],["E","G","B"],["F","G#","C"],["G","A#","D"],["A","C","E"],["B","D","F#"]] @=> string rootQualityminor[][]; // add the rest 

[["C","G","D#"],["D","A","F"],["E","B","G"],["F","C","G#"],["G","D","A#"],["A","E","C"],["B","F#","D"]] @=> string rootQualityminor2[][]; // add the rest 



[["C#","E","G#"],["D#","F#","A#"],["F#","A","C#"],["G#","B","D#"],["A#","C#","E#"]] @=> string rootQualityAccidentalsminor[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 
[["C#","G#","E"],["D#","A#","F#"],["F#","C#","A"],["G#","D#","B"],["A#","E#","C#"]] @=> string rootQualityAccidentalsminor2[][]; 


// *********** Minor triads  1st inv 
[["D#","G","C"],["A","D","F"],["B","E","G"],["C","F","G#"],["D","G","A#"],["E","A","C"],["F#","B","D"]] @=> string rootQualityminorInv1[][]; // add the rest 

[["D#","C","G"],["A","F","D"],["B","G","E"],["C","G#","F"],["D","A#","G"],["E","C","A"],["F#","D","B"]] @=> string rootQualityminor2Inv1[][]; // add the rest 



[["E","C#","G#"],["F#","D#","A#"],["A","C#","F#"],["B","G#","D#"],["C#","A#","E#"]] @=> string rootQualityAccidentalsminorInv1[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 
[["E","G#","C#"],["F#","A#","D#"],["A","F#","A"],["B","D#","G#"],["C#","E#","A#"]] @=> string rootQualityAccidentalsminor2Inv1[][]; 


////// **************** Minor triads 2nd inv 
[["G","D#","C"],["A","F","D"],["B","G","E"],["C","G#","F"],["D","A#","G"],["E","C","A"],["F#","D","B"]] @=> string rootQualityminorInv2[][]; // add the rest 

[["C","G","D#"],["A","D","F"],["B","E","G"],["C","F","G#"],["G","D","A#"],["E","A","C"],["F#","B","D"]] @=> string rootQualityminor2Inv2[][]; // add the rest 



[["G#","E","C#"],["A#","F#","D#"],["C#","A","F#"],["D#","B","G#"],["E#","C#","A#"]] @=> string rootQualityAccidentalsminorInv2[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 
[["G#","C#","E"],["A#","D#","F#"],["C#","F#","A"],["D#","G#","B"],["E#","A#","C#"]] @=> string rootQualityAccidentalsminor2Inv2[][]; 


//STOP 3:05


// Diminished Triads
[["C","D#","F#"],["D","F","G#"],["E","G","A#"],["F","G#","B"],["G","A#","C#"],["A","C","D#"],["B","D","F"]] @=> string rootQualitydim[][]; // add the rest 

[["C","F#","D#"],["D","G#","F"],["E","A#","G"],["F","B","G#"],["G","C#","A#"],["A","D#","C"],["B","F","D"]] @=> string rootQualitydim2[][]; // add the rest 


[["C#","E","G"],["D#","F","A"],["F#","A","C"],["G#","B","D"],["A#","C","E"]] @=> string rootQualityAccidentalsdim[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 

[["C#","G","E"],["D#","A","F"],["F#","C","A"],["G#","D","B"],["A#","E","C"]] @=> string rootQualityAccidentalsdim2[][]; 

///** ////////// Diminished Triads 1st inv **** 
[["D#","F#","C"],["F","G#","D"],["G","E","A#"],["G#","F","B"],["A#","G","C#"],["C","A","D#"],["D","B","F"]] @=> string rootQualitydimInv1[][]; // add the rest 

[["D#","F#","C"],["F","D","G#"],["G","E","A#"],["G#","F","B"],["A#","C#","G"],["C","D#","A"],["D","F","B"]] @=> string rootQualitydim2Inv1[][]; // add the rest 


[["E","C#","G"],["F","D#","A"],["A","F#","C"],["B","G#","D"],["C","A#","E"]] @=> string rootQualityAccidentalsdimInv1[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 

[["E","G","C#"],["F","A","D#"],["A","C","F#"],["B","G#","D"],["C","E","A#"]] @=> string rootQualityAccidentalsdim2Inv1[][]; 

///** ////////// Diminished Triads 2st inv **** 
[["F#","D#","C"],["G#","F","D"],["A#","G","E"],["B","G#","F"],["C#","A#","G"],["D#","C","A"],["F","D","B"]] @=> string rootQualitydimInv2[][]; // add the rest 

[["F#","C","D#"],["G#","D","F"],["A#","E","G"],["B","F","G#"],["C#","G","A#"],["D#","A","C"],["F","B","D"]] @=> string rootQualitydim2Inv2[][]; // add the rest 


[["G","E","C#"],["A","F","D#"],["C","A","F#"],["D","B","G#"],["E","C","A#"]] @=> string rootQualityAccidentalsdimInv2[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 

[["G","C#","E"],["A","D#","F"],["C","F#","A"],["D","G#","B"],["E","A#","C"]] @=> string rootQualityAccidentalsdim2Inv2[][]; 

// stop 3:17 

// Augmented Triads
[["C","E","G#"],["D","F#","A#"],["E","G#","C"],["F","A","C#"],["G","B","D#"],["A","C#","F"],["B","D#","G"]] @=> string rootQualityaug[][]; // add the rest 

[["C","G#","E"],["D","A#","F#"],["E","C","G#"],["F","C#","A"],["G","D#","B"],["A","F","C#"],["B","G","D#"]] @=> string rootQualityaug2[][]; // add the rest 


[["C#","F","A"],["D#","G","B"],["F#","A#","D"],["G#","B#","E"],["A#","C#","F#"]] @=> string rootQualityAccidentalsaug[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 

[["C#","A","F"],["D#","B","G"],["F#","D","A#"],["G#","E","B#"],["A#","F#","C#"]] @=> string rootQualityAccidentalsaug2[][]; 


// ***** //// Augmented Triads 1st inv 
[["E","C","G#"],["F#","D#","A#"],["G#","E","C"],["A","F","C#"],["B","G","D#"],["D","A","F"],["G","D#","B"]] @=> string rootQualityaugInv1[][]; // add the rest 

[["E","G#","C"],["F#","A#","D#"],["G#","C","E"],["A","C#","F"],["B","D#","G"],["D","F","A"],["G","B","D#"]] @=> string rootQualityaug2Inv1[][]; // add the rest 


[["F","C#","A"],["G","D#","B"],["A#","F#","D"],["B#","G#","E"],["C#","A#","F#"]] @=> string rootQualityAccidentalsaugInv1[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 

[["F","A","C#"],["G","B","D#"],["A#","D","F#"],["B#","E","G#"],["C#","F#","A#"]] @=> string rootQualityAccidentalsaug2Inv1[][]; 


// stop 3:27 


// ***** **********//// Augmented Triads 2st inv 
[["G#","E","C"],["A#","F#","D"],["C","G#","E"],["C#","A","F"],["D#","B","G"],["F","C#","A"],["G","D#","B"]] @=> string rootQualityaugInv2[][]; // add the rest 

[["G#","C","E"],["A#","D","F#"],["C","E","G#"],["C#","F","A"],["D#","G","B"],["F","A","C#"],["G","B","D#"]] @=> string rootQualityaug2Inv2[][]; // add the rest 


[["A","F","C#"],["B","G","D#"],["D","A#","F#"],["E","B#","G#"],["F#","C#","A#"]] @=> string rootQualityAccidentalsaugInv2[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 

[["A","C#","F"],["B","D#","G"],["D","F#","A#"],["E","G#","B#"],["F#","A#","C#"]] @=> string rootQualityAccidentalsaug2Inv2[][]; 



/// CHORD SYMBOLS 
["Cmaj","Dmaj","Emaj","Fmaj","Gmaj","Amaj","Bmaj"] @=> string chordSymbols[];
["C#maj","D#maj","F#maj","G#maj","A#maj"] @=> string chordSymbolsAccidentals[]; // NB enharmonic equivalence, b = #  

["Cmin","Dmin","Emin","Fmin","Gmin","Amin","Bmin"] @=> string chordSymbolsmin[];
["C#min","D#min","F#min","G#min","A#min"] @=> string chordSymbolsAccidentalsmin[];  // minor 

["Cdim","Ddim","Edim","Fdim","Gdim","Adim","Bdim"] @=> string chordSymbolsdim[];
["C#dim","D#dim","F#dim","G#dim","A#dim"] @=> string chordSymbolsAccidentalsdim[];  // diminished 

["Caug","Daug","Eaug","Faug","Gaug","Aaug","Baug"] @=> string chordSymbolsaug[];
["C#aug","D#aug","F#aug","G#aug","A#aug"] @=> string chordSymbolsAccidentalsaug[];  // augmented 


//First Inversion  

["Cmaj/E","Dmaj/F#","Emaj/G#","Fmaj/A","Gmaj/B","Amaj/C#","Bmaj/D#"] @=> string chordSymbols1inv[];
["C#maj/E#","D#maj/Fx","F#maj/A#","G#maj/B#","A#maj/Cx"] @=> string chordSymbolsAccidentals1inv[]; // NB enharmonic equivalence, b = #  

["Cmin/Eb","Dmin/F","Emin/G","Fmin/Ab","Gmin/Bb","Amin/C","Bmin/D"] @=> string chordSymbolsmin1inv[];
["C#min/E","D#min/F#","F#min/A","G#min/B","A#min/C#"] @=> string chordSymbolsAccidentalsmin1inv[];  // minor 

["Cdim/Eb","Ddim/F","Edim/G","Fdim/Ab","Gdim/Bb","Adim/C","Bdim/D"] @=> string chordSymbolsdim1inv[];
["C#dim/E","D#dim/F#","F#dim/A","G#dim/B","A#dim/C#"] @=> string chordSymbolsAccidentalsdim1inv[];  // diminished 

["Caug/E","Daug/F#","Eaug/G#","Faug/A","Gaug/B","Aaug/C#","Baug/D#"] @=> string chordSymbolsaug1inv[];
["C#aug/Gx","D#aug/Ax","F#aug/Cx","G#aug/Dx","A#aug/Ex"] @=> string chordSymbolsAccidentalsaug1inv[];  // augmented 

// Second Inversion

["Cmaj/G","Dmaj/A","Emaj/B","Fmaj/C","Gmaj/D","Amaj/E","Bmaj/F#"] @=> string chordSymbols2inv[];
["C#maj/G#","D#maj/A#","F#maj/C#","G#maj/D#","A#maj/E#"] @=> string chordSymbolsAccidentals2inv[]; // NB enharmonic equivalence, b = #  

["Cmin/G","Dmin/A","Emin/B","Fmin/C","Gmin/D","Amin/E","Bmin/F#"] @=> string chordSymbolsmin2inv[];
["C#min/G#","D#min/A#","F#min/C#","G#min/D#","A#min/E#"] @=> string chordSymbolsAccidentalsmin2inv[];  // minor 

["Cdim/Gb","Ddim/Ab","Edim/Bb","Fdim/Cb","Gdim/Db","Adim/Eb","Bdim/F"] @=> string chordSymbolsdim2inv[];
["C#dim/G","D#dim/A","F#dim/C","G#dim/D","A#dim/E"] @=> string chordSymbolsAccidentalsdim2inv[];  // diminished 

["Caug/G#","Daug/A#","Eaug/B#","Faug/C#","Gaug/D#","Aaug/E#","Baug/Fx"] @=> string chordSymbolsaug2inv[];
["C#aug/Gx","D#aug/Ax","F#aug/Cx","G#aug/Dx","A#aug/Ex"] @=> string chordSymbolsAccidentalsaug2inv[];  // augmented 

// testChord function mainly used to return a root/quality chord symbol 

fun string testChord(string pitches[])
{
    for (0 => int q; q < pitches.cap(); q++) // what's the purpose of the outer loop?
    {
        for (0 => int h; h < 3; h++)
        {
            
            /// the h+ 1 h+2 h+3 etc allows you to index to next triad in the multiple dimensional array
            //MAJOR
            if (pitches[h] == rootQuality[0][h] || pitches[h] == rootQuality2[0][h])
            {  <<< "Cmaj" >>>; 
            return chordSymbols[0] ;}
            
            else if (pitches[h] == rootQuality[1][h] || pitches[h] == rootQuality2[1][h]) // Dmaj
            {     <<< "Dmaj" >>>;
            return chordSymbols[1];}
            
            else if (pitches[h] == rootQuality[2][h] || pitches[h] == rootQuality2[2][h]) // Emaj
            {  <<< "Emaj" >>>;
            return chordSymbols[2];}
            else if (pitches[h] == rootQuality[3][h] || pitches[h] == rootQuality2[3][h]) // Dmaj
            { <<< "Fmaj" >>>;
            return chordSymbols[3];}
            else if (pitches[h] == rootQuality[4][h] || pitches[h] == rootQuality2[4][h]) // Emaj
            {<<< "Gmaj" >>>;
            return chordSymbols[4];}
            else if (pitches[h] == rootQuality[5][h] || pitches[h] == rootQuality2[5][h]) // Emaj
            {<<< "Amaj" >>>;
            return chordSymbols[5];}
            else if (pitches[h] == rootQuality[6][h] || pitches[h] == rootQuality2[6][h]) // Emaj
            {<<< "Bmaj" >>>;
            return chordSymbols[6];}
            
            
            if (pitches[h] == rootQualityAccidentals[0][h] || pitches[h] == rootQualityAccidentals2[0][h])
            {  <<< "C#maj" >>>; 
            return chordSymbolsAccidentals[0] ;}
            
            else if (pitches[h] == rootQualityAccidentals[1][h] || pitches[h] == rootQualityAccidentals2[1][h]) // Dmaj
            {     <<< "D#maj" >>>;
            return chordSymbolsAccidentals[1];}
            else if (pitches[h] == rootQualityAccidentals[2][h] || pitches[h] == rootQualityAccidentals2[2][h]) // Emaj
            {  <<< "F#maj" >>>;
            return chordSymbolsAccidentals[2];}
            else if (pitches[h] == rootQualityAccidentals[3][h] || pitches[h] == rootQualityAccidentals2[4][h]) // Emaj
            {<<< "G#maj" >>>;
            return chordSymbolsAccidentals[3];}
            else if (pitches[h] == rootQualityAccidentals[4][h] || pitches[h] == rootQualityAccidentals2[5][h]) // Emaj
            {<<< "A#maj" >>>;
            return chordSymbolsAccidentals[4];}
            //!
            
            
            //Major 1st inv 
            if (pitches[h] == rootQualityInv1[0][h] || pitches[h] == rootQuality2Inv1[0][h])
            {  <<< "Cmaj/E" >>>; 
            return chordSymbols1inv[0] ;}
            
            else if (pitches[h] == rootQualityInv1[1][h] || pitches[h] == rootQuality2Inv1[1][h]) // Dmaj
            {     <<< "Dmaj/F#" >>>;
            return chordSymbols1inv[1];}
            
            else if (pitches[h] == rootQualityInv1[2][h] || pitches[h] == rootQuality2Inv1[2][h]) // Emaj
            {  <<< "Emaj/G#" >>>;
            return chordSymbols1inv[2];}
            else if (pitches[h] == rootQualityInv1[3][h] || pitches[h] == rootQuality2Inv1[3][h]) // Dmaj
            { <<< "Fmaj/A" >>>;
            return chordSymbols1inv[3];}
            else if (pitches[h] == rootQualityInv1[4][h] || pitches[h] == rootQuality2Inv1[4][h]) // Emaj
            {<<< "Gmaj/B" >>>;
            return chordSymbols1inv[4];}
            else if (pitches[h] == rootQualityInv1[5][h] || pitches[h] == rootQuality2Inv1[5][h]) // Emaj
            {<<< "Amaj/C#" >>>;
            return chordSymbols1inv[5];}
            else if (pitches[h] == rootQualityInv1[6][h] || pitches[h] == rootQuality2Inv1[6][h]) // Emaj
            {<<< "Bmaj/D#" >>>;
            return chordSymbols1inv[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsInv1[0][h] || pitches[h] == rootQualityAccidentals2Inv1[0][h])
            {  <<< "C#maj/E#" >>>; 
            return chordSymbolsAccidentals1inv[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsInv1[1][h] || pitches[h] == rootQualityAccidentals2Inv1[1][h]) // Dmaj
            {     <<< "D#maj/Fx" >>>;
            return chordSymbolsAccidentals1inv[1];}
            else if (pitches[h] == rootQualityAccidentalsInv1[2][h] || pitches[h] == rootQualityAccidentals2Inv1[2][h]) // Emaj
            {  <<< "F#maj/A#" >>>;
            return chordSymbolsAccidentals1inv[2];}
            else if (pitches[h] == rootQualityAccidentalsInv1[3][h] || pitches[h] == rootQualityAccidentals2Inv1[4][h]) // Emaj
            {<<< "G#maj/B#" >>>;
            return chordSymbolsAccidentals1inv[3];}
            else if (pitches[h] == rootQualityAccidentalsInv1[4][h] || pitches[h] == rootQualityAccidentals2Inv1[5][h]) // Emaj
            {<<< "A#maj/Cx" >>>;
            return chordSymbolsAccidentals1inv[4];}
            
            
            
            //Major 2nd inv 
            if (pitches[h] == rootQualityInv2[0][h] || pitches[h] == rootQuality2Inv2[0][h])
            {  <<< "Cmaj/G" >>>; 
            return chordSymbols2inv[0] ;}
            
            else if (pitches[h] == rootQualityInv2[1][h] || pitches[h] == rootQuality2Inv2[1][h]) // Dmaj
            {     <<< "Dmaj/A" >>>;
            return chordSymbols2inv[1];}
            
            else if (pitches[h] == rootQualityInv2[2][h] || pitches[h] == rootQuality2Inv2[2][h]) // Emaj
            {  <<< "Emaj/B" >>>;
            return chordSymbols2inv[2];}
            else if (pitches[h] == rootQualityInv2[3][h] || pitches[h] == rootQuality2Inv2[3][h]) // Dmaj
            { <<< "Fmaj/C" >>>;
            return chordSymbols2inv[3];}
            else if (pitches[h] == rootQualityInv2[4][h] || pitches[h] == rootQuality2Inv2[4][h]) // Emaj
            {<<< "Gmaj/D" >>>;
            return chordSymbols2inv[4];}
            else if (pitches[h] == rootQualityInv2[5][h] || pitches[h] == rootQuality2Inv2[5][h]) // Emaj
            {<<< "Amaj/E" >>>;
            return chordSymbols2inv[5];}
            else if (pitches[h] == rootQualityInv2[6][h] || pitches[h] == rootQuality2Inv2[6][h]) // Emaj
            {<<< "Bmaj/F#" >>>;
            return chordSymbols2inv[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsInv2[0][h] || pitches[h] == rootQualityAccidentals2Inv2[0][h])
            {  <<< "C#maj/G#" >>>; 
            return chordSymbolsAccidentals2inv[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsInv2[1][h] || pitches[h] == rootQualityAccidentals2Inv2[1][h]) // Dmaj
            {     <<< "D#maj/A#" >>>;
            return chordSymbolsAccidentals2inv[1];}
            else if (pitches[h] == rootQualityAccidentalsInv2[2][h] || pitches[h] == rootQualityAccidentals2Inv2[2][h]) // Emaj
            {  <<< "F#maj/C#" >>>;
            return chordSymbolsAccidentals2inv[2];}
            else if (pitches[h] == rootQualityAccidentalsInv2[3][h] || pitches[h] == rootQualityAccidentals2Inv2[4][h]) // Emaj
            {<<< "G#maj/D#" >>>;
            return chordSymbolsAccidentals2inv[3];}
            else if (pitches[h] == rootQualityAccidentalsInv2[4][h] || pitches[h] == rootQualityAccidentals2Inv2[5][h]) // Emaj
            {<<< "A#maj/E#" >>>;
            return chordSymbolsAccidentals2inv[4];}
            
            
            
            //MINOR
            if (pitches[h] == rootQualityminor[0][h] || pitches[h] == rootQualityminor2[0][h])
            {  <<< "Cmin" >>>; 
            return chordSymbolsmin[0] ;}
            
            else if (pitches[h] == rootQualityminor[1][h] || pitches[h] == rootQualityminor2[1][h]) // Dmaj
            {     <<< "Dmin" >>>;
            return chordSymbolsmin[1];}
            
            else if (pitches[h] == rootQualityminor[2][h] || pitches[h] == rootQualityminor2[2][h]) // Emaj
            {  <<< "Emin" >>>;
            return chordSymbolsmin[2];}
            else if (pitches[h] == rootQualityminor[3][h] || pitches[h] == rootQualityminor2[3][h]) // Dmaj
            { <<< "Fmin" >>>;
            return chordSymbolsmin[3];}
            else if (pitches[h] == rootQualityminor[4][h] || pitches[h] == rootQualityminor2[4][h]) // Emaj
            {<<< "Gmin" >>>;
            return chordSymbolsmin[4];}
            else if (pitches[h] == rootQualityminor[5][h] || pitches[h] == rootQualityminor2[5][h]) // Emaj
            {<<< "Amin" >>>;
            return chordSymbolsmin[5];}
            else if (pitches[h] == rootQualityminor[6][h] || pitches[h] == rootQualityminor2[6][h]) // Emaj
            {<<< "Bmin" >>>;
            return chordSymbolsmin[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsminor[0][h] || pitches[h] == rootQualityAccidentalsminor2[0][h])
            {  <<< "C#min" >>>; 
            return chordSymbolsAccidentalsmin[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsminor[1][h] || pitches[h] == rootQualityAccidentalsminor2[1][h]) // Dmaj
            {     <<< "D#min" >>>;
            return chordSymbolsAccidentalsmin[1];}
            else if (pitches[h] == rootQualityAccidentalsminor[2][h] || pitches[h] == rootQualityAccidentalsminor2[2][h]) // Emaj
            {  <<< "F#min" >>>;
            return chordSymbolsAccidentalsmin[2];}
            else if (pitches[h] == rootQualityAccidentalsminor[3][h] || pitches[h] == rootQualityAccidentalsminor2[3][h]) // Emaj
            {<<< "G#min" >>>;
            return chordSymbolsAccidentalsmin[3];}
            else if (pitches[h] == rootQualityAccidentalsminor[4][h] || pitches[h] == rootQualityAccidentalsminor2[4][h]) // Emaj
            {<<< "A#min" >>>;
            return chordSymbolsAccidentalsmin[4];}
            
            //(
            
            //MINOR first inv 
            if (pitches[h] == rootQualityminorInv1[0][h] || pitches[h] == rootQualityminor2Inv1[0][h])
            {  <<< "Cmin/Eb" >>>; 
            return chordSymbolsmin1inv[0] ;}
            
            else if (pitches[h] == rootQualityminorInv1[1][h] || pitches[h] == rootQualityminor2Inv1[1][h]) // Dmaj
            {     <<< "Dmin/F" >>>;
            return chordSymbolsmin1inv[1];}
            
            else if (pitches[h] == rootQualityminorInv1[2][h] || pitches[h] == rootQualityminor2Inv1[2][h]) // Emaj
            {  <<< "Emin/G" >>>;
            return chordSymbolsmin1inv[2];}
            else if (pitches[h] == rootQualityminorInv1[3][h] || pitches[h] == rootQualityminor2Inv1[3][h]) // Dmaj
            { <<< "Fmin/Ab" >>>;
            return chordSymbolsmin1inv[3];}
            else if (pitches[h] == rootQualityminorInv1[4][h] || pitches[h] == rootQualityminor2Inv1[4][h]) // Emaj
            {<<< "Gmin/B" >>>;
            return chordSymbolsmin1inv[4];}
            else if (pitches[h] == rootQualityminorInv1[5][h] || pitches[h] == rootQualityminor2Inv1[5][h]) // Emaj
            {<<< "Amin/C" >>>;
            return chordSymbolsmin1inv[5];}
            else if (pitches[h] == rootQualityminorInv1[6][h] || pitches[h] == rootQualityminor2Inv1[6][h]) // Emaj
            {<<< "Bmin/D#" >>>;
            return chordSymbolsmin1inv[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsminorInv1[0][h] || pitches[h] == rootQualityAccidentalsminor2Inv1[0][h])
            {  <<< "C#min/E" >>>; 
            return chordSymbolsAccidentalsmin1inv[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsminorInv1[1][h] || pitches[h] == rootQualityAccidentalsminor2Inv1[1][h]) // Dmaj
            {     <<< "D#min/F#" >>>;
            return chordSymbolsAccidentalsmin1inv[1];}
            else if (pitches[h] == rootQualityAccidentalsminorInv1[2][h] || pitches[h] == rootQualityAccidentalsminor2Inv1[2][h]) // Emaj
            {  <<< "F#min/A" >>>;
            return chordSymbolsAccidentalsmin1inv[2];}
            else if (pitches[h] == rootQualityAccidentalsminorInv1[3][h] || pitches[h] == rootQualityAccidentalsminor2Inv1[3][h]) // Emaj
            {<<< "G#min/B" >>>;
            return chordSymbolsAccidentalsmin1inv[3];}
            else if (pitches[h] == rootQualityAccidentalsminorInv1[4][h] || pitches[h] == rootQualityAccidentalsminor2Inv1[4][h]) // Emaj
            {<<< "A#min/C#" >>>;
            return chordSymbolsAccidentalsmin1inv[4];}
            
            // & 2ND
            //MINOR second  inv 
            //3:59 
            if (pitches[h] == rootQualityminorInv2[0][h] || pitches[h] == rootQualityminor2Inv2[0][h])
            {  <<< "Cmin/G" >>>; 
            return chordSymbolsmin2inv[0] ;}
            
            else if (pitches[h] == rootQualityminorInv2[1][h] || pitches[h] == rootQualityminor2Inv2[1][h]) // Dmaj
            {     <<< "Dmin/A" >>>;
            return chordSymbolsmin2inv[1];}
            
            else if (pitches[h] == rootQualityminorInv2[2][h] || pitches[h] == rootQualityminor2Inv2[2][h]) // Emaj
            {  <<< "Emin/B" >>>;
            return chordSymbolsmin2inv[2];}
            else if (pitches[h] == rootQualityminorInv2[3][h] || pitches[h] == rootQualityminor2Inv2[3][h]) // Dmaj
            { <<< "Fmin/C" >>>;
            return chordSymbolsmin2inv[3];}
            else if (pitches[h] == rootQualityminorInv2[4][h] || pitches[h] == rootQualityminor2Inv2[4][h]) // Emaj
            {<<< "Gmin/D" >>>;
            return chordSymbolsmin2inv[4];}
            else if (pitches[h] == rootQualityminorInv2[5][h] || pitches[h] == rootQualityminor2Inv2[5][h]) // Emaj
            {<<< "Amin/E" >>>;
            return chordSymbolsmin2inv[5];}
            else if (pitches[h] == rootQualityminorInv2[6][h] || pitches[h] == rootQualityminor2Inv2[6][h]) // Emaj
            {<<< "Bmin/F#" >>>;
            return chordSymbolsmin2inv[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsminorInv2[0][h] || pitches[h] == rootQualityAccidentalsminor2Inv2[0][h])
            {  <<< "C#min/G#" >>>; 
            return chordSymbolsAccidentalsmin2inv[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsminorInv2[1][h] || pitches[h] == rootQualityAccidentalsminor2Inv2[1][h]) // Dmaj
            {     <<< "D#min/A#" >>>;
            return chordSymbolsAccidentalsmin2inv[1];}
            else if (pitches[h] == rootQualityAccidentalsminorInv2[2][h] || pitches[h] == rootQualityAccidentalsminor2Inv2[2][h]) // Emaj
            {  <<< "F#min/C#" >>>;
            return chordSymbolsAccidentalsmin2inv[2];}
            else if (pitches[h] == rootQualityAccidentalsminorInv2[3][h] || pitches[h] == rootQualityAccidentalsminor2Inv2[3][h]) // Emaj
            {<<< "G#min/D#" >>>;
            return chordSymbolsAccidentalsmin2inv[3];}
            else if (pitches[h] == rootQualityAccidentalsminorInv2[4][h] || pitches[h] == rootQualityAccidentalsminor2Inv2[4][h]) // Emaj
            {<<< "A#min/E#" >>>;
            return chordSymbolsAccidentalsmin2inv[4];}
            
            
            
            // &^%$
            //4:05 pm stop dimiinished
            
            
            //DIMINISHED
            if (pitches[h] == rootQualitydim[0][h] || pitches[h] == rootQualitydim2[0][h])
            {  <<< "Cdim" >>>; 
            return chordSymbolsdim[0] ;}
            
            else if (pitches[h] == rootQualitydim[1][h] || pitches[h] == rootQualitydim2[1][h]) // Dmaj
            {     <<< "Ddim" >>>;
            return chordSymbolsdim[1];}
            
            else if (pitches[h] == rootQualitydim[2][h] || pitches[h] == rootQualitydim2[2][h]) // Emaj
            {  <<< "Edim" >>>;
            return chordSymbolsdim[2];}
            else if (pitches[h] == rootQualitydim[3][h] || pitches[h] == rootQualitydim2[3][h]) // Dmaj
            { <<< "Fdim" >>>;
            return chordSymbolsdim[3];}
            else if (pitches[h] == rootQualitydim[4][h] || pitches[h] == rootQualitydim2[4][h]) // Emaj
            {<<< "Gdim" >>>;
            return chordSymbolsdim[4];}
            else if (pitches[h] == rootQualitydim[5][h] || pitches[h] == rootQualitydim2[5][h]) // Emaj
            {<<< "Adim" >>>;
            return chordSymbolsdim[5];}
            else if (pitches[h] == rootQualitydim[6][h] || pitches[h] == rootQualitydim2[6][h]) // Emaj
            {<<< "Bdim" >>>;
            return chordSymbolsdim[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsdim[0][h] || pitches[h] == rootQualityAccidentalsdim2[0][h])
            {  <<< "C#dim" >>>; 
            return chordSymbolsAccidentalsdim[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsdim[1][h] || pitches[h] == rootQualityAccidentalsdim2[1][h]) // Dmaj
            {     <<< "D#dim" >>>;
            return chordSymbolsAccidentalsdim[1];}
            else if (pitches[h] == rootQualityAccidentalsdim[2][h] || pitches[h] == rootQualityAccidentalsdim2[2][h]) // Emaj
            {  <<< "F#dim" >>>;
            return chordSymbolsAccidentalsdim[2];}
            else if (pitches[h] == rootQualityAccidentalsdim[3][h] || pitches[h] == rootQualityAccidentalsdim2[3][h]) // Emaj
            {<<< "G#dim" >>>;
            return chordSymbolsAccidentalsdim[3];}
            else if (pitches[h] == rootQualityAccidentalsdim[4][h] || pitches[h] == rootQualityAccidentalsdim2[4][h]) // Emaj
            {<<< "A#dim" >>>;
            return chordSymbolsAccidentalsdim[4];}
            
            
            
            
            //first inv dim 
            if (pitches[h] == rootQualitydimInv1[0][h] || pitches[h] == rootQualitydim2Inv1[0][h])
            {  <<< "Cdim/Eb" >>>; 
            return chordSymbolsdim1inv[0] ;}
            
            else if (pitches[h] == rootQualitydimInv1[1][h] || pitches[h] == rootQualitydim2Inv1[1][h]) // Dmaj
            {     <<< "Ddim/F" >>>;
            return chordSymbolsdim1inv[1];}
            
            else if (pitches[h] == rootQualitydimInv1[2][h] || pitches[h] == rootQualitydim2Inv1[2][h]) // Emaj
            {  <<< "Edim/G" >>>;
            return chordSymbolsdim1inv[2];}
            else if (pitches[h] == rootQualitydimInv1[3][h] || pitches[h] == rootQualitydim2Inv1[3][h]) // Dmaj
            { <<< "Fdim/Ab" >>>;
            return chordSymbolsdim1inv[3];}
            else if (pitches[h] == rootQualitydimInv1[4][h] || pitches[h] == rootQualitydim2Inv1[4][h]) // Emaj
            {<<< "Gdim/B" >>>;
            return chordSymbolsdim1inv[4];}
            else if (pitches[h] == rootQualitydimInv1[5][h] || pitches[h] == rootQualitydim2Inv1[5][h]) // Emaj
            {<<< "Adim/C" >>>;
            return chordSymbolsdim1inv[5];}
            else if (pitches[h] == rootQualitydimInv1[6][h] || pitches[h] == rootQualitydim2Inv1[6][h]) // Emaj
            {<<< "Bdim/D" >>>;
            return chordSymbolsdim1inv[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsdimInv1[0][h] || pitches[h] == rootQualityAccidentalsdim2Inv1[0][h])
            {  <<< "C#dim/E" >>>; 
            return chordSymbolsAccidentalsdim1inv[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsdimInv1[1][h] || pitches[h] == rootQualityAccidentalsdim2Inv1[1][h]) // Dmaj
            {     <<< "D#dim/F#" >>>;
            return chordSymbolsAccidentalsdim1inv[1];}
            else if (pitches[h] == rootQualityAccidentalsdimInv1[2][h] || pitches[h] == rootQualityAccidentalsdim2Inv1[2][h]) // Emaj
            {  <<< "F#dim/A" >>>;
            return chordSymbolsAccidentalsdim1inv[2];}
            else if (pitches[h] == rootQualityAccidentalsdimInv1[3][h] || pitches[h] == rootQualityAccidentalsdim2Inv1[3][h]) // Emaj
            {<<< "G#dim/B" >>>;
            return chordSymbolsAccidentalsdim1inv[3];}
            else if (pitches[h] == rootQualityAccidentalsdimInv1[4][h] || pitches[h] == rootQualityAccidentalsdim2Inv1[4][h]) // Emaj
            {<<< "A#dim/C#" >>>;
            return chordSymbolsAccidentalsdim1inv[4];}
            
            
            //2ND inv dim 
            if (pitches[h] == rootQualitydimInv2[0][h] || pitches[h] == rootQualitydim2Inv2[0][h])
            {  <<< "Cdim/Gb" >>>; 
            return chordSymbolsdim2inv[0] ;}
            
            else if (pitches[h] == rootQualitydimInv2[1][h] || pitches[h] == rootQualitydim2Inv2[1][h]) // Dmaj
            {     <<< "Ddim/Ab" >>>;
            return chordSymbolsdim2inv[1];}
            
            else if (pitches[h] == rootQualitydimInv2[2][h] || pitches[h] == rootQualitydim2Inv2[2][h]) // Emaj
            {  <<< "Edim/Bb" >>>;
            return chordSymbolsdim2inv[2];}
            else if (pitches[h] == rootQualitydimInv2[3][h] || pitches[h] == rootQualitydim2Inv2[3][h]) // Dmaj
            { <<< "Fdim/Cb" >>>;
            return chordSymbolsdim2inv[3];}
            else if (pitches[h] == rootQualitydimInv2[4][h] || pitches[h] == rootQualitydim2Inv2[4][h]) // Emaj
            {<<< "Gdim/Db" >>>;
            return chordSymbolsdim2inv[4];}
            else if (pitches[h] == rootQualitydimInv2[5][h] || pitches[h] == rootQualitydim2Inv2[5][h]) // Emaj
            {<<< "Adim/Eb" >>>;
            return chordSymbolsdim2inv[5];}
            else if (pitches[h] == rootQualitydimInv2[6][h] || pitches[h] == rootQualitydim2Inv2[6][h]) // Emaj
            {<<< "Bdim/F" >>>;
            return chordSymbolsdim2inv[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsdimInv2[0][h] || pitches[h] == rootQualityAccidentalsdim2Inv2[0][h])
            {  <<< "C#dim/G" >>>; 
            return chordSymbolsAccidentalsdim2inv[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsdimInv2[1][h] || pitches[h] == rootQualityAccidentalsdim2Inv2[1][h]) // Dmaj
            {     <<< "D#dim/A" >>>;
            return chordSymbolsAccidentalsdim2inv[1];}
            else if (pitches[h] == rootQualityAccidentalsdimInv2[2][h] || pitches[h] == rootQualityAccidentalsdim2Inv2[2][h]) // Emaj
            {  <<< "F#dim/C" >>>;
            return chordSymbolsAccidentalsdim2inv[2];}
            else if (pitches[h] == rootQualityAccidentalsdimInv2[3][h] || pitches[h] == rootQualityAccidentalsdim2Inv2[3][h]) // Emaj
            {<<< "G#dim/D" >>>;
            return chordSymbolsAccidentalsdim2inv[3];}
            else if (pitches[h] == rootQualityAccidentalsdimInv2[4][h] || pitches[h] == rootQualityAccidentalsdim2Inv2[4][h]) // Emaj
            {<<< "A#dim/E" >>>;
            return chordSymbolsAccidentalsdim2inv[4];}
            
            
            
            //Augmented
            if (pitches[h] == rootQualityaug[0][h] || pitches[h] == rootQualityaug2[0][h])
            {  <<< "Caug" >>>; 
            return chordSymbolsaug[0] ;}
            
            else if (pitches[h] == rootQualityaug[1][h] || pitches[h] == rootQualityaug2[1][h]) // Dmaj
            {     <<< "Daug" >>>;
            return chordSymbolsaug[1];}
            
            else if (pitches[h] == rootQualityaug[2][h] || pitches[h] == rootQualityaug2[2][h]) // Emaj
            {  <<< "Eaug" >>>;
            return chordSymbolsaug[2];}
            else if (pitches[h] == rootQualityaug[3][h] || pitches[h] == rootQualityaug2[3][h]) // Dmaj
            { <<< "Faug" >>>;
            return chordSymbolsaug[3];}
            else if (pitches[h] == rootQualityaug[4][h] || pitches[h] == rootQualityaug2[4][h]) // Emaj
            {<<< "Gaug" >>>;
            return chordSymbolsaug[4];}
            else if (pitches[h] == rootQualityaug[5][h] || pitches[h] == rootQualityaug2[5][h]) // Emaj
            {<<< "Aaug" >>>;
            return chordSymbolsaug[5];}
            else if (pitches[h] == rootQualityaug[6][h] || pitches[h] == rootQualityaug2[6][h]) // Emaj
            {<<< "Baug" >>>;
            return chordSymbolsaug[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsaug[0][h] || pitches[h] == rootQualityAccidentalsaug2[0][h])
            {  <<< "C#aug" >>>; 
            return chordSymbolsAccidentalsaug[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsaug[1][h] || pitches[h] == rootQualityAccidentalsaug2[1][h]) // Dmaj
            {     <<< "D#aug" >>>;
            return chordSymbolsAccidentalsaug[1];}
            else if (pitches[h] == rootQualityAccidentalsaug[2][h] || pitches[h] == rootQualityAccidentalsaug2[2][h]) // Emaj
            {  <<< "F#aug" >>>;
            return chordSymbolsAccidentalsaug[2];}
            else if (pitches[h] == rootQualityAccidentalsaug[3][h] || pitches[h] == rootQualityAccidentalsaug2[3][h]) // Emaj
            {<<< "G#aug" >>>;
            return chordSymbolsAccidentalsaug[3];}
            else if (pitches[h] == rootQualityAccidentalsaug[4][h] || pitches[h] == rootQualityAccidentalsaug2[4][h]) // Emaj
            {<<< "A#aug" >>>;
            return chordSymbolsAccidentalsaug[4];}
            
            //
            //Augmented 1ST Inv
            if (pitches[h] == rootQualityaugInv1[0][h] || pitches[h] == rootQualityaug2Inv1[0][h])
            {  <<< "Caug/E" >>>; 
            return chordSymbolsaug1inv[0] ;}
            
            else if (pitches[h] == rootQualityaugInv1[1][h] || pitches[h] == rootQualityaug2Inv1[1][h]) // Dmaj
            {     <<< "Daug/F#" >>>;
            return chordSymbolsaug1inv[1];}
            
            else if (pitches[h] == rootQualityaugInv1[2][h] || pitches[h] == rootQualityaug2Inv1[2][h]) // Emaj
            {  <<< "Eaug/G#" >>>;
            return chordSymbolsaug1inv[2];}
            else if (pitches[h] == rootQualityaugInv1[3][h] || pitches[h] == rootQualityaug2Inv1[3][h]) // Dmaj
            { <<< "Faug/A" >>>;
            return chordSymbolsaug1inv[3];}
            else if (pitches[h] == rootQualityaugInv1[4][h] || pitches[h] == rootQualityaug2Inv1[4][h]) // Emaj
            {<<< "Gaug/B" >>>;
            return chordSymbolsaug1inv[4];}
            else if (pitches[h] == rootQualityaugInv1[5][h] || pitches[h] == rootQualityaug2Inv1[5][h]) // Emaj
            {<<< "Aaug/C#" >>>;
            return chordSymbolsaug1inv[5];}
            else if (pitches[h] == rootQualityaugInv1[6][h] || pitches[h] == rootQualityaug2Inv1[6][h]) // Emaj
            {<<< "Baug/D#" >>>;
            return chordSymbolsaug1inv[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsaugInv1[0][h] || pitches[h] == rootQualityAccidentalsaug2Inv1[0][h])
            {  <<< "C#aug/E#" >>>; 
            return chordSymbolsAccidentalsaug1inv[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsaugInv1[1][h] || pitches[h] == rootQualityAccidentalsaug2Inv1[1][h]) // Dmaj
            {     <<< "D#aug/Fx" >>>;
            return chordSymbolsAccidentalsaug1inv[1];}
            else if (pitches[h] == rootQualityAccidentalsaugInv1[2][h] || pitches[h] == rootQualityAccidentalsaug2Inv1[2][h]) // Emaj
            {  <<< "F#aug/A#" >>>;
            return chordSymbolsAccidentalsaug1inv[2];}
            else if (pitches[h] == rootQualityAccidentalsaugInv1[3][h] || pitches[h] == rootQualityAccidentalsaug2Inv1[3][h]) // Emaj
            {<<< "G#aug/B#" >>>;
            return chordSymbolsAccidentalsaug1inv[3];}
            else if (pitches[h] == rootQualityAccidentalsaugInv1[4][h] || pitches[h] == rootQualityAccidentalsaug2Inv1[4][h]) // Emaj
            {<<< "A#aug/Cx" >>>;
            return chordSymbolsAccidentalsaug1inv[4];}
            //
            
            
            //Augmented 2nd Inv - 
            if (pitches[h] == rootQualityaugInv2[0][h] || pitches[h] == rootQualityaug2Inv2[0][h])
            {  <<< "Caug/G#" >>>; 
            return chordSymbolsaug2inv[0] ;}
            
            else if (pitches[h] == rootQualityaugInv2[1][h] || pitches[h] == rootQualityaug2Inv2[1][h]) // Dmaj
            {     <<< "Daug/A#" >>>;
            return chordSymbolsaug2inv[1];}
            
            else if (pitches[h] == rootQualityaugInv2[2][h] || pitches[h] == rootQualityaug2Inv2[2][h]) // Emaj
            {  <<< "Eaug/B#" >>>;
            return chordSymbolsaug2inv[2];}
            else if (pitches[h] == rootQualityaugInv2[3][h] || pitches[h] == rootQualityaug2Inv2[3][h]) // Dmaj
            { <<< "Faug/C" >>>;
            return chordSymbolsaug2inv[3];}
            else if (pitches[h] == rootQualityaugInv2[4][h] || pitches[h] == rootQualityaug2Inv2[4][h]) // Emaj
            {<<< "Gaug/D#" >>>;
            return chordSymbolsaug2inv[4];}
            else if (pitches[h] == rootQualityaugInv2[5][h] || pitches[h] == rootQualityaug2Inv2[5][h]) // Emaj
            {<<< "Aaug/E#" >>>;
            return chordSymbolsaug2inv[5];}
            else if (pitches[h] == rootQualityaugInv2[6][h] || pitches[h] == rootQualityaug2Inv2[6][h]) // Emaj
            {<<< "Baug/Fx" >>>;
            return chordSymbolsaug2inv[6];}
            
            
            if (pitches[h] == rootQualityAccidentalsaugInv2[0][h] || pitches[h] == rootQualityAccidentalsaug2Inv1[0][h])
            {  <<< "C#aug/Gx" >>>; 
            return chordSymbolsAccidentalsaug2inv[0] ;}
            
            else if (pitches[h] == rootQualityAccidentalsaugInv2[1][h] || pitches[h] == rootQualityAccidentalsaug2Inv2[1][h]) // Dmaj
            {     <<< "D#aug/Ax" >>>;
            return chordSymbolsAccidentalsaug2inv[1];}
            else if (pitches[h] == rootQualityAccidentalsaugInv2[2][h] || pitches[h] == rootQualityAccidentalsaug2Inv2[2][h]) // Emaj
            {  <<< "F#aug/Cx" >>>;
            return chordSymbolsAccidentalsaug2inv[2];}
            else if (pitches[h] == rootQualityAccidentalsaugInv2[3][h] || pitches[h] == rootQualityAccidentalsaug2Inv2[3][h]) // Emaj
            {<<< "G#aug/Dx" >>>;
            return chordSymbolsAccidentalsaug2inv[3];}
            else if (pitches[h] == rootQualityAccidentalsaugInv2[4][h] || pitches[h] == rootQualityAccidentalsaug2Inv2[4][h]) // Emaj
            {<<< "A#aug/Ex" >>>;
            return chordSymbolsAccidentalsaug2inv[4];}
            
            
        }
    }
}



fun string[] triadDetector(float pchSet[]) // needs to return the notename to feed into pitch array
{     
    string triad1[3];
    
    for (0 => int a; a < pchSet.cap(); a++)
    {
        
        pchSet[a] => float testPitch; // play 3 pitches 
        <<< "the tested pitch is:", testPitch>>>;
        // this could all be put into a loop 
        
        
        ["A", "B", "C", "D", "E", "F", "G", "A#", "C#", "D#", "F#", "G#"] @=> string noteSet[];
        string noteName;
        
        string collectNotesArr[];  
        
        float testA; float testB; float testC; float testD; float testE; float testF; float testG;
        float testAsharp; float testCsharp; float testDsharp; float testFsharp;float testGsharp;
        
        /// Octave 1 - as in A1, B1,C1...
        if(testPitch > 53.0 && testPitch < 57.0) 
            noteSet[0] => noteName; // A 
        if(testPitch > 60.0 && testPitch < 63.5) 
            noteSet[1] => noteName; // B 
        if(testPitch > 63.5 && testPitch < 68.0) 
            noteSet[2] => noteName; // C
        if(testPitch > 71.0 && testPitch < 76.0) 
            noteSet[3] => noteName; //D
        if(testPitch > 80.0 && testPitch < 85.0) 
            noteSet[4] => noteName; //E
        if(testPitch > 85.0 && testPitch < 90.0) 
            noteSet[5] => noteName; //F
        if(testPitch > 96.0 && testPitch < 101.0)
            noteSet[6] => noteName; //G
        
        //accidentals 
        if(testPitch > 57.0 && testPitch < 60.0) 
            noteSet[7] => noteName; //A#
        if(testPitch > 68.0 && testPitch < 71.0) 
            noteSet[8] => noteName; //C#
        if(testPitch > 76.0 && testPitch < 80.0) 
            noteSet[9] => noteName; //D#
        if(testPitch > 90.0 && testPitch < 96.0) 
            noteSet[10] => noteName; //F#
        if(testPitch > 101.0 && testPitch < 107.5) 
            noteSet[11] => noteName; //G#
        
        /// Octave 2 - as in A2, B2,C2...
        if(testPitch > 107.5 && testPitch < 113.5) 
            noteSet[0] => noteName; // A 
        if(testPitch > 120.0 && testPitch < 126.0) 
            noteSet[1] => noteName; // B 
        if(testPitch > 126.0 && testPitch < 135.0) 
            noteSet[2] => noteName; // C
        if(testPitch > 142.5 && testPitch < 150.0) 
            noteSet[3] => noteName; //D
        if(testPitch > 160.0 && testPitch < 170.0)
            noteSet[4] => noteName; //E
        if(testPitch > 170.0 && testPitch < 180.0) 
            noteSet[5] => noteName; //F
        if(testPitch > 190.0 && testPitch < 201.0) 
            noteSet[6] => noteName; //G
        
        //accidentals 
        if(testPitch > 113.5 && testPitch < 120.0) 
            noteSet[7] => noteName; //A#
        if(testPitch > 135.0 && testPitch < 142.5) 
            noteSet[8] => noteName; //C#
        if(testPitch > 150.0 && testPitch < 160.0) 
            noteSet[9] => noteName; //D#
        if(testPitch > 180.0 && testPitch < 190.0) 
            noteSet[10] => noteName; //F#
        if(testPitch > 201.0 && testPitch < 214.5) 
            noteSet[11] => noteName; //G#
        
        /// Octave 3 - as in A3, .
        if(testPitch > 214.5 && testPitch < 229.0) 
            noteSet[0] => noteName; // A 
        if(testPitch > 238.0 && testPitch < 252.0) 
            noteSet[1] => noteName; // B 
        if(testPitch > 252.0 && testPitch < 270.0) 
            noteSet[2] => noteName;  //C
        if(testPitch > 285.0 && testPitch < 304.0) 
            noteSet[3] => noteName; //D
        if(testPitch > 321.0 && testPitch < 337.0) 
            noteSet[4] => noteName; //E
        if(testPitch > 337.0 && testPitch < 356.0) 
            noteSet[5] => noteName; //F
        if(testPitch > 384.0 && testPitch < 406.5) 
            noteSet[6] => noteName; //G
        
        //accidentals 
        if(testPitch > 229.0 && testPitch < 238.0) 
            noteSet[7] => noteName; //A#
        if(testPitch > 270.0 && testPitch < 285.0) 
            noteSet[8] => noteName; //C#
        if(testPitch > 304.0 && testPitch < 321.0) 
            noteSet[9] => noteName; //D#
        if(testPitch > 356.0 && testPitch < 384.0) 
            noteSet[10] => noteName; //F#
        if(testPitch > 406.5 && testPitch < 425.0) 
            noteSet[11] => noteName; //G#
        
        /// Octave 4 - as in A4, .
        if(testPitch > 425.0 && testPitch < 457.0) 
            noteSet[0] => noteName; // A 
        if(testPitch > 485.0 && testPitch < 510.0) 
            noteSet[1] => noteName; // B 
        if(testPitch > 510.0 && testPitch < 535.0) 
            noteSet[2] => noteName; //C 
        if(testPitch > 578.0 && testPitch < 608.0) 
            noteSet[3] => noteName; //D
        if(testPitch > 635.0 && testPitch < 673.0) 
            noteSet[4] => noteName; //E
        if(testPitch > 673.0 && testPitch < 705.0) 
            noteSet[5] => noteName; //F
        if(testPitch > 760.0 && testPitch < 800.0) 
            noteSet[6] => noteName; //G
        
        //accidentals 
        if(testPitch > 457.0 && testPitch < 485.0) 
            noteSet[7] => noteName; //A#
        if(testPitch > 535.0 && testPitch < 578.0) 
            noteSet[8] => noteName; //C#
        if(testPitch > 608.0 && testPitch < 635.0) 
            noteSet[9] => noteName; //D#
        if(testPitch > 705.0 && testPitch < 760.0) 
            noteSet[10] => noteName; //F#
        if(testPitch > 800.0 && testPitch < 850.0) 
            noteSet[11] => noteName; //G#
        
        /// Octave 5 - as in A5 
        if(testPitch > 850.0 && testPitch < 905.0) 
            noteSet[0] => noteName; // A 
        if(testPitch > 955.0 && testPitch < 1005.0) 
            noteSet[1] => noteName; // B 
        if(testPitch > 1005.0 && testPitch < 1070.0) 
            noteSet[2] => noteName; //C 
        if(testPitch > 1125.0 && testPitch < 1205.0) 
            noteSet[3] => noteName; //D
        if(testPitch > 1280.0 && testPitch < 1355.0) 
            noteSet[4] => noteName; //E
        if(testPitch > 1355.0 && testPitch < 1420.0) 
            noteSet[5] => noteName; //F
        if(testPitch > 1530.0 && testPitch < 1610.0) 
            noteSet[6] => noteName; //G
        
        //accidentals 
        if(testPitch > 905.0 && testPitch < 955.0) 
            noteSet[7] => noteName; //A#
        if(testPitch > 1070.0 && testPitch < 1125.0) 
            noteSet[8] => noteName; //C#
        if(testPitch > 1205.0 && testPitch < 1280.0)
            noteSet[9] => noteName; //D#
        if(testPitch > 1420.0 && testPitch < 1530.0) 
            noteSet[10] => noteName; //F#
        if(testPitch > 1610.0 && testPitch < 1700.0) 
            noteSet[11] => noteName; //G#
        
        /// Octave 6 - as in A6 , .
        if(testPitch > 1700.0 && testPitch < 1800.0) 
            noteSet[0] => noteName; // A 
        if(testPitch > 1910.0 && testPitch < 2020.0) 
            noteSet[1] => noteName; // B 
        if(testPitch > 2020.0 && testPitch < 2130.0) 
            noteSet[2] => noteName; //C 
        if(testPitch > 2290.0 && testPitch < 2400.0) 
            noteSet[3] => noteName; //D
        if(testPitch > 2580.0 && testPitch < 2690.0) 
            noteSet[4] => noteName; //E
        if(testPitch > 2690.0 && testPitch < 2880.0)
            noteSet[5] => noteName; //F
        if(testPitch > 3000.0 && testPitch < 3200.0)
            noteSet[6] => noteName; //G
        
        //accidentals 
        if(testPitch > 1800.0 && testPitch < 1910.0) 
            noteSet[7] => noteName; //A#
        if(testPitch > 2130.0 && testPitch < 2290.0) 
            noteSet[8] => noteName; //C#
        if(testPitch > 2400.0 && testPitch < 2580.0) 
            noteSet[9] => noteName; //D#
        if(testPitch > 2880.0 && testPitch < 3000.0) 
            noteSet[10] => noteName; //F#
        if(testPitch > 3200.0 && testPitch < 3400.0) 
            noteSet[11] => noteName; //G#
        
        
        
        <<< "the note is", noteName >>>; // why is noteName undefined here?
        
        noteName => triad1[a];/// JAN29 1:10PM STOP 
        
        
        
        
        //NOW PASS NOTENAME AND RETURN , first get it to scan for DF#A multiple times 
        
        // This prints the index number of the pitch set array members  fed into the large function 
        for (0 => int g; g < noteSet.cap(); g++)
        {
            if ( noteName == noteSet[g])
                // return g; // returning g seems to give issues
            <<< g >>>;
        }   
        
        
    }   
    
    return triad1;  
    
} 


Event sendPitch;  // these events are taken out of the function to avoid issues from limited scope 
Event collectNotes;


fun string takePitches(int scanTime) // here we need the confirmed Hz from the testCleanHz() func ~ line 135
{
    float pitchesIn[3];
    
    // while (true)
    //   {
    
    // calls 3x to accumulate a triad  
    for (0 => int r; r < 3; r++)
    {
        
        testCleanHz() => pitchesIn[r]; // do I need the earlier spork ~ testCleanHz? 
        
        scanTime::ms => now; // enough time to scan through realHz array
    //}
    
}

// then wait a sec and test against the triad detector 

string chordNotes[];

string chord[];

triadDetector(pitchesIn) @=> chord; // => string noteNamey;   // A D and C call the triad detector function  
// THE pitch tracker needs to fill this array 

testChord(chord) => string triadType;


<<< triadType, "IS THE CHORD" >>>;

return triadType;

}

fun string scanActive()
{
    while (true)
    {
        scannerRepeat() @=> string triadLog[];
        
        modeTell(triadLog) => string triadSentIt;
        
        
        return triadSentIt;
        
        30::second => now;
    }
    
    
}

spork ~ PITCHEY();

fun float mandoSend()
{
    
    float mandoPitch;
    
    while (true)
    {
        
        scanActive() => string triadBase;
        
        if (triadBase == "Cmaj")
            261.5 => mandoPitch;
        if (triadBase == "Gmaj")
            98. => mandoPitch;
        if (triadBase == "Amaj")
            55.0 => mandoPitch;
        if (triadBase == "Emaj")
            82. => mandoPitch;
        if (triadBase == "Bmaj")
            62. => mandoPitch;
        if (triadBase == "Fmaj")
            87. => mandoPitch;
        if (triadBase == "Dmaj")
            73.5 => mandoPitch;
        
        
        
        return mandoPitch;
        
        30::second => now;
    }
}


fun void mandoLisa(float duration, float rate, float pos, float rampUp, float rampDown, int biDirect)
{
    duration::second => mandoL.duration;
    rampUp::second => mandoL.duration;
    rampDown::second => mandoL.duration;
    
    (0, rate) => mandoL.rate;
    (1, 5.0) => mandoL.rate;
    (2,0.5) => mandoL.rate;
    pos::second => mandoL.playPos;
    
    
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
        
    }
    
    
    
    fun void pches(float basePitch, int cons)
    {
        [1,2,3,4] @=> int pitchScale[];
        
        basePitch * pickrandInt(pitchScale) => mando[0].freq;
        basePitch * pickrandInt(pitchScale) => mando[1].freq;
        
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
    
    fun float playMode(int mode, int keepLisa, float baseHz)
    {
        float nextOne;
        
        [0.1,0.5,0.25,0.05] @=> float lengths[];   
        
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
            spork ~ pches(baseHz,0);
            nextOne::second => now;
            
            a++;
            
        }
        
    }
    
    
    
    mandoSend() => float mandolinInHz;
    
    //  spork ~ scannerRepeat();
    
    spork ~ playMode(2,0,mandolinInHz); // base for mando insts
    
    // returns the confirmed "real" non-spurious freq 
    1::day => now;