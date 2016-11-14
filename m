From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 14 Nov 2016 18:25:39 +0200
Message-ID: <CAOQ4uxjAZAWTy14B1HA-=RmPVsgBBXve7914g0gn7EG3xADebA@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com> <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
 <20161107134215.2v5leafss2mamim5@home.ouaza.com> <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
 <CAOQ4uxiC+O93=Dbgogc-GpL_7rF-qCRXeGzy3epVfpZRHNQf=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36721 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbcKNQZm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 Nov 2016 11:25:42 -0500
In-Reply-To: <CAOQ4uxiC+O93=Dbgogc-GpL_7rF-qCRXeGzy3epVfpZRHNQf=A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Raphael Hertzog <hertzog@debian.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sun, Nov 13, 2016 at 12:00 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Nov 11, 2016 at 12:39 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> New version is at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #redirect
>>
>> News:
>> - it actually should work in all cases
>> - when rename is not cross directory, just store the new name instead
>> of a full path, as suggested by Amir
>> - when redirect path is too long fall back to EXDEV (the max length
>> should probably be a module param)
>>
>
> Looks goods, except for the case of change from relative to absolute
> redirect of the victim dentry. IIUC, ovl_set_redirect() will return immediately
> because ovl_dentry_is_redirect() and will not get to setting the absolute
> redirect.
>

I added some more tests to catch this problem at:
https://github.com/amir73il/unionmount-testsuite.git #ovl_rename_dir

In the new version, upper recycling is optional and you can set a bound
to the number of layers. This is needed to catch the bug because the
scenario is:
- Rename populated dir in same dir
- Move the populated dir to another dir
- Re-mount
- Populated dir is empty

The following test run demonstrates it:

$ sudo ./run --ov=0 rename-move-dir
...
TEST rename-move-dir.py:37: Rename populated dir and move into another
 ./run --rename /mnt/a/dir102 /mnt/a/dir102x
 ./run --rename /mnt/a/dir102 /mnt/a/dir102x -E ENOENT
 ./run --rename /mnt/a/dir102x /mnt/a/empty102/dir102
 ./run --rename /mnt/a/dir102x /mnt/a/empty102/dir102 -E ENOENT
 ./run --open-file /mnt/a/dir102 -r -d -E ENOENT
 ./run --open-file /mnt/a/dir102x -r -d -E ENOENT
 ./run --open-file /mnt/a/empty102/dir102 -r -d
/mnt/a/empty102/dir102/a: File is missing


Amir.
