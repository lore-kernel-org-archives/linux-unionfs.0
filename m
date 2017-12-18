From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ovl: fix overlay: warning prefix
Date: Mon, 18 Dec 2017 13:35:30 +0100
Message-ID: <20171218123530.GA7128@kroah.com>
References: <1511375254-15206-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxi9SMM6YY1SYKOns3S4jEa0cuHDt+DiHo8ThSSMWCTgFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933349AbdLRMf2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 07:35:28 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi9SMM6YY1SYKOns3S4jEa0cuHDt+DiHo8ThSSMWCTgFw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, stable <stable@vger.kernel.org>

On Mon, Dec 18, 2017 at 02:19:52PM +0200, Amir Goldstein wrote:
> On Wed, Nov 22, 2017 at 8:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > Conform two stray warning messages to the standard overlayfs: prefix.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> 
> Greg,
> 
> Upstream commit ("da2e6b7eeda8 ovl: fix overlay: warning prefix")
> was not marked for stable, because it is not a bug fix per-se.
> Nevertheless, it may be useful to apply it to stable kernels to keep
> overlayfs bug reports/analysis consistent.
> 
> The first hunk fixes (#v4.10):
> a6c606551141 ovl: redirect on rename-dir
> 
> The second hunk fixes (#v4.14):
> b5efccbe0a12 ovl: constant d_ino across copy up
> 
> For your consideration.
> If you wish, I can send a patch for v4.10 with just the first hunk.


4.10 is long end-of-life, so I don't think that matters :)

As for 4.14, this is just an error message, I don't think it's that
serious of a fix for a stable kernel, do you?  It's _this_ close to just
being a spelling fix.

thanks,

greg k-h
