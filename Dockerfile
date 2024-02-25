FROM gvenzl/oracle-xe:21.3.0-slim
MAINTAINER Suraiya Khan


ENV ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE 
ENV ORACLE_SID=XE
ENV PATH=${ORACLE_HOME}:${ORACLE_HOME}/bin:${PATH}:${ORACLE_BASE}
ENV LD_LIBRARY_PATH=${ORACLE_HOME}/lib
RUN export LD_LIBRARY_PATH  
RUN export PATH


RUN mkdir -p ${ORACLE_BASE}/sqlplus_orig_scripts
RUN mkdir -p ${ORACLE_BASE}/what_to_run
COPY --chown=oracle:oinstall ./sqlplus/* ${ORACLE_BASE}/sqlplus_orig_scripts/


#verification
#RUN cat ${ORACLE_BASE}/sqlplus_orig_scripts/sqlplus_install.sql

ENTRYPOINT ${ORACLE_BASE}/sqlplus_orig_scripts/container-entrypoint-updated.sh --nowait 




