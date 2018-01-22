From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v10 07/18] ovl: Add mechanism to create a chain of origin dentries
Date: Mon, 22 Jan 2018 21:34:20 +0200
Message-ID: <CAOQ4uxiAbz479QygqeJGcbZdO2y1apJo3SqXAXby05c9z2Q85Q@mail.gmail.com>
References: <20180122184004.26026-1-vgoyal@redhat.com> <20180122184004.26026-8-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:34830 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751149AbeAVTeW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 14:34:22 -0500
Received: by mail-yw0-f172.google.com with SMTP id u21so3642589ywc.2
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2018 11:34:22 -0800 (PST)
In-Reply-To: <20180122184004.26026-8-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Jan 22, 2018 at 8:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> There is a need to support metacopy dentry in midlayer. That means there
> could be a chain of metacopy dentries.
>
> For example, upper could be metacopy, midlayer lower could be metacopy and
> lowest layer could be actual data inode. This means when we copy up actual
> data, we should be able to reach to lowest data inode and copy up data from
> there. And that means we should keep track of all the dentries in origin
> chain which lead to data inode.
>
> Current ovl_check_origin() logic only looks for one origin dentry. This patch
> enhances ovl_check_origin() to continue to follow origin chain and return
> all the origin entries found. This is done only if caller of the function
> set "follow_chain" argument.
>

We don't really need to keep the entire chain do we?
We can follow chain but keep only the one inode that is not a metacopy inode.
All the rest are useless, no?
Then we don't create a new type of object - non-dir with numlower > 1.

Amir.
