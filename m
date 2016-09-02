From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Bug#836211: dpkg: Cannot upgrade some packages on overlayfs:
 Invalid cross-device link
Date: Fri, 2 Sep 2016 14:30:58 +0200
Message-ID: <CAJfpegu-JhRpDmzx1=fLsnL+=FTsAX21Up5A6s4eQFDPZ2ET3g@mail.gmail.com>
References: <147265657047.31705.7496372748096616425.reportbug@felipepc> <20160902113633.5kbibrlwlhhlppyr@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36116 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbcIBMbA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Sep 2016 08:31:00 -0400
Received: by mail-oi0-f46.google.com with SMTP id r205so78934110oih.3
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Sep 2016 05:31:00 -0700 (PDT)
In-Reply-To: <20160902113633.5kbibrlwlhhlppyr@home.ouaza.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Raphael Hertzog <hertzog@debian.org>
Cc: Felipe Sateler <fsateler@debian.org>, 836211@bugs.debian.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Sep 2, 2016 at 1:36 PM, Raphael Hertzog <hertzog@debian.org> wrote:
> Hi,
>
> On Wed, 31 Aug 2016, Felipe Sateler wrote:
>> overlayfs does not support renaming directories when the directories
>> live in the lower filesystem:
> [...]
>> Unfortunately this means that dpkg fails at least in the case where a
>> directory is converted into a file: apt 1.3~rc2 moves
>> /usr/share/bug/apt/script to /usr/share/bug/apt . This causes dpkg to
>
> That's the change at the package level. The operation that fails
> at the dpkg level is rename('/usr/share/bug/apt', '/usr/share/bug/apt.dpkg-tmp').
>
>> fail when running in an overlayfs with the following error:
> [...]
>>  unable to move aside './usr/share/bug/apt' to install new version: Invalid cross-device link
>
> I got the same failure here but I also saw similar reports in a Kali live
> system where overlayfs is used for persistence (and with the upgrade
> of gedit). So that error is affecting many Kali users. It's not a
> very rare error (ex: https://bugs.kali.org/view.php?id=3473,
> https://bugs.kali.org/view.php?id=3476,
> https://bugs.kali.org/view.php?id=3361,
> https://bugs.kali.org/view.php?id=3365).
>
> I'm putting in copy the overlayfs kernel maintainer... Hello Miklos,
> that restriction above (cf
> https://github.com/torvalds/linux/blob/v4.8-rc2/fs/overlayfs/copy_up.c#L318-L322)
> is very problematic for us.
>
> Do you have plans to get rid of it?

You are the first to report that this quirk actually causes problems
in real life.

I have plans to fix this by adding a "redirector" attribute so that
copied up directories (and perhaps files) can refer to lower directory
that is found at a different location relative to the root of the
overlay from the location of the upper directory.

Maybe an example can make this more clear:

lower/foo/bar/baz
upper/foo/bar <- whiteout
upper/moved/here <- redirects to "foo/bar"

will result in the tree:

overlay/moved/here/baz

> It does not seem very correct to put the burden on user-space to be aware
> of overlayfs restrictions such as this one. Renaming a directory is
> not something that happens often in practice in the uses cases where
> we use overlayfs but it's still frequent enough to deserve better than
> a EXDEV error IMO and dpkg trying to rename "foo/" into "foo.dpkg-tmp/"
> is in its right to assume that this rename will not cross any device
> boundary.

The EXDEV trick  just works for mv(1), hence this didn't seem to be a
big issue in practice.

Thanks,
Miklos
