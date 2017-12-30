From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH xfstest v2 3/4] overlay: add fsck.overlay redirect
 directory test
Date: Sat, 30 Dec 2017 11:35:28 +0200
Message-ID: <CAOQ4uxhmGo759uLV6Fvg1Pa2rNJ_sfskL_aPa8rDDZcPXTkwEQ@mail.gmail.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com> <20171228114933.47759-4-yi.zhang@huawei.com>
 <CAOQ4uxiyAj7+UmFMW7eP+HeeZuH6pWxCLKd5WKtc53b77ZihoQ@mail.gmail.com> <d1601184-7272-b607-ee6e-768a33623e42@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <d1601184-7272-b607-ee6e-768a33623e42@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yizhang089@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Sat, Dec 30, 2017 at 6:06 AM, zhangyi (F) <yizhang089@gmail.com> wrote:
> On 2017/12/28 20:37, Amir Goldstein Wrote:
>
>>
>>> +# Test valid redirect xattr with general directory cover lower origin
>>> +# target, should ask user this directory is merged or not by default
>>> +# and do nothing in auto mode
>>> +echo "+ Valid redirect(4)"
>>> +mkdir $lowerdir/origin
>>> +mkdir $upperdir/origin
>>> +make_redirect_dir $upperdir/testdir "origin"
>>> +
>>> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&=
1
>>> || \
>>> +       _fail "fsck should not fail"
>>> +check_redirect "origin" $upperdir/testdir
>>> +$GETFATTR_PROG --absolute-names -d -m $OVL_OPAQUE_XATTR
>>> $upperdir/testdir
>>> +
>>> +echo "n" > $tmp.input
>>
>> This approach seems a bit fragile to me.
>> Maybe you will want to add some questions in the future.
>> To me it makes better sense to check behavior of fsck -y is automated
>> test,
>> because some user who does not understand the questions is surely going
>> to run fsck -y to fix problems.
>>
>>> +_overlay_fsck_dirs $lowerdir $upperdir $workdir <$tmp.input >>
>>> $seqres.full 2>&1 || \
>>> +       _fail "fsck should not fail"
>>> +check_redirect "origin" $upperdir/testdir
>>> +check_opaque $upperdir/origin
>>> +rm -rf $lowerdir/* $upperdir/*
>>> +
>
> Hi Amir=EF=BC=9A
>
> Think about this again. IIUC, I think there is a consistency problem abou=
t
> this case.
> If we allow user to create a new directory in upper layer merge with lowe=
r
> redirect origin target when overlay offline, we will see duplicate d_ino =
in
> overlay filesystem after next mount, becasue current ovl_getattr() will g=
et
> the lower d_ino for both merged dir and redirect dir.
>
> eg:
> mnt:         dira(ino=3Dx)    dirb(ino=3Dx)
> upper:      *dira(ino=3Dy)   dirb(ino=3Dz, redirect=3Ddirb)
> lower:       dira(ino=3Dx)
>
> *) User remove whiteout or opaque dir and then newly created when overlay=
fs
> is offline.
>
> Furthermore, if user rename dira again, will lead to duplicate redirect
> xattr directly.
> So I think we should forbid user do this and check by fsck.overlay. Or
> handle by overlay filesytem?  thought?
>

I am not sure I follow. Of course there is a consistency problem with
allowing merge
and redirect to same target. merge dir is just a private case of
"redirect to .".
merge+redirect is not different in any way than multiple redirect.
All our discussion w.r.t the "Is merge dir?" question was revolving around =
the
fact that either the merge dir or the redirected dir needs to be fixed.

And duplicate d_ino is the *least* of the problem.
With duplicate redirect, there can be many objects (all descendants)
in the file system
with the same st_dev;st_ino, which may have different data.

This work in my queue is verifying multiple redirect/merge at lookup time,
but *only* if directories where indexed to begin with.
fsck.overlay will be needed to find and correct duplicate redirects
and even merge
dirs that were copied up without an index and fix the index (if
-overify=3Don is given).

There is a limitation of verify=3Don that it cannot use index to verify
mulitple redirect
from mid layers. This is where only fsck.overlay can be used.

Cheers,
Amir.
