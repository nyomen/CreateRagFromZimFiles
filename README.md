# CreateRagFromZimFiles
Collection of scripts to extract zimfiles, BeautifulSoup them to lxml (essentialy kicking out all htmlcode in it) and than convert it to a RAG jsonl

# Requirements:
Linux 

https://github.com/openzim/zim-tools

Python

sudo dnf/apt install pv

pip install readability-lxml html2text beautifulsoup4 lxml

# Step-by-Step:

1. Get the zim-tools they are hidden at the top right of the github page, for an unknown reason, so you don´t have to build them by yourself, I also add a directlink here:<br/>
https://download.openzim.org/release/zim-tools/ <br />Just take the newest version for your system.
2. Use the zimdump script like this:<br/> zimdump dump --dir=WHERE_YOU_WANT_TO_PUT_THE_DUMP_FOLDER WHERE_YOUR_ZIM_FILE_IS<br/>Most likely there will be exceptions, because I don´t know about this script, but it can not take all the files, and then just puts them in an exceptionsfolder. <br/> If the script refuses to create anything you can try to do a zimsplit(also one script inside the zim-tools) first - it says it splits the zimfile intelligent, nobody knows what this means, but after splitting the file and taking the first splitted file mostly called "aa" in the end, the zimdump script was at least running throught.
