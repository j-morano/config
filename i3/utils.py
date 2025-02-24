import time

def get_cpu_times():
    with open('/proc/stat', 'r') as f:
        line = f.readline()
    fields = line.strip().split()[1:]
    return list(map(int, fields))

def calculate_cpu_usage():
    # Get first snapshot
    cpu_times1 = get_cpu_times()
    idle1 = cpu_times1[3]  # idle time is the 4th value
    total1 = sum(cpu_times1)

    # Wait a moment and get second snapshot
    time.sleep(0.2)
    cpu_times2 = get_cpu_times()
    idle2 = cpu_times2[3]
    total2 = sum(cpu_times2)

    # Calculate deltas
    idle_delta = idle2 - idle1
    total_delta = total2 - total1

    # Calculate CPU usage percentage
    cpu_usage = 100 * ( (total_delta - idle_delta) / total_delta )
    # integer with 3 digits always with leading spaces like '  5'
    return str(int(round(cpu_usage))).rjust(2)

def get_memory_info():
    meminfo = {}
    with open('/proc/meminfo', 'r') as f:
        for line in f:
            parts = line.split(':')
            key = parts[0].strip()
            value = int(parts[1].strip().split()[0])  # Get value in kB
            meminfo[key] = value
    return meminfo

def calculate_memory_usage():
    meminfo = get_memory_info()
    total = meminfo.get('MemTotal', 0)
    available = meminfo.get('MemAvailable', 0)
    used = total - available

    # Calculate usage percentage
    usage_percentage = (used / total) * 100
    return round(usage_percentage, 2), total, used, available



if __name__ == "__main__":
    usage = calculate_cpu_usage()
    print(f"CPU Usage: {usage}%")

    usage, total, used, available = calculate_memory_usage()
    print(f"Memory Usage: {usage}%")
    print(f"Total: {total // 1024} MB")
    print(f"Used: {used // 1024} MB")
    print(f"Available: {available // 1024} MB")

