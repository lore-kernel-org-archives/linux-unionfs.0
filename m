Return-Path: <cgxu@mykernel.net>
From: Chengguang Xu <cgxu@mykernel.net>
Message-Id: <553026C2-3A8C-4FE3-9E36-AC9E157D503A@mykernel.net>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_7A826C38-49EB-495D-9A1F-751770665B01"
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v3] ovl: Sync upper dirty data when sync overlayfs
Date: Wed, 29 Nov 2017 11:01:53 +0800
In-Reply-To: <CAOQ4uxjVekor=Bk26=OS4E2=L8+qMUw08nsY_Bn=iDsLSs6Dcg@mail.gmail.com>
References: <1511872768-12759-1-git-send-email-cgxu@mykernel.net>
 <CAOQ4uxjVekor=Bk26=OS4E2=L8+qMUw08nsY_Bn=iDsLSs6Dcg@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>


--Apple-Mail=_7A826C38-49EB-495D-9A1F-751770665B01
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=gb2312


> =D4=DA 2017=C4=EA11=D4=C228=C8=D5=A3=AC=CF=C2=CE=E710:58=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Nov 28, 2017 at 2:39 PM, Chengguang Xu <cgxu@mykernel.net> =
wrote:
>> Executes filesystem sync or umount on overlayfs,
>=20
> When executing...
>=20
>> dirty data does not be synced as expected on upper filesystem.
>=20
> ...does not get synced...
>=20
>> This patch fixes sync filesystem method to keep data consistency
>> for overlayfs.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
>>=20
>> ---
>>=20
>=20
> Chengguang,
>=20
> This patch looks fine, but it is not based on overlayfs-next nor on =
master.
> I guess by "mainline" you meant latest release or something.
> Please rebase V4 on overlayfs-next from Miklos' tree.
>=20
> I enhanced my origin syncfs test to check for syncing of upper files:
> https://github.com/amir73il/overlayfs/blob/master/tests/xfs_syncfs.sh
>=20
> Without your fix, the upper file delalloc blocks are not flushed after =
syncfs,
> but only after fsync. With your fix delalloc blacks are flushed by =
syncfs.
>=20
> Can you take the task to make this simple test into an xfstest?
> If you need help finding your way around xfstests, I can help you with =
that.
> You do not need the xfs specific parts of the test, only the generic =
delalloc
> part.
>=20
> I think it is best to make a generic/* test (i.e. not fs specific), =
which tests
> flushing of delalloc blocks on sync/syncfs/fsync for fs that support =
delalloc,
> but it may also make sense to have an overlay/* specific regression =
test for
> syncfs. We can discuss those details after you post a test.
>=20

OK, I=A1=AFll  make test case for different sync scenarios.


> Thanks,
> Amir.
>=20


--Apple-Mail=_7A826C38-49EB-495D-9A1F-751770665B01
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=gb2312

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dgb2312"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><div =
dir=3D"auto" style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;" class=3D""><div class=3D""><div =
style=3D"color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"color: rgb(0, 0, 0); letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space;" class=3D""><div style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><br =
class=3D""></div></div></div></div></div><div><blockquote type=3D"cite" =
class=3D""><div class=3D"">=D4=DA 2017=C4=EA11=D4=C228=C8=D5=A3=AC=CF=C2=CE=
=E710:58=A3=ACAmir Goldstein &lt;<a href=3D"mailto:amir73il@gmail.com" =
class=3D"">amir73il@gmail.com</a>&gt; =D0=B4=B5=C0=A3=BA</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><div class=3D"">On =
Tue, Nov 28, 2017 at 2:39 PM, Chengguang Xu &lt;<a =
href=3D"mailto:cgxu@mykernel.net" class=3D"">cgxu@mykernel.net</a>&gt; =
wrote:<br class=3D""><blockquote type=3D"cite" class=3D"">Executes =
filesystem sync or umount on overlayfs,<br class=3D""></blockquote><br =
class=3D"">When executing...<br class=3D""><br class=3D""><blockquote =
type=3D"cite" class=3D"">dirty data does not be synced as expected on =
upper filesystem.<br class=3D""></blockquote><br class=3D"">...does not =
get synced...<br class=3D""><br class=3D""><blockquote type=3D"cite" =
class=3D"">This patch fixes sync filesystem method to keep data =
consistency<br class=3D"">for overlayfs.<br class=3D""><br =
class=3D"">Signed-off-by: Chengguang Xu &lt;<a =
href=3D"mailto:cgxu@mykernel.net" class=3D"">cgxu@mykernel.net</a>&gt;<br =
class=3D""><br class=3D"">---<br class=3D""><br =
class=3D""></blockquote><br class=3D"">Chengguang,<br class=3D""><br =
class=3D"">This patch looks fine, but it is not based on overlayfs-next =
nor on master.<br class=3D"">I guess by "mainline" you meant latest =
release or something.<br class=3D"">Please rebase V4 on overlayfs-next =
from Miklos' tree.<br class=3D""><br class=3D"">I enhanced my origin =
syncfs test to check for syncing of upper files:<br class=3D""><a =
href=3D"https://github.com/amir73il/overlayfs/blob/master/tests/xfs_syncfs=
.sh" =
class=3D"">https://github.com/amir73il/overlayfs/blob/master/tests/xfs_syn=
cfs.sh</a><br class=3D""><br class=3D"">Without your fix, the upper file =
delalloc blocks are not flushed after syncfs,<br class=3D"">but only =
after fsync. With your fix delalloc blacks are flushed by syncfs.<br =
class=3D""><br class=3D"">Can you take the task to make this simple test =
into an xfstest?<br class=3D"">If you need help finding your way around =
xfstests, I can help you with that.<br class=3D"">You do not need the =
xfs specific parts of the test, only the generic delalloc<br =
class=3D"">part.<br class=3D""><br =
class=3D""></div></div></blockquote><blockquote type=3D"cite" =
class=3D""><div class=3D""><div class=3D"">I think it is best to make a =
generic/* test (i.e. not fs specific), which tests<br class=3D"">flushing =
of delalloc blocks on sync/syncfs/fsync for fs that support delalloc,<br =
class=3D"">but it may also make sense to have an overlay/* specific =
regression test for<br class=3D"">syncfs. We can discuss those details =
after you post a test.<br class=3D""><br =
class=3D""></div></div></blockquote><div><br class=3D""></div><div>OK, =
I=A1=AFll &nbsp;make test case for different =
sync&nbsp;scenarios.</div><div><br class=3D""></div><br =
class=3D""><blockquote type=3D"cite" class=3D""><div class=3D""><div =
class=3D"">Thanks,<br class=3D"">Amir.<br class=3D""><br =
class=3D""></div></div></blockquote></div><br =
class=3D""></div></body></html>=

--Apple-Mail=_7A826C38-49EB-495D-9A1F-751770665B01--
