import tkinter as tk
from model import clf, vectorizer, le
from PIL import ImageTk, Image

# Functions
def predict_res():
    inp = [entry_field1.get()]
    res = clf.predict(vectorizer.transform(inp))
    out = le.inverse_transform(res)
    result['text']="You could be a " + out[0]
    if out[0]=="data scientist":
        result_pic["image"]=ds
    elif out[0]=="java developer":
        result_pic["image"]=jd
    else: result_pic["image"]=se

# Window
window = tk.Tk()

window.title("Job Prediction Model")

window.geometry("400x300")

# Images
se = ImageTk.PhotoImage(Image.open("se.jpg").resize((200, 200), Image.ANTIALIAS))
ds = ImageTk.PhotoImage(Image.open("ds.png").resize((200, 200), Image.ANTIALIAS))
jd = ImageTk.PhotoImage(Image.open("jd.png").resize((200, 200), Image.ANTIALIAS))
qm = ImageTk.PhotoImage(Image.open("qm.png").resize((200, 200), Image.ANTIALIAS))

# Labels
question = tk.Label(text="What are your skills?")
question.grid()
entry_field1 = tk.Entry()
entry_field1.grid(column=1, row=0)

result = tk.Label(text="")
result.grid(column=1, row=1)
result_pic = tk.Label(image = qm)
result_pic.grid(column=1, row = 2)

# Buttons
button1 = tk.Button(text="Predict", command=predict_res)
button1.grid(column=2, row=0)



window.mainloop()
