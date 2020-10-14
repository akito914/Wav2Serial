

import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

byte[] txBuf = new byte[256];

int txCount = 0;

byte wav[];

int wav_index = 0;

int  totalSize;


int getIntVal(byte[] buf, int startIndex, int bytes)
{
  int val = 0;
  
  for(int i = 0; i < bytes; i++)
  {
    val |= (buf[startIndex + i] & 0xff) << (i*8);
  }
  
  return val;
}

void setup() 
{
  
  wav = loadBytes("./data/kouoniki-10.2kS.wav");
  //wav = loadBytes("./data/teion-10.2kS.wav");
  //wav = loadBytes("./data/godknows-10.2kS.wav");
  //wav = loadBytes("./data/uma-10.2kS.wav");
  //wav = loadBytes("./data/monster-10.2kS.wav");
  //wav = loadBytes("./data/1kHz-10.2kS.wav");
  //wav = loadBytes("./data/20Hz-10.2kS.wav");
  
  println((char)wav[0]+"-"+(char)wav[1]+"-"+(char)wav[2]+"-"+(char)wav[3]);
  
  totalSize = getIntVal(wav, 4, 4);
  
  println("total size = "+ totalSize);
  
  size(200, 200);
  myPort = new Serial(this, "COM5", 230400);
  
  wav_index = 44;
  
  for(int i = 0; i < 256; i++)
  {
    txBuf[i] = wav[wav_index++];
  }
  
  //println((byte)0x80);
  
}

void draw() {
}


void serialEvent(Serial thisPort) {
  int inByte = thisPort.read();
  
  myPort.write(txBuf);
  println("send: ["+wav_index+"]");
  
  if(wav_index + 256 * 10>= wav.length - 1)
  {
    delay(10);
    exit();
  }
  
  for(int i = 0; i < 256; i++)
  {
    if(wav_index < wav.length)
    {
      txBuf[i] = wav[wav_index++];
    }
    else
    {
      txBuf[i] = wav[44];
    }
  }
  
  
}
