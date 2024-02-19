#FROM oracleinanutshell/oracle-xe-11g:latest

FROM gvenzl/oracle-xe:21.3.0-slim
MAINTAINER Suraiya Khan


#ENV ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
ENV ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE 
ENV ORACLE_SID=XE
ENV PATH=${ORACLE_HOME}:${ORACLE_HOME}/bin:${PATH}:${ORACLE_BASE}
ENV LD_LIBRARY_PATH=${ORACLE_HOME}/lib
RUN export LD_LIBRARY_PATH  
RUN export PATH


RUN mkdir -p ${ORACLE_BASE}/sqlplus_orig_scripts
RUN mkdir -p ${ORACLE_BASE}/what_to_run
COPY --chown=oracle:oinstall ./sqlplus/* ${ORACLE_BASE}/sqlplus_orig_scripts/
#COPY --chown=oracle:oinstall ./script_with_params.sql ${ORACLE_BASE}/what_to_run/

#COPY sqlplus ${ORACLE_BASE}/sqlplus

#verification
#RUN cat ${ORACLE_BASE}/sqlplus_orig_scripts/sqlplus_install.sql

#CMD ["/bin/bash"]  <--- for debugging when we are not using entrypoint statement


# For Oracle 11
#ENTRYPOINT /usr/sbin/startup.sh && \ 
#sqlplus SYSTEM/oracle @sqlplus/sqlplus_install.sql pltap && \
#sqlplus SYSTEM/oracle @sqlplus/sqlplus_example.sql example_tap 
 
#Oracle 21.3.0 --- does not work okay 
#ENTRYPOINT container-entrypoint.sh && \ 
#run_custom_scripts ${ORACLE_BASE}/what_to_run/

ENTRYPOINT ${ORACLE_BASE}/sqlplus_orig_scripts/container-entrypoint-updated.sh --nowait 


#Some useful instructions

#build instruction : docker build -t pltap/oracle-xe-21 ./  <---this one
#run instruction: docker run -d -p 49162:22 -p 49163:1521 pltap/oracle-xe-11  <--- for image built 
#from oracleinanutshell/oracle-xe-11g:latest

#docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<your password> pltap/oracle-xe-21

#docker run -d -p 1521:1521 -e ORACLE_RANDOM_PASSWORD=yes pltap/oracle-xe-21

#docker run -d -p 1521:1521 -e ORACLE_PASSWORD=oracle pltap/oracle-xe-21   <---this one

#docker exec -it <mycontainer> bash

#https://github.com/gvenzl/oci-oracle-xe

#https://hub.docker.com/r/oracleinanutshell/oracle-xe-11g  (older)
