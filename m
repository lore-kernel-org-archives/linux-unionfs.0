From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v9 14/15] ovl: Fix encryption/compression status of a
 metacopy only file
Date: Thu, 18 Jan 2018 09:36:51 -0500
Message-ID: <20180118143651.GC5769@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
 <20171129155448.32721-15-vgoyal@redhat.com>
 <20180118142453.GA5769@redhat.com>
 <CAOQ4uxiLMF6BmzF9hzX6LD7eeX_=-6w1aWir5-d61bj3ojpXxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756497AbeAROgv (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:36:51 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiLMF6BmzF9hzX6LD7eeX_=-6w1aWir5-d61bj3ojpXxQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Jan 18, 2018 at 04:32:01PM +0200, Amir Goldstein wrote:
> On Thu, Jan 18, 2018 at 4:24 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Nov 29, 2017 at 10:54:47AM -0500, Vivek Goyal wrote:
> >> If file is metacopy only, it is possible that lower is encrypted while
> >> other is not. In that case, report file as encrypted (despite the fact
> >> that only data is encrypted while metadata is not).
> >>
> >> Similarly if lower is compressed, report that in stat for a metacopy
> >> only file.
> >>
> >
> > Hi Amir,
> >
> > Thinking more about this patch. Taking union of lower and upper attributes
> > (encryption and compressed) does not feel right.
> >
> > Right now if lower is compressed and upper is not (metacopy), then we will
> > report file as compressed. But if lower is not compressed while upper is,
> > still we will report file as compressed. So there is an anomaly here.
> >
> > I think, compression and encryption primarily represent the data state.
> > So always report the state from inode which has file data (lower). And
> > don't take union with upper metacopy only inode. Because state in
> > upper inode does not matter till data is copied up.
> >
> > This will also simplify my implementation when supporting metacopy in
> > middle layer. That way I don't have to do getattr() on all intermediate
> > metacopy inodes in the chain and take a union. Instead I can go to lowest
> > most data inode and take encryption and compression attributes from there.
> >
> > I am not sure why did we decide to take union of lower and upper attrs.
> > Right now it does not seem to make sense to me.
> >
> 
> Now I am not sure either. I suspect that userspace may need the ability to
> know if a file is encrypted, but I can't say for sure.
> If you want to know better ask the developers that work of fs/crypto.
> 
> I don't mind if you leave this patch out.

For now I think I prefer to leave this patch out. If somebody cares,
fixing it is really easy. Just report encryption/compression state from
the inode which actually has data.

Vivek
