From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Questions about redirect_fd feature
Date: Tue, 18 Apr 2017 17:16:49 +0300
Message-ID: <CAOQ4uxi-8OTHAicvAmDoUA3DUf4a-ajWko5qmO6PUYra7-5PyA@mail.gmail.com>
References: <CAL-1w2uGpuFNCLycjUNNrWDZkdrtkZDGAkEtMOT7E34wdZYwtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36442 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753040AbdDROQu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 10:16:50 -0400
Received: by mail-oi0-f54.google.com with SMTP id r203so178293812oib.3
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2017 07:16:50 -0700 (PDT)
In-Reply-To: <CAL-1w2uGpuFNCLycjUNNrWDZkdrtkZDGAkEtMOT7E34wdZYwtw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Rock Lee <rockdotlee@gmail.com>
Cc: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2017 at 3:59 PM, Rock Lee <rockdotlee@gmail.com> wrote:
> Hi, Amir
> I am a little confused. redirect_fd feature needs to wrt a file handle

typo: redirect_fh (not to be confused with consistent_fd)

> to a xattr in upper dir, but what are the advantages ? Because it is
> faster to lookup than ordinary lookup ? Could you please give me some
> hints about why redirect by file handle is faster ?

There are some use cases where lookup by fh could be faster than
by path because it just needs one inode lookup (by ino) as opposed
to name lookup per path element (e.g. in path /a/b/c/d/e/f/g/h/i/g/k)
and also redirect by path is limited to certain path length (which is less
than MAX_PATH).

But to be honest, those optimizations are not  the reason I needed
redirect_fh. My reasons are related to overlayfs snapshots and it
not easy to explain.

In my recent submission of "stable inode" feature, redirect_fh is used
to track the origin of non-dir copy up files.
That is an easier motivation to explain and that is the strongest advantage
that overlayfs gains from redirect_fh.

>
> BTW, there are too few comments in the overlayfs code which makes me
> very hard to understand.
>

I can only say that my comment to code ratio is only slightly better than
Miklos's ;-)
I'll do my best to improve.

Thanks,
Amir.
