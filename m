From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] vfs: introduce inode 'inuse' lock
Date: Wed, 31 May 2017 16:54:57 +0300
Message-ID: <CAOQ4uxi=0w2JmBJqoRGZ9iqete2rhCQv0i+qYyk9=rXvEX+s3Q@mail.gmail.com>
References: <1495533033-22367-1-git-send-email-amir73il@gmail.com>
 <1495533033-22367-2-git-send-email-amir73il@gmail.com> <CAJfpegugzuJUszWV4CEDC92pCcU1tv1t=kZX0O0Uk_Uhjyoi1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36130 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdEaNy6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 May 2017 09:54:58 -0400
In-Reply-To: <CAJfpegugzuJUszWV4CEDC92pCcU1tv1t=kZX0O0Uk_Uhjyoi1A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 31, 2017 at 1:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, May 23, 2017 at 11:50 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Added an i_state flag I_INUSE and helpers to set/clear/test the bit.
>>
>> The 'inuse' lock is an 'advisory' inode lock, which also provides
>> may_delete() protection, so can be used to extend exclusive create
>> protection beyond parent->i_mutex lock among cooperating users.
>>
>> This is going to be used by overlayfs to get exclusive ownership
>> on upper and work dirs among overlayfs mounts.
>
> Not sure I like the delete protection.  Any modification of workdir or
> layers while mounted might cause inconsistencies or errors in the
> overlay.  So why single out deletion of base directories?
>

There are a few reasons why 'inuse' inode should not be deleted,
regardless of whether delete protection is needed by overlayfs or not
(I think we don't need it).

1. setting INUSE on a  FREEING|WILL_FREE inode is not allowed
so preventing delete on INUSE makes the possible states fewer and
easier to manage.

2. With latest patchset I also implemented wait_on_inode_inuse()
https://github.com/amir73il/linux/blob/ovl-dir-lock/fs/inode.c#L2175
which is later used by to copy up code for index hardlink.
By preventing delete, I can isolate I_INUSE waiters from I_NEW waiters
and don't need to deal with INUSE waiters and inode delete.

3. Backwards justification: the man page for unlink(2) and rmdir(2)
already explain EBUSY in a generic way:
"pathname cannot be unlinked because it is being used by the system ..."
"pathname is currently in use by the system or ..."

So you may think of the new INUSE flag as a declaration by any
module in the system to make the inode qualify for "in use by the system".

Did any of the arguments above convince you to leave delete protection?
Because if I leave delete protection in v2, I agree the reason should
be better documented.

Amir.
