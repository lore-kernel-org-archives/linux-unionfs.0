From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v9 00/15] overlayfs: Delayed copy up of data
Date: Wed, 10 Jan 2018 10:23:45 -0500
Message-ID: <20180110152345.GB8999@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
 <CAOQ4uxiKAXXNOkY2gvWWkTTuw7TRu9z33az8uVf0Z47uH2LdyA@mail.gmail.com>
 <20180108141335.GB9910@redhat.com>
 <CAOQ4uxjM4fQstyWkZcCWA0BO40sxuTd5wNESeL_B21SNp4zdgg@mail.gmail.com>
 <20180110145647.GA8999@redhat.com>
 <CAJfpegv=kfLF+s21s_5S45Dc53F31KXdxXvticg8q5_C26+b7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754083AbeAJPXv (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:23:51 -0500
Content-Disposition: inline
In-Reply-To: <CAJfpegv=kfLF+s21s_5S45Dc53F31KXdxXvticg8q5_C26+b7Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 10, 2018 at 04:08:56PM +0100, Miklos Szeredi wrote:
> On Wed, Jan 10, 2018 at 3:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Jan 08, 2018 at 04:42:59PM +0200, Amir Goldstein wrote:
> >> On Mon, Jan 8, 2018 at 4:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Sat, Jan 06, 2018 at 09:38:07AM +0200, Amir Goldstein wrote:
> >> >> On Wed, Nov 29, 2017 at 5:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> >> > Hi,
> >> >> >
> >> >> > Please find attached V9 of the patches. Minor changes to take care of
> >> >> > Amir's comments. I have also dropped RFC tag. If there are no concerns,
> >> >> > then I would like these patches to be included.
> >> >> >
> >> >>
> >> >> Sorry Vivek, just realized some issues:
> >> >>
> >> >> 1. Considering Miklos' commit
> >> >>     438c84c2f0c7 ovl: don't follow redirects if redirect_dir=off
> >> >>     It is probably not a good idea to allow lookup of metacopy unless
> >> >>     metacopy=on. Is that already the behavior in V9?
> >> >
> >> > Hi Amir,
> >> >
> >> > Hmm.., no, that's not the behavior in V9. Remember, we wanted to follow
> >> > metacopy origin even if metacopy=off. That way a user can mount a
> >> > overlayfs with metacopy=off (which was previously mounted as metacopy=on)
> >> > and not be broken.
> >> >
> >>
> >> User can also mount with redirect_dir=nofollow after previously mounting with
> >> redirect_dir=on. It's the exact same thing.
> >>
> >> > If we follow metacopy only if metacopy=on, then we really need some
> >> > mechanism which can atleast warn user that this overlay mount was
> >> > mounted with metacopy=on in the past and expect some unexpected results
> >> > if mounted with metacopy=off.
> >> >
> >> > Has there been any agreement on what mechanism to use to remember what
> >> > features have been turned on existing overlay mount.
> >> >
> >>
> >> There is no agreement, but there is code in upstream that "allows" the user
> >> to make the same with redirect_dir. The consequences of this configuration is
> >> -EPERM on lookup.
> >> You actually have to allow this configuration for security reasons, the only
> >> question is whether metacopy will have 3 modes (off/follow/on) or just on/off
> >> where off implies nofollow.
> >
> > Hi Miklos and Amir,
> >
> > Thinking more about security implications of this.
> >
> > Can a user hand craft ORIGIN xattr? I mean, if inode number of lower file
> > is known, can a user come up with file handle of lower and put in ORIGIN
> > XATTR?
> >
> > If yes, this sounds like a security concern. Then I as a user can simply
> > hand craft an upper file and point to any file in lower and put associated
> > ORIGIN and METACOPY xattr on upper and next time mount is done with
> > metacopy=on, I can get access to any lower file?
> 
> "trusted." prefix xattrs need CAP_SYS_ADMIN, so no, it's not that
> simple to exploit.

Aha..., forgot about that. So that will atleast make sure that  for
container use case it will be fine. Even if a process manages to get out
of container, it can't write these "trusted." xattrs and not gain 
additional privileges.

> 
> But if underlying layer comes from untrusted source (e.g. pendrive,
> etc) then that could indeed be a security concern.

Ok. I am writing small section on overlayfs.txt about "metadata only
copyup" and I will mention it there.

> 
> So, we should make sure users understand the risks associated with
> overlay mounting.  And we'll need to be especially careful if we want
> to allow unprivileged mount of overlays.

Unprivileged mounts of overlay will come up at some point of time. It
will be tricky.

Vivek
