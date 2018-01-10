From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v9 00/15] overlayfs: Delayed copy up of data
Date: Wed, 10 Jan 2018 10:47:36 -0500
Message-ID: <20180110154736.GD8999@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
 <CAOQ4uxiKAXXNOkY2gvWWkTTuw7TRu9z33az8uVf0Z47uH2LdyA@mail.gmail.com>
 <20180108141335.GB9910@redhat.com>
 <CAOQ4uxjM4fQstyWkZcCWA0BO40sxuTd5wNESeL_B21SNp4zdgg@mail.gmail.com>
 <20180110145647.GA8999@redhat.com>
 <CAOQ4uxjjr=FzHLvYpBQ4Uebp9-fT2Prnm-XUNkc=LRaT3QMFHQ@mail.gmail.com>
 <20180110152715.GC8999@redhat.com>
 <CAJfpegttqS4mWR3Pt4AK9Zp32LoqD7kx_wXqyVaZjJpHjx+ZVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965202AbeAJPrh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 10:47:37 -0500
Content-Disposition: inline
In-Reply-To: <CAJfpegttqS4mWR3Pt4AK9Zp32LoqD7kx_wXqyVaZjJpHjx+ZVQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 10, 2018 at 04:38:22PM +0100, Miklos Szeredi wrote:
> On Wed, Jan 10, 2018 at 4:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Jan 10, 2018 at 05:10:22PM +0200, Amir Goldstein wrote:
> >
> > [..]
> >> >> >> 1. Considering Miklos' commit
> >> >> >>     438c84c2f0c7 ovl: don't follow redirects if redirect_dir=off
> >> >> >>     It is probably not a good idea to allow lookup of metacopy unless
> >> >> >>     metacopy=on. Is that already the behavior in V9?
> >> >> >
> >> >> > Hi Amir,
> >> >> >
> >> >> > Hmm.., no, that's not the behavior in V9. Remember, we wanted to follow
> >> >> > metacopy origin even if metacopy=off. That way a user can mount a
> >> >> > overlayfs with metacopy=off (which was previously mounted as metacopy=on)
> >> >> > and not be broken.
> >> >> >
> >> >>
> >> >> User can also mount with redirect_dir=nofollow after previously mounting with
> >> >> redirect_dir=on. It's the exact same thing.
> >> >>
> >> >> > If we follow metacopy only if metacopy=on, then we really need some
> >> >> > mechanism which can atleast warn user that this overlay mount was
> >> >> > mounted with metacopy=on in the past and expect some unexpected results
> >> >> > if mounted with metacopy=off.
> >> >> >
> >> >> > Has there been any agreement on what mechanism to use to remember what
> >> >> > features have been turned on existing overlay mount.
> >> >> >
> >> >>
> >> >> There is no agreement, but there is code in upstream that "allows" the user
> >> >> to make the same with redirect_dir. The consequences of this configuration is
> >> >> -EPERM on lookup.
> >> >> You actually have to allow this configuration for security reasons, the only
> >> >> question is whether metacopy will have 3 modes (off/follow/on) or just on/off
> >> >> where off implies nofollow.
> >> >
> >> > Hi Miklos and Amir,
> >> >
> >> > Thinking more about security implications of this.
> >> >
> >> > Can a user hand craft ORIGIN xattr? I mean, if inode number of lower file
> >> > is known, can a user come up with file handle of lower and put in ORIGIN
> >> > XATTR?
> >>
> >> Yes, its quite easy if you know the underlying fs.
> >> For example for ext4, you don't even need to guess the generation number,
> >> you can provide 0 generation and ext4 treats it as ANY.
> >>
> >> >
> >> > If yes, this sounds like a security concern. Then I as a user can simply
> >> > hand craft an upper file and point to any file in lower and put associated
> >> > ORIGIN and METACOPY xattr on upper and next time mount is done with
> >> > metacopy=on, I can get access to any lower file?
> >> >
> >> > In fact, not just metacopy, if ORIGIN can be handcrafted, then we will have
> >> > to be very careful on when ORIGIN should be followed otherwise an
> >> > handcrafted upper can lead to unexpected security issues. (This is
> >> > assuming that we will use ORIGIN for more and more features).
> >> >
> >> > Am I overthinking this?
> >> >
> >>
> >> It is exactly as you wrote. Not any less or any more of a security concern
> >> than a hand crafted redirect_dir. The only difference is that without
> >> metacopy=on and without redirect_dir=origin, the only implication of
> >> following an hand crafted origin would be to get a different st_dev/st_ino
> >> and for example, to fake that 2 files/dirs are the same while one is actually
> >> a rootkit/malware. So not that easy to exploit in current upstream.
> >
> > Right. Currently we seem to be using origin only for st_dev/st_ino so
> > no big impact. "metadata only copyup" is first feature which will make
> > data of lower file available using ORIGIN. So anymore features we add
> > using ORIGIN, we will have to be extra careful. Atleast make it
> > conditional on a mount option and document that using this mount option
> > on untrusted layer source can lead to privilege escalation.
> 
> One more reason to use redirect, rather than origin.   Redirect at
> least constrains things to inside the overlay, while following origin
> can lead to anywhere within the filesystem.
> 
> The other reason is backup+restore not breaking.

Agreed. Looks like using REDIRECT instead of ORIGIN is more appealing. I 
will give it a try and see what issues do I run into.

Vivek
