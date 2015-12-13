import pypyodbc
import cgi, cgitb 


form = cgi.FieldStorage() 
search = form.getvalue('search')

connection = pypyodbc.connect('Driver={SQL Server};'
                                'Server=localhost;'
                                'Database=user;'
                                'uid=sql;pwd=Sqlsql1!')


print ("HTTP/1.0 200 OK")
print ("Content-Type: text/html\n\n\n")
print('BETA user Information search<br />')
print('Good job you got a domain user account : FLAG-6235401daa92365013116dac3eddc38e<br /><br />')
print('<form action="index.py" method="get">')
if (search):	
	print('Last Name Search: <input type="text" name="search" value="{0}" >  <br />'.format(search))
else:
	print('Last Name Search: <input type="text" name="search" value="%" >  <br />'.format(search))
	search = "%"
print('<input type="submit" value="Search" />') 
print('</form>')

cursor = connection.cursor()
SQLCommand = ('SELECT Name,LastName,City FROM "user".dbo."user" WHERE Name LIKE \'{0}\''.format(search))
#print(SQLCommand+ "<br />")
cursor.execute(SQLCommand)


results = cursor.fetchone() 

while results:
     print ("Name :" +  str(results[0]) + " " + results[1] + " lives in " + results[2] + "<br>")
     results = cursor.fetchone()






connection.close()
