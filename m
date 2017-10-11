From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/9] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 11 Oct 2017 12:53:48 -0400
Message-ID: <20171011165348.GC8086@redhat.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-4-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxiU6BNrwKnfx1ToY4ZARV8X4S6HRNmfhCmaON=+46B7bg@mail.gmail.com>
 <20171011135715.GB8086@redhat.com>
 <CAOQ4uxg1OwbFuytiHLn3fwXzu3mZ8cwW6Vadj3YgTihbiL0BdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbdJKQxt (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2017 12:53:49 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg1OwbFuytiHLn3fwXzu3mZ8cwW6Vadj3YgTihbiL0BdA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Wed, Oct 11, 2017 at 07:29:38PM +0300, Amir Goldstein wrote:

[..]
> >
> > Anyway, I did not understand what's the problem with borken upper
> > hardlinks when index=off. If two upper hardlinks (broken), can
> > point to same ORIGIN on lower, they will just copy up same data.
> >
> > IOW, it does not seem to be more broken then what it is now just
> > becase of metadata copy up or because of both upper pointing to
> > same ORIGIN? What am I missing.
> >
> It is not broken now because we intentionally do NOT set origin when
> copying up lower hardlinks and index is disabled.
> You must not break this rule, so instead you can avoid metacopy for
> lower hardlinks when index is disabled.

Hi Amir,

Ok, I am open to change it so that if index=off, lower hardlinks are not
copied up metadata only.

But please help me understand that what *additional* thing breaks if origin
is set when index=off. 

Say lower has a file foo.txt and another hard link foo-link.txt.
(say index=off, metacopy=off).

Say, I open foo-link.txt for WRITE, and it gets copied up. Now there is
no link between foo-link.txt and foo.txt and if a user opens foo.txt for
READ, it does not see updates to foo-link.txt. So this is the broken
behavior of hardlinks with index=off, as of today.

Now I go back to original state and this time do same operation with
(indxex=off, metacopy=on). Then "chown foo-link.txt" will only copy
metadata and set origin to lower file. Say I also chown "foo.txt", that
will do the same thing. Now both foo.txt and foo-link.txt will have
ORIGIN pointing to same lower inode. If any of the file is opened for
WRITE, data will be copied up from same origin.

So setting same ORIGIN on two upper files, does not seem to break anything
additional, AFAICS. What am I missing.

Vivek
