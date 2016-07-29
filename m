From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs update for 4.8
Date: Fri, 29 Jul 2016 12:26:46 -0700
Message-ID: <CA+55aFzUvF4ENbAygX+YGuvCnk7qmG8Z4JpiS_H6zmtz8hZZag@mail.gmail.com>
References: <20160729112024.GB25404@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35287 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcG2T0x (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 29 Jul 2016 15:26:53 -0400
In-Reply-To: <20160729112024.GB25404@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Fri, Jul 29, 2016 at 4:20 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> First of all, this fixes a regression in overlayfs introduced by the dentry hash
> salting.  I've moved the patch fixing this to the front of the queue, so if (god
> forbid) something needs to be bisected in overlayfs this regression won't
> interfere with that.

Thanks, I had missed that completely, and while I build overlayfs for
testing, I don't have any actual tests of it.

I decided to just remove the whole "lookup_hash()" helper again, not
only because it's now not longer used, but because it clearly isn't a
good interface with the hash of the name depending on the base
directory.

The lookup_hash() creation commit still reverted cleanly, so I just did that.

Thanks,

            Linus
