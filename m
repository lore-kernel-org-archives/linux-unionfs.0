From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Thu, 14 Sep 2017 08:46:57 +0200
Message-ID: <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu> <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Sep 13, 2017 at 6:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Sep 13, 2017 at 7:05 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> There are also some bug fixes, one in particular (random ioctl's shouldn't be
>> able to modify lower layers) that touches some vfs code, but of course no-op for
>> non-overlay fs.
>
> Argh. I _despise_ those changes to 'd_real()'.
>
> I reall ythink you should have made it a bit in the f_flags argument
> instead. The whole "pick the upper file" is _very_ similar to the
> file->f_flags bits conceptually - those change how accesses are done
> in other ways (eg O_DIRECT etc), and it's entirely possible that some
> day maybe you'd even want to expose it to user space as a O_UPPER flag
> to open (which would then only succeed if the file is in the upper
> overlay, and never open the lower filesystem).
>
> So adding _another_ field that is only for overlayfs and makes
> absolutely no sense in any other context is nasty. It's wrong. That's
> not a "VFS layer interface" any more. It's just an ugly hack that
> makes no sense outside of overlayfs.

d_real() is currently is *the* overlayfs-op:

$ git grep -l "\.d_real"
fs/overlayfs/super.c

It might find other uses in the future, but for now that's the fact.

I could have merged D_REAL_UPPER into f_flags, but it would have
polluted the O_ namespace (which is a uapi)  with an internal flag.
Look at the MS_ flags mess to see how mixing internal and external
flags is a really bad idea.

Changing internal interfaces is so much easier than userspace
interfaces.  So this is not set in stone, and since currently
overlayfs is the only user of the d_real api, it's really trivial to
change around if we find some other use for it.

But if we try to think up some interface  (e.g. the O_UPPER that you
suggested) then we'll be stuck with it even if it makes no sense, or
worse, causes problems.  So let's just wait until the need for
something comes up, then we can massage the internal interface to our
liking.

Thanks,
Miklos
