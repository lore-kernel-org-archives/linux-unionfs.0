From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v9 04/15] ovl: Create origin xattr on copy up for all files
Date: Mon, 8 Jan 2018 13:18:05 +0200
Message-ID: <CAOQ4uxg1K_EA+kYzMB8LMP4B-VLxStRT3yworjMJhHWAHNTxWg@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <20171129155448.32721-5-vgoyal@redhat.com>
 <CAJfpegvL1ZvSq3gm5oqHR_AzeW4XHOP2V=PUyuY0ubUrxYO4cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f181.google.com ([209.85.213.181]:46764 "EHLO
        mail-yb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755973AbeAHLSH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 06:18:07 -0500
Received: by mail-yb0-f181.google.com with SMTP id b39so4346490ybj.13
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jan 2018 03:18:06 -0800 (PST)
In-Reply-To: <CAJfpegvL1ZvSq3gm5oqHR_AzeW4XHOP2V=PUyuY0ubUrxYO4cA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 8, 2018 at 12:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Nov 29, 2017 at 4:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> Right now my understanding is that origin xattr is created for all copied
>> up files if index=on. And if index=off, then we create it for all type
>> of files except hardlinks (nlink != 1).
>>
>> With metadata only copy up, I will still require origin xattr to copy up
>> data later, so create it even for hardlinks even with index=off.
>
> This doesn't look right.  Without index we can't do hard links
> properly, doing metacopy in that case will complicate the situation
> further and can result in weirdness (e.g. two files that have
> different attributes but same inode number).

But ovl_getattr() does not return lower st_ino for non-indexed
upper with lowerstat.nlink != 1.

>
> So I think we should either require index for metacopy, or disable
> metacopy only for nlink != 1 files, but otherwise enable it even in
> case of index=off.
>

IIRC, commit 6eaf011144af ("ovl: fix EIO from lookup of non-indexed
upper") was a result of a conversation about this very patch and this
very issue. After this commit, the situation of non-indexed upper with
origin is handled correctly on lookup (hash by upper inode) and I
couldn't find a reason why setting origin for metacopy with index=off
is wrong. Or anything that could go wrong for setting origin on every
copy up.

Am I missing something?

Amir.
