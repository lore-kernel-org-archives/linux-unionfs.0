From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v9 04/15] ovl: Create origin xattr on copy up for all files
Date: Mon, 8 Jan 2018 11:16:55 +0100
Message-ID: <CAJfpegvL1ZvSq3gm5oqHR_AzeW4XHOP2V=PUyuY0ubUrxYO4cA@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <20171129155448.32721-5-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:43812 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754372AbeAHKQ4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 05:16:56 -0500
Received: by mail-qk0-f174.google.com with SMTP id j137so13458219qke.10
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jan 2018 02:16:55 -0800 (PST)
In-Reply-To: <20171129155448.32721-5-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>

On Wed, Nov 29, 2017 at 4:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now my understanding is that origin xattr is created for all copied
> up files if index=on. And if index=off, then we create it for all type
> of files except hardlinks (nlink != 1).
>
> With metadata only copy up, I will still require origin xattr to copy up
> data later, so create it even for hardlinks even with index=off.

This doesn't look right.  Without index we can't do hard links
properly, doing metacopy in that case will complicate the situation
further and can result in weirdness (e.g. two files that have
different attributes but same inode number).

So I think we should either require index for metacopy, or disable
metacopy only for nlink != 1 files, but otherwise enable it even in
case of index=off.

Thanks,
Miklos
