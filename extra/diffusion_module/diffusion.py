#
# idea computer Web Server
# Generates images using CPU and StabilityAI SD-Turbo from HuggingFace.
# This is to remove any and all rate-limits to the application.
#
# The web server will show a "loading" image until a proper one is provided.
# The Flutter app can continue requesting the end-point until the image is available.
#
# The web server will NOT generate the image unless it must, at which point the task
# is deferred using threads. If an image is currently being generated and a request is
# made yet again - it will simply ignore the said request.
#

# pip install diffusers
from diffusers import AutoPipelineForText2Image

currently_generating = set()

diffusion_pipe = AutoPipelineForText2Image.from_pretrained("stabilityai/sd-turbo")
diffusion_pipe.to("cpu")

def run_diffusion_prompt(prompt):
    global diffusion_pipe

    print(f'Prompt \'{prompt}\' is new, generating a new image...')
    image = diffusion_pipe(prompt='artistic sketch of ' + ', '.join(prompt.split('_')),
                 num_inference_steps=1, 
                 guidance_scale=0.0, 
                 width=320, height=320).images[0]
    
    image.save(f'generated/{prompt}.png')

    try:
        currently_generating.remove(prompt) # this is ok dw
    except:
        pass


from flask import Flask, abort, send_file, send_from_directory
import os
import threading

app = Flask(__name__)

@app.route("/")
def index():
    return "<h1>idea computer Web Server is OPERATIONAL!</h1>"

@app.route("/generated/<prompt>")
def image(prompt):
    filename = prompt + ".png"
    if os.path.exists("generated/" + filename):
        return send_from_directory(
            "generated",
            filename,
            mimetype='image/png'
        )
    else:
        if (currently_generating):
            abort(404)
        currently_generating.add(prompt)

        thread = threading.Thread(target=run_diffusion_prompt, args=(prompt,))
        thread.start()
        abort(404)
