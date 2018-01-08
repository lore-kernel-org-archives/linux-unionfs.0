From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v9 00/15] overlayfs: Delayed copy up of data
Date: Mon, 8 Jan 2018 09:13:35 -0500
Message-ID: <20180108141335.GB9910@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
 <CAOQ4uxiKAXXNOkY2gvWWkTTuw7TRu9z33az8uVf0Z47uH2LdyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755665AbeAHONg (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 09:13:36 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiKAXXNOkY2gvWWkTTuw7TRu9z33az8uVf0Z47uH2LdyA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Sat, Jan 06, 2018 at 09:38:07AM +0200, Amir Goldstein wrote:
> On Wed, Nov 29, 2017 at 5:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi,
> >
> > Please find attached V9 of the patches. Minor changes to take care of
> > Amir's comments. I have also dropped RFC tag. If there are no concerns,
> > then I would like these patches to be included.
> >
> 
> Sorry Vivek, just realized some issues:
> 
> 1. Considering Miklos' commit
>     438c84c2f0c7 ovl: don't follow redirects if redirect_dir=off
>     It is probably not a good idea to allow lookup of metacopy unless
>     metacopy=on. Is that already the behavior in V9?

Hi Amir,

Hmm.., no, that's not the behavior in V9. Remember, we wanted to follow
metacopy origin even if metacopy=off. That way a user can mount a
overlayfs with metacopy=off (which was previously mounted as metacopy=on)
and not be broken.

If we follow metacopy only if metacopy=on, then we really need some
mechanism which can atleast warn user that this overlay mount was 
mounted with metacopy=on in the past and expect some unexpected results
if mounted with metacopy=off.

Has there been any agreement on what mechanism to use to remember what
features have been turned on existing overlay mount.

> 
> 2. An upper layer with metacopy cannot be rotated as middle layer
>     becasue non-dir origin is only followed from upper layer.
>     This needs to be fixed (follow origin of metacopy from middle layer).

I was thinking about it. I did not have an immediate user of this
functinality to so I did not bother too much about it. I will look
into it and see how to implement it.

> 
> 3. You really should write some tests to verify correctness of
>     metadata before requesting to include the feature.

Was thinking about this too. Agreed, it is a good idea to write test
cases. Will do.

Vivek

> 
> I recommend that you start with a simple xfstest that verify expected
> behavior of a some basic use cases with
> _require_scratch_feature metacopy.
> 
> Then, I suggest that you look into extending  unionmount-testsuite's
> check_layer() to know about metacopy. Currently it checks that
> objects that were supposed to be copied up (dentry.copied_up())
> are on upper layer (dentry.on_upper()). It shouldn't be too hard to
> extend that with dentry.data_copied_up() and dentry.data_on_upper().
> to verify metacopy correctness.
> 
> Alas, there are currently no chmod/chown test cases in
> unionmount-testsuite, so you will also need to add some test cases.
> 
> To properly test metacopy in middle layers (once it is implemented)
> you can use ./run --ov=N. Currently, to verify redirect_dir,
> upper layer is rotated on mkdir and rename dir. You will need
> to add some relevant "rotate points" for the metacopy use cases.
> For example, I added rotate and recycle points for testing
> handlinks/index:
> c427e85 - Cycle mount after link rename of non dir
> 
> I never got around to the TODO item
> https://github.com/amir73il/overlayfs/wiki/Overlayfs-TODO#testing
> "unionmount-testsuite configure rotate points"
> I envisioned something like:
>   ./run --ov=N rotate=mkdir,rename recycle=link
> Instead of the hardcoded rotate/recycle points.
> 
> Well, you don't need to implement ALL of that ;-)
> 
> Cheers,
> Amir.
