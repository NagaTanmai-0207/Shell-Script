#!/bin/bash

# Ensure folders exist
mkdir -p input text logs output backup

# Save report with date header
REPORT="output/report.txt"
echo "========================================" >> $REPORT
echo "===== REPORT GENERATED: $(date) =====" >> $REPORT
echo "========================================" >> $REPORT

echo "===== SYSTEM REPORT =====" >> $REPORT

# Step 1: Organize files
echo "Organizing files..." >> $REPORT
find input -type f -name "*.txt" -exec mv {} text/ \;
find input -type f -name "*.log" -exec mv {} logs/ \;

# Step 2: Log Analysis
echo "Analyzing logs..." >> $REPORT

if ls logs/*.log 1> /dev/null 2>&1
then
    ERROR=$(grep -i "error" logs/*.log | wc -l)
    WARNING=$(grep -i "warning" logs/*.log | wc -l)
else
    ERROR=0
    WARNING=0
fi

echo "Total ERROR: $ERROR" >> $REPORT
echo "Total WARNING: $WARNING" >> $REPORT

# Step 3: System Info
echo "===== SYSTEM INFO =====" >> $REPORT
echo "User: $(whoami)" >> $REPORT
echo "Date & Time: $(date)" >> $REPORT

# Disk Usage
echo "----- Disk Usage -----" >> $REPORT
df -h >> $REPORT

# Memory Usage
echo "----- Memory Usage -----" >> $REPORT
free -h >> $REPORT

# Step 4: Process Monitoring
echo "----- Top CPU Processes -----" >> $REPORT
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 >> $REPORT

# Step 5: Backup
echo "Creating backup..." >> $REPORT
tar -czf backup/project_$(date +"%Y-%m-%d_%H-%M").tar.gz text logs

# Step 6: Network Check
echo "===== NETWORK CHECK =====" >> $REPORT

if ping -c 3 google.com > /dev/null 2>&1
then
    echo "Network: CONNECTED" >> $REPORT
else
    echo "Network: NOT CONNECTED" >> $REPORT
fi

echo "===== END OF REPORT =====" >> $REPORT
echo "" >> $REPORT
