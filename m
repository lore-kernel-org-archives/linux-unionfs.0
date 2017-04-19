From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Wed, 19 Apr 2017 15:58:37 -0700
Message-ID: <20170419225837.GE5205@birch.djwong.org>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com>
 <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com>
 <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
 <CAJfpegumzAZbvyWgfYaLtG1L7LF_Ob2zgA55Hz5H5Ctv7DoJ=Q@mail.gmail.com>
 <CAOQ4uxi0vRsyY2jrS_baaZ3n+d0Fx+6fDWj2Wm=4ZEGAZGHzDQ@mail.gmail.com>
 <CAJfpegsDMfM066PvoQup5SwS3exmfM23+2EWiUsuGROZvN3H_g@mail.gmail.com>
 <CAOQ4uxjWvgKr02-D-HwnGwrpoq165W++aOxddRUHhDFvv8bB7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35872 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937565AbdDSW6t (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 18:58:49 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjWvgKr02-D-HwnGwrpoq165W++aOxddRUHhDFvv8bB7w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Apr 19, 2017 at 06:17:15PM +0300, Amir Goldstein wrote:
> On Wed, Apr 19, 2017 at 6:01 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Wed, Apr 19, 2017 at 4:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >> Well, if you are lucky you can run into a filesystem that exports
> >> a file handle of type FILEID_INO32_GEN, then you *know* you're
> >> good to go. ext* will do that and xfs that was forever mounted with
> >> -o inode32.
> >> Even with xfs -o inode64, it will not use the MSB ino bits unless
> >> you are in the exabytes fs sizes.

I think it only takes really big AGs for it to start using the >32 bit parts.

> >
> > Could filesystems export a max-ino property in their sb?  That would
> > help with doing this properly.
> >
> 
> Sounds reasonable, but as max-ino usually derived from filesystem size
> and filesystems can grow size online, you will need to query both the
> 'soft' ino limit (without growing fs) and the 'hard' ino limit.
> 
> Darrick,
> 
> Are there bits in GETFSMAP to provide this info?

Nope.  I suppose there could be a way to find out the theoretical
maximum inode number for a filesystem (statvfsx, etc.) but on the other
hand I can also see the other fs developers not wanting to expose that
information for fear that someone will start using the upper bits (inode
numbers should just be a 64-bit cookie we hand to users, right?) and
then they'll have to resort to all sorts of trickery to avoid breaking
things if they ever /do/ want to use those high bits that have been
claimed by someone else.

/me wonders what you're trying to accomplish?

--D
