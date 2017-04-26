From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 04/11] ovl: store file handle of lower inode on copy up
Date: Wed, 26 Apr 2017 12:53:08 +0300
Message-ID: <CAOQ4uxjMigPec-xnF9uCnyHkABA_oxhFJqzKr+i0qFAMbOP-Pg@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-5-git-send-email-amir73il@gmail.com> <CAJfpegsPYR=nWQxKbLvw1istWu8a-VogBAbt=WdxM+ho-yJa5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33841 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970933AbdDZJxJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 05:53:09 -0400
In-Reply-To: <CAJfpegsPYR=nWQxKbLvw1istWu8a-VogBAbt=WdxM+ho-yJa5A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 26, 2017 at 12:39 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Apr 24, 2017 at 11:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Sometimes it is interesting to know if an upper file is pure
>> upper or a copy up target, and if it is a copy up target, it
>> may be interesting to find the copy up origin.
>>
>> This will be used to preserve lower inode numbers across copy up.
>>
>> Store the lower inode file handle in upper inode xattr overlay.fh
>> on copy up to use it later for these cases.
>>
>> On failure to encode lower file handle, store an invalid 'null'
>> handle, so we can always use the overlay.fh xattr to distignuish
>> between a copy up and a pure upper inode.
>>
>> If lower fs does not support NFS export ops or if not all lower
>> layers are on the same fs, don't try to encode a lower file handle
>> and use the 'null' handle instead.
>
> One other question regarding this:  do we want  to store the handle of
> the next file in the copy up chain or the handle of the original file?
>
> This patch seems to do the "next file" thing.  For directories,
> obviously that's what we want, but for files...
>

What I found when working on this is that any file below to uppermost
lower is of zero interest to us.

So I defined 'stable inode' and we only need to lookup stable inode:
Stable := uppermost lower (or upper if numlower == 0)

For NFS export, Stable fh is unique enough, because
when rotating upper layer or any change of layer stack configuration,
NFS handles may become stale and this is fine.

inode numbers are guarantied to remain constant and persistent
as long as upper is not rotated.
Rotating upper will change stable inode numbers and this is fine
(regard it as cpio/tar of the filesystem).

Hardlinks will be preserved as long as lower stack configuration
doesn't change.
When upper is rotated the copy up hardlink bunch will be broken
from the non-copy-up hardlink bunch, which is quite a minor
concern IMO (cpio/tar don't always preserve hardlinks).

Amir.
