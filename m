From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix dir cache leak for ovl_cache_get
Date: Mon, 8 May 2017 13:05:16 +0300
Message-ID: <CAOQ4uxhkS4uCaJWyZ-pWehu05b=cbQ=O=UgQytR=UzXYZwbh+w@mail.gmail.com>
References: <1493881633-3451-1-git-send-email-rockdotlee@gmail.com>
 <CAOQ4uxinf7VO+=LnUkBjgCAQvUB-4nwP6vMPM4Orcq2FvgQdKg@mail.gmail.com>
 <CAL-1w2tQmJFxu+72wkKu9wZznx0wE-UX24cFzCG=3XfEY4PETQ@mail.gmail.com>
 <CAOQ4uxginvgDYQD+ijXSeU+EbDTV6+Q2OH3MP6kvN-0aY6XNdA@mail.gmail.com> <CAL-1w2uu3b2Cc5cvrJEC5Wd2HzSEKkDGUR=vztL2VdAFamVJuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33868 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753969AbdEHKFR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 May 2017 06:05:17 -0400
Received: by mail-oi0-f46.google.com with SMTP id b204so44540262oii.1
        for <linux-unionfs@vger.kernel.org>; Mon, 08 May 2017 03:05:17 -0700 (PDT)
In-Reply-To: <CAL-1w2uu3b2Cc5cvrJEC5Wd2HzSEKkDGUR=vztL2VdAFamVJuQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Rock Lee <rockdotlee@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

On Mon, May 8, 2017 at 12:54 PM, Rock Lee <rockdotlee@gmail.com> wrote:

>
> One more question, only ctx->pos == 0 in ovl_iterate would cause
> ovl_dir_reset and rebuild dir cache which means in some scenarios, dir
> cache may be not up to date. Consider this code:
>
>     DIR *dirp = opendir("foo");
>     readdir(dirp);                /* make sure ctx->pos != 0 in the
> blow readir() */
>     creat("foo/bar" ,0600);  /* ovl_dentry_version_inc() */
>     while ((entry = readdir(dirp)) != NULL) {
>         printf("name %s\n", entry->d_name);
>     }
>
> In this case, "foo/bar" will not be shown in the output because
> readdir will not rebuild dir cache. Could we just ovl_dir_reset()
> everytime regardless of ctx->pos in ovl_iterate() ? Once files
> created/removed/renamed in a directory, ovl_iterate will rebuild dir
> cache and keep the dir cache up to date?
>

We can't because:

1. After rebuilding the cache, you have no guaranty that ctx->pos is
pointing AFTER all the entries that you already read BEFORE rebuilding
the cache, so the result list can be a total disaster.

2. Even if we have a way to use persistent iterator position somehow,
rebuilding the cache on every iteration for a large dir is expensive.

Anyway, the situation you described - skipping an entry that was created
AFTER dir iteration has started can happen on any file system, so it's not
even a bug what you suggest to fix.

Amir.
