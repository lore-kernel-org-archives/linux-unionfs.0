From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4] ovl: lockdep annotate of nested stacked overlayfs
 inode lock
Date: Fri, 3 Mar 2017 17:07:53 +0100
Message-ID: <CAJfpegtcZKy4MJouupkQB5qQXg93CvG6zk=6OdrSfW0-1bJEWg@mail.gmail.com>
References: <1484129266-8968-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxhy_4ymrya5AMZ3AvFU0t4u+ytV6QOcAB9oriiAwNuCSg@mail.gmail.com>
 <CAOQ4uxjOePL4zEhtDZG634MkkKvrP3AvYwnv_78EWo2ZVBKgGQ@mail.gmail.com> <CAOQ4uxgENJ9ggpnCm7X9nQrFjQXXfCzCgOd2NPGJyUPYkE6F+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34008 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdCCQH6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Mar 2017 11:07:58 -0500
Received: by mail-oi0-f65.google.com with SMTP id m124so7948571oig.1
        for <linux-unionfs@vger.kernel.org>; Fri, 03 Mar 2017 08:07:55 -0800 (PST)
In-Reply-To: <CAOQ4uxgENJ9ggpnCm7X9nQrFjQXXfCzCgOd2NPGJyUPYkE6F+Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Xiong Zhou <xzhou@redhat.com>

On Fri, Mar 3, 2017 at 9:22 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Feb 8, 2017 at 9:42 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Jan 31, 2017 at 9:15 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Wed, Jan 11, 2017 at 12:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> An overlayfs instance can be the lower layer of another overlayfs
>>>> instance. This setup triggers a lockdep splat of possible recursive
>>>> locking of sb->s_type->i_mutex_key in iterate_dir(). Trimmed snip:
>>>>
>>>>  [ INFO: possible recursive locking detected ]
>>>>  bash/2468 is trying to acquire lock:
>>>>   &sb->s_type->i_mutex_key#14, at: iterate_dir+0x7d/0x15c
>>>>  but task is already holding lock:
>>>>   &sb->s_type->i_mutex_key#14, at: iterate_dir+0x7d/0x15c
>>>>
>>>> One problem observed with this splat is that ovl_new_inode()
>>>> does not call lockdep_annotate_inode_mutex_key() to annotate
>>>> the dir inode lock as &sb->s_type->i_mutex_dir_key like other
>>>> fs do.
>>>>
>>>> The other problem is that the 2 nested levels of overlayfs inode
>>>> lock are annotated using the same key, which is the cause of the
>>>> false positive lockdep warning.
>>>>
>>>> Fix this by annotating overlayfs inode lock in ovl_fill_inode()
>>>> according to stack level of the super block instance and use
>>>> different key for dir vs. non-dir like other fs do.
>>>>
>>>> Here is an edited snip from /proc/lockdep_chains after
>>>> iterate_dir() of nested overlayfs:
>>>>
>>>>  [...] &ovl_i_mutex_dir_key[depth]   (stack_depth=2)
>>>>  [...] &ovl_i_mutex_dir_key[depth]#2 (stack_depth=1)
>>>>  [...] &type->i_mutex_dir_key        (stack_depth=0)
>>>>
>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>> ---
>>>>  fs/overlayfs/inode.c | 38 ++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 38 insertions(+)
>>>>
>>>> v4:
>>>> - further simplify by removing unneeded ofs->nested
>>>>
>>>
>>> Miklos,
>>>
>>> This patch version addresses your review comments from previous merge cycle
>>> and it has zero impact without CONFIG_LOCKDEP as you requested.
>>>
>>
>> Ping.
>>
>> Would you mind queuing this one as well for 4.11?

Sorry, missed this.  I'll bundle this with the next pull; probably
there will be other fixes before 4.11 final.

Thanks,
Miklos
