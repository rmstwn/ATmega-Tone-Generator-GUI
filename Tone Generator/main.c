/*******************************************************
 This program was created by the
 CodeWizardAVR V3.12 Advanced
 Automatic Program Generator
 © Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
 http://www.hpinfotech.com
 
 Project : 
 Version : 
 Date    : 04/11/2019
 Author  : 
 Company : 
 Comments: 
 
 
 Chip type               : ATmega162
 Program type            : Application
 AVR Core Clock frequency: 12,000000 MHz
 Memory model            : Small
 External RAM size       : 0
 Data Stack size         : 256
 *******************************************************/

#include <mega162.h>
  #include <delay.h>
  // Declare your global variables here

  #define DATA_REGISTER_EMPTY (1<<UDRE0)
  #define RX_COMPLETE (1<<RXC0)
  #define FRAMING_ERROR (1<<FE0)
  #define PARITY_ERROR (1<<UPE0)
  #define DATA_OVERRUN (1<<DOR0)

  //Bunyi nada : do re mi fa sol la si do 
  //Frekuensi : 264 297 330 352 396 440 495 528 hz 
  #define doFreq 262 
  #define reFreq 294 
  #define miFreq 330 
  #define faFreq 350 
  #define solFreq 392 
  #define laFreq 440 
  #define siFreq 494 
  #define DoFreq 528 

  #ifndef RXB8 
  #define RXB8 1 
  #endif 

  #ifndef TXB8 
  #define TXB8 0 
  #endif 

  #ifndef UPE 
  #define UPE 2 
  #endif 

  #ifndef DOR 
  #define DOR 3 
  #endif 

  #ifndef FE 
  #define FE 4 
  #endif 

  #ifndef UDRE 
  #define UDRE 5 
  #endif 

  #ifndef RXC 
  #define RXC 7 
  #endif 

  char flag, nada, flagSerial; 
int count, i; 
void putchar1(char c); 

// USART1 Receiver buffer
#define RX_BUFFER_SIZE1 8
  char rx_buffer1[RX_BUFFER_SIZE1];

#if RX_BUFFER_SIZE1 <= 256
  unsigned char rx_wr_index1=0, rx_rd_index1=0;
#else
  unsigned int rx_wr_index1=0, rx_rd_index1=0;
#endif

  #if RX_BUFFER_SIZE1 < 256
  unsigned char rx_counter1=0;
#else
  unsigned int rx_counter1=0;
#endif

  // This flag is set on USART1 Receiver buffer overflow
  bit rx_buffer_overflow1;

// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
  char status, data;
  status=UCSR1A;
  data=UDR1;
  nada=UDR1;
  if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
  {
    //   rx_buffer1[rx_wr_index1++]=data;

    //#if RX_BUFFER_SIZE1 == 256
    //   // special case for receiver buffer size=256
    //   if (++rx_counter1 == 0) rx_buffer_overflow1=1;
    //#else
    //   if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
    //   if (++rx_counter1 == RX_BUFFER_SIZE1)
    //      {
    //      rx_counter1=0;
    //      rx_buffer_overflow1=1;
    //      }
    //#endif
    /*--------------------*/
    if (data=='#')
    {
      flagSerial=1;
      count=0;
    } else { 
      rx_buffer1[count]=data;
      count++;
    } 

    if (data=='!'&&flagSerial==1) {//Input data 
      flagSerial=0; 
      flag=rx_buffer1[0]; 
      nada=rx_buffer1[1];
    }
  }
}

// Get a character from the USART1 Receiver buffer
#pragma used+
  char getchar1(void)
{
  char data;
  while (rx_counter1==0);
  data=rx_buffer1[rx_rd_index1++];
  #if RX_BUFFER_SIZE1 != 256
    if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
  #endif
    #asm("cli")
    --rx_counter1;
  #asm("sei")
    return data;
}
#pragma used-
  // Write a character to the USART1 Transmitter
  #pragma used+
  void putchar1(char c)
{
  while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
  UDR1=c;
}
#pragma used-
  void delay_tone(char tone)
{ 
  //Rumus delay = (1/freq )*1000000/2; 
  switch(tone)
  { 
  case 1 :
    { 
      delay_us(1893);
      break;
    } 
  case 2 :
    { 
      delay_us(1683);
      break;
    } 
  case 3 :
    { 
      delay_us(1515);
      break;
    } 
  case 4 :
    { 
      delay_us(1420);
      break;
    } 
  case 5 :
    { 
      delay_us(1262);
      break;
    } 
  case 6 :
    { 
      delay_us(1136);
      break;
    } 
  case 7 :
    { 
      delay_us(1010);
      break;
    } 
  case 8 :
    { 
      delay_us(946);
      break;
    } 
  case 88:
    { 
      delay_us(800);
      break;
    }
  }
} 


void toneGenerator(char tone)
{ 
  if (tone!=88)
  { 
    PORTB.0 =1; 
    delay_tone(tone); 
    PORTB.0 =0; 
    delay_tone(tone);
  } else {
    PORTB.0 = 0;
    delay_tone(tone);
  }
} 


int Dur; 
void musicGenerator(char duration, char tone)
{ 
  for (Dur=0; Dur<=duration; Dur++)
    toneGenerator(tone); 

  PORTB.0=0;
} 


int gundulPacul[] = {1, 3, 1, 3, 4, 5, 5, 0, 7, 8, 7, 8, 7, 5, 88, 0, 1, 
  3, 1, 3, 4, 5, 5, 0, 7, 8, 7, 8, 7, 5, 88, 1, 
  3, 5, 88, 4, 4, 5, 4, 3, 1, 4, 3, 1, 88, 0, 1, 
  3, 5, 88, 4, 4, 5, 4, 3, 1, 4, 3, 1, 88, 0, 
  99}; 
int Twinkle[]={ 
  1, 1, 5, 5, 6, 6, 5, 88, 
  4, 4, 3, 3, 2, 2, 1, 88, 
  5, 5, 4, 4, 3, 3, 2, 88, 
  5, 5, 4, 4, 3, 3, 2, 88, 
  1, 1, 5, 5, 6, 6, 5, 88, 
  4, 4, 3, 3, 2, 2, 1, 88, 
  99 
}; 

int ibuKitakartini[]={ 
  1, 2, 3, 4, 5, 3, 1, 88, 
  6, 8, 7, 6, 5, 88, 
  4, 6, 5, 4, 3, 1, 88, 
  2, 4, 3, 2, 1, 88, 
  4, 3, 4, 6, 5, 6, 5, 3, 1, 3, 2, 3, 4, 5, 3, 88, 
  4, 3, 4, 6, 5, 6, 5, 3, 1, 3, 2, 3, 4, 5, 3, 88, 99 
} ; 

int babyShark[]={ 
  2, 3, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 
  2, 3, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 
  2, 3, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 
  5, 88, 5, 88, 4, 99 
}; 

int randomMusic[] = 
  {1, 2, 3, 4, 5, 6, 7, 8, 88, 99};

int index=0; 
void musicPlayer(int music[])
{ 
  while (music[index]!=99) 
  { 
    musicGenerator(70, music[index]);
    index++;
  } 

  index=0; 
  flag=0;
} 

int i; 

void main(void)
{
  // Declare your local variables here

  // Crystal Oscillator division factor: 1
  #pragma optsize-
    CLKPR=(1<<CLKPCE);
  CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
  #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    // Input/Output Ports initialization
    // Port A initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
  PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

  // Port B initialization
  // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
  DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
  // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
  PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

  // Port C initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
  DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
  PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

  // Port D initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
  DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
  PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

  // Port E initialization
  // Function: Bit2=In Bit1=In Bit0=In 
  DDRE=(0<<DDE2) | (0<<DDE1) | (0<<DDE0);
  // State: Bit2=T Bit1=T Bit0=T 
  PORTE=(0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);

  // USART1 initialization
  // Communication Parameters: 8 Data, 1 Stop, No Parity
  // USART1 Receiver: On
  // USART1 Transmitter: On
  // USART1 Mode: Asynchronous
  // USART1 Baud Rate: 9600
  UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
  UCSR1B=(1<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
  UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
  UBRR1H=0x00;
  UBRR1L=0x4D;

  // Global enable interrupts
  #asm("sei")

    while (1)
  {
    // Place your code here    
    //char a = 'a';
    //putchar1(nada); 
    //delay_ms(100);
    //musicPlayer(randomMusic); 
    //flag = 1;
    putchar1(nada); 

    if (flag=='1') { 
      if (nada=='1') { 
        musicPlayer(gundulPacul);
      } else if (nada=='2') { 
        musicPlayer(Twinkle);
      } else if (nada=='3') { 
        musicPlayer(ibuKitakartini);
      } else if (nada=='4') { 
        musicPlayer(babyShark);
      }
    } else if (flag=='2') { 
      if (nada=='1') {
        toneGenerator(1);
      } else if (nada=='2') {
        toneGenerator(2);
      } else if (nada=='3') {
        toneGenerator(3);
      } else if (nada=='4') {
        toneGenerator(4);
      } else if (nada=='5') {
        toneGenerator(5);
      } else if (nada=='6') {
        toneGenerator(6);
      } else if (nada=='7') {
        toneGenerator(7);
      } else if (nada=='8') {
        toneGenerator(8);
      } else if (nada=='9') {
        toneGenerator(99);
      }
    }
  }
}
