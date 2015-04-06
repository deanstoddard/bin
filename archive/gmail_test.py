#!/usr/bin/env python

import smtplib


GMAIL_USERNAME="dean@stoddards-kc.com"
GMAIL_PASSWORD="1938Munich"
email_subject="Test"
recipient="deanstoddard@yahoo.com"

# The below code never changes, though obviously those variables need values.
session = smtplib.SMTP('smtp.gmail.com', 587)
session.ehlo()
session.starttls()
session.login(GMAIL_USERNAME, GMAIL_PASSWORD)
# This is how you send an email in Python:

#headers = "\r\n".join(["from: " + GMAIL_USERNAME,
#                       "subject: " + email_subject
#                       "to: " + recipient,
#                       "mime-version: 1.0",
#                       "content-type: text/html"])

headers='''from: GMAIL_USERNAME\r\nsubject: test\r\nto: deanstoddard@yahoo.com\r\n
   mime-version: 1.0\r\ncontent-type: text/html'''

# body_of_email can be plaintext or html!                    
body_of_email="Stuff"
content = headers + "\r\n" + body_of_email

content="Stuff"
session.sendmail(GMAIL_USERNAME, recipient, content)
