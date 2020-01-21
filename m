From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix wrong WARN_ON() in ovl_cache_update_ino()
Date: Tue, 21 Jan 2020 11:07:10 +0100
Message-ID: <CAJfpegtcpqhiOqbdCCEz5_h=2WbYDWvLihAUYPC9KkB-uCmDbg@mail.gmail.com>
References: <20191223064025.23801-1-amir73il@gmail.com> <CAOQ4uxh4NygFUFvUp3xs8rZRUkc3SDxO1DL6YrNhx3j0SBgAJg@mail.gmail.com>
 <CAOQ4uxjsiQ5PKYSPLmgk5b5O_e5255+QK8Obgs9K--cTi3z=7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:33533 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgAUKHX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Jan 2020 05:07:23 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so2275207ioh.0
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Jan 2020 02:07:22 -0800 (PST)
In-Reply-To: <CAOQ4uxjsiQ5PKYSPLmgk5b5O_e5255+QK8Obgs9K--cTi3z=7w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 21, 2020 at 11:04 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jan 6, 2020 at 8:35 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Dec 23, 2019 at 8:40 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > The WARN_ON() that child entry is always on overlay st_dev became wrong
> > > when we allowed this function to update d_ino in non-samefs setup with
> > > xino enabled.
> > >
> > > It is not true in case of xino bits overflow on a non-dir inode.
> > > Leave the WARN_ON() only for directories, where assertion is still true.
> > >
> > > Fixes: adbf4f7ea834 ("ovl: consistent d_ino for non-samefs with xino")
> > > Cc: <stable@vger.kernel.org> # v4.17+
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> >
> > Miklos,
> >
> > If you have time, please send this one to Linus for v5.5.
> > It is a simple fix and the only one causing failure in the new xfstests [1]
> > that I posted.
> >
>
> Gentle nudge..

I'm working this into the next batch bound for 5.6, unless something
more urgent comes up before that.

Thanks,
Miklos
