# Testplan Opdracht 1 - Lab 1

## Part 1
In part 1 of this lab you have to acces a *Cisco Switch* through the *Serial Console Port*. 

### Packet Tracer
In Packet Tracer you should have a switch connected to a pc. You can see if this is succesfull by having two green dots between these two devices. 

### Physical/Real life
To test if this connection was succesful, you can use an open-source terminal emulator, such as [Putty](https://www.putty.org/). 
You connect through the use of a serial link from the switch to your computer which you can then acces in putty by selecting *connection type* **Serial** and you give in the right serial line which can be found in the device manager.
If you manage to connect this, it means that the connection is in fact successful.

## Part 2
In this section, you are introduced to the user and privileged executive modes. Now you can either use Packet Tracer or Putty(or any other emulator for that matter)
You should by now how a switch and a pc on which you can use a terminal.

### Step 1
Check if your version is still the same as **flash:/c2960-lanbasek9-mz.152-2.E8/c2960-lanbasek9-mz.152-2.E8.bin** by using the *show version* command in *user EXEC mode*. 

### Step 2
Check if the clock settings are enabled by using the *show clock* command and compare it to the current date/time.

## Reflection
Check if the console password is enable by entering console line 0 with password *Cisco*.

Auteur Testplan Opdracht 1: Olivier Troch
