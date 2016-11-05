From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [GIT PULL] overlayfs fixes for 4.9-rc3
Date: Sat, 5 Nov 2016 08:44:51 +0200
Message-ID: <CAOQ4uxjsfAwpvKj1PXvR+_DWKm0HxF7sn1j7QfTzXWquvvXvTQ@mail.gmail.com>
References: <20161104093050.GB1839@veci.piliscsaba.szeredi.hu> <CA+55aFx7bsMNKMfxaxXuw=E13H5dQpGQHdNgBKKt_JKyL2eGeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx7bsMNKMfxaxXuw=E13H5dQpGQHdNgBKKt_JKyL2eGeQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sat, Nov 5, 2016 at 5:06 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 4, 2016 at 2:30 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> Also introduce the concept of feature flags to allow backward incompatible
>> changes to the overlay format.  This should have been there from day one; the
>> best we can do now is backport to stable kernels.  Add the check for features
>> without adding any actual features yet.
>
> No. I pulled the three other commits, but not that last one.
>
> That feature just seems to actively *encourage* backwards incompatible
> features. It's a bad idea. Don't do it. If we've been able to do
> without it so far, then why should we suddenly start doing things like
> this?
>
> So I don't agree that it should have been there since day one, it just
> shouldn't exist at all.
>

Linus,

Can you please clarify your objection?

I suppose you do not object to the concept of on-disk format version nor on-disk
format compatible/incompatible features sets.
Just to fact that overlayfs didn't have those form day one, so it
should find a way
to cope with that situation without patching stable kernels?

Thanks,
Amir.
