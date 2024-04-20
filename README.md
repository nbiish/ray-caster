# 👍🧿👄🧿💻   
# Raycast How-To:  
### INSTALL AND ADDING SCRIPTS TO RAYCAST:

1. Install [Raycast](https://www.raycast.com/)
2. open Raycast
3. press CMD+, (CMD+comma)
4. press CMD+n
5. select "add script directory"
6. choose ../where/you/cloned/../scripts

## If you're using API's for:
### Groq, OpenAI, Google, Claude, StableDiffusion

    create a .env in 
    ../where/you/cloned/../scripts
- for an example check [.env-example](https://github.com/nbiish/ray-caster/blob/main/raycast/scripts/.env-example)

- or edit../raycast/scripts/.env-example  

  (remove the -example section when done)
```
-------------------------------------
OR


touch ../scripts/.env
echo 'API_KEY=your-key' >> ../scripts/.env
```  

---  
### HOW TO USE IN RAYCAST:

```
1) use raycast raycast hotkey
2) type name of script


USAGE EXAMPLES:
--------------------------------------------
{raycast hotkey} + ollama-solve "some-text"

{raycast hotkey} + ollama-choose "model name" "prompt"

{raycast hotkey} + call-claude-haiku "some-text"

{raycast hotkey} + call-groq-amole "some-text"

{raycast hotkey} + call-gem-in-ai "some-text"

{raycast hotkey} + call-sd3 "ratio" "prompt" "neg-prompt"
```
### Customize scripts in:

```
../raycast/scripts
```
--- 
# Use local with ollama🦙
### Install  Ollama📂
* maxOS [Ollama](https://ollama.com/download/mac)  
* Linux [Ollama](https://ollama.com/download/linux)  
* Windows [Ollama](https://ollama.com/download/windows)  

```
ollama run your-wildest-dreams "ober-der"  
```

---  
## Customizing ollama🛠️:
### Modelfiles  
```
TODO
- add how-to
```
# Use .bashrc/.zshrc alias instead🦑🤖
## DESKTOP TODO:
- add script that adds alias of all .sh files in ../raycast/scripts to .bashrc or .zshrc (check)  

- formatt nice like..
     - ...
     - ###shell-caster ###
     - new alias group
     - ###shell-caster ###
     - ...

- test a removal sed command for new script to remove from rc file when user is done  
---
## MOBILE TODO:
- learn about tmux alias directory
- learn about tmux venv
---
- does ollama work?
- figure out what doesnt work

---
## HOW-TO-CAST-SHELL:
```
1) pwd in ../where/you/cloned/../scripts
(copy output)

2) vim/nano ~/.bashrc OR .zshrc

3) ...

4) ...
```