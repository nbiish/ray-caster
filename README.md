# 👍🧿👄🧿💻   
# [Raycast](https://www.raycast.com/) stuff:  
### ADDING SCRIPTS TO RAYCAST:
```
    1. open raycast
    2. press CMD+, <--(CMD+comma)
    3. press CMD+n
    4. select "add script directory"
    5. choose ../where/you/cloned/../scripts
```  
### If you're using Claude, Groq, OpenAI, Google API:
```
# create a .env in 
# ../where/you/cloned/../scripts
# and enter

touch .env

----------------------

# add api_keys in 
# ../scripts

echo 'SOME_API_KEY=your-key' >> .env
```  
- for and example check [.env-example](https://github.com/nbiish/ray-caster/blob/main/raycast/scripts/.env-example)
- or edit../raycast/scripts/.env-example  
(remove the -example section when done)

---  
### HOW TO USE IN RAYCAST:

```
1) use raycast raycast hotkey
2) type name of script


USAGE EXAMPLES:
--------------------------------------------
{raycast hotkey} + ollama-solve "some-text"

{raycast hotkey} + claude-haiku "some-text"

{raycast hotkey} + groq-amole "some-text"

{raycast hotkey} + gem-in-ai "some-text"
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
## TODO  
- add script that adds alias of all .sh files in ../raycast/scripts to .bashrc or .zshrc (check)  

- formatt nice like..
     - ...
     - ###shell-caster ###
     - new alias group
     - ###shell-caster ###
     - ...

- test a removal sed command for new script to remove from rc file when user is done  

## HOW-TO:
```
1) pwd in ../where/you/cloned/../scripts
(copy output)

2) vim/nano ~/.bashrc OR .zshrc

3) ...

4) ...
```