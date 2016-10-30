Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 30 Oct 2016 15:35:04 +0200
Message-ID: <CAOQ4uxgFBZumexGm0qtN70qwmYraxMMEzHgSLHHzT1ZYUnn-hw@mail.gmail.com>
Subject: ACL test failures on overlayfs over tmpfs
Content-Type: multipart/alternative; boundary=047d7b873cd0bcbe690540152855
To: Andreas Gruenbacher <agruenba@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

--047d7b873cd0bcbe690540152855
Content-Type: text/plain; charset=UTF-8

Hi guys,

I recently learned about a set of ACL tests that were added
by Tuxera to pjdtests. I pushed a branch to my github with
some fixes to build and run on recent Linux:

https://github.com/amir73il/pjdfstest.git #tuxera-acl-tests

While the set of ACL tests pass on overlayfs over xfs/ext4
some fail on overlayfs over tmpfs.
Below is a snippet from one of the failed tests.
The test setup grants read-only access to a 'foreign' user
and write-only access to a 'foreign' group (i.e. not the owner).

The return value from the 4 open statements at the bottom
of the test are correct when run on tmpfs/xfs/ext4 and they
are correct when run on overlayfs over xfs/ext4.

However, when running the same test on overlayfs over tmpfs
(both lower and upper) all 4 open statements fail with EACCESS
as if the ACL permission grant for the foreign user/group are skipped.

I tried following the permission checks code and got lost.

Can you shed some light on this for me?

Thanks,
Amir.

# create a basic directory, clean its inherited ACLs, and check initial ACL
# 1
expect 0 mkdir ${d0} 0777
expect 0 setfacl ${d0} b
expect 0 create ${d0}/${n1} 0644
expect 0 chown ${d0}/${n1} 65533 65533
expect 'u::rw-,g::r--,o::r--' getfacl ${d0}/${n1} access
expect EACCES getfacl ${d0}/${n1} default
#
# Grant read or write access to another user or group, check access
# 6
expect 0 setfacl ${d0}/${n1} m 'u::-,g::-,o::-,m::rw,u:65531:r,g:65532:w'
expect 0 -u 65531 -g 65531 open ${d0}/${n1} O_RDONLY
expect EACCES -u 65531 -g 65531 open ${d0}/${n1} O_RDWR
expect 0 -u 65532 -g 65532 open ${d0}/${n1} O_WRONLY
expect EACCES -u 65532 -g 65532 open ${d0}/${n1} O_RDWR

--047d7b873cd0bcbe690540152855
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi guys,</div><div><br></div><div>I recently learned =
about a set of ACL tests that were added</div><div>by Tuxera to pjdtests. I=
 pushed a branch to my github with</div><div>some fixes to build and run on=
 recent Linux:</div><div><br></div><div><a href=3D"https://github.com/amir7=
3il/pjdfstest.git" target=3D"_blank">https://github.com/amir73il/<wbr>pjdfs=
test.git</a> #tuxera-acl-tests<br></div><div><br></div><div>While the set o=
f ACL tests pass on overlayfs over xfs/ext4</div><div>some fail on overlayf=
s over tmpfs.</div><div>Below is a snippet from one of the failed tests.</d=
iv><div>The test setup grants read-only access to a &#39;foreign&#39; user<=
/div><div>and write-only access to a &#39;foreign&#39; group (i.e. not the =
owner).</div><div><br></div><div>The return value from the 4 open statement=
s at the bottom</div><div>of the test are correct when run on tmpfs/xfs/ext=
4 and they</div><div>are correct when run on overlayfs over xfs/ext4.</div>=
<div><br></div><div>However, when running the same test on overlayfs over t=
mpfs</div><div>(both lower and upper) all 4 open statements fail with EACCE=
SS</div><div>as if the ACL permission grant for the foreign user/group are =
skipped.</div><div><br></div><div>I tried following the permission checks c=
ode and got lost.</div><div><br></div><div>Can you shed some light on this =
for me?</div><div><br></div><div>Thanks,</div><div>Amir.</div><div><br></di=
v><div># create a basic directory, clean its inherited ACLs, and check init=
ial ACL</div><div># 1</div><div>expect 0 mkdir ${d0} 0777</div><div>expect =
0 setfacl ${d0} b</div><div>expect 0 create ${d0}/${n1} 0644</div><div>expe=
ct 0 chown ${d0}/${n1} 65533 65533</div><div>expect &#39;u::rw-,g::r--,o::r=
--&#39; getfacl ${d0}/${n1} access</div><div>expect EACCES getfacl ${d0}/${=
n1} default</div><div>#</div><div># Grant read or write access to another u=
ser or group, check access</div><div># 6</div><div>expect 0 setfacl ${d0}/$=
{n1} m &#39;u::-,g::-,o::-,m::rw,u:65531:<wbr>r,g:65532:w&#39;</div><div>ex=
pect 0 -u 65531 -g 65531 open ${d0}/${n1} O_RDONLY</div><div>expect EACCES =
-u 65531 -g 65531 open ${d0}/${n1} O_RDWR</div><div>expect 0 -u 65532 -g 65=
532 open ${d0}/${n1} O_WRONLY</div><div>expect EACCES -u 65532 -g 65532 ope=
n ${d0}/${n1} O_RDWR</div><div><br></div></div>

--047d7b873cd0bcbe690540152855--
