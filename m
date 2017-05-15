From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs in 4.12-rc1. Files in lower become unwritable in the overlay
Date: Mon, 15 May 2017 19:57:03 +0200
Message-ID: <CAJfpegs_FGhA4yj=W6eraLrw4GAavTv1-Zxwj27XM4QgGvo-_Q@mail.gmail.com>
References: <E1dAI7k-0006Fd-6q@tux00.mathematik.uni-freiburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36214 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdEOR5F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2017 13:57:05 -0400
Received: by mail-oi0-f43.google.com with SMTP id h4so140112451oib.3
        for <linux-unionfs@vger.kernel.org>; Mon, 15 May 2017 10:57:05 -0700 (PDT)
In-Reply-To: <E1dAI7k-0006Fd-6q@tux00.mathematik.uni-freiburg.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Martin Ziegler <ziegler@uni-freiburg.de>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, May 15, 2017 at 5:41 PM,  <ziegler@uni-freiburg.de> wrote:
>
> How to reproduce: Make sure that the kernel is compiled with
> CONFIG_TMPFS_XATTR not set. (Otherwise, as Miklos suggested, the bug
> does not occur)
>
> Start with a directory "lower" (btrfs in my case) containing an empty
> file "x", and three empty directories "upper", "workdir", "over" on
> "/tmp" (tmpfs). Then mount the overlayfs
>
>    sudo mount -t overlay -o \
>      lowerdir=lower,upperdir=/tmp/upper,workdir=/tmp/workdir overlay \
>      /tmp/over
>
> Then the commands
>
>    sudo touch /tmp/over/x
>    sudo mv /tmp/over/x /tmp/over/z
>
> fail:
>   touch: cannot touch '/tmp/over/x': Operation not supported
>   mv: cannot move '/tmp/over/x' to '/tmp/over/z': Operation not
>   supported

Thanks for the report.  Fix pushed to overlayfs-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git

Miklos
