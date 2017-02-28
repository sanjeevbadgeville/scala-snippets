#!/bin/sh
exec scala -classpath "./jars/*:." "$0" "$@"
!#

import javax.mail._
import javax.mail.internet._
import java.util.Properties._
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import java.util.Calendar
import java.util.Date
import scala.sys.process._

object SendMail {
    val dt = new DateTime()
    val prevDt = dt.plusDays(-1)
    val dtfOut = DateTimeFormat.forPattern("MM/dd/yyyy")
    val dtfOutYYYY = DateTimeFormat.forPattern("yyyy/MM/dd")
    val prevDtFrmt = dtfOut.print(prevDt)
    val prevDtFrmtYYYY = dtfOutYYYY.print(prevDt)
    var bodyText = s"Errors in jobs that ran on $prevDtFrmt:\n\n"
    val startBTSize = bodyText.size

    def checkMatch(line: String) = {
        if (line contains prevDtFrmt) bodyText += s"$line \n"
        if (line contains prevDtFrmtYYYY) bodyText += s"$line \n"
    }

    def errorContent(): (Stream[String]) = {
        val cmd = Seq("egrep", "-i",  "(error|exception)", "<FILE>")
        cmd lines_!
    }

    def main(args: Array[String]) {

        val content:List[String] = errorContent.toList
        content foreach { n => checkMatch(n) }

        // Set up the mail object
        val properties = System.getProperties
        properties.put("mail.smtp.host", "localhost")
        val session = Session.getDefaultInstance(properties)
        val message = new MimeMessage(session)

        // Set the from, to, subject, body text
        message.setFrom(new InternetAddress("<FROMEMAIL>"))
        message.setRecipients(Message.RecipientType.TO, "<TOEMAIL>")
        message.setSubject("Errors in Jobs Submitted")
        message.setText(bodyText)

        // And send it
        if (bodyText.size > startBTSize) {
          Transport.send(message)
        }
    }
}
