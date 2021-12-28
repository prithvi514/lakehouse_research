## Hadoop configuration

### Secure Hive credentials in `hive-site.xml`
```
sudo hadoop credential create javax.jdo.option.ConnectionPassword -provider jceks://file/usr/lib/hive/conf/hive.jceks
```

```
sudo hadoop credential list -provider jceks://file/usr/lib/hive/conf/hive.jceks
```

Remove
```
<property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>password</value>
    <description>password to use against metastore database</description>
  </property>
```

Add
```
 <property>
    <name>hadoop.security.credential.provider.path</name>
    <value>jceks://file/usr/lib/hive/conf/hive.jceks</value>
 </property>
```  


### Secure S3 crendentials in `core-site.xml`
Create a credential keystore: replace `hdfs` with `file` for local storage
```
hadoop credential create fs.s3a.access.key -provider jceks://hdfs/tmp/softlayer_all.jceks -v '123456789'
hadoop credential create fs.s3a.secret.key -provider jceks://hdfs/tmp/softlayer_all.jceks -v 'abcdefgh'
```

Validate the credential keystore
```
 hadoop credential list -provider jceks://hdfs/tmp/softlayer_all.jceks
   Listing aliases for CredentialProvider: jceks://hdfs/tmp/softlayer_all.jceks
   fs.s3a.access.key
   fs.s3a.secret.key
```

Update `core-site.xml`
```
<property>
  <name>hadoop.security.credential.provider.path</name>
  <value>jceks://hdfs/tmp/softlayer_all.jceks</value>
</property>
```

Update `hive-site.xml`
```
<property>
  <name>fs.s3a.security.credential.provider.path</name>
  <value>jceks://hdfs/tmp/softlayer_all.jceks</value>
</property>
```