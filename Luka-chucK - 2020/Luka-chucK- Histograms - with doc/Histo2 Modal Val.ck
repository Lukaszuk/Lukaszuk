// Histogram no. 2 
// Modal value 

["hi","hi","hi","bye","hi"] @=> string set[]; // master set convert to string 


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


fun int pitchSet(string notes[], string testIt)
{
    
    histo1(notes, testIt) => int hi;
    
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


modal(set) => int mode;

finalTest(set,mode) => string final;

<<< "modal val =" , final >>>;

1::day => now;