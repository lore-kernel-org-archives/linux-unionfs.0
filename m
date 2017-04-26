From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 04/11] ovl: store file handle of lower inode on copy up
Date: Wed, 26 Apr 2017 11:21:50 +0200
Message-ID: <CAJfpegs7SZ8VKBjoM9ingoJhGh24gNotYOy=eyPc4cmOu-dUzg@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-5-git-send-email-amir73il@gmail.com> <CAJfpegt=mVd7kCB2CwX4TDbnaKcHdxMnEfD9eTMHx8ZRNQ0WyA@mail.gmail.com>
 <CAOQ4uxjsk+nU8Hemb83Cwkmws90qA5yYkGB=pzbraJofd9jN3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33123 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1433772AbdDZJbK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 05:31:10 -0400
Received: by mail-oi0-f46.google.com with SMTP id y11so169831818oie.0
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2017 02:31:10 -0700 (PDT)
In-Reply-To: <CAOQ4uxjsk+nU8Hemb83Cwkmws90qA5yYkGB=pzbraJofd9jN3g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 26, 2017 at 7:47 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Apr 25, 2017 at 5:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Apr 24, 2017 at 11:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Sometimes it is interesting to know if an upper file is pure
>>> upper or a copy up target, and if it is a copy up target, it
>>> may be interesting to find the copy up origin.
>>>
>>> This will be used to preserve lower inode numbers across copy up.
>>>
>>> Store the lower inode file handle in upper inode xattr overlay.fh
>>> on copy up to use it later for these cases.
>>>
>>> On failure to encode lower file handle, store an invalid 'null'
>>> handle, so we can always use the overlay.fh xattr to distignuish
>>> between a copy up and a pure upper inode.
>>>
>>> If lower fs does not support NFS export ops or if not all lower
>>> layers are on the same fs, don't try to encode a lower file handle
>>> and use the 'null' handle instead.
>>
>> Decoding fh on wrong fs is going to result in "interesting"
>> posibilities, so I think we should be storing some kind of identifier
>> about the layer from the very start.
>>
>> The trivial way to do that would be to encode the filesystem's UUID
>> into the stored fh.  Problem seems to be that only ext4 is setting
>> sb->s_uuid.  Probably not too hard to fix the others.
>>
>
> xfs supports sb->s_export_op->get_uuid() (and seems to be the only
> fs that supports exportfs block ops). It may be more appropriate
> for our use case (universal unique file handle) to use this API
> and add support for it in other fs.
> We can also use the existence of sb->s_export_op->get_uuid
> as a promise for a persistent/exportable sb uuid instead of assuming
> that sb->s_uuid has such properties.

Right, if ->get_uuid() could be made to work on all exportable fs,
than that would be good.

The "offset" argument worries me a little.   And we'd need to get rid
of the printk in the xfs code (or move it to pnfsd, which is where it
belongs).

Thanks,
Miklos
