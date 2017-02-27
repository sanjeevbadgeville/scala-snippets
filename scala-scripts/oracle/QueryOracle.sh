#!/bin/sh
exec scala -classpath "./jars/*:." "$0" "$@"
!#

import java.sql.DriverManager
import java.sql.Connection

object ScalaOracleJdbcConnectSelect {

  def main(args: Array[String]) {
    val driver = "oracle.jdbc.driver.OracleDriver"
    val url = "jdbc:oracle:thin:@<DBHOST>:1521:<SID>"
    val username = "<USERNAME>"
    val password = "<PASSWORD>"

    var connection:Connection = null
    DriverManager.setLoginTimeout(5);
    try {
      // make the connection
      Class.forName(driver)
      connection = DriverManager.getConnection(url, username, password)

      // create the statement, and run the select query
      val statement = connection.createStatement()
      val resultSet = statement.executeQuery("SELECT TO_CHAR (SYSDATE, 'MM-DD-YYYY HH24:MI:SS') \"NOW\" FROM DUAL")

      while ( resultSet.next() ) {
        println(s"output: ${resultSet.getString(1)}")
      }
    } catch {
      case e:Throwable => e.printStackTrace
    } finally {
      connection.close()
    }
  }

}
