From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix wrong WARN_ON() in ovl_cache_update_ino()
Date: Tue, 21 Jan 2020 12:04:17 +0200
Message-ID: <CAOQ4uxjsiQ5PKYSPLmgk5b5O_e5255+QK8Obgs9K--cTi3z=7w@mail.gmail.com>
References: <20191223064025.23801-1-amir73il@gmail.com> <CAOQ4uxh4NygFUFvUp3xs8rZRUkc3SDxO1DL6YrNhx3j0SBgAJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-il1-f195.google.com ([209.85.166.195]:45187 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgAUKE3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Jan 2020 05:04:29 -0500
Received: by mail-il1-f195.google.com with SMTP id p8so1879361iln.12
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Jan 2020 02:04:28 -0800 (PST)
In-Reply-To: <CAOQ4uxh4NygFUFvUp3xs8rZRUkc3SDxO1DL6YrNhx3j0SBgAJg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 6, 2020 at 8:35 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Dec 23, 2019 at 8:40 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > The WARN_ON() that child entry is always on overlay st_dev became wrong
> > when we allowed this function to update d_ino in non-samefs setup with
> > xino enabled.
> >
> > It is not true in case of xino bits overflow on a non-dir inode.
> > Leave the WARN_ON() only for directories, where assertion is still true.
> >
> > Fixes: adbf4f7ea834 ("ovl: consistent d_ino for non-samefs with xino")
> > Cc: <stable@vger.kernel.org> # v4.17+
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
>
> Miklos,
>
> If you have time, please send this one to Linus for v5.5.
> It is a simple fix and the only one causing failure in the new xfstests [1]
> that I posted.
>

Gentle nudge..

Thanks,
Amir.
