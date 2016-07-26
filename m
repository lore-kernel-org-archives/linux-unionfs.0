From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Stable inode numbers
Date: Tue, 26 Jul 2016 12:02:13 +0200
Message-ID: <CAJfpegvsP62Bk3_5+QzDP1n4d_Jze_eXff1bwXUof1+abk5Ecg@mail.gmail.com>
References: <CAKp8XJ41QeG03E_AW4cxsuyp4-uxrPWAkhKc60OMp3vK2YAADA@mail.gmail.com>
 <20160722121503.GC20504@veci.piliscsaba.szeredi.hu> <CAKp8XJ4Lfx06of5D4aVkg2up77xESZ9cy0z2PGn1g6-AoHvE8g@mail.gmail.com>
 <20160725113400.GF20504@veci.piliscsaba.szeredi.hu> <CAKp8XJ7p38vuP_AY7Ky27ui7w=4G5TiwGTB6ZDpfr96dX_hVeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34876 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbcGZKCP (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 26 Jul 2016 06:02:15 -0400
Received: by mail-io0-f181.google.com with SMTP id m101so10004316ioi.2
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Jul 2016 03:02:14 -0700 (PDT)
In-Reply-To: <CAKp8XJ7p38vuP_AY7Ky27ui7w=4G5TiwGTB6ZDpfr96dX_hVeQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vito Caputo <vito.caputo@coreos.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jul 25, 2016 at 11:25 PM, Vito Caputo <vito.caputo@coreos.com> wrote:
> I think this strategy is an improvement, but I'm a bit apprehensive
> about how specific it is to this particular style of untar-like
> directory metadata preservation failure in only providing stability to
> directory inode numbers.
>
> Additionally it introduces a userspace-visible mount option, for
> something which /feels/ like a stop-gap kludge to make some things
> work better in the short-term.  Maybe it's acceptable, since a more
> general solution could be implemented later which ignores the added
> mount option without conflict.

Not sure that it's a kludge.  AFAIR union-mounts copy up directory on
lookup for simplicity of implementation.  Overlayfs doesn't do that
and it turns out to be not a big problem.  But I don't have any input
into the performance impact of doing this way or that.   If it turns
out to be unacceptable then we can think about some other solution
(possibly something out-of-band, like aufs does).

> As overlayfs usage increases in the "enterprise" via containers I
> suspect we'll be seeing substantial support load from unsuspecting
> users tripping over quirks like this and at some point there's a
> threshold where user confidence is lost.

Too true.

>  That is the lens I view
> overlayfs problems like these through, hence I'd prefer a more general
> solution with stable inode numbers making overlayfs behavior more
> consistent with the filesystems backing it.

Perhaps this needs to be the default then, turning it off to get the
more space efficient but less conformant version.  That risks being a
regression for some, but hey, overlayfs is still somewhat
experimental.

> It's difficult for me to define what is "good enough" for overlayfs
> correctness, and this situation seems like it might be one of those
> epitomizing the saying "perfect is the enemy of good".

If it breaks real apps, then it's not good.  We need to fix it one way
or the other.

Thanks,
Miklos
