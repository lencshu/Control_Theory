# -*- coding: utf-8 -*- 
from bs4 import BeautifulSoup
import re
import os

if os.path.exists("index.html") :
	os.remove("index.html")
html = open('MC59.html',"r+")

soup = BeautifulSoup(html, "html.parser")
#Rename
divto = soup.find("div", class_="to")
divtoc = soup.find("div", class_="toc")
print divto
if divto!=None or divto!="": 
    divto.append(divtoc)
divto.div['class'] = 'tod'
html = soup.prettify("utf-8")

keyword="outline: 1300px solid #fff;"
post = html.find(keyword)
if post != -1:
    html = html[:post+len(keyword)]+"float:right;padding-left:10px;width:60%;"+html[post+len(keyword):]
    html = html.replace('///C://Users/lencs/Desktop/MC59/git.control_theory/', '')
    html = html.replace('C://Users/lencs/Desktop/MC59/git.control_theory/', '')
    file = open('index.html', 'w')
    file.write(html)
file.close( )
os.remove("MC59.html")
