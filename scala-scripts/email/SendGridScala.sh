#!/bin/sh
exec /opt/lang/scala/scala-2.11.7/bin/scala -classpath "lib/sendgrid-java.jar:." "$0" "$@"
!#

import com.sendgrid._

object SendGridScala {
  def main(args: Array[String]) {
    println("Sending Email using SendGrid! " + args.toList)
    val sendgrid:SendGrid = new SendGrid("<YOUR_API_KEY>")

    val email:SendGrid.Email = new SendGrid.Email()
    email.addTo("to@example.com")
    email.setFrom("from@example.com")
    email.setSubject("Hello World")
    email.setText("My first email with SendGrid in Scala!")

    try {
      val response: SendGrid.Response = sendgrid.send(email)
      println(response.getMessage())
    }
    catch {
      case e:SendGridException => println(e)
    }
  }
}

SendGridScala.main(args)
