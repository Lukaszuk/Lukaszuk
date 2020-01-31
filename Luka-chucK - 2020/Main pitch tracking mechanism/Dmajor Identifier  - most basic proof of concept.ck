/// Michael Lukaszuk - winter 2020

// Super simple synth outputs notes from Dmaj chord, scanner identifies the DMaj triad


// each triad note is 2'' long 

2000 => int masterScan;

SinOsc s;

TriOsc t => dac;

0.1 => t.gain;

fun void Dmaj()
{
    
    while (true)
    {
        
        587 => t.freq;
        
        2::second => now;
        
        740 => t.freq;
        
        2::second => now;
        
        880 => t.freq;
        
        2::second => now;
        
    }
}

fun float PITCHEY()
{
    
    spork ~ Dmaj(); // replace t with adc and comment out spork later on 
    
    t => Gain inGain => dac; // create an oscillator
    // PitchTrack must connect to blackhole to run
    inGain => PitchTrack pitch => blackhole;
    float hzhz;
    
    while (true)
    {   
        pitch.get() => hzhz;
        hzhz => s.freq;
        <<< hzhz >>>;
        
        0.1::second => now; // tracker analyzes input at speed of 100ms 
        
    }
    return hzhz;
}

fun string scannerRepeat()
{
    spork ~ testCleanHz();
    
    while (true)
    {
        
        spork ~ takePitches(masterScan); // ms for scan time 
        
        masterScan * 3 => int nextScan; // * 3 because the takePitches takes 3x the masterScan time to complete
        
        masterScan::ms => now;
        //  testChord(triad) => string triadType;
        
        // return triadType;
    }
}



/////////////////////// PART 2 HISTOGRAM FUNC ***///////////////////

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
[["C#","G#","F#"],["D#","A#","G"],["F#","C#","A#"],["G#","D#","C"],["A#","E","D"]] @=> string rootQualityAccidentals2[][]; 



//Minor triads 
[["C","D#","G"],["D","F","A"],["E","G","B"],["F","G#","C"],["G","A#","D"],["A","C","E"],["B","D","F#"]] @=> string rootQualityminor[][]; // add the rest 

[["C","G","D#"],["D","A","F"],["E","B","G"],["F","C","G#"],["G","D","A#"],["A","E","C"],["B","F#","D"]] @=> string rootQualityminor2[][]; // add the rest 



[["C#","E","G#"],["D#","F#","A#"],["F#","A","C#"],["G#","B","D#"],["A#","C#","E#"]] @=> string rootQualityAccidentalsminor[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 
[["C#","G#","E"],["D#","A#","F#"],["F#","C#","A"],["G#","D#","B"],["A#","E#","C#"]] @=> string rootQualityAccidentalsminor2[][]; 



// Diminished Triads
[["C","D#","F#"],["D","F","G#"],["E","G","A#"],["F","G#","B"],["G","A#","C#"],["A","C","D#"],["B","D","F"]] @=> string rootQualitydim[][]; // add the rest 

[["C","F#","D#"],["D","G#","F"],["E","A#","G"],["F","B","G#"],["G","C#","A#"],["A","D#","C"],["B","F","D"]] @=> string rootQualitydim2[][]; // add the rest 


[["C#","E","G"],["D#","F","A"],["F#","A","C"],["G#","B","D"],["A#","C","E"]] @=> string rootQualityAccidentalsdim[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 

[["C#","G","E"],["D#","A","F"],["F#","C","A"],["G#","D","B"],["A#","E","C"]] @=> string rootQualityAccidentalsdim2[][]; 


// Augmented Triads
[["C","E","G#"],["D","F#","A#"],["E","G#","C"],["F","A","C#"],["G","B","D#"],["A","C#","F"],["B","D#","G"]] @=> string rootQualityaug[][]; // add the rest 

[["C","G#","E"],["D","A#","F#"],["E","C","G#"],["F","C#","A"],["G","D#","B"],["A","F","C#"],["B","G","D#"]] @=> string rootQualityaug2[][]; // add the rest 


[["C#","F","A"],["D#","G","B"],["F#","A#","D"],["G#","B#","E"],["A#","C#","F#"]] @=> string rootQualityAccidentalsaug[][]; 
// NB E# -> F,   Fx -> G for reduced work with the pitch tracking - i.e. doesn't have to test against two things 

[["C#","A","F"],["D#","B","G"],["F#","D","A#"],["G#","E","B#"],["A#","F#","C#"]] @=> string rootQualityAccidentalsaug2[][]; 


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

// Second Inversion  - not done yet!! 

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


fun string[] takePitches(int scanTime) // here we need the confirmed Hz from the testCleanHz() func ~ line 135
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


<<< triadType, "It's",triadType >>>;

return chord;

}


spork ~ PITCHEY();
spork ~ scannerRepeat();

1::day => now;