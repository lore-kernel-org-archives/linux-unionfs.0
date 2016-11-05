From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs fixes for 4.9-rc3
Date: Sat, 5 Nov 2016 14:30:21 -0700
Message-ID: <CA+55aFzn7RvHfbYkRmJZ2LWbAVHGBSPoAMQNkKh7DsOYX82_9w@mail.gmail.com>
References: <20161104093050.GB1839@veci.piliscsaba.szeredi.hu>
 <CA+55aFx7bsMNKMfxaxXuw=E13H5dQpGQHdNgBKKt_JKyL2eGeQ@mail.gmail.com>
 <CAOQ4uxjsfAwpvKj1PXvR+_DWKm0HxF7sn1j7QfTzXWquvvXvTQ@mail.gmail.com>
 <CA+55aFwseoebvgSvi8sHswESOGnLknh+d6_aYAknwPFQbtp7hg@mail.gmail.com> <CAJfpegs6e_K7y-CPj4dm1qtoF6h1z0dFrXHxJSc8TsV=ckuEbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegs6e_K7y-CPj4dm1qtoF6h1z0dFrXHxJSc8TsV=ckuEbA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sat, Nov 5, 2016 at 12:45 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> The feature that would be introduced is this: allow directory renames
> to work without having to recursively copy-up the subtree.  Whatever
> mechanism is devised to do this will be backward incompatible.  Maybe
> it's a misguided idea, but it's been through several rounds of reviews
> on the relevant mailing lists and there weren't any objections (yet).
>
> And the thing is, backward incompatibility is less of an issue for
> overlayfs than for normal filesystems, because it's usually not
> something people store their root filesystems on, and if so they can
> simply not turn off this feature.

(a) that should be explained

(b) that has nothing to do with being marked for stable

(c) that new doesn't actually explain in any way why you'd want
"feature flags" thing, for exactly the same "backwards incompatibility
is less of an issue" reason that you state.

Why not "just do it", in other words. For exactly the reasons you say.
Make it a mount option that people can choose to use or not.

> overlayfs relies on xattr to create opaque directories

Yes and no. It relies on it for THAT ONE FEATURE, which you don't have
to use. As far as I can tell, overlayfs does *not* rely on xattrs in
general.

               Linus
