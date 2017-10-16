From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 7/9] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Mon, 16 Oct 2017 09:24:53 -0400
Message-ID: <20171016132453.GB31318@redhat.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-8-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxisKjK+kH_kEMb7JPUHn+Gaoa7YNvQsS9W=REUPuywy+A@mail.gmail.com>
 <20171011202713.GF8086@redhat.com>
 <CAOQ4uxgKtG=6QdqPbrkHJTGFS_h2_9SmNeWphwso3uFtM4N4dg@mail.gmail.com>
 <20171013182706.GA23232@redhat.com>
 <CAOQ4uxj1eUq8OWaG4-Fw4Kx2v6jB4p5bwaU6S-iJU7j9vTwEhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753032AbdJPNYy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2017 09:24:54 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj1eUq8OWaG4-Fw4Kx2v6jB4p5bwaU6S-iJU7j9vTwEhQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Sat, Oct 14, 2017 at 09:05:17AM +0300, Amir Goldstein wrote:

[..]
> > When I read memory-barrier.txt, it seems to suggest that RELEASE can let
> > instructions outside critical region sneak into critical region. If that's
> > the case, actually clearing of metaflag can happen before xattr actually
> > got removed. Though I can't think what will go wrong in that case.
> 
> clear_bit takes a spinlock so I *think* clearing of flag cannot sneak
> before removing xattr.

Which spinlock does clear_bit take? Are you referring to ovl_inode->lock mutex?

Vivek
