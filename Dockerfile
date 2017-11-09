# ベースとなるイメージ
FROM jboss/wildfly:10.1.0.Final

# 環境変数
ENV JBOSS_HOME=/opt/jboss/wildfly

USER root
RUN yum install -y net-tools

# ------------------------------
# WildFlyの設定
# ------------------------------
USER jboss
# MySQL JConnector をダウンロード
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar /tmp
# WildFly を設定する CLIスクリプトを配置
COPY assets/setup-wildfly.cli /tmp
# WildFly の管理ユーザを作成
RUN /opt/jboss/wildfly/bin/add-user.sh admin password --silent
# CLIスクリプトを実行して、JConnector や コネクションプール の設定などをする
RUN ${JBOSS_HOME}/bin/jboss-cli.sh --file=/tmp/setup-wildfly.cli
RUN rm -rf ${JBOSS_HOME}/standalone/configuration/standalone_xml_history

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-full.xml"]
