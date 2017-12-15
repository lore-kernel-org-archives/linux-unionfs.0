From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Fri, 15 Dec 2017 17:06:12 +0100
Message-ID: <CAJfpegvSAiWYirK2729KP6vKm=A=tdTpg32K6JVTrV_aOdatxw@mail.gmail.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com> <20171214064747.20999-2-yi.zhang@huawei.com>
 <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
 <CAOQ4uxh-4kKPLHDXHJux2_tM35frxxNWmPEZcDu2EQ2n+yYkKA@mail.gmail.com>
 <CAJfpegt7LR=G+UK5VY0kEScduuBj2SFhAw3pf1_8NSM+r61PeQ@mail.gmail.com>
 <CAOQ4uxg7UahQ=t2sWpf0FEi7MP+OT3XfO8AB_y+0qpeq8CWgrA@mail.gmail.com>
 <CAJfpegt-Upt3z4wFVQJ5bJf9pBbjOGXd93P+3LZdemSeS0Y_BA@mail.gmail.com>
 <CAOQ4uxg+DY=9MT+2sPNBnM77qv8eqyY5mCqnE6k1viptmLR8yA@mail.gmail.com>
 <CAJfpegsMT6ctTDRDQHosz52ZTg5gQgmxr5Em3YGm-htQzdNjCA@mail.gmail.com>
 <CAOQ4uxhU72XkzeTr19p5G+nGt9ONfb8=AxzqOBk-Sc2seR2fLw@mail.gmail.com>
 <CAJfpegsQvKfOLh2cWj496+g9pFFPmXbRdwZobqVDaQ_7-EBgrQ@mail.gmail.com> <CAOQ4uxgxwFjJH6hhxJDZP1vzBViTgPnur6GPuNaQmhhg+QjN1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:42478 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932463AbdLOQGN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 11:06:13 -0500
Received: by mail-qt0-f176.google.com with SMTP id g9so12652974qth.9
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Dec 2017 08:06:13 -0800 (PST)
In-Reply-To: <CAOQ4uxgxwFjJH6hhxJDZP1vzBViTgPnur6GPuNaQmhhg+QjN1w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>, Vivek Goyal <vgoyal@redhat.com>

On Fri, Dec 15, 2017 at 3:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Dec 15, 2017 at 4:18 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Dec 14, 2017 at 5:29 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Thu, Dec 14, 2017 at 5:48 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> [...]
>>>>
>>>>> Exporting index is a challenge for the same reason and also because tar can
>>>>> break hardlinks on extract. Probably index should be rebuilt from scratch on
>>>>> import, based on "redirect".
>>>>
>>>> Yes, hard links need special handling, so will metacopy.  Might be
>>>> worth adding "redirect" to hard links and metacopy to make this issue
>>>> less of a problem.
>>>>
>>>
>>> Do you mean add it now in kernel? hmm, that's just another thing that
>>> can become inconsistent, so I don't see the immediate value.
>>
>> The immediate value is that no need for a special pack/unpack tool for
>> transferring the overlay "image".
>>
>
> OK, but I don't see how we can escape unpack tool for rebuilding the index
> from redirects.
> Do you mean that you want to also follow non-dir "redirect"?
> Resolve conflicts between "redirect" and "origin"?
> Fix "redirect" by "origin"? fix "origin" by redirect"?
> I am all for that. Already have patches to fix "redirect" by "origin" for dirs:
> https://github.com/amir73il/linux/commits/ovl-redirect-fix
>
>>>
>>> Which reminds me, you did not provide feedback to the patch I posted
>>> to detect duplicate redirect dir use case:
>>>
>>> https://marc.info/?l=linux-unionfs&m=151126880100432&w=2
>>>
>>> Do you consider this a bug that should be detected by overlayfs
>>> as patch proposed or leave it to be detected only when enabling
>>> opt-in directory indexing (named verify=on in current WIP patches)?
>>>
>>> Also waiting for your feedback about merging the duplicate redirect dir
>>> test case to xfstests:
>>> https://marc.info/?l=fstests&m=151149994629687&w=2
>>>
>>> Bug or not bug?
>>
>> Hmm... I'd lean towards non-bug.  That "offline modification is
>> allowed" rule should point out caveats when messing with overlay
>> specific attributes (opaque, whiteout, redirect, etc).  Obviously
>> having two redirects pointing to the same underlying dir is going to
>> result in inconsistencies.  We can get away with it without constant
>> ino, but I don't think it makes sense to allow that construct.
>>
>
> I also think that allowing user to mess with trusted.overlay xattr is
> not fair play. The test I posted however, doesn't do that.
> The test does cp -a of a redirected upper dir.
> Something that perhaps user could get away with before redirect_dir
> and something that an innocent user may be doing.

Right.   And fsck.overlay will help greatly, since it defines what a
correct image is and what is not.  Ovlerlayfs is not expected to
operate correctly on an incorrect image.

In addition we do need to document all this, in order to minimize surprises.

>
> Anyway, directories index lookup takes care of duplicate redirect problem
> as a by product of NFS export:
> https://github.com/amir73il/linux/commit/b1dd6461aa7c26091aad7c9b65c04cc1071bb9e0

Yes, if we detect inconsistencies online, then that will also help.

Thanks,
Miklos
