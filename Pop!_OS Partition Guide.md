
## Problem Summary

Your Pop!_OS partition is only using ~240GB of your 5TB drive, with ~4.7TB sitting as unallocated space. This guide will help you expand your main partition to use that space.

⚠️ **WARNING**: This is an advanced operation. You cannot resize the partition you are currently booted from. Performing this incorrectly can lead to data loss. **Please back up any critical data before you begin.**

## Step 1: Create a Pop!_OS Live USB

You'll need a spare USB drive (8GB or larger).

1. Download a fresh Pop!_OS ISO from [pop.system76.com](https://pop.system76.com)
2. Open your applications and find the pre-installed **"Popsicle"** app (USB Flasher)
3. Use Popsicle to flash the downloaded ISO file onto your USB drive

## Step 2: Boot From the Live USB

1. Plug the newly created Live USB into your computer
2. Restart your computer. As it boots up, press the boot menu key (often **F12**, **F2**, **ESC**, or **DEL**)
3. From the boot menu, select your USB drive to boot from it
4. When prompted, choose **"Try Pop!_OS"** or **"Demo Mode"** (this runs the OS from USB without installing)

## Step 3: Resize The Partition with GParted

Once you're on the live desktop:

### Install GParted

1. Connect to Wi-Fi
2. Open a terminal (`Ctrl+Alt+T`) and run:

```bash
sudo apt update
sudo apt install gparted
```

3. Launch GParted from your applications

### The Resizing Sequence

1. **Select your drive**: Make sure you've selected your 5TB drive from the dropdown menu in the top-right corner of GParted
    
2. **Disable swap**: Find the partition labeled `linux-swap`. Right-click on it and select **"Swapoff"**
    
3. **Delete swap temporarily**: Right-click the `linux-swap` partition again and select **"Delete"** (we'll recreate it later)
    
4. **Resize main partition**:
    
    - Right-click your main Pop!_OS partition (the ~240GB one formatted as `ext4`)
    - Choose **"Resize/Move"**
    - In the window that appears, drag the right edge of the partition all the way to the right
    - **Leave about 16-32 GB of space at the end** (this will be for your new swap)
    - Click **"Resize/Move"**
5. **Create new swap**:
    
    - Right-click the remaining unallocated space at the end of the drive
    - Select **"New"**
    - Format it as `linux-swap`
    - Click **"Add"**
6. **Review operations**: Check the list of pending operations at the bottom of GParted. It should show:
    
    - Resizing your main partition
    - Creating a new swap partition
7. **Apply changes**:
    
    - If everything looks correct, click the green checkmark icon (✔️) in the toolbar
    - This will apply all operations
    - **This process may take 30-60+ minutes** depending on data size
    - The progress bar may appear stuck at times - this is normal
    - **Do not interrupt this process!**

## Step 4: Verify After Reboot

1. Remove the USB and reboot into your main system
2. Open a terminal and verify swap is working:

```bash
swapon --show
```

3. Check your new partition size:

```bash
df -h
```

You should now see your main partition using most of the 5TB drive!

## Troubleshooting

- If GParted shows errors, run `sudo e2fsck -f /dev/[your-partition]` from the Live USB
- If swap isn't working after reboot, you may need to update `/etc/fstab` with the new swap UUID
- To find the new swap UUID: `sudo blkid | grep swap`

## Need Help?

If you encounter issues, boot back into the Live USB and you can reverse the operations in GParted before applying them.