#-*- coding:utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')
import mysql.connector
import requests
import csv
from bs4 import BeautifulSoup
conn = mysql.connector.connect(user="root", password="0427", host="localhost", database="textmaster")
c = conn.cursor()
c.execute("SELECT * FROM editorial")
row = c.fetchone()
filename = 1
while row is not None:
	url = row[0]
	r = requests.get(url)
	p = r.content
	soup = BeautifulSoup(p, 'lxml')
	div_all = soup.find_all('div')
	div_nonull = []
	for i in range(0, len(div_all)-1):
		div_nonull.append(div_all[i].text.replace("\n", ""))
	final_complete = []
	final_count = []
	for i in range(0, len(div_all)-1):
		if len(div_nonull[i]) > 800:
			s = div_nonull[i].replace(" ", "")
			opt = len(s)-2
			if s.find(u"다.", opt) == opt:
				final_complete.append(div_nonull[i])
			elif s.count(u"다.") > 10:
				final_count.append(div_nonull[i])
	min=0
	if len(final_complete) != 0:
		for i in range(1, len(final_complete)-1):
			if len(final_complete[i]) < len(final_complete[i-1]):
				min = i
		if len(final_complete[min]) < 4000:
			f = open("C:\Python27\user\%s.txt" % filename, "wt")
			f.write(final_complete[min])
			f.close()
		else:
			f = open("C:\Python27\user\%s.txt" % filename, "wt")
			f.write("Sorry")
			f.close()
	elif len(final_count) != 0:
		for i in range(1, len(final_count)-1):
			if len(final_count[i]) < len(final_count[i-1]):
				min = i
		if len(final_count[min]) < 4000:
			f = open("C:\Python27\user\%s.txt" % filename, "wt")
			f.write(final_count[min])
			f.close()
		else:
			f = open("C:\Python27\user\%s.txt" % filename, "wt")
			f.write("Sorry")
			f.close()
	else:
		f = open("C:\Python27\user\%s.txt" % filename, "wt")
		f.write("Sorry")
		f.close()
	row = c.fetchone()
	filename = filename + 1

c.execute("SELECT keyword FROM personal order by id desc limit 1")
key = c.fetchone()
key = key[0]
f = open("C:\Python27\user/keyword.txt", "wt")
f.write(key)
f.close()

c.execute("SELECT * FROM personal WHERE gender='female' and keyword='%s'" % key)
fe_num = c.fetchall()
c.execute("SELECT * FROM personal WHERE gender='male' and keyword='%s'" % key)
ma_num = c.fetchall()
cwr = csv.writer(open("C:\Python27\user/gender.csv", "w"))
cwr.writerow(["gender", "number"])
cwr.writerow(["female", len(fe_num)])
cwr.writerow(["male", len(ma_num)])

c.execute("SELECT * FROM personal WHERE age='10' and keyword='%s'" % key)
num_10 = c.fetchall()
c.execute("SELECT * FROM personal WHERE age='20' and keyword='%s'" % key)
num_20 = c.fetchall()
c.execute("SELECT * FROM personal WHERE age='30' and keyword='%s'" % key)
num_30 = c.fetchall()
c.execute("SELECT * FROM personal WHERE age='40' and keyword='%s'" % key)
num_40 = c.fetchall()
c.execute("SELECT * FROM personal WHERE age='50' and keyword='%s'" % key)
num_50 = c.fetchall()
cwr = csv.writer(open("C:\Python27\user/age.csv", "w"))
cwr.writerow(["age", "number"])
cwr.writerow(["10s", len(num_10)])
cwr.writerow(["20s", len(num_20)])
cwr.writerow(["30s", len(num_30)])
cwr.writerow(["40s", len(num_40)])
cwr.writerow(["50s", len(num_50)])

c.execute("SELECT * FROM personal WHERE region='seoul' and keyword='%s'" % key)
seoul = c.fetchall()
c.execute("SELECT * FROM personal WHERE region='kyungki' and keyword='%s'" % key)
kyungki = c.fetchall()
c.execute("SELECT * FROM personal WHERE region='chung' and keyword='%s'" % key)
chung = c.fetchall()
c.execute("SELECT * FROM personal WHERE region='jun' and keyword='%s'" % key)
jun = c.fetchall()
c.execute("SELECT * FROM personal WHERE region='kyougn' and keyword='%s'" % key)
kyoung = c.fetchall()
c.execute("SELECT * FROM personal WHERE region='kang' and keyword='%s'" % key )
kang = c.fetchall()
cwr = csv.writer(open("C:\Python27\user/region.csv", "w"))
cwr.writerow(["lon", "lat", "total"])
cwr.writerow([126.9860, 37.54100, len(seoul)])
cwr.writerow([127.0095, 37.27461, len(kyungki)])
cwr.writerow([126.909789, 36.275718, len(chung)])
cwr.writerow([125.7517045, 35.0269541, len(jun)])
cwr.writerow([127.458688, 35.813685, len(kyoung)])
cwr.writerow([127.7301, 37.88630, len(kang)])


