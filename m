From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 04/11] ovl: store file handle of lower inode on copy up
Date: Wed, 26 Apr 2017 11:35:30 +0200
Message-ID: <CAJfpeguzCjSJFZTaO+i62o67YVrVtxBRxYVPpCUa1g3ThCY7EQ@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-5-git-send-email-amir73il@gmail.com> <CAJfpegt=mVd7kCB2CwX4TDbnaKcHdxMnEfD9eTMHx8ZRNQ0WyA@mail.gmail.com>
 <CAOQ4uxjsk+nU8Hemb83Cwkmws90qA5yYkGB=pzbraJofd9jN3g@mail.gmail.com>
 <CAJfpegs7SZ8VKBjoM9ingoJhGh24gNotYOy=eyPc4cmOu-dUzg@mail.gmail.com> <CAOQ4uxgPJ1Op=J6yc=F55s7-9vt+tC9q9OhOVopo_6ygwcVFFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35325 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2997415AbdDZJfb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 05:35:31 -0400
Received: by mail-oi0-f66.google.com with SMTP id m34so33488277oik.2
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2017 02:35:31 -0700 (PDT)
In-Reply-To: <CAOQ4uxgPJ1Op=J6yc=F55s7-9vt+tC9q9OhOVopo_6ygwcVFFg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 26, 2017 at 11:27 AM, Amir Goldstein <amir73il@gmail.com> wrote:

>
> The offset argument is discard-able, it gives you more information
> than we need.

Sure, the problem with that is what should a filesystem put there
which cannot provide such an offset?   Is it optional?  What value
indicates invalid offset?

> Another problem is that ->get_uuid for xfs is compiled out by default
> without CONFIG_PNFSD, although this could be changed.
>
> Anyway, I have a very simple patch for xfs to set sb->s_uuid.
> btrfs has several uuid's (i.e. subvolumes) on the same sb struct IIUC,
> so need to see how to handle this.

Yes, actually btrfs wants some sort of lightweight superblock for
subvolumes with just s_dev and s_uuid.

Not sure what we can do about that for now...

Thanks,
Miklos
