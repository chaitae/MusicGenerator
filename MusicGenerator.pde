import ddf.minim.*;
import ddf.minim.ugens.*;
import java.util.Collections;
Minim minim;
AudioOutput out;
String[] freqList;
String[] noteNames;
String[] userInput;
String[] intervalList;
Float[] beatList = {.5, .25, 1.0, 2.0, 4.0};
HashMap<String, Integer> noteTable;
float currTime = 0;
AudioRecorder recorder;
boolean recorded;
void fillHash()
{
  noteTable = new HashMap();
  for (int i = 0; i<noteNames.length; i++)
  {
    noteTable.put(noteNames[i], i);
  }
}
void setup()
{
  size(512, 200, P3D);
  freqList = loadStrings("freqList.txt");
  intervalList = loadStrings("intervalList.txt");
  noteNames = loadStrings("noteList.txt");
  fillHash();
  minim = new Minim(this);
  out = minim.getLineOut();  
  out.setTempo( 80 );
  out.pauseNotes( );
  playNotes();
  recorder = minim.createRecorder(out, "myrecording.wav");
}
float prevSpeed = 0;

void playNote(float note, float speed)
{
  prevSpeed = speed;
  currTime+= speed;
  out.playNote(currTime, prevSpeed, note);
}

void playNote(String note, float speed)
{
  if (note.contains("/"))
  {
    note = note.substring(0, note.indexOf("/")-1);
  }
  prevSpeed = speed;
  out.playNote(currTime, prevSpeed, note);
  currTime+= speed;
}
void playConcurrent(String note)
{
  out.playNote(currTime, prevSpeed+.2, note);
}

void playPattern(ArrayList<Float> patterns, ArrayList<String> noteList)
{
  int patternIndex = 0;
  print(patterns);
        int randNote = (int)random(0, noteList.size());

  int prevNote = randNote;
  for (int i = 0; i< 1; i++)
  {
    while (patternIndex<patterns.size())
    {
      int randNote2 = (int)random(0, noteList.size());
      int random =(int) random(0, patterns.size());
      if (random(0, 1)<-1)
      {
        playNote(0, patterns.get(0));
        Collections.rotate(patterns, 1);
      } else
      {
        playNote(noteList.get(randNote2), patterns.get(0));
        Collections.rotate(patterns, 1);
      }
      patternIndex++;
    }
    patternIndex = 0;
  }
}
void playChordContents(ArrayList<String> chordList)
{
  for (int i = 0; i<chordList.size(); i++)
  {
    playNote(chordList.get(i), .3);
  }
}

void playProgressions(ArrayList<ArrayList<String>> listProgressions, ArrayList<Integer> progression, ArrayList<String> scale)
{
  GetNotes getNotes = new GetNotes();
  for (int i = 0; i<progression.size(); i++)
  {
    listProgressions.add(getNotes.getChord("1 4 9", scale.get(progression.get(i)), 1));
  }
  ArrayList<Float> measure = getNotes.getMeasure(4);
  for (int z = 0; z<listProgressions.size(); z++)
  {
    playPattern(measure, listProgressions.get(z));
  }
  playPattern(measure, listProgressions.get(0));
}
void playNotes()
{
  GetNotes getNotes = new GetNotes();
  ArrayList<String> scale = getNotes.makeScale("WWHWWWH", "C3");
  ArrayList<Integer> progression = getNotes.getProgression("1 4 5");
  ArrayList<ArrayList<String>> listOfProgressions = new ArrayList<ArrayList<String>>();
  playProgressions(listOfProgressions, progression, scale);
  out.resumeNotes();
  //out.resumeNotes();
}
void draw()
{
  background(0);
  stroke(255);
  // draw the waveforms
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50 );
    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 );
  }
}
void keyReleased()
{
  if ( key == 'r' ) 
  {
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of the buffer 
    // (in the case of buffered recording) or to the end of the file (in the case of streamed recording). 
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
    } else 
    {
      recorder.beginRecord();
    }
  }
  if ( key == 's' )
  {
    // we've filled the file out buffer, 
    // now write it to the file we specified in createRecorder
    // in the case of buffered recording, if the buffer is large, 
    // this will appear to freeze the sketch for sometime
    // in the case of streamed recording, 
    // it will not freeze as the data is already in the file and all that is being done
    // is closing the file.
    // the method returns the recorded audio as an AudioRecording, 
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    println("Done saving.");
  }
}