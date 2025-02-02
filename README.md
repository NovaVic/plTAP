# plTAP
### A TAP emititng framework for Oracle PL/SQL

This is an attempt to write a lightweight TAP emitting framework for Oracle's procedural language PL/SQL.

TAP stands for [Test Anything Protocol](https://testanything.org/) ... "a simple text-based interface between testing modules in a test harness." It started life as a Perl test suite, but has spawned implementations in many other languages, perhaps due to its human readable output and therefore ease of implementation and extension according to environment.

This project has taken inspiration from [PostgreSQL's excellent pgTAP extension](http://pgtap.org/), and is trying to fulfil similar functionality to pipe the results as a SQL result set.  As such, results can be re-directed easily e.g. from a Maven software build and parsed by TAP consumers such as the Jenkins plugin.

This code contains Oracle SQL and PL/SQL only, in files as follows:

 * **sqlplus/sqlplus_install.sql -** The DDL to create the pltap schema and the pltap.tap package. In fact, the schema should be passed as a parameter to the script depending what you want to call the schema e.g. calling it pltap:
```
sqlplus SYSTEM/oracle @sqlplus/sqlplus_install.sql pltap
```
 * **sqlplus/sqlplus_example.sql -** The DDL to create a users schema containing some unit tests predicated on the pltap.tap package. This isn't required but populates an example schema with calls to the tap package.  The schema should be passed as a parameter e.g.
```
sqlplus SYSTEM/oracle @sqlplus/sqlplus_example.sql example_tap
```
 * **example_call.sql -** An example of how to call the unit tests from a SQL statement, given the example schema has been installed as example_tap.
 * **Dockerfile -** Uses wnameless/oracle-xe-11g from Dockerhub to run sqlplus, install the TAP schema, and build a new image e.g.
```
Some useful instructions

build instruction : 
  docker build -t pltap/oracle-xe-21 ./  <---this one for image built 

Run instructions:
 docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<your password> pltap/oracle-xe-21

 docker run -d -p 1521:1521 -e ORACLE_RANDOM_PASSWORD=yes pltap/oracle-xe-21

 docker run -d -p 1521:1521 -e ORACLE_PASSWORD=oracle pltap/oracle-xe-21   <---use this one

 docker exec -it <mycontainer> bash

```
User defined unit tests are created in a separate database package of the users choosing.  Each test is predicated on the **ok()** function (within the pltap.tap package):
```
CREATE OR REPLACE PACKAGE example_tap.mytests
AS
	FUNCTION test_tap       RETURN VARCHAR2; 
END mytests;
/
CREATE OR REPLACE PACKAGE BODY example_tap.mytests
AS
	FUNCTION test_tap    RETURN VARCHAR2
	IS 
	BEGIN
		RETURN tap.ok(true, 'this is a test');
	END test_tap;
END mytests;
/
```
Running the tests within this package involve piplining the output of the ok function.  This is called as follows:
```
select * from table(tap.run_tests('example_tap','mytests') );
```

```
1..4
okay 1 - this is a test
not okay 2 - this is another test
not okay 3 - test that hello=world
not okay 4 - EXAMPLE_TAP.MYTESTS.TEST_TAP_4:ORA-01476: divisor is equal to zero
```

### Future
The **ok()** function is a simple assert familar in all testing frameworks.  With this in place, any test for equality of objects, exceptions being thrown, presence of database objects etc. may be written.

