From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Thu, 14 Sep 2017 13:24:22 -0700
Message-ID: <CA+55aFznd3O7CtT9tKSs4_HVY_OYiUHdcZFzx8eQaG8Ye5AVdA@mail.gmail.com>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
 <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
 <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com>
 <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com> <CAJfpegvK_LyL0eHbmpp=NrJMnS1i8KkPpxRtBL_zyB_n-NKg7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:51592 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdINUYX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2017 16:24:23 -0400
In-Reply-To: <CAJfpegvK_LyL0eHbmpp=NrJMnS1i8KkPpxRtBL_zyB_n-NKg7A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Sep 14, 2017 at 1:12 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> I was saying that it's a bad idea to mix external and internal flags.
> That was the reason the two were separated on that API. I'm open to
> arguments about that.

The thing is, I don't think "upper layer" is any more internal than
"direct IO" is.

And I don't think it's necessarily overlayfs-specific. Other
filesystems have potential upper layers (eg things like caching
layers, where the "upper" layer could be "the cached copy").

And no, I'm, not saying we should expose things directly to user
space. We have lots of operations where we expose some flags to user
space but keep others internal (look at the VM_xyz flags for mmap, for
example - we obviously expose things like read/write/execute to user
space, but we have the MAYREAD/MAYWRITE/MAYEXEC flags in the same word
that are *not* something that user space can just set).

I just don't see any reason why those two "flags" arguments are separate.

              Linus
