From: Andrey Melnikov <temnota.am@gmail.com>
Subject: Re: [PATCH] Fix overlayfs inotify interaction
Date: Thu, 14 Jul 2016 12:42:01 +0300
Message-ID: <CA+PODjrvb5_ZdVCBfObx9HxZzy6rABpTm=ftEsFxJHSAYJTwOQ@mail.gmail.com>
References: <20160630105956.GA9949@ppc.Dlink> <CA+PODjrncMt=vPkFun5eMFH02AAnMh89rFpcyhiu4ne_r1fVVA@mail.gmail.com>
 <CAJfpegtgUOa1pB7SLWbL4tL4_=062LN12em2nS-oFiUJt-n0fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33753 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbcGNJmE (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 Jul 2016 05:42:04 -0400
Received: by mail-lf0-f65.google.com with SMTP id f93so5066225lfi.0
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2016 02:42:03 -0700 (PDT)
In-Reply-To: <CAJfpegtgUOa1pB7SLWbL4tL4_=062LN12em2nS-oFiUJt-n0fg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, zhangaihua <zhangaihua1@huawei.com>

2016-07-14 12:23 GMT+03:00 Miklos Szeredi <miklos@szeredi.hu>:
> On Tue, Jul 12, 2016 at 11:01 PM, Andrey Melnikov <temnota.am@gmail.com> wrote:
>> Ping.
>>
>> 2016-06-30 14:04 GMT+03:00 Andrey Jr. Melnikov <temnota.am@gmail.com>:
>>>  Fix overlayfs inotify interaction - use d_real_inode() helper
>>>  to resolve real (underlying) inode. Without this inotify is not functional on
>>>  overlayfs.
>
> Have you tried the alternative patch from Aihua Zhang:
>   https://lkml.org/lkml/2016/7/7/83

No. My patch add small overhead, lookup inode once when add inotify
watch, this patch - lookup inode on each operation. For what?

>>>
>>> Signed-off-by: Andrey Jr. Melnikov <temnota.am@gmail.com>
>>>
>>> ---
>>> Runtime tested with inotifywait in monitor mode to confirm event generation.
>>>
>>> cd /tmp/ && mkdir dest upper lower work
>>> mount -t overlay none dest -o upperdir=upper/,lowerdir=lower/,workdir=work/
>>> while /bin/true; do echo test >>/tmp/dest/lower-data; sleep 5; done &
>>> inotifywait -m /tmp/dest/lower-data
>>>
>>>  fs/notify/inotify/inotify_user.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
>>> index b8d08d0..592ce16 100644
>>> --- a/fs/notify/inotify/inotify_user.c
>>> +++ b/fs/notify/inotify/inotify_user.c
>>> @@ -742,7 +742,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
>>>                 goto fput_and_out;
>>>
>>>         /* inode held in place by reference to path; group by fget on fd */
>>> -       inode = path.dentry->d_inode;
>>> +       inode = d_real_inode(path.dentry);
>>>         group = f.file->private_data;
>>>
>>>         /* create/update an inode mark */
>>> --
>>> 2.8.1
>>>
