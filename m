From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Thu, 14 Sep 2017 13:00:24 -0700
Message-ID: <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
 <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com> <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34500 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdINUA1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2017 16:00:27 -0400
In-Reply-To: <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Sep 13, 2017 at 11:46 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> d_real() is currently is *the* overlayfs-op:

I know. And it's ugly as #%^! hell.

We don't want to  make it uglier.

And honestly, if you think that "it's only for overlayfs, so I can do
anything I damn well want to this p[iece of shit" is valid, then I
want to re-educate you. That is *not* how the VFS layer works.

If you can't bother to try to make it act as a proper VFS thing, then
I don't want to see patches from you to the VFS code.

I'm perfectly happy just reverting those changes again. Because I'm
not making the VFS layer bend over backwards due to some overlayfs
braindamage.

                 Linus
