From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 2/3] vfs: truncate check IS_APPEND() on real inode
Date: Sat, 8 Apr 2017 14:50:29 +0300
Message-ID: <CAOQ4uxi_jtMq774OoH5bmULA3W1AGDrNv9aXgfY0CLFW9gJLLA@mail.gmail.com>
References: <1491555701-16608-1-git-send-email-amir73il@gmail.com>
 <1491555701-16608-3-git-send-email-amir73il@gmail.com> <CAJfpeguGgXwLa0-Aw1m5t09D-6g28W9OhSjSposWAE84bc8a-A@mail.gmail.com>
 <CAOQ4uxhpkwSNhNQJO0sabXozFAOb2YWifL-bAWDgQJtveBZGyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34687 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdDHLub (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2017 07:50:31 -0400
In-Reply-To: <CAOQ4uxhpkwSNhNQJO0sabXozFAOb2YWifL-bAWDgQJtveBZGyg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Apr 7, 2017 at 7:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Apr 7, 2017 at 4:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Apr 7, 2017 at 11:01 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> truncate an overlayfs inode was checking IS_APPEND() on
>>> overlay inode, but overlay inode does not have the S_APPEND flag.
>>>
>>> Move the IS_APPEND() check to after we have the upperdentry
>>> and pass it the real upper inode.
>>
>> Not sure the reordering is worth it.  Just use d_real_inode() in the
>
> Hmm, I meant move after d_real() which actually does a copy up.
> If we use d_real_inode() before d_real() then we prevent truncate
> of a lower with chattr +a.
> That is not consistent at all with open(O_TRUNC) and ftruncate
> and with checks for IS_IMMUTABLE() which only test upper
> (and I think it is better this way).
>
>> IS_APPEND() check.  OTOH it shouldn't matter (well, except whether the
>> file is copied up or not in the error caae ).  But mainly I just feel
>> when there's a choice of a simpler way we should use that.
>>
>> Also it's usually better not to mix fixes with cleanups (the d_inode() thing).
>>
>
> Sure, I can split that or drop the cleanup altogether.
>

Or drop the patch altogether... d_real() already takes care of IS_APPEND()
now :)
