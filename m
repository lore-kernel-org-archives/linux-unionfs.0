From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Tue, 22 Nov 2016 15:42:35 +0200
Message-ID: <CAOQ4uxjeocaCqLZ9Xbk1D77xVVbNmkFVgtdAefAVqrET5xtXJw@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com> <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
 <20161107134215.2v5leafss2mamim5@home.ouaza.com> <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
 <CAOQ4uxiC+O93=Dbgogc-GpL_7rF-qCRXeGzy3epVfpZRHNQf=A@mail.gmail.com>
 <CAOQ4uxjAZAWTy14B1HA-=RmPVsgBBXve7914g0gn7EG3xADebA@mail.gmail.com>
 <CAJfpegsKmo9zES6ZpHkjVE50z6ere3J9X2ixSFN6dhU_cEReSw@mail.gmail.com>
 <CAOQ4uxjD60ZqjXYq345SEjg79V89NvM8bUGt1=CUSiQHyQcBkA@mail.gmail.com>
 <CAJfpegtZ_86Axi9Ffrdzhkgy9gvd-bUnWMXwhGo-LRAegTWd8w@mail.gmail.com>
 <CAOQ4uxh0eqgMezo1zUhdvKNXYofb_-fpV_ASO-A7vJOWXnZ0Kg@mail.gmail.com> <CAOssrKe=5sRj1NeUeNnD3r8_2D6yG1modqobn67D-0Wj52Ju3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:33537 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753763AbcKVNmi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Nov 2016 08:42:38 -0500
In-Reply-To: <CAOssrKe=5sRj1NeUeNnD3r8_2D6yG1modqobn67D-0Wj52Ju3g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Raphael Hertzog <hertzog@debian.org>, Konstantin Khlebnikov <koct9i@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Nov 21, 2016 at 12:16 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> On Mon, Nov 21, 2016 at 11:13 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Nov 21, 2016 at 11:54 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Fri, Nov 18, 2016 at 4:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>>> Found one typo and one bug in error that can cause crash on dput(ERR_PTR(err)):
>>>
>>> Thanks.
>>>
>>> Fixes force pushed to overlayfs-next.
>>
>> All right. I had the (wrong) impression the next was not a rewindable branch.
>
> That depends on how many devel branches are broken by such an action.
> In case of overlayfs-next, there doesn't appear to be too much of
> that, so for now I feel free to mess with it.
>

All right. Just posted another minor fix to display redirect=xx on /proc/mounts
when it is due. Feel free to squash or apply or whatever.

*Strictly* FYI, here is something I have been working on, on top of
redirect_dir,
which I need for one of our use cases.
Since it is working and passed all the sanity tests, I am letting you all know
about it in case it's relevant for anyone else.
Not even going to post the patches yet, just a link and an abstract.

Amir.

https://github.com/amir73il/linux.git #redirect_fh

===============================
  ovl: redirect merged dir by file handle on copy up

When mounted with mount option redirect_dir=fh,
every copy up of lower directory stores the lower
dir file handle in redirect xattr of upper dir.

After the redirect at copy up, renaming upper merged
directory requires no further action.

This method has some advantages over absolute path redirect:
- it is more compact in stored xattr size
- it is not limited by lengths of full paths
- lookup redirect is more efficient for very nested directories

It also has some disadvantages over absolute path redirect:
- it requires setting the redirect xattr for all layers of
  merged dirs
- it requires that all lower layers are on the same file system,
  which support exportfs ops
- file handles will become stale if overlay lower directories
  where to be copied to another location

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
