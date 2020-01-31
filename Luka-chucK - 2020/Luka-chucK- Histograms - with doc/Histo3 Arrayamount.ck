// Histogram no. 3
// This first histogram tells you how many of a particular string 
// occur in an array. Possible uses: how many times a performer plays
// a particular pitch, a particular duration, etc etc 


["hi","bye","bye","bye"] @=> string set[];


fun int histo1(string pches[], string testFreq)
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


fun void pitchSet(string notes[], string testIt)
{
    
    histo1(notes, testIt) => int hi;
    
    <<< hi >>>;
    
}

spork ~ pitchSet(set, "bye");
//spork ~ histo1([2.0,3.0,2.0,2.0], 2.0);
1::day => now;