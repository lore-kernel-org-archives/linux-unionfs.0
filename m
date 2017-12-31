From: zhangyi <yizhang089@gmail.com>
Subject: Re: [PATCH xfstest v2 3/4] overlay: add fsck.overlay redirect
 directory test
Date: Sun, 31 Dec 2017 13:06:50 +0800
Message-ID: <6b5ad224-5863-6eb9-fb2a-766bccc4c9c5@gmail.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com>
 <20171228114933.47759-4-yi.zhang@huawei.com>
 <CAOQ4uxiyAj7+UmFMW7eP+HeeZuH6pWxCLKd5WKtc53b77ZihoQ@mail.gmail.com>
 <d1601184-7272-b607-ee6e-768a33623e42@gmail.com>
 <CAOQ4uxhmGo759uLV6Fvg1Pa2rNJ_sfskL_aPa8rDDZcPXTkwEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:43258 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbdLaFGz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 Dec 2017 00:06:55 -0500
In-Reply-To: <CAOQ4uxhmGo759uLV6Fvg1Pa2rNJ_sfskL_aPa8rDDZcPXTkwEQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On 2017/12/30 17:35, Amir Goldstein Wrote:
> On Sat, Dec 30, 2017 at 6:06 AM, zhangyi (F) <yizhang089@gmail.com> wrote:
>> On 2017/12/28 20:37, Amir Goldstein Wrote:
>>
>>>> +# Test valid redirect xattr with general directory cover lower origin
>>>> +# target, should ask user this directory is merged or not by default
>>>> +# and do nothing in auto mode
>>>> +echo "+ Valid redirect(4)"
>>>> +mkdir $lowerdir/origin
>>>> +mkdir $upperdir/origin
>>>> +make_redirect_dir $upperdir/testdir "origin"
>>>> +
>>>> +_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
>>>> || \
>>>> +       _fail "fsck should not fail"
>>>> +check_redirect "origin" $upperdir/testdir
>>>> +$GETFATTR_PROG --absolute-names -d -m $OVL_OPAQUE_XATTR
>>>> $upperdir/testdir
>>>> +
>>>> +echo "n" > $tmp.input
>>> This approach seems a bit fragile to me.
>>> Maybe you will want to add some questions in the future.
>>> To me it makes better sense to check behavior of fsck -y is automated
>>> test,
>>> because some user who does not understand the questions is surely going
>>> to run fsck -y to fix problems.
>>>
>>>> +_overlay_fsck_dirs $lowerdir $upperdir $workdir <$tmp.input >>
>>>> $seqres.full 2>&1 || \
>>>> +       _fail "fsck should not fail"
>>>> +check_redirect "origin" $upperdir/testdir
>>>> +check_opaque $upperdir/origin
>>>> +rm -rf $lowerdir/* $upperdir/*
>>>> +
>> Hi Amir：
>>
>> Think about this again. IIUC, I think there is a consistency problem about
>> this case.
>> If we allow user to create a new directory in upper layer merge with lower
>> redirect origin target when overlay offline, we will see duplicate d_ino in
>> overlay filesystem after next mount, becasue current ovl_getattr() will get
>> the lower d_ino for both merged dir and redirect dir.
>>
>> eg:
>> mnt:         dira(ino=x)    dirb(ino=x)
>> upper:      *dira(ino=y)   dirb(ino=z, redirect=dirb)
>> lower:       dira(ino=x)
>>
>> *) User remove whiteout or opaque dir and then newly created when overlayfs
>> is offline.
>>
>> Furthermore, if user rename dira again, will lead to duplicate redirect
>> xattr directly.
>> So I think we should forbid user do this and check by fsck.overlay. Or
>> handle by overlay filesytem?  thought?
>>
> I am not sure I follow. Of course there is a consistency problem with
> allowing merge
> and redirect to same target. merge dir is just a private case of
> "redirect to .".
> merge+redirect is not different in any way than multiple redirect.
> All our discussion w.r.t the "Is merge dir?" question was revolving around the
> fact that either the merge dir or the redirected dir needs to be fixed.
Exactly，If user selsect the "merge" option(not opaque), we also should 
fix the
redirected dir which point to the same origin. Thanks!

> And duplicate d_ino is the *least* of the problem.
> With duplicate redirect, there can be many objects (all descendants)
> in the file system
> with the same st_dev;st_ino, which may have different data.
>
> This work in my queue is verifying multiple redirect/merge at lookup time,
> but *only* if directories where indexed to begin with.
> fsck.overlay will be needed to find and correct duplicate redirects
> and even merge
> dirs that were copied up without an index and fix the index (if
> -overify=on is given).
>
> There is a limitation of verify=on that it cannot use index to verify
> mulitple redirect
> from mid layers. This is where only fsck.overlay can be used.
OK, I can add this check and fix latter.  :）

Cheers,
Yi.
