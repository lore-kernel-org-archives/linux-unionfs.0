From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Wed, 13 Sep 2017 09:25:25 -0700
Message-ID: <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Sep 13, 2017 at 7:05 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> There are also some bug fixes, one in particular (random ioctl's shouldn't be
> able to modify lower layers) that touches some vfs code, but of course no-op for
> non-overlay fs.

Argh. I _despise_ those changes to 'd_real()'.

I reall ythink you should have made it a bit in the f_flags argument
instead. The whole "pick the upper file" is _very_ similar to the
file->f_flags bits conceptually - those change how accesses are done
in other ways (eg O_DIRECT etc), and it's entirely possible that some
day maybe you'd even want to expose it to user space as a O_UPPER flag
to open (which would then only succeed if the file is in the upper
overlay, and never open the lower filesystem).

So adding _another_ field that is only for overlayfs and makes
absolutely no sense in any other context is nasty. It's wrong. That's
not a "VFS layer interface" any more. It's just an ugly hack that
makes no sense outside of overlayfs.

Try to make it something that makes conceptual sense, and isn't just
an overlayfs issue. For example, maybe for cachefs the bit could mean
"give me the cached copy without doing validation or looking anything
new up". Try to make it something that actually makes sense from a
higher-level perspective, where overlayfs is just one implementation,
not the driving force. See what I'm saying? THAT is what VFS layer
interfaces should all be about, not about "this one specific
filesystem needs this one specific f*cking ugly hack".

I've pulled it, but I really think you should change this.

                Linus
