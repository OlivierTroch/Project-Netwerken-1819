# Testplan Opdracht 1 - Lab 2

## Part 1
In Part 1, you will cable the devices together according to the network topology.

### Step 1
All the devices should be powered on. You can check this by selecting the two computers. 
Switches do not have a power switch, they will power on as soon as the power cord is plugged in, which happens automatically in Packet Tracer.

### Step 2
If you want to make sure the devices are connected on the right port, you can hover over the green light.
After some time you can see the port name. \(Make sure your Packet Tracer is actively selected\)

### Step 3 
To check if the devices are connected succesfully, you can check if the lights are green. 
If you want to make sure they are connected ot the right port, you can look on the devices themself.

For the computer, you click *Desktop* and then *IP Configuration* on the top you can see the interface which should be the same as in the assignement.

### Step 4
Check if User-01 is connected to 1 switch, that switch should be connected to another one and the swich itself should be connected to User-02.

## Part 2
Configuring static IP Addresses on the computers

### Step 1
To see if this was done correctly, click the desktop and enter the *IP Configuration* tab. Here you can the right IP address. Also look at the second computer.

### Step 2 
Now you can verify if this is all correct. Go to User-01 and go into the *Command Prompt* and ping User-02 via **ping 192.168.1.11**. This should be succesfull. Now go to User-02 and do the same but use **ping 192.168.1.10**.

## Part 3
Configuring and verifying basic switch settings

### Step 1
Connect to the switch trough User-01 using the terminal on the desktop.

### Step 2
Before entering the user EXEC mode you should see a banner MOTD, if this is present, this means step 7 in the assignement is correctly executed.
Enter the user EXEC mode with the *enable* command.

### Step 3
Enter the configure terminal mode with the *configure terminal* command. You will need a password to get in to this configuration.
This pass \(cisco\) also confirms that step 6 in the assignement worked well.

### Step 4
To check if the switch has a custom name, you can look before the \# symbol. It should be S1 of S2 depending on the switch you are connected to.

### Step 5 
Use the *show running-config* command to see if the configuration of step 5 in the assignement was succesfull.
It should show "no ip domain-lookup". Here you can also recheck all the other steps from the assignement. Such as the pass, the banner,...

### Step 6 
Use the *show ip interface brief* to check if the connections were succesfull.

### Step 7
Go through step 1 to 6 again for the second switch. Don't forget to put the console cable in the second switch physically.

Auteur Testplan Opdracht 2: Olivier Troch
