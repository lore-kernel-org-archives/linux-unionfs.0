From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
Date: Fri, 21 Nov 2014 15:51:59 +0100
Message-ID: <1775324.vr1BUO4kWb@xrated>
References: <20141120164531.GB3596@tucsk> <1962959.JkOx4gJGaG@xrated> <CAJfpegtRktN8BdOogCMW++Gar02j06K=9OYOyDMBbwBZq6_=Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:63379 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaKUOwN (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 21 Nov 2014 09:52:13 -0500
In-Reply-To: <CAJfpegtRktN8BdOogCMW++Gar02j06K=9OYOyDMBbwBZq6_=Hg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Freitag, 21. November 2014 13:41:57 Miklos Szeredi wrote:
> On Fri, Nov 21, 2014 at 12:32 PM, Hans-Peter Jansen <hpj@urpla.net> wrote:
> > Dear Miklos,
> > 
> > On Donnerstag, 20. November 2014 17:45:31 Miklos Szeredi wrote:
> >> The biggest change is to rename the filesystem from "overlayfs" to
> >> "overlay". This will allow legacy overlayfs to be easily carried by
> >> distros
> >> alongside the new mainline one.
> > 
> > Would you kindly give a firm elaboration of this rename?
> > 
> 
> See this thread:
> 
> https://lkml.org/lkml/2014/11/18/433

Okay, thanks. I  must have missed this one. "overlay" is as good as a name can 
be, IMHO.

Cheers,
Pete
