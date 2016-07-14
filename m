From: Andrey Melnikov <temnota.am@gmail.com>
Subject: Re: [PATCH] Fix overlayfs inotify interaction
Date: Thu, 14 Jul 2016 13:08:04 +0300
Message-ID: <CA+PODjqgaRepX14b=-9seX3MjXXDmWHdtnNhHq=GS_=SAGqfjQ@mail.gmail.com>
References: <20160630105956.GA9949@ppc.Dlink> <CA+PODjrncMt=vPkFun5eMFH02AAnMh89rFpcyhiu4ne_r1fVVA@mail.gmail.com>
 <CAJfpegtgUOa1pB7SLWbL4tL4_=062LN12em2nS-oFiUJt-n0fg@mail.gmail.com>
 <CA+PODjrvb5_ZdVCBfObx9HxZzy6rABpTm=ftEsFxJHSAYJTwOQ@mail.gmail.com> <CAJfpegtVVJb5d=EoRqx_3x03PFqL_=fcQfyAM=kJh3kpVd7NMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34805 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbcGNKII (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 Jul 2016 06:08:08 -0400
Received: by mail-lf0-f68.google.com with SMTP id l69so590838lfg.1
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2016 03:08:06 -0700 (PDT)
In-Reply-To: <CAJfpegtVVJb5d=EoRqx_3x03PFqL_=fcQfyAM=kJh3kpVd7NMw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, zhangaihua <zhangaihua1@huawei.com>

2016-07-14 12:53 GMT+03:00 Miklos Szeredi <miklos@szeredi.hu>:
> On Thu, Jul 14, 2016 at 11:42 AM, Andrey Melnikov <temnota.am@gmail.com> wrote:
>> 2016-07-14 12:23 GMT+03:00 Miklos Szeredi <miklos@szeredi.hu>:
>>> On Tue, Jul 12, 2016 at 11:01 PM, Andrey Melnikov <temnota.am@gmail.com> wrote:
>>>> Ping.
>>>>
>>>> 2016-06-30 14:04 GMT+03:00 Andrey Jr. Melnikov <temnota.am@gmail.com>:
>>>>>  Fix overlayfs inotify interaction - use d_real_inode() helper
>>>>>  to resolve real (underlying) inode. Without this inotify is not functional on
>>>>>  overlayfs.
>>>
>>> Have you tried the alternative patch from Aihua Zhang:
>>>   https://lkml.org/lkml/2016/7/7/83
>>
>> No. My patch add small overhead, lookup inode once when add inotify
>> watch, this patch - lookup inode on each operation. For what?
>
> I'm afraid that your patch won't work for all notifications (like
> directory modification).

It work with dir's too:

# mount
none on /tmp/dest type overlay
(rw,relatime,lowerdir=lower/,upperdir=upper/,workdir=work/)

# cd /tmp/dest/test-dir/
/tmp/dest/test-dir# ls -als
total 8
4 drwxr-xr-x 2 root root 4096 Jul 14 09:58 .
4 drwxr-xr-x 1 root root 4096 Jul 14 09:58 ..
/tmp/dest/test-dir# touch test-1
/tmp/dest/test-dir# cd ..
/tmp/dest# mv test-dir/ test-dir-1/
/tmp/dest# touch test-dir-1/test-2
/tmp/dest# mkdir test-dir-1/test-dir-2

in other console:

# inotifywait -m /tmp/dest/test-dir/
Setting up watches.
Watches established.
/tmp/dest/test-dir/ OPEN,ISDIR
/tmp/dest/test-dir/ ACCESS,ISDIR
/tmp/dest/test-dir/ CLOSE_NOWRITE,CLOSE,ISDIR
/tmp/dest/test-dir/ OPEN,ISDIR
/tmp/dest/test-dir/ ACCESS,ISDIR
/tmp/dest/test-dir/ CLOSE_NOWRITE,CLOSE,ISDIR
/tmp/dest/test-dir/ CREATE test-1
/tmp/dest/test-dir/ OPEN test-1
/tmp/dest/test-dir/ ATTRIB test-1
/tmp/dest/test-dir/ CLOSE_WRITE,CLOSE test-1
/tmp/dest/test-dir/ MOVE_SELF
/tmp/dest/test-dir/ OPEN,ISDIR
/tmp/dest/test-dir/ ACCESS,ISDIR
/tmp/dest/test-dir/ CLOSE_NOWRITE,CLOSE,ISDIR
/tmp/dest/test-dir/ CREATE test-2
/tmp/dest/test-dir/ OPEN test-2
/tmp/dest/test-dir/ ATTRIB test-2
/tmp/dest/test-dir/ CLOSE_WRITE,CLOSE test-2
/tmp/dest/test-dir/ CREATE,ISDIR test-dir-2
/tmp/dest/test-dir/ OPEN,ISDIR
/tmp/dest/test-dir/ ACCESS,ISDIR
/tmp/dest/test-dir/ CLOSE_NOWRITE,CLOSE,ISDIR

Can't see any problem here.

>>>>> Signed-off-by: Andrey Jr. Melnikov <temnota.am@gmail.com>
>>>>>
>>>>> ---
>>>>> Runtime tested with inotifywait in monitor mode to confirm event generation.
>>>>>
>>>>> cd /tmp/ && mkdir dest upper lower work
>>>>> mount -t overlay none dest -o upperdir=upper/,lowerdir=lower/,workdir=work/
>>>>> while /bin/true; do echo test >>/tmp/dest/lower-data; sleep 5; done &
>>>>> inotifywait -m /tmp/dest/lower-data
>>>>>
>>>>>  fs/notify/inotify/inotify_user.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
>>>>> index b8d08d0..592ce16 100644
>>>>> --- a/fs/notify/inotify/inotify_user.c
>>>>> +++ b/fs/notify/inotify/inotify_user.c
>>>>> @@ -742,7 +742,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
>>>>>                 goto fput_and_out;
>>>>>
>>>>>         /* inode held in place by reference to path; group by fget on fd */
>>>>> -       inode = path.dentry->d_inode;
>>>>> +       inode = d_real_inode(path.dentry);
>>>>>         group = f.file->private_data;
>>>>>
>>>>>         /* create/update an inode mark */
>>>>> --
>>>>> 2.8.1
>>>>>
