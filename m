From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 0/7] overlayfs: Delayed copy up of data
Date: Mon, 2 Oct 2017 22:03:13 +0300
Message-ID: <CAOQ4uxgmvukQPbAWxA9Mfs_9-qBJkOV+oEwjsJBr0bARzyki9g@mail.gmail.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:45520 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdJBTDO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 15:03:14 -0400
Received: by mail-qt0-f170.google.com with SMTP id b21so2877533qte.2
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Oct 2017 12:03:14 -0700 (PDT)
In-Reply-To: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 2, 2017 at 4:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> In one of the recent converstions, people mentioned that chown/chmod
> lead to copy up files as well as data. We could optimize it so that
> only metadata is copied up during chown/chmod and data is copied up when
> file is opened for WRITE.
>
> This optimization potentially could be useful with containers and user
> namespaces. In popular scenario, people end up doing chown() on whole
> image directory tree based on container mappings. And this chown copies
> up everything, breaking sharing of page cache between containers.
>
> With these patches, only metadat is copied up during chown() and if file
> is opened for READ, d_real() returns lower dentry/inode. That way,
> different containers can still continue to use page cache. That's the
> use case I have in mind. I have not tested it though.
>
> So here are very crude RFC patch. I have done bare minimal testing on
> these and there are many unaddressed issues I can see.
>
> Before I go any further, I wanted to send these out for some feedback
> and see if I am moving in right direction or this appraoch is completely
> broken.
>

I like the direction this is going :)
Beyond the important use case you listed, this could be useful also for:
1. copy up of lower hardlink in ovl_nlink_start(), just to have a place holder
    inode for OVL_XATTR_NLINK
2. similar case as above needed for NFS export of lower hardlink
3. possible starting point for consistent ro/rw file descriptor, see POC:
    https://github.com/amir73il/linux/commits/ovl-rocopyup
    your patches actually take off where my patches stop

> Basically, I am relying on storing OVL_XATTR_ORIGIN in upper inode
> during copy up. I use that information to get to lower inode later and
> do data copy up when necessary.

Your feature is relying on OVL_XATTR_ORIGIN, and so does index feature.
There are several places in your patches were you wonder what happens
in cases there is no index or there is an index.
Why not make life simpler and make METACOPY depend on index?
METACOPY is not backward compat, not even readonly backward compat.
It may be easy for you to base on my index=all patches:
https://github.com/amir73il/linux/commits/ovl-index-all
and make the life cycle of copy up go through the following stages:
- create metadata copy index
- copy data to index
- link index to upper

AFAICT there is never any reason to actually have an upper alias as
a result of metadata copy up.

>
> I also store OVL_XATTR_METACOPY in upper inode to mark that only
> metadata has been copied up and data copy up still might be required.
>

And that is not backward compat so need a new opt-in config option.
I don't like it so much that we keep adding config options and complicate
the compatibility matrix, that is why I prefer if we bundle several new
functionalities into a single new opt-in config option if possible, but
Miklos seems to feel differently about this.

Cheers,
Amir.
