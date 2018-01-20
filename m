From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v4] ovl: Check link ability between upperdir and workdir
Date: Sat, 20 Jan 2018 18:22:23 +0800
Message-ID: <880443F3-540F-4456-B3DB-3E5FA15CA05A@icloud.com>
References: <1513735754-40567-1-git-send-email-cgxu519@icloud.com>
 <CAJfpegt8YTjGvhX-u4Ovf34euRZ9sYHJT5ZXCbL-_H2=m91Uew@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:36510 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbeATKWe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 Jan 2018 05:22:34 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2U00E00N6LRN00@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Sat, 20 Jan 2018 10:22:34 +0000 (GMT)
In-reply-to: <CAJfpegt8YTjGvhX-u4Ovf34euRZ9sYHJT5ZXCbL-_H2=m91Uew@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C220=C8=D5=A3=AC=C9=CF=CE=E712:25=A3=ACMiklos =
Szeredi <miklos@szeredi.hu> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Dec 20, 2017 at 3:09 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> Inspired by encountering unexpected write error with
>> error code -EXDEV when upperdir and workdir having
>> different project quotas. The reason of the error is
>> project quota asks files in it strictly inherit
>> project id of it=A1=AFs own, so rename/link operations
>> between those directories will fail and it may cause
>> failure during copy-up/index-link operations in overlayfs.
>>=20
>> So if upper filesystem supports O_TMPFILE, try to check
>> link ability between upperdir and workdir and if check
>> fails, print a proper warning message to indicate potential
>> possibility of write failure.
>>=20
>> The failure of the check does not directly lead to
>> read-only mounting because in some use cases may only
>> write to upperdir and do not modify anything in lowerdirs.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
>> Changes since v3:
>> - Add more detail comment about motivation to changelog.
>>=20
>> Changes since v2:
>> - Add comment about motivation.
>> - Modify warning message.
>>=20
>> Changes since v1:
>> - Check link ablity between upperdir and workdir instead of checking
>> project ids of upperdir and workdir.
>> - Print a warning message instead of falling to readonly mode.
>>=20
>> fs/overlayfs/super.c | 30 +++++++++++++++++++++++-------
>> 1 file changed, 23 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 76440fe..7d6bd82 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -929,7 +929,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, =
struct path *upperpath)
>>=20
>> static int ovl_make_workdir(struct ovl_fs *ofs, struct path =
*workpath)
>> {
>> -       struct dentry *temp;
>> +       struct dentry *uppertemp, *worktemp;
>>        int err;
>>=20
>>        ofs->workdir =3D ovl_workdir_create(ofs, OVL_WORKDIR_NAME, =
false);
>> @@ -953,12 +953,28 @@ static int ovl_make_workdir(struct ovl_fs *ofs, =
struct path *workpath)
>>        if (!err)
>>                pr_warn("overlayfs: upper fs needs to support =
d_type.\n");
>>=20
>> -       /* Check if upper/work fs supports O_TMPFILE */
>> -       temp =3D ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
>> -       ofs->tmpfile =3D !IS_ERR(temp);
>> -       if (ofs->tmpfile)
>> -               dput(temp);
>> -       else
>> +       /*
>> +        * Check if upper/work fs supports O_TMPFILE and if support, =
check
>> +        * link ability between upperdir and workdir, this is =
inspired by
>> +        * encountering unexpected write error when upperdir and =
workdir
>> +        * having different project ids.
>> +        */
>> +       uppertemp =3D ovl_do_tmpfile(ofs->upper_mnt->mnt_root, =
S_IFREG | 0);
>> +       ofs->tmpfile =3D !IS_ERR(uppertemp);
>> +       if (ofs->tmpfile) {
>> +               worktemp =3D ovl_lookup_temp(ofs->workdir);
>=20
> Have you tested this?  Because there's a warning at the top of
> lookup_one_len() that triggers because of no locking of parent.
>=20
> I can add the locking, it's trivial, but I'd still like you to test
> this on your setup, if it actually does what you promise it does.


Hi Miklos,

Sorry that I could not reproduce it on my setup for the patch because
the test vm has already reclaimed, but I can see the warning in my new
test vm, so I guess maybe =A1=AEDEBUG_BUGVERBOSE=A1=AF configuration was =
not=20
properly set in the previous test setup.


Thanks,
Chengguang.
