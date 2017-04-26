From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Wed, 26 Apr 2017 11:06:57 +0200
Message-ID: <CAJfpegssdQ4E=uY3bq8zgXLHZsOQaJXpMWtCZ+V=yVM8vmcw5w@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
 <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com> <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33956 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936681AbdDZJG7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 05:06:59 -0400
Received: by mail-oi0-f67.google.com with SMTP id y11so40637805oie.1
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2017 02:06:58 -0700 (PDT)
In-Reply-To: <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Apr 25, 2017 at 9:11 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Or maybe like this:
>
> At mount time either set or verify the xattr in upper layer root inode:
> overlay.root.$i [i:=0..numlower-1] - ovl_root_id of lower layer i
> ovl_root_id includes for each layer:
> - sb uuid
> - fh of root inode
>
> If mount was able to set or verify that all ovl_root_id[i] match their
> respective lower layer sb and root inode, then redirect_fh can be enabled,
> otherwise it is disabled.
>
> With redirect_fh enabled, it is safe to lookup by the lower layer index,
> root fh and lower inode fh.
> With redirect_fh enabled, it is safe to store handles on copy up along
> with lower layer index and root fh.
>
> A lower layer can be used and reused by any number of overlay mounts
> at different layer index.
>
> An upper layer can be reused in an overlay mount with either copied lower
> layers or with different lower stack and will have redirect_fh disabled.
>
> An upper layer can be rotated as lower layer, because file handles are
> never followed from a lower layer. Constant inode numbers code does
> not need to follow by fh from lower layers.
>
> With this scheme, there is no need to store nor match sb_uuid a for
> every single copy up and every single lookup by fh.
> There is no need to 'lookup' the layer, just use the index and compare
> the root_fh.
>
> It is quite safe from following handles to wrong fs, except if user copies
> parts of an upper layer (without the layer root), but doing something like
> that is equivalent to a user that takes down an NFS server, brings up
> a server with the same network address and exports the same share
> name from a different filesystem.
>
> Maybe the chances are more slim, but the same interesting things could
> happen.

Checking UUID would be O(1) and very fast, so I wouldn't worry about
that.  Using is_subdir() to verify the layer is O(depth) but still
very fast.  I don't think that's an issue either.

Using is_subdir() to find the layer would be O(depth*numlower).  But
we can optimize that if we really want to:  have a function that
returns the first ancestor of a dentry that is a layer root (marked
with a flag).  Then we just need to map that dentry to the layer,
which can be done with a hash table or whatever.

And anyway uncached lookup will be slow, and we are only doing this
for copied up files and directories.  So I don't think we need to
worry too much about optimizing this.

So for now lets just go with the original patch but replace
ovl_is_lookable() with is_subdir().

Thanks,
Miklos
