From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Thu, 20 Apr 2017 10:45:46 +0200
Message-ID: <CAJfpeguojvzDKN3bPqbwxxAJ+G2bfH3eO3Oe+H4AAcZp9Svwzg@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com>
 <CAJfpegsQTd8SgHRFcuEJMgjLjNW45vyuUiPPKZLC4bv_OJOmGA@mail.gmail.com>
 <CAOQ4uxh1VmeB1WGuP4sXyzR0oeQ_ux2hd+9vXM=UbsL+cxTwXQ@mail.gmail.com>
 <CAJfpegumzAZbvyWgfYaLtG1L7LF_Ob2zgA55Hz5H5Ctv7DoJ=Q@mail.gmail.com>
 <CAOQ4uxi0vRsyY2jrS_baaZ3n+d0Fx+6fDWj2Wm=4ZEGAZGHzDQ@mail.gmail.com>
 <CAJfpegsDMfM066PvoQup5SwS3exmfM23+2EWiUsuGROZvN3H_g@mail.gmail.com>
 <CAOQ4uxjWvgKr02-D-HwnGwrpoq165W++aOxddRUHhDFvv8bB7w@mail.gmail.com>
 <20170419225837.GE5205@birch.djwong.org> <940D64D5-55A8-45D1-844F-41872B2FEBB6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36155 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943724AbdDTIps (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 04:45:48 -0400
Received: by mail-oi0-f46.google.com with SMTP id r203so40682603oib.3
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2017 01:45:48 -0700 (PDT)
In-Reply-To: <940D64D5-55A8-45D1-844F-41872B2FEBB6@dilger.ca>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Thu, Apr 20, 2017 at 1:15 AM, Andreas Dilger <adilger@dilger.ca> wrote:

> I recall there was a similar issue with GlusterFS assuming only 32-bit
> readdir cookies on ext4, and stashing some information in the high bits,
> but that broke when ext4 moved to 64-bit readdir cookies to avoid hash
> collisions on "normal sized" directories (above ~32k entries).
>
> I'd agree that it is the filesystem's prerogative to use any/all of the
> 64-bit inode number when it wants, and stacking filesystems shouldn't
> try to usurp those bits for something else, only to suffer later on.

Thought experiment:  we extend statx with 128bit inode numbers; is it
now the filesystems' prerogative to use all of the 128 bits for what
it wants?

See the flaw with that reasoning?

Ideally we'd want dynamically sized inode numbers and we have that:
file handles.  But file handles do more than inode numbers and they
are more heavyweight.


> There is already some interest to add 64-bit inode numbers for ext4, and
> it may allocate inode numbers sparsely, so just because the filesystem has
> 2^33 inodes in it doesn't imply that the highest possible inum is 2^33,
> but could instead be 2^48 or something else entirely.

Exactly.

I'm not saying we should limit filesystems use of MSB's but that
filesystems should be able to say that they will use at max say 56
bits or whatever.   They would be free to say they use all 64, but
that would limit their use in stacking filesystems so they may not
want to do that.

Is that not reasonable?

Thanks,
Miklos
