From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs fixes for 4.9-rc3
Date: Fri, 4 Nov 2016 20:06:02 -0700
Message-ID: <CA+55aFx7bsMNKMfxaxXuw=E13H5dQpGQHdNgBKKt_JKyL2eGeQ@mail.gmail.com>
References: <20161104093050.GB1839@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161104093050.GB1839@veci.piliscsaba.szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 4, 2016 at 2:30 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Also introduce the concept of feature flags to allow backward incompatible
> changes to the overlay format.  This should have been there from day one; the
> best we can do now is backport to stable kernels.  Add the check for features
> without adding any actual features yet.

No. I pulled the three other commits, but not that last one.

That feature just seems to actively *encourage* backwards incompatible
features. It's a bad idea. Don't do it. If we've been able to do
without it so far, then why should we suddenly start doing things like
this?

So I don't agree that it should have been there since day one, it just
shouldn't exist at all.

                  Linus
