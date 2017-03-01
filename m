From: Colin Walters <walters@verbum.org>
Subject: Re: overlayfs: allowing for changes to lowerdir
Date: Wed, 01 Mar 2017 15:22:24 -0500
Message-ID: <1488399744.4117222.897262296.4F6CBA5A@webmail.messagingengine.com>
References: <CA+ZH+jFBAaRi6VPmf3PBdDZQQMOaT6WUByATqaw1QL5M9+-dxg@mail.gmail.com>
 <CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com>
 <CA+ZH+jH9yoB5_wxyff088Fsm2-g5=oO1ECimHVo7u2SKVK4AAw@mail.gmail.com>
 <CAOQ4uxh5OVadTPLM-jw5J_6sRKBFv0WB_CTMdy68fe3dxtYsKA@mail.gmail.com>
 <CA+ZH+jE0k2hKoWTMZ2g-5vfU95OFxbW=WxGEC-umQM51vcC1gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+ZH+jE0k2hKoWTMZ2g-5vfU95OFxbW=WxGEC-umQM51vcC1gQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josh England <jjengla@gmail.com>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-unionfs@vger.kernel.org



On Tue, Feb 28, 2017, at 02:08 PM, Josh England wrote:
>  It has always been an
> annoyance to have to find the little bits and pieces in the OS (think
> of a full RHEL/CentOS distro) that require the ability to write
> somewhere

As part of driving the [OSTree](https://ostree.readthedocs.io/en/latest/)
model into Fedora/CentOS (well really rpm-ostree, which is part of Atomic Host),
we have a read-only bind mount over /usr, and the only two writable directories are /etc and /var.

In a diskless mode, then you could have /usr as a read-only NFS/cachefiles mount, and use tmpfs
for /etc and /var.  Ideally /etc can be read-only too during operation but that is
definitely one where we hit things like LVM userspace writing there in the background:
https://bugzilla.redhat.com/show_bug.cgi?id=1366584

But if something required writing to /usr at runtime in Fedora/CentOS that should
be considered a bug.
