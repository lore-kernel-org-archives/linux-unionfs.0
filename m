From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs fixes for 4.9-rc3
Date: Sat, 5 Nov 2016 20:45:35 +0100
Message-ID: <CAJfpegs6e_K7y-CPj4dm1qtoF6h1z0dFrXHxJSc8TsV=ckuEbA@mail.gmail.com>
References: <20161104093050.GB1839@veci.piliscsaba.szeredi.hu>
 <CA+55aFx7bsMNKMfxaxXuw=E13H5dQpGQHdNgBKKt_JKyL2eGeQ@mail.gmail.com>
 <CAOQ4uxjsfAwpvKj1PXvR+_DWKm0HxF7sn1j7QfTzXWquvvXvTQ@mail.gmail.com> <CA+55aFwseoebvgSvi8sHswESOGnLknh+d6_aYAknwPFQbtp7hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwseoebvgSvi8sHswESOGnLknh+d6_aYAknwPFQbtp7hg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sat, Nov 5, 2016 at 6:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 4, 2016 at 11:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> Can you please clarify your objection?
>
> There are several:
>
>  - timing. No way in hell will I take a new feature like this during an rc

I can do it next merge window; the reason I wanted this patch in as
early as possible because, as I said, it's already too late.  But it's
no big deal.

>  - lack of explanation. Why is this bad feature needed in the first
> place? Why would overlayfs versioning _ever_ be a good idea?

The feature that would be introduced is this: allow directory renames
to work without having to recursively copy-up the subtree.  Whatever
mechanism is devised to do this will be backward incompatible.  Maybe
it's a misguided idea, but it's been through several rounds of reviews
on the relevant mailing lists and there weren't any objections (yet).

And the thing is, backward incompatibility is less of an issue for
overlayfs than for normal filesystems, because it's usually not
something people store their root filesystems on, and if so they can
simply not turn off this feature.

>
>  - is the implementation even sane? Right now I don't think overlayfs
> even requires xattr support in the upper filesystem, so the whole
> concept seems frankly totally misdesigned.

overlayfs relies on xattr to create opaque directories (i.e. you
remove a directory (residing on the lower layer) and create one with
the same name).  So it is needed for normal r/w operation.   And
definitely for the above feature which also uses xattr.

Thanks,
Miklos
