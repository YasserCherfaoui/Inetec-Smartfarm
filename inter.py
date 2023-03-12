import threading
import time

def loop_function():
    while True:
        print("I'm from the thread")
        time.sleep(3)
    
t = threading.Thread(target=loop_function)
t.start()
count = 1
while True:
    print(f"I am running {count} time(s)")
    time.sleep(1)
    count+=1
    

    