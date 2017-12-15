From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Fri, 15 Dec 2017 15:18:58 +0100
Message-ID: <CAJfpegsQvKfOLh2cWj496+g9pFFPmXbRdwZobqVDaQ_7-EBgrQ@mail.gmail.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com> <20171214064747.20999-2-yi.zhang@huawei.com>
 <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
 <CAOQ4uxh-4kKPLHDXHJux2_tM35frxxNWmPEZcDu2EQ2n+yYkKA@mail.gmail.com>
 <CAJfpegt7LR=G+UK5VY0kEScduuBj2SFhAw3pf1_8NSM+r61PeQ@mail.gmail.com>
 <CAOQ4uxg7UahQ=t2sWpf0FEi7MP+OT3XfO8AB_y+0qpeq8CWgrA@mail.gmail.com>
 <CAJfpegt-Upt3z4wFVQJ5bJf9pBbjOGXd93P+3LZdemSeS0Y_BA@mail.gmail.com>
 <CAOQ4uxg+DY=9MT+2sPNBnM77qv8eqyY5mCqnE6k1viptmLR8yA@mail.gmail.com>
 <CAJfpegsMT6ctTDRDQHosz52ZTg5gQgmxr5Em3YGm-htQzdNjCA@mail.gmail.com> <CAOQ4uxhU72XkzeTr19p5G+nGt9ONfb8=AxzqOBk-Sc2seR2fLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:40954 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755800AbdLOOTA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 09:19:00 -0500
Received: by mail-qt0-f176.google.com with SMTP id u42so12212887qte.7
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Dec 2017 06:18:59 -0800 (PST)
In-Reply-To: <CAOQ4uxhU72XkzeTr19p5G+nGt9ONfb8=AxzqOBk-Sc2seR2fLw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>, Vivek Goyal <vgoyal@redhat.com>

On Thu, Dec 14, 2017 at 5:29 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Dec 14, 2017 at 5:48 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Dec 14, 2017 at 4:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Thu, Dec 14, 2017 at 5:10 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> [...]
>>> Yes :) Docker uses tar alright.
>>> But for example "origin" xattr cannot be exported as is to a portable format.
>>> Need to decode file handles during export and change them to "redirect"
>>> for directories and possible to "redirect" for files as well, that
>>> would be converted
>>> back to "origin" on import.
>>
>> Is it worth preserving origin for non-hardlinks?  Same story as "cp
>> -a", inode numbers will change, so there doesn't appear to be a reason
>> to preserve the connection between origin and the copied up file.
>
> Besides metacopy, no reason.
>
>>
>>> Exporting index is a challenge for the same reason and also because tar can
>>> break hardlinks on extract. Probably index should be rebuilt from scratch on
>>> import, based on "redirect".
>>
>> Yes, hard links need special handling, so will metacopy.  Might be
>> worth adding "redirect" to hard links and metacopy to make this issue
>> less of a problem.
>>
>
> Do you mean add it now in kernel? hmm, that's just another thing that
> can become inconsistent, so I don't see the immediate value.

The immediate value is that no need for a special pack/unpack tool for
transferring the overlay "image".

>
> Which reminds me, you did not provide feedback to the patch I posted
> to detect duplicate redirect dir use case:
>
> https://marc.info/?l=linux-unionfs&m=151126880100432&w=2
>
> Do you consider this a bug that should be detected by overlayfs
> as patch proposed or leave it to be detected only when enabling
> opt-in directory indexing (named verify=on in current WIP patches)?
>
> Also waiting for your feedback about merging the duplicate redirect dir
> test case to xfstests:
> https://marc.info/?l=fstests&m=151149994629687&w=2
>
> Bug or not bug?

Hmm... I'd lean towards non-bug.  That "offline modification is
allowed" rule should point out caveats when messing with overlay
specific attributes (opaque, whiteout, redirect, etc).  Obviously
having two redirects pointing to the same underlying dir is going to
result in inconsistencies.  We can get away with it without constant
ino, but I don't think it makes sense to allow that construct.

Thanks,
Miklos
