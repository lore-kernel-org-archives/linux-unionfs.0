Return-Path: <vgoyal@redhat.com>
Date: Tue, 4 Sep 2018 10:54:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: What's the right/expected behavior with metacopy=off
Message-ID: <20180904145453.GD1469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi Miklos/Amir,

I have a query about metacopy behavior with metacopy=off.

As of now, metacopy=off still continues to check for metacopy xattr,
and if a metacopy file is found, data copy up takes place when file
is opened for write. And there are other paths in getattr() for reporting
number of blocks of lower file etc.

IOW, metacopy=off does not turn off metacopy functionality completely.
It only disables metacopy for new copy up operations. Anything which
is already metadata copy up (due to previous mounts), that will continue
to work as if metacopy=on was specified during mount.

I am wondering is this the right way to do things. I did this because
we don't have a functionality to detect and warn if current mount options
are incompatible with existing state of file system. Ideally, I think
we should warn/error out if an fs is mounted with metacopy=off and it was
mounted with metacopy=on in the past. And metacopy=off should disable
metacopy path completely (irrespective of the fact whether previously
it was mounted with metacopy=on or not).

Given we don't have such feature in overlayfs yet, I thought continuing
to honor metacopy files even if metacopy=off, will be path of least
surprise for a user.

I want to revisit this question while we are still in -rc phase and
before it becomes a completely supported mode.

What do you folks think about it.

Thanks
Vivek
