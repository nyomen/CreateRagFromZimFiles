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
2. Use the zimdump script like this:<br/> zimdump dump --dir=WHERE_YOU_WANT_TO_PUT_THE_DUMP_FOLDER WHERE_YOUR_ZIM_FILE_IS<br/>Most likely there will be exceptions, because I don´t know about this script, but it can not take all the files, and then just puts them in an exceptionsfolder. <br/> If the script refuses to create anything you can try to do a zimsplit(also one script inside the zim-tools) first - it says it splits the zimfile intelligent, nobody knows what this means, but after splitting the file and taking the first splitted file mostly called "aa" in the end, the zimdump script was at least running through.
3. Start the clean_html_folder.sh Script(its in the src files in this repo) and add the WHERE_YOU_WANT_TO_PUT_THE_DUMP_FOLDER as parameter.<br/>
What its does: It finds all the html MIME type files in that folder recursivly and in parallel (so it will eat up quite some system performance), after that it will kick out all the html tags inside the zimdump and reduce it to plane text. This happens also in parallel and will take all the system power it can get. (for my example just the scanning of 14M files(whole wiki without pics) was taking 4:30h)
4. #GO on with creating the RAG jsonl script#
